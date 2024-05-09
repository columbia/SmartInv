1 pragma solidity ^0.4.16;
2 
3 //Define the pool
4 contract SmartPool {
5 
6     //Pool info
7     uint currAmount;    //Current amount in the pool (=balance)
8     uint ticketPrice;   //Price of one ticket
9     uint startDate;		//The date of opening
10 	uint endDate;		//The date of closing (or 0 if still open)
11 	
12 	//Block infos (better to use block number than dates to trigger the end)
13 	uint startBlock;
14 	uint endBlock;
15 	
16 	//End triggers
17 	uint duration;		//The pool ends when the duration expire
18     uint ticketCount;	//Or when the reserve of tickets has been sold
19     bool ended;			//Current state (can't buy tickets when ended)
20 	bool terminated;	//true if a winner has been picked
21 	bool moneySent;		//true if the winner has picked his money
22     
23 	//Min wait duration between ended and terminated states
24 	uint constant blockDuration = 15; // we use 15 sec for the block duration
25 	uint constant minWaitDuration = 240; // (= 3600 / blockDuration => 60 minutes waiting between 'ended' and 'terminated')
26 	
27     //Players
28     address[] players;	//List of tickets owners, each ticket gives an entry in the array
29 	
30 	//Winning info
31     address winner;		//The final winner (only available when terminated == true)
32      
33     //Pool manager address (only the manager can call modifiers of this contract, see PoolManager.sol)
34     address poolManager;
35     
36     //Create a pool with a fixed ticket price, a ticket reserve and/or a duration)
37     function SmartPool(uint _ticketPrice, uint _ticketCount, uint _duration) public
38     {
39 		//Positive ticket price and either ticketCount or duration must be provided
40         require(_ticketPrice > 0 && (_ticketCount > 0 || _duration > blockDuration));
41 		
42 		//Check for overflows
43 		require(now + _duration >= now);
44 		
45 		//Set ticketCount if needed (according to max balance)
46 		if (_ticketCount == 0)
47 		{
48 			_ticketCount = (2 ** 256 - 1) / _ticketPrice;
49 		}
50 		
51 		require(_ticketCount * _ticketPrice >= _ticketPrice);
52 		
53 		//Store manager
54 		poolManager = msg.sender;
55 		
56         //Init
57         currAmount = 0;
58 		startDate = now;
59 		endDate = 0;
60 		startBlock = block.number;
61 		endBlock = 0;
62         ticketPrice = _ticketPrice;
63         ticketCount = _ticketCount;
64 		duration = _duration / blockDuration; // compute duration in blocks
65         ended = false;
66 		terminated = false;
67 		moneySent = false;
68 		winner = 0x0000000000000000000000000000000000000000;
69     }
70 
71 	
72 	//Accessors
73 	function getPlayers() public constant returns (address[])
74     {
75     	return players;
76     }
77 	
78 	function getStartDate() public constant returns (uint)
79     {
80     	return startDate;
81     }
82 	
83 	function getStartBlock() public constant returns (uint)
84     {
85     	return startBlock;
86     }
87 	
88     function getCurrAmount() public constant returns (uint)
89     {
90     	return currAmount;
91     }
92 	
93 	function getTicketPrice() public constant returns (uint)
94 	{
95 		return ticketPrice;
96 	}
97 	
98 	function getTicketCount() public constant returns (uint)
99 	{
100 		return ticketCount;
101 	}
102 	
103 	function getBoughtTicketCount() public constant returns (uint)
104 	{
105 		return players.length;
106 	}
107 	
108 	function getAvailableTicketCount() public constant returns (uint)
109 	{
110 		return ticketCount - players.length;
111 	}
112 	
113 	function getEndDate() public constant returns (uint)
114 	{
115 		return endDate;
116 	}
117 	
118 	function getEndBlock() public constant returns (uint)
119     {
120     	return endBlock;
121     }
122 	
123 	function getDuration() public constant returns (uint)
124 	{
125 		return duration; // duration in blocks
126 	}
127 	
128 	function getDurationS() public constant returns (uint)
129 	{
130 		return duration * blockDuration; // duration in seconds
131 	}
132 		
133 	function isEnded() public constant returns (bool)
134 	{
135 		return ended;
136 	}
137 
138 	function isTerminated() public constant returns (bool)
139 	{
140 		return terminated;
141 	}
142 	
143 	function isMoneySent() public constant returns (bool)
144 	{
145 		return moneySent;
146 	}
147 	
148 	function getWinner() public constant returns (address)
149 	{
150 		return winner;
151 	}
152 
153 	//End trigger
154 	function checkEnd() public
155 	{
156 		if ( (duration > 0 && block.number >= startBlock + duration) || (players.length >= ticketCount) )
157         {
158 			ended = true;
159 			endDate = now;
160 			endBlock = block.number;
161         }
162 	}
163 	
164     //Add player with ticketCount to the pool (only poolManager can do this)
165     function addPlayer(address player, uint ticketBoughtCount, uint amount) public  
166 	{
167 		//Only manager can call this
168 		require(msg.sender == poolManager);
169 		
170         //Revert if pool ended (should not happen because the manager check this too)
171         require (!ended);
172 		
173         //Add amount to the pool
174         currAmount += amount; // amount has been checked by the manager
175         
176         //Add player to the ticket owner array, for each bought ticket
177 		for (uint i = 0; i < ticketBoughtCount; i++)
178 			players.push(player);
179         
180         //Check end	
181 		checkEnd();
182     }
183 	
184 	function canTerminate() public constant returns(bool)
185 	{
186 		return ended && !terminated && block.number - endBlock >= minWaitDuration;
187 	}
188 
189     //Terminate the pool by picking a winner (only poolManager can do this, after the pool is ended and some time has passed so the seed has changed many times)
190     function terminate(uint randSeed) public 
191 	{		
192 		//Only manager can call this
193 		require(msg.sender == poolManager);
194 		
195         //The pool need to be ended, but not terminated
196         require(ended && !terminated);
197 		
198 		//Min duration between ended and terminated
199 		require(block.number - endBlock >= minWaitDuration);
200 		
201 		//Only one call to this function
202         terminated = true;
203 
204 		//Pick a winner
205 		if (players.length > 0)
206 			winner = players[randSeed % players.length];
207     }
208 	
209 	//Update pool state (only poolManager can call this when the money has been sent)
210 	function onMoneySent() public
211 	{
212 		//Only manager can call this
213 		require(msg.sender == poolManager);
214 		
215 		//The pool must be terminated (winner picked)
216 		require(terminated);
217 		
218 		//Update money sent (only one call to this function)
219 		require(!moneySent);
220 		moneySent = true;
221 	}
222 }
223 
224        
225 //Wallet interface
226 contract WalletContract
227 {
228 	function payMe() public payable;
229 }
230 	   
231 	   
232 contract PoolManager {
233 
234 	//Pool owner (address which manage the pool creation)
235     address owner;
236 	
237 	//Wallet which receive the fees (1% of ticket price)
238 	address wallet;
239 	
240 	//Fees infos (external websites providing access to pools get 1% too)
241 	mapping(address => uint) fees;
242 		
243 	//Fees divider (1% for the wallet, and 1% for external website where player can buy tickets)
244 	uint constant feeDivider = 100; //(1/100 of the amount)
245 
246 	//The ticket price for pools must be a multiple of 0.010205 ether (to avoid truncating the fees, and having a minimum to send to the winner)
247     uint constant ticketPriceMultiple = 10205000000000000; //(multiple of 0.010205 ether for ticketPrice)
248 
249 	//Pools infos (current active pools. When a pool is done, it goes into the poolsDone array bellow and a new pool is created to replace it at the same index)
250 	SmartPool[] pools;
251 	
252 	//Ended pools (cleaned automatically after winners get their prices)
253 	SmartPool[] poolsDone;
254 	
255 	//History (contains all the pools since the deploy)
256 	SmartPool[] poolsHistory;
257 	
258 	//Current rand seed (it changes a lot so it's pretty hard to know its value when the winner is picked)
259 	uint randSeed;
260 
261 	//Constructor (only owner)
262 	function PoolManager(address wal) public
263 	{
264 		owner = msg.sender;
265 		wallet = wal;
266 
267 		randSeed = 0;
268 	}
269 	
270 	//Called frequently by other functions to keep the seed moving
271 	function updateSeed() private
272 	{
273 		randSeed += (uint(block.blockhash(block.number - 1)));
274 	}
275 	
276 	//Create a new pool (only owner can do this)
277 	function addPool(uint ticketPrice, uint ticketCount, uint duration) public
278 	{
279 		require(msg.sender == owner);
280 		require(ticketPrice >= ticketPriceMultiple && ticketPrice % ticketPriceMultiple == 0);
281 		
282 		//Deploy a new pool
283 		pools.push(new SmartPool(ticketPrice, ticketCount, duration));
284 	}
285 	
286 	//Accessors (public)
287 	
288 	//Get Active Pools
289 	function getPoolCount() public constant returns(uint)
290 	{
291 		return pools.length;
292 	}
293 	function getPool(uint index) public constant returns(address)
294 	{
295 		require(index < pools.length);
296 		return pools[index];
297 	}
298 	
299 	//Get Ended Pools
300 	function getPoolDoneCount() public constant returns(uint)
301 	{
302 		return poolsDone.length;
303 	}
304 	function getPoolDone(uint index) public constant returns(address)
305 	{
306 		require(index < poolsDone.length);
307 		return poolsDone[index];
308 	}
309 
310 	//Get History
311 	function getPoolHistoryCount() public constant returns(uint)
312 	{
313 		return poolsHistory.length;
314 	}
315 	function getPoolHistory(uint index) public constant returns(address)
316 	{
317 		require(index < poolsHistory.length);
318 		return poolsHistory[index];
319 	}
320 		
321 	//Buy tickets for a pool (public)
322 	function buyTicket(uint poolIndex, uint ticketCount, address websiteFeeAddr) public payable
323 	{
324 		require(poolIndex < pools.length);
325 		require(ticketCount > 0);
326 		
327 		//Get pool and check state
328 		SmartPool pool = pools[poolIndex];
329 		pool.checkEnd();
330 		require (!pool.isEnded());
331 		
332 		//Adjust ticketCount according to available tickets
333 		uint availableCount = pool.getAvailableTicketCount();
334 		if (ticketCount > availableCount)
335 			ticketCount = availableCount;
336 		
337 		//Get amount required and check msg.value
338 		uint amountRequired = ticketCount * pool.getTicketPrice();
339 		require(msg.value >= amountRequired);
340 		
341 		//If too much value sent, we send it back to player
342 		uint amountLeft = msg.value - amountRequired;
343 		
344 		//if no websiteFeeAddr given, the wallet get the fee
345 		if (websiteFeeAddr == address(0))
346 			websiteFeeAddr = wallet;
347 		
348 		//Compute fee
349 		uint feeAmount = amountRequired / feeDivider;
350 		
351 		addFee(websiteFeeAddr, feeAmount);
352 		addFee(wallet, feeAmount);
353 		
354 		//Add player to the pool with the amount minus the fees (1% + 1% = 2%)
355 		pool.addPlayer(msg.sender, ticketCount, amountRequired - 2 * feeAmount);
356 		
357 		//Send back amountLeft to player if too much value sent
358 		if (amountLeft > 0 && !msg.sender.send(amountLeft))
359 		{
360 			addFee(wallet, amountLeft); // if it fails, we take it as a fee..
361 		}
362 		
363 		updateSeed();
364 	}
365 
366 	//Check pools end. (called by our console each 10 minutes, or can be called by anybody)
367 	function checkPoolsEnd() public 
368 	{
369 		for (uint i = 0; i < pools.length; i++)
370 		{
371 			//Check each pool and restart the ended ones
372 			checkPoolEnd(i);
373 		}
374 	}
375 	
376 	//Check end of a pool and restart it if it's ended (public)
377 	function checkPoolEnd(uint i) public 
378 	{
379 		require(i < pools.length);
380 		
381 		//Check end (if not triggered yet)
382 		SmartPool pool = pools[i];
383 		if (!pool.isEnded())
384 			pool.checkEnd();
385 			
386 		if (!pool.isEnded())
387 		{
388 			return; // not ended yet
389 		}
390 		
391 		updateSeed();
392 		
393 		//Store pool done and restart a pool to replace it
394 		poolsDone.push(pool);
395 		pools[i] = new SmartPool(pool.getTicketPrice(), pool.getTicketCount(), pool.getDurationS());
396 	}
397 	
398 	//Check pools done. (called by our console, or can be called by anybody)
399 	function checkPoolsDone() public 
400 	{
401 		for (uint i = 0; i < poolsDone.length; i++)
402 		{
403 			checkPoolDone(i);
404 		}
405 	}
406 	
407 	//Check end of one pool
408 	function checkPoolDone(uint i) public
409 	{
410 		require(i < poolsDone.length);
411 		
412 		SmartPool pool = poolsDone[i];
413 		if (pool.isTerminated())
414 			return; // already terminated
415 			
416 		if (!pool.canTerminate())
417 			return; // we need to wait a bit more before random occurs, so the seed has changed enough (60 minutes before ended and terminated states)
418 			
419 		updateSeed();
420 		
421 		//Terminate (pick a winner) and store pool done
422 		pool.terminate(randSeed);
423 	}
424 
425 	//Send money of the pool to the winner (public)
426 	function sendPoolMoney(uint i) public
427 	{
428 		require(i < poolsDone.length);
429 		
430 		SmartPool pool = poolsDone[i];
431 		require (pool.isTerminated()); // we need a winner picked
432 		
433 		require(!pool.isMoneySent()); // money not sent
434 		
435 		uint amount = pool.getCurrAmount();
436 		address winner = pool.getWinner();
437 		pool.onMoneySent();
438 		if (amount > 0 && !winner.send(amount)) // the winner can't get his money (should not happen)
439 		{
440 			addFee(wallet, amount);
441 		}
442 		
443 		//Pool goes into history array
444 		poolsHistory.push(pool);
445 	}
446 		
447 	//Clear pools done array (called once a week by our console, or can be called by anybody)
448 	function clearPoolsDone() public
449 	{
450 		//Make sure all pools are terminated with no money left
451 		for (uint i = 0; i < poolsDone.length; i++)
452 		{
453 			if (!poolsDone[i].isMoneySent())
454 				return;
455 		}
456 		
457 		//"Clear" poolsDone array (just reset the length, instances will be override)
458 		poolsDone.length = 0;
459 	}
460 	
461 	//Get current fee value
462 	function getFeeValue(address a) public constant returns (uint)
463 	{
464 		if (a == address(0))
465 			a = msg.sender;
466 		return fees[a];
467 	}
468 
469 	//Send fee to address (public, with a min amount required)
470 	function getMyFee(address a) public
471 	{
472 		if (a == address(0))
473 			a = msg.sender;
474 		uint amount = fees[a];
475 		require (amount > 0);
476 		
477 		fees[a] = 0;
478 		
479 		if (a == wallet)
480 		{
481 			WalletContract walletContract = WalletContract(a);
482 			walletContract.payMe.value(amount)();
483 		}
484 		else if (!a.send(amount))
485 			addFee(wallet, amount); // the fee can't be sent (hacking attempt?), so we take it... :-p
486 	}
487 	
488 	//Add fee (private)
489 	function addFee(address a, uint fee) private
490 	{
491 		if (fees[a] == 0)
492 			fees[a] = fee;
493 		else
494 			fees[a] += fee; // we don't check for overflow, if you're billionaire in fees, call getMyFee sometimes :-)
495 	}
496 }