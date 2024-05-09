1 /*
2 * Team Proof of Long Hodl presents... v2
3 */
4 
5 pragma solidity ^0.4.21;
6 
7 contract ProofOfLongHodl {
8     using SafeMath for uint256;
9 
10     event Deposit(address user, uint amount);
11     event Withdraw(address user, uint amount);
12     event Claim(address user, uint dividends);
13     event Reinvest(address user, uint dividends);
14 
15     address owner;
16     mapping(address => bool) preauthorized;
17     bool gameStarted;
18 
19     uint constant depositTaxDivisor = 5;		// 20% of  deposits goes to  divs
20     uint constant withdrawalTaxDivisor = 5;	// 20% of  withdrawals goes to  divs
21     uint constant lotteryFee = 20; 				// 5% of deposits and withdrawals goes to dailyPool
22 
23     mapping(address => uint) public investment;
24 
25     mapping(address => uint) public stake;
26     uint public totalStake;
27     uint stakeValue;
28 
29     mapping(address => uint) dividendCredit;
30     mapping(address => uint) dividendDebit;
31 
32     function ProofOfLongHodl() public {
33         owner = msg.sender;
34         preauthorized[owner] = true;
35     }
36 
37     function preauthorize(address _user) public {
38         require(msg.sender == owner);
39         preauthorized[_user] = true;
40     }
41 
42     function startGame() public {
43         require(msg.sender == owner);
44         gameStarted = true;
45     }
46 
47     function depositHelper(uint _amount) private {
48     	require(_amount > 0);
49         uint _tax = _amount.div(depositTaxDivisor);
50         uint _lotteryPool = _amount.div(lotteryFee);
51         uint _amountAfterTax = _amount.sub(_tax).sub(_lotteryPool);
52 
53         // weekly and daily pool
54         uint weeklyPoolFee = _lotteryPool.div(5);
55         uint dailyPoolFee = _lotteryPool.sub(weeklyPoolFee);
56 
57         uint tickets = _amount.div(TICKET_PRICE);
58 
59         weeklyPool = weeklyPool.add(weeklyPoolFee);
60         dailyPool = dailyPool.add(dailyPoolFee);
61 
62         //********** ADD DAILY TICKETS
63         dailyTicketPurchases storage dailyPurchases = dailyTicketsBoughtByPlayer[msg.sender];
64 
65         // If we need to reset tickets from a previous lotteryRound
66         if (dailyPurchases.lotteryId != dailyLotteryRound) {
67             dailyPurchases.numPurchases = 0;
68             dailyPurchases.ticketsPurchased = 0;
69             dailyPurchases.lotteryId = dailyLotteryRound;
70             dailyLotteryPlayers[dailyLotteryRound].push(msg.sender); // Add user to lottery round
71         }
72 
73         // Store new ticket purchase
74         if (dailyPurchases.numPurchases == dailyPurchases.ticketsBought.length) {
75             dailyPurchases.ticketsBought.length += 1;
76         }
77         dailyPurchases.ticketsBought[dailyPurchases.numPurchases++] = dailyTicketPurchase(dailyTicketsBought, dailyTicketsBought + (tickets - 1)); // (eg: buy 10, get id's 0-9)
78         
79         // Finally update ticket total
80         dailyPurchases.ticketsPurchased += tickets;
81         dailyTicketsBought += tickets;
82 
83         //********** ADD WEEKLY TICKETS
84 		weeklyTicketPurchases storage weeklyPurchases = weeklyTicketsBoughtByPlayer[msg.sender];
85 
86 		// If we need to reset tickets from a previous lotteryRound
87 		if (weeklyPurchases.lotteryId != weeklyLotteryRound) {
88 		    weeklyPurchases.numPurchases = 0;
89 		    weeklyPurchases.ticketsPurchased = 0;
90 		    weeklyPurchases.lotteryId = weeklyLotteryRound;
91 		    weeklyLotteryPlayers[weeklyLotteryRound].push(msg.sender); // Add user to lottery round
92 		}
93 
94 		// Store new ticket purchase
95 		if (weeklyPurchases.numPurchases == weeklyPurchases.ticketsBought.length) {
96 		    weeklyPurchases.ticketsBought.length += 1;
97 		}
98 		weeklyPurchases.ticketsBought[weeklyPurchases.numPurchases++] = weeklyTicketPurchase(weeklyTicketsBought, weeklyTicketsBought + (tickets - 1)); // (eg: buy 10, get id's 0-9)
99 
100 		// Finally update ticket total
101 		weeklyPurchases.ticketsPurchased += tickets;
102 		weeklyTicketsBought += tickets;
103 
104         if (totalStake > 0)
105             stakeValue = stakeValue.add(_tax.div(totalStake));
106         uint _stakeIncrement = sqrt(totalStake.mul(totalStake).add(_amountAfterTax)).sub(totalStake);
107         investment[msg.sender] = investment[msg.sender].add(_amountAfterTax);
108         stake[msg.sender] = stake[msg.sender].add(_stakeIncrement);
109         totalStake = totalStake.add(_stakeIncrement);
110         dividendDebit[msg.sender] = dividendDebit[msg.sender].add(_stakeIncrement.mul(stakeValue));
111     }
112 
113     function deposit() public payable {
114         require(preauthorized[msg.sender] || gameStarted);
115         depositHelper(msg.value);
116         emit Deposit(msg.sender, msg.value);
117     }
118 
119     function withdraw(uint _amount) public {
120         require(_amount > 0);
121         require(_amount <= investment[msg.sender]);
122         uint _tax = _amount.div(withdrawalTaxDivisor);
123         uint _lotteryPool = _amount.div(lotteryFee);
124         uint _amountAfterTax = _amount.sub(_tax).sub(_lotteryPool);
125 
126         // weekly and daily pool
127         uint weeklyPoolFee = _lotteryPool.div(20);
128         uint dailyPoolFee = _lotteryPool.sub(weeklyPoolFee);
129 
130         weeklyPool = weeklyPool.add(weeklyPoolFee);
131         dailyPool = dailyPool.add(dailyPoolFee);
132 
133         uint _stakeDecrement = stake[msg.sender].mul(_amount).div(investment[msg.sender]);
134         uint _dividendCredit = _stakeDecrement.mul(stakeValue);
135         investment[msg.sender] = investment[msg.sender].sub(_amount);
136         stake[msg.sender] = stake[msg.sender].sub(_stakeDecrement);
137         totalStake = totalStake.sub(_stakeDecrement);
138         if (totalStake > 0)
139             stakeValue = stakeValue.add(_tax.div(totalStake));
140         dividendCredit[msg.sender] = dividendCredit[msg.sender].add(_dividendCredit);
141         uint _creditDebitCancellation = min(dividendCredit[msg.sender], dividendDebit[msg.sender]);
142         dividendCredit[msg.sender] = dividendCredit[msg.sender].sub(_creditDebitCancellation);
143         dividendDebit[msg.sender] = dividendDebit[msg.sender].sub(_creditDebitCancellation);
144 
145         msg.sender.transfer(_amountAfterTax);
146         emit Withdraw(msg.sender, _amount);
147     }
148 
149     function claimHelper() private returns(uint) {
150         uint _dividendsForStake = stake[msg.sender].mul(stakeValue);
151         uint _dividends = _dividendsForStake.add(dividendCredit[msg.sender]).sub(dividendDebit[msg.sender]);
152         dividendCredit[msg.sender] = 0;
153         dividendDebit[msg.sender] = _dividendsForStake;
154 
155         return _dividends;
156     }
157 
158     function claim() public {
159         uint _dividends = claimHelper();
160         msg.sender.transfer(_dividends);
161 
162         emit Claim(msg.sender, _dividends);
163     }
164 
165     function reinvest() public {
166         uint _dividends = claimHelper();
167         depositHelper(_dividends);
168 
169         emit Reinvest(msg.sender, _dividends);
170     }
171 
172     function dividendsForUser(address _user) public view returns (uint) {
173         return stake[_user].mul(stakeValue).add(dividendCredit[_user]).sub(dividendDebit[_user]);
174     }
175 
176     function min(uint x, uint y) private pure returns (uint) {
177         return x <= y ? x : y;
178     }
179 
180     function sqrt(uint x) private pure returns (uint y) {
181         uint z = (x + 1) / 2;
182         y = x;
183         while (z < y) {
184             y = z;
185             z = (x / z + z) / 2;
186         }
187     }
188 
189     // LOTTERY MODULE 
190     // DAILY
191     uint private dailyPool = 0;
192     uint private dailyLotteryRound = 1;
193     uint private dailyTicketsBought = 0;
194     uint private dailyTicketThatWon;
195     address[] public dailyWinners;
196     uint256[] public dailyPots;
197 
198     // WEEKLY
199     uint private weeklyPool = 0;
200     uint private weeklyLotteryRound = 1;
201     uint private weeklyTicketsBought = 0;
202     uint private weeklyTicketThatWon;
203     address[] public weeklyWinners;
204     uint256[] public weeklyPots;
205 
206     uint public TICKET_PRICE = 0.01 ether;
207     uint public DAILY_LIMIT = 0.15 ether;
208     bool private dailyTicketSelected;
209     bool private weeklyTicketSelected;
210 
211     // STRUCTS for LOTTERY
212     // DAILY
213     struct dailyTicketPurchases {
214         dailyTicketPurchase[] ticketsBought;
215         uint256 numPurchases; // Allows us to reset without clearing dailyTicketPurchase[] (avoids potential for gas limit)
216         uint256 lotteryId;
217         uint256 ticketsPurchased;
218     }
219 
220     // Allows us to query winner without looping (avoiding potential for gas limit)
221     struct dailyTicketPurchase {
222         uint256 startId;
223         uint256 endId;
224     }
225 
226     mapping(address => dailyTicketPurchases) private dailyTicketsBoughtByPlayer;
227     mapping(uint256 => address[]) private dailyLotteryPlayers;
228 
229     // WEEKLY
230     struct weeklyTicketPurchases {
231         weeklyTicketPurchase[] ticketsBought;
232         uint256 numPurchases; // Allows us to reset without clearing weeklyTicketPurchase[] (avoids potential for gas limit)
233         uint256 lotteryId;
234         uint256 ticketsPurchased;
235     }
236 
237     // Allows us to query winner without looping (avoiding potential for gas limit)
238     struct weeklyTicketPurchase {
239         uint256 startId;
240         uint256 endId;
241     }
242 
243     mapping(address => weeklyTicketPurchases) private weeklyTicketsBoughtByPlayer;
244     mapping(uint256 => address[]) private weeklyLotteryPlayers;
245 
246     // DRAWS
247     function drawDailyWinner() public {
248         require(msg.sender == owner);
249         require(!dailyTicketSelected);
250        
251         uint256 seed = dailyTicketsBought + block.timestamp;
252         dailyTicketThatWon = addmod(uint256(block.blockhash(block.number-1)), seed, dailyTicketsBought);
253         dailyTicketSelected = true;
254     }
255 
256     function drawWeeklyWinner() public {
257         require(msg.sender == owner);
258         require(!weeklyTicketSelected);
259        
260         uint256 seed = weeklyTicketsBought + block.timestamp;
261         weeklyTicketThatWon = addmod(uint256(block.blockhash(block.number-1)), seed, weeklyTicketsBought);
262         weeklyTicketSelected = true;
263     }
264 
265     function awardDailyLottery(address checkWinner, uint256 checkIndex) external {
266 		require(msg.sender == owner);
267 	    
268 	    if (!dailyTicketSelected) {
269 	    	drawDailyWinner(); // Ideally do it in one call (gas limit cautious)
270 	    }
271 	        
272 	    // Reduce gas by (optionally) offering an address to _check_ for winner
273 	    if (checkWinner != 0) {
274 	        dailyTicketPurchases storage tickets = dailyTicketsBoughtByPlayer[checkWinner];
275 	        if (tickets.numPurchases > 0 && checkIndex < tickets.numPurchases && tickets.lotteryId == dailyLotteryRound) {
276 	            dailyTicketPurchase storage checkTicket = tickets.ticketsBought[checkIndex];
277 	            if (dailyTicketThatWon >= checkTicket.startId && dailyTicketThatWon <= checkTicket.endId) {
278 	                if ( dailyPool >= DAILY_LIMIT) {
279 	            		checkWinner.transfer(DAILY_LIMIT);
280 	            		dailyPots.push(DAILY_LIMIT);
281 	            		dailyPool = dailyPool.sub(DAILY_LIMIT);		
282 	        		} else {
283 	        			checkWinner.transfer(dailyPool);
284 	        			dailyPots.push(dailyPool);
285 	        			dailyPool = 0;
286 	        		}
287 
288 	        		dailyWinners.push(checkWinner);
289             		dailyLotteryRound = dailyLotteryRound.add(1);
290             		dailyTicketsBought = 0;
291             		dailyTicketSelected = false;
292 	                return;
293 	            }
294 	        }
295 	    }
296 	    
297 	    // Otherwise just naively try to find the winner (will work until mass amounts of players)
298 	    for (uint256 i = 0; i < dailyLotteryPlayers[dailyLotteryRound].length; i++) {
299 	        address player = dailyLotteryPlayers[dailyLotteryRound][i];
300 	        dailyTicketPurchases storage playersTickets = dailyTicketsBoughtByPlayer[player];
301 	        
302 	        uint256 endIndex = playersTickets.numPurchases - 1;
303 	        // Minor optimization to avoid checking every single player
304 	        if (dailyTicketThatWon >= playersTickets.ticketsBought[0].startId && dailyTicketThatWon <= playersTickets.ticketsBought[endIndex].endId) {
305 	            for (uint256 j = 0; j < playersTickets.numPurchases; j++) {
306 	                dailyTicketPurchase storage playerTicket = playersTickets.ticketsBought[j];
307 	                if (dailyTicketThatWon >= playerTicket.startId && dailyTicketThatWon <= playerTicket.endId) {
308 	                	if ( dailyPool >= DAILY_LIMIT) {
309 	                		player.transfer(DAILY_LIMIT);
310 	                		dailyPots.push(DAILY_LIMIT);
311 	                		dailyPool = dailyPool.sub(DAILY_LIMIT);
312 	            		} else {
313 	            			player.transfer(dailyPool);
314 	            			dailyPots.push(dailyPool);
315 	            			dailyPool = 0;
316 	            		}
317 
318 	            		dailyWinners.push(player);
319 	            		dailyLotteryRound = dailyLotteryRound.add(1);
320 	            		dailyTicketsBought = 0;
321 	            		dailyTicketSelected = false;
322 
323 	                    return;
324 	                }
325 	            }
326 	        }
327 	    }
328 	}
329 
330 	function awardWeeklyLottery(address checkWinner, uint256 checkIndex) external {
331 		require(msg.sender == owner);
332 	    
333 	    if (!weeklyTicketSelected) {
334 	    	drawWeeklyWinner(); // Ideally do it in one call (gas limit cautious)
335 	    }
336 	       
337 	    // Reduce gas by (optionally) offering an address to _check_ for winner
338 	    if (checkWinner != 0) {
339 	        weeklyTicketPurchases storage tickets = weeklyTicketsBoughtByPlayer[checkWinner];
340 	        if (tickets.numPurchases > 0 && checkIndex < tickets.numPurchases && tickets.lotteryId == weeklyLotteryRound) {
341 	            weeklyTicketPurchase storage checkTicket = tickets.ticketsBought[checkIndex];
342 	            if (weeklyTicketThatWon >= checkTicket.startId && weeklyTicketThatWon <= checkTicket.endId) {
343 	        		checkWinner.transfer(weeklyPool);
344 
345 	        		weeklyPots.push(weeklyPool);
346 	        		weeklyPool = 0;
347 	            	weeklyWinners.push(player);
348 	            	weeklyLotteryRound = weeklyLotteryRound.add(1);
349 	            	weeklyTicketsBought = 0;
350 	            	weeklyTicketSelected = false;
351 	                return;
352 	            }
353 	        }
354 	    }
355 	    
356 	    // Otherwise just naively try to find the winner (will work until mass amounts of players)
357 	    for (uint256 i = 0; i < weeklyLotteryPlayers[weeklyLotteryRound].length; i++) {
358 	        address player = weeklyLotteryPlayers[weeklyLotteryRound][i];
359 	        weeklyTicketPurchases storage playersTickets = weeklyTicketsBoughtByPlayer[player];
360 	        
361 	        uint256 endIndex = playersTickets.numPurchases - 1;
362 	        // Minor optimization to avoid checking every single player
363 	        if (weeklyTicketThatWon >= playersTickets.ticketsBought[0].startId && weeklyTicketThatWon <= playersTickets.ticketsBought[endIndex].endId) {
364 	            for (uint256 j = 0; j < playersTickets.numPurchases; j++) {
365 	                weeklyTicketPurchase storage playerTicket = playersTickets.ticketsBought[j];
366 	                if (weeklyTicketThatWon >= playerTicket.startId && weeklyTicketThatWon <= playerTicket.endId) {
367 	            		player.transfer(weeklyPool);  
368 
369 	            		weeklyPots.push(weeklyPool);
370 	            		weeklyPool = 0;
371 	            		weeklyWinners.push(player);
372 	            		weeklyLotteryRound = weeklyLotteryRound.add(1);
373 	            		weeklyTicketsBought = 0;  
374 	            		weeklyTicketSelected = false;            
375 	                    return;
376 	                }
377 	            }
378 	        }
379 	    }
380 	}
381 
382     function getLotteryData() public view returns( uint256, uint256, uint256, uint256, uint256, uint256) {
383     	return (dailyPool, weeklyPool, dailyLotteryRound, weeklyLotteryRound, dailyTicketsBought, weeklyTicketsBought);
384     }
385 
386     function getDailyLotteryParticipants(uint256 _round) public view returns(address[]) {
387     	return dailyLotteryPlayers[_round];
388     }
389 
390     function getWeeklyLotteryParticipants(uint256 _round) public view returns(address[]) {
391     	return weeklyLotteryPlayers[_round];
392     }
393 
394     function getLotteryWinners() public view returns(uint256, uint256) {
395     	return (dailyWinners.length, weeklyWinners.length);
396     }
397 
398     function editDailyLimit(uint _price) public payable {
399     	require(msg.sender == owner);
400     	DAILY_LIMIT = _price;
401     }
402 
403     function editTicketPrice(uint _price) public payable {
404     	require(msg.sender == owner);
405     	TICKET_PRICE = _price;
406     }
407 
408     function getDailyTickets(address _player) public view returns(uint256) {
409     	dailyTicketPurchases storage dailyPurchases = dailyTicketsBoughtByPlayer[_player];
410 
411     	if (dailyPurchases.lotteryId != dailyLotteryRound) {
412     		return 0;
413     	}
414 
415     	return dailyPurchases.ticketsPurchased;
416     }
417 
418     function getWeeklyTickets(address _player) public view returns(uint256) {
419     	weeklyTicketPurchases storage weeklyPurchases = weeklyTicketsBoughtByPlayer[_player];
420 
421     	if (weeklyPurchases.lotteryId != weeklyLotteryRound) {
422     		return 0;
423     	}
424 
425     	return weeklyPurchases.ticketsPurchased;	
426     }
427 
428     // If someone is generous and wants to add to pool
429     function addToPool() public payable {
430     	require(msg.value > 0);
431     	uint _lotteryPool = msg.value;
432 
433     	// weekly and daily pool
434         uint weeklyPoolFee = _lotteryPool.div(5);
435         uint dailyPoolFee = _lotteryPool.sub(weeklyPoolFee);
436 
437         weeklyPool = weeklyPool.add(weeklyPoolFee);
438         dailyPool = dailyPool.add(dailyPoolFee);
439     }
440 
441     function winningTickets() public view returns(uint256, uint256) {
442     	return (dailyTicketThatWon, weeklyTicketThatWon);
443     }
444     
445 }
446 
447 /**
448  * @title SafeMath
449  * @dev Math operations with safety checks that throw on error
450  */
451 library SafeMath {
452 
453     /**
454     * @dev Multiplies two numbers, throws on overflow.
455     */
456     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
457         if (a == 0) {
458             return 0;                                                                                                                                                                                       
459         }
460         uint256 c = a * b;                                                                                                                                                                                  
461         assert(c / a == b);                                                                                                                                                                                 
462         return c;                                                                                                                                                                                           
463     }
464 
465     /**
466     * @dev Integer division of two numbers, truncating the quotient.
467     */
468     function div(uint256 a, uint256 b) internal pure returns (uint256) {
469         // assert(b > 0); // Solidity automatically throws when dividing by 0                                                                                                                               
470         // uint256 c = a / b;                                                                                                                                                                               
471         // assert(a == b * c + a % b); // There is no case in which this doesn't hold                                                                                                                       
472         return a / b;                                                                                                                                                                                       
473     }
474 
475     /**
476     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
477     */
478     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
479         assert(b <= a);                                                                                                                                                                                     
480         return a - b;                                                                                                                                                                                       
481     }
482 
483     /**
484     * @dev Adds two numbers, throws on overflow.
485     */
486     function add(uint256 a, uint256 b) internal pure returns (uint256) {
487         uint256 c = a + b;                                                                                                                                                                                  
488         assert(c >= a);                                                                                                                                                                                     
489         return c;                                                                                                                                                                                           
490     }
491 }