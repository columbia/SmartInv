1 contract EtherTopDog {
2 
3 	// fund for bailing out underdogs when they are pushed out
4 	uint private bailoutBalance = 0;
5 
6 
7 	// === Underdog Payin Distribution: ===
8 	
9 	// percent of underdog deposit amount to go in bailout fund
10 	uint constant private bailoutFundPercent = 70;
11 
12 	// percent of underdog deposit that goes to the top dog's dividend
13 	uint constant private topDogDividend = 15;
14 
15 	// percent of underdog deposit sent chip away top dog's strength
16 	uint constant private topDogDecayPercent = 10;
17 
18 	// percent of underdog deposiot that goes to lucky dog's dividend
19 	uint constant private luckyDogDividend = 3;
20 
21 	// vision dog takes a small fee from each underdog deposit
22 	uint constant private visionDogFeePercent = 2;
23 
24 	// === === === === === === === === ===
25 
26 	
27 	// percentage markup from payin for calculating new mininum TopDog price threshold
28 	uint constant private topDogMinMarkup = 125;
29 
30 	// minimum required deposit to become the next Top Dog
31 	// (aka Top Dog strength / lowest possible takeover threshold)
32 	// starts at 125% of Top Dog's deposit, slowly declines as underdogs join
33 	uint private topDogMinPrice = 1;
34 
35 	// range above the topdog strength (aka topDogMinPrice) within which
36 	// the randomly generated required takeover threhold is set
37 	uint constant private topDogBuyoutRange = 150;
38 
39 	// percentage of topdog buyout fee gets paid to creator
40 	uint constant private visionDogBuyPercent = 5;
41 
42 
43 
44 	// underdog payout markup, as a percentage of their deposits
45 	// gets reset to 150% after each round when the top dog gets replaced
46 	// gradually decays to mininum of 120% as underdogs chip away at top dog's strength
47 	uint private underDogMarkup = 150;
48 
49 	// as top dog price declines, these keep track of the range
50 	// so underDopMarkup can slowly go from 150% to 120% return
51 	// as the Top Dog mininum price starts at the price ceiling,
52 	// and declines until it reaches the floor (or lower)
53 	uint private topDogPriceCeiling = 0;
54 	uint private topDogPriceFloor = 0;
55 
56 	// total collected fees from underdogs, paid out whenever Top Dog is bought out
57 	uint private visionFees = 0;
58 
59 	// current top dog
60 	address private topDog = 0x0;
61 
62 	// underdog entries
63 	struct Underdog {
64 		address addr;
65 		uint deposit;
66 		uint payout;
67 		uint bailouts;
68 	}
69 	Underdog[] private Underdogs;
70 
71 	// player names for fun
72 	mapping (address => string) dogNames;
73 
74 	// current lucky dog (if exists) will receive 3% of underdog payins
75 	// specified as index in Underdogs array
76 	// 0 = nobody (the very first underdog to join the game is precluded from becoming the Lucky Dog)
77 	uint private luckyDog = 0;
78 
79 	// index of next underdog to be paid 
80 	uint private payoutIndex = 0;
81 
82 	// count payouts made by underdogs currently in the game
83 	// so we can have a baseline for dividing the scraps
84 	uint private payoutCount = 0;
85 
86 	// address of the creator
87 	address private visionDog;
88 
89 	function EtherTopDog() {
90 		visionDog = msg.sender;
91 	}
92 
93 
94 	// ==== Game Info Display ABI functions: ====
95 	function underdogPayoutFund() public constant returns (uint balance) {
96 		balance = bailoutBalance;
97 	}
98 
99 	function nextUnderdogPayout() public constant returns (uint) {
100 		if (Underdogs.length - payoutIndex >= 1) {
101 			return Underdogs[payoutIndex].payout;
102 		}
103 	}
104 	
105 
106 	function underdogPayoutMarkup() public constant returns (uint) {
107 		return underDogMarkup;
108 	}
109 
110 	function topDogInfo() public constant returns (string name, uint strength) {
111 		if (topDog != address(0x0)) {
112 			name = getDogName(topDog);
113 		} else {
114 			name = "[not set]";
115 		}
116 		strength = topDogMinPrice;
117 	}
118 	function luckyDogInfo() public constant returns (string name) {
119 		if (luckyDog > 0) {
120 			name = getDogName(Underdogs[luckyDog].addr);
121 		} else {
122 			name = "[nobody]";
123 		}
124 	}
125 
126 	function underdogCount() constant returns (uint) {
127 		return Underdogs.length - payoutIndex;
128 	} 
129 
130 	function underdogInfo(uint linePosition) constant returns (string name, address dogAddress, uint deposit, uint payout, uint scrapBonus) {
131 		if (linePosition > 0 && linePosition <= Underdogs.length - payoutIndex) {
132 
133 			Underdog thedog = Underdogs[payoutIndex + (linePosition - 1)];
134 			name = getDogName(thedog.addr);
135 			dogAddress = thedog.addr;
136 			deposit = thedog.deposit;
137 			payout= thedog.payout;
138 			scrapBonus = thedog.bailouts;
139 		}
140 	}
141 
142 	// ==== End ABI Functions ====
143 
144 
145 
146 	// ==== Public transaction functions: ====
147 
148 	// default fallback : play a round
149 	function() {
150 		dogFight();
151 	}
152 	
153 	// sets name, optionally plays a round if Ether was sent
154 	function setName(string DogName) {
155 		if (bytes(DogName).length >= 2 && bytes(DogName).length <= 16)
156 			dogNames[msg.sender] = DogName;
157 
158 		// if a deposit was sent, play it!
159 		if (msg.value > 0) {
160 			dogFight();
161 		}
162 		
163 	}
164 
165 	function dogFight() public {
166 		// minimum 1 ETH required to play
167 		if (msg.value < 1 ether) {
168 			msg.sender.send(msg.value);
169 			return;
170 		}
171 
172 		// does a topdog exist ?
173 		if (topDog != address(0x0)) {
174 
175 			// the actual amount required to knock out the top dig is random within the buyout range
176 			uint topDogPrice = topDogMinPrice + randInt( (topDogMinPrice * topDogBuyoutRange / 100) - topDogMinPrice, 4321);
177 
178 			// Calculate the top dog price
179 			if (msg.value >= topDogPrice) {
180 				// They bought out the top dog!
181 				buyTopDog(topDogPrice, msg.value - topDogPrice);
182 			} else {
183 				// didn't buy the top dog, this participant becomes an underdog!
184 				addUnderDog(msg.value);
185 			}
186 		} else {
187 			// no top dog exists yet, the game must be just getting started
188 			// put the first deposit in the bailout fund, initialize the game
189 
190 			// set first topDog 
191 			topDog = msg.sender;
192 
193 			topDogPriceFloor = topDogMinPrice;
194 
195 			bailoutBalance += msg.value;
196 			topDogMinPrice = msg.value * topDogMinMarkup / 100;
197 
198 			topDogPriceCeiling = topDogMinPrice;
199 
200 		}
201 	}
202 
203 	// ==== End Public Functions ====
204 
205 
206 
207 	// ==== Private Functions: ====
208 	function addUnderDog(uint buyin) private {
209 
210 		uint bailcount = 0;
211 
212 		// amount this depositor will be paid when the fund allows
213 		uint payoutval = buyin * underDogMarkup / 100;
214 
215 		// add portion of deposit to bailout fund 
216 		bailoutBalance += buyin * bailoutFundPercent / 100;
217 
218 		// top dog / lucky dog dividends
219 		uint topdividend = buyin * topDogDividend / 100;
220 		uint luckydividend = buyin * luckyDogDividend / 100;
221 
222 		// is there a lucky dog?
223 		if (luckyDog != 0 && luckyDog >= payoutIndex) {
224 			// pay lucky dog dividends
225 			Underdogs[luckyDog].addr.send(luckydividend);
226 		} else {
227 			// no lucky dog exists, all dividends go to top dog
228 			topdividend += luckydividend;
229 		}
230 
231 		// pay top dog dividends
232 		topDog.send(topdividend);
233 
234 
235 		// chip away at the top dog's strength
236 		uint topdecay = (buyin * topDogDecayPercent / 100);
237 		topDogMinPrice -= topdecay;
238 
239 		// update underdog markup % for next round
240 
241 		// specified as n/100000 to avoid floating point math
242 		uint decayfactor = 0;
243 
244 		// calculate the payout markup for next underdog
245 		if (topDogMinPrice > topDogPriceFloor) {
246 			uint decayrange = (topDogPriceCeiling - topDogPriceFloor);
247 			decayfactor = 100000 * (topDogPriceCeiling - topDogMinPrice) / decayrange;
248 		} else {
249 			decayfactor = 100000;
250 		}
251 		// markup will be between 120-150% corresponding to current top dog price decline (150% - 30% = 120%)
252 		underDogMarkup = 150 - (decayfactor * 30 / 100000);
253 
254 
255 
256 		// creator takes a slice
257 		visionFees += (buyin * visionDogFeePercent / 100);
258 		
259 
260 		// payout as many previous underdogs as the fund can afford
261 		while (payoutIndex < Underdogs.length && bailoutBalance >= Underdogs[payoutIndex].payout ) {
262 			payoutCount -= Underdogs[payoutIndex].bailouts;
263 			bailoutBalance -= Underdogs[payoutIndex].payout;
264 			Underdogs[payoutIndex].addr.send(Underdogs[payoutIndex].payout);
265 
266 
267 			// if the lucky dog was bailed out, the user who did it now becomes the lucky dog
268 			if (payoutIndex == luckyDog && luckyDog != 0)
269 				luckyDog = Underdogs.length;
270 
271 			payoutIndex++;
272 			bailcount++;
273 			payoutCount++;
274 		}
275 
276 		
277 		// add the new underdog to the queue
278 		Underdogs.push(Underdog(msg.sender, buyin, payoutval, bailcount));
279 
280 	}
281 
282 	function buyTopDog(uint buyprice, uint surplus) private {
283 
284 		// take out vizionDog fee
285 		uint vfee = buyprice * visionDogBuyPercent / 100;
286 
287 		uint dogpayoff = (buyprice - vfee);
288 
289 		// payout previous top dog
290 		topDog.send(dogpayoff);
291 
292 		visionFees += vfee;
293 
294 		// send buy fee (plus previous collected underdog fees) to visionDog
295 		visionDog.send(visionFees);
296 		visionFees = 0;
297 
298 		// record a price floor for underdog markup decay calculation during the next round:
299 		// the mininum purchase price before buyout
300 		topDogPriceFloor = topDogMinPrice;
301 
302 		// set the initial minimum buy price for the next top dog
303 		topDogMinPrice = msg.value * topDogMinMarkup / 100;
304 
305 		// the price ceiling for calculating the underdog markup decay is the new minimum price
306 		topDogPriceCeiling = topDogMinPrice;
307 
308 
309 		// check for eligible lucky dog...
310 //		if (Underdogs.length - payoutIndex > 0) {
311 			// lucky dog is most recent underdog to make an entry
312 //			luckyDog = Underdogs.length - 1;
313 //		} else {
314 			// no dogs waiting in line?  all dividends will go to top dog this round
315 //			luckyDog = 0;
316 //		}
317 		
318 
319 		// reset underdog markup for next round
320 		underDogMarkup = 150;
321 
322 		// how many dogs are waiting?
323 		uint linelength = Underdogs.length - payoutIndex;
324 
325 		// surplus goes to pay scraps to random underdogs
326 		// calculate and pay scraps
327 
328 
329 		// are there underdogs around to receive the scraps?
330 		if (surplus > 0 && linelength > 0 ) {
331 			throwScraps(surplus);
332 		}
333 
334 
335 		// if there are any underdogs in line, the lucky dog will be picked from among them	
336 		if (linelength > 0) {
337 
338 			// randomly pick a new lucky dog, with luck weighted toward more recent entries
339 
340 			// weighting works like this:
341 			// 	For example, if the line length is 6, the most recent entry will
342 			//	be 6 times more likely than the oldest (6/21 odds),
343 			//	the second most recent will be 5 times more likely than the oldest (5/21 odds)
344 			//	the third most recent will be 4 times as likely as the oldest (4/21 odds),
345 			//	etc...
346 
347 			//	of course, the player that has been in line longest is
348 			//	least likely to be lucky (1/21 odds in this example)
349 			//	and will be getting sent out of the game soonest anyway
350 
351 			uint luckypickline = (linelength % 2 == 1) ?
352 				( linelength / 2 + 1 ) + (linelength + 1) * (linelength / 2) :  // odd
353 				( (linelength + 1) * (linelength / 2)  ); // even
354 
355 			uint luckypick = randInt(luckypickline, 69);
356 	
357 			uint pickpos = luckypickline - linelength;
358 			uint linepos = 1;
359 
360 			while (pickpos >= luckypick && linepos < linelength) {
361 				pickpos -= (linelength - linepos);
362 				linepos++;
363 			}
364 
365 			luckyDog = Underdogs.length - linepos;
366 		} else {
367 			// no underdogs in line?  no lucky dog this round.
368 			// (should only possibly happen when game starts)
369 			luckyDog = 0;
370 		}
371 		
372 
373 		// the new top dog is crowned!
374 		topDog = msg.sender;
375 	}
376 
377 	function throwScraps(uint totalscrapvalue) private {
378 
379 		// how many dogs are waiting?
380 		uint linelength = Underdogs.length - payoutIndex;
381 
382 		// to keep from having too many transactions, make sure we never have more than 7 scraps.
383 		// the more dogs in line, the more we jump over when scraps get scattered
384 		uint skipstep = (linelength / 7) + 1;
385 
386 		// how many pieces to divide (roughly, randomization might make it more or less)
387 		uint pieces = linelength / skipstep;
388 
389 		// how far from the end of the queue to start throwing the first scrap (semi-random)
390 		uint startoffset = randInt(skipstep, 42) - 1;
391 
392 		// base size for scraps...  
393 		uint scrapbasesize = totalscrapvalue / (pieces + payoutCount);
394 
395 		// minimum base scrap size of 0.5 eth
396 		if (scrapbasesize < 500 finney) {
397 			scrapbasesize = 500 finney;
398 		}
399 
400 		uint scrapsize;
401 		uint sptr = Underdogs.length - 1 - startoffset;
402 
403 		uint scrapvalueleft = totalscrapvalue;
404 
405 		while (pieces > 0 && scrapvalueleft > 0 && sptr >= payoutIndex) {
406 			// those who bailed out other dogs get bigger scraps
407 			// size of the scrap is multiplied by # of other dogs the user bailed out
408 			scrapsize = scrapbasesize * (Underdogs[sptr].bailouts + 1);
409 
410 
411 			// scraps can never be more than what's in the pile
412 			if (scrapsize < scrapvalueleft) {
413 				scrapvalueleft -= scrapsize;
414 			} else {
415 				scrapsize = scrapvalueleft;
416 				scrapvalueleft = 0;
417 			}
418 
419 			// pay it
420 			Underdogs[sptr].addr.send(scrapsize);
421 			pieces--;
422 			sptr -= skipstep;
423 		}
424 
425 		// any scraps left uncaught? put them in the bailout fund for the underdogs
426 		if (scrapvalueleft > 0) {
427 			bailoutBalance += scrapvalueleft;
428 		}
429 	}
430 
431 	function getDogName(address adr) private constant returns (string thename) {
432 		if (bytes(dogNames[adr]).length > 0)
433 			thename = dogNames[adr];
434 		else
435 			thename = 'Unnamed Mutt';
436 	}
437 	
438 	// Generate pseudo semi-random number between 1 - max 
439 	function randInt(uint max, uint seedswitch) private constant returns (uint randomNumber) {
440 		return( uint(sha3(block.blockhash(block.number-1), block.timestamp + seedswitch) ) % max + 1 );
441 	}
442 }