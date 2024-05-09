1 //! Copyright Parity Technologies, 2017.
2 //! Released under the Apache Licence 2.
3 
4 pragma solidity ^0.4.17;
5 
6 /// Stripped down ERC20 standard token interface.
7 contract Token {
8 	function transfer(address _to, uint256 _value) public returns (bool success);
9 }
10 
11 // From Certifier.sol
12 contract Certifier {
13 	event Confirmed(address indexed who);
14 	event Revoked(address indexed who);
15 	function certified(address) public constant returns (bool);
16 	function get(address, string) public constant returns (bytes32);
17 	function getAddress(address, string) public constant returns (address);
18 	function getUint(address, string) public constant returns (uint);
19 }
20 
21 /// Simple modified second price auction contract. Price starts high and monotonically decreases
22 /// until all tokens are sold at the current price with currently received funds.
23 /// The price curve has been chosen to resemble a logarithmic curve
24 /// and produce a reasonable auction timeline.
25 contract SecondPriceAuction {
26 	// Events:
27 
28 	/// Someone bought in at a particular max-price.
29 	event Buyin(address indexed who, uint accounted, uint received, uint price);
30 
31 	/// Admin injected a purchase.
32 	event Injected(address indexed who, uint accounted, uint received);
33 
34 	/// Admin uninjected a purchase.
35 	event Uninjected(address indexed who);
36 
37 	/// At least 5 minutes has passed since last Ticked event.
38 	event Ticked(uint era, uint received, uint accounted);
39 
40 	/// The sale just ended with the current price.
41 	event Ended(uint price);
42 
43 	/// Finalised the purchase for `who`, who has been given `tokens` tokens.
44 	event Finalised(address indexed who, uint tokens);
45 
46 	/// Auction is over. All accounts finalised.
47 	event Retired();
48 
49 	// Constructor:
50 
51 	/// Simple constructor.
52 	/// Token cap should take be in whole tokens, not smallest divisible units.
53 	function SecondPriceAuction(
54 		address _certifierContract,
55 		address _tokenContract,
56 		address _treasury,
57 		address _admin,
58 		uint _beginTime,
59 		uint _tokenCap
60 	)
61 		public
62 	{
63 		certifier = Certifier(_certifierContract);
64 		tokenContract = Token(_tokenContract);
65 		treasury = _treasury;
66 		admin = _admin;
67 		beginTime = _beginTime;
68 		tokenCap = _tokenCap;
69 		endTime = beginTime + 28 days;
70 	}
71 
72 	// No default function, entry-level users
73 	function() public { assert(false); }
74 
75 	// Public interaction:
76 
77 	/// Buyin function. Throws if the sale is not active and when refund would be needed.
78 	function buyin(uint8 v, bytes32 r, bytes32 s)
79 		public
80 		payable
81 		when_not_halted
82 		when_active
83 		only_eligible(msg.sender, v, r, s)
84 	{
85 		flushEra();
86 
87 		// Flush bonus period:
88 		if (currentBonus > 0) {
89 			// Bonus is currently active...
90 			if (now >= beginTime + BONUS_MIN_DURATION				// ...but outside the automatic bonus period
91 				&& lastNewInterest + BONUS_LATCH <= block.number	// ...and had no new interest for some blocks
92 			) {
93 				currentBonus--;
94 			}
95 			if (now >= beginTime + BONUS_MAX_DURATION) {
96 				currentBonus = 0;
97 			}
98 			if (buyins[msg.sender].received == 0) {	// We have new interest
99 				lastNewInterest = uint32(block.number);
100 			}
101 		}
102 
103 		uint accounted;
104 		bool refund;
105 		uint price;
106 		(accounted, refund, price) = theDeal(msg.value);
107 
108 		/// No refunds allowed.
109 		require (!refund);
110 
111 		// record the acceptance.
112 		buyins[msg.sender].accounted += uint128(accounted);
113 		buyins[msg.sender].received += uint128(msg.value);
114 		totalAccounted += accounted;
115 		totalReceived += msg.value;
116 		endTime = calculateEndTime();
117 		Buyin(msg.sender, accounted, msg.value, price);
118 
119 		// send to treasury
120 		treasury.transfer(msg.value);
121 	}
122 
123 	/// Like buyin except no payment required and bonus automatically given.
124 	function inject(address _who, uint128 _received)
125 		public
126 		only_admin
127 		only_basic(_who)
128 		before_beginning
129 	{
130 		uint128 bonus = _received * uint128(currentBonus) / 100;
131 		uint128 accounted = _received + bonus;
132 
133 		buyins[_who].accounted += accounted;
134 		buyins[_who].received += _received;
135 		totalAccounted += accounted;
136 		totalReceived += _received;
137 		endTime = calculateEndTime();
138 		Injected(_who, accounted, _received);
139 	}
140 
141 	/// Reverses a previous `inject` command.
142 	function uninject(address _who)
143 		public
144 		only_admin
145 		before_beginning
146 	{
147 		totalAccounted -= buyins[_who].accounted;
148 		totalReceived -= buyins[_who].received;
149 		delete buyins[_who];
150 		endTime = calculateEndTime();
151 		Uninjected(_who);
152 	}
153 
154 	/// Mint tokens for a particular participant.
155 	function finalise(address _who)
156 		public
157 		when_not_halted
158 		when_ended
159 		only_buyins(_who)
160 	{
161 		// end the auction if we're the first one to finalise.
162 		if (endPrice == 0) {
163 			endPrice = totalAccounted / tokenCap;
164 			Ended(endPrice);
165 		}
166 
167 		// enact the purchase.
168 		uint total = buyins[_who].accounted;
169 		uint tokens = total / endPrice;
170 		totalFinalised += total;
171 		delete buyins[_who];
172 		require (tokenContract.transfer(_who, tokens));
173 
174 		Finalised(_who, tokens);
175 
176 		if (totalFinalised == totalAccounted) {
177 			Retired();
178 		}
179 	}
180 
181 	// Prviate utilities:
182 
183 	/// Ensure the era tracker is prepared in case the current changed.
184 	function flushEra() private {
185 		uint currentEra = (now - beginTime) / ERA_PERIOD;
186 		if (currentEra > eraIndex) {
187 			Ticked(eraIndex, totalReceived, totalAccounted);
188 		}
189 		eraIndex = currentEra;
190 	}
191 
192 	// Admin interaction:
193 
194 	/// Emergency function to pause buy-in and finalisation.
195 	function setHalted(bool _halted) public only_admin { halted = _halted; }
196 
197 	/// Emergency function to drain the contract of any funds.
198 	function drain() public only_admin { treasury.transfer(this.balance); }
199 
200 	// Inspection:
201 
202 	/**
203 	 * The formula for the price over time.
204 	 *
205 	 * This is a hand-crafted formula (no named to the constants) in order to
206 	 * provide the following requirements:
207 	 *
208 	 * - Simple reciprocal curve (of the form y = a + b / (x + c));
209 	 * - Would be completely unreasonable to end in the first 48 hours;
210 	 * - Would reach $65m effective cap in 4 weeks.
211 	 *
212 	 * The curve begins with an effective cap (EC) of over $30b, more ether
213 	 * than is in existance. After 48 hours, the EC reduces to approx. $1b.
214 	 * At just over 10 days, the EC has reduced to $200m, and half way through
215 	 * the 19th day it has reduced to $100m.
216 	 *
217 	 * Here's the curve: https://www.desmos.com/calculator/k6iprxzcrg?embed
218 	 */
219 
220 	/// The current end time of the sale assuming that nobody else buys in.
221 	function calculateEndTime() public constant returns (uint) {
222 		var factor = tokenCap / DIVISOR * USDWEI;
223 		return beginTime + 40000000 * factor / (totalAccounted + 5 * factor) - 5760;
224 	}
225 
226 	/// The current price for a single indivisible part of a token. If a buyin happens now, this is
227 	/// the highest price per indivisible token part that the buyer will pay. This doesn't
228 	/// include the discount which may be available.
229 	function currentPrice() public constant when_active returns (uint weiPerIndivisibleTokenPart) {
230 		return (USDWEI * 40000000 / (now - beginTime + 5760) - USDWEI * 5) / DIVISOR;
231 	}
232 
233 	/// Returns the total indivisible token parts available for purchase right now.
234 	function tokensAvailable() public constant when_active returns (uint tokens) {
235 		uint _currentCap = totalAccounted / currentPrice();
236 		if (_currentCap >= tokenCap) {
237 			return 0;
238 		}
239 		return tokenCap - _currentCap;
240 	}
241 
242 	/// The largest purchase than can be made at present, not including any
243 	/// discount.
244 	function maxPurchase() public constant when_active returns (uint spend) {
245 		return tokenCap * currentPrice() - totalAccounted;
246 	}
247 
248 	/// Get the number of `tokens` that would be given if the sender were to
249 	/// spend `_value` now. Also tell you what `refund` would be given, if any.
250 	function theDeal(uint _value)
251 		public
252 		constant
253 		when_active
254 		returns (uint accounted, bool refund, uint price)
255 	{
256 		uint _bonus = bonus(_value);
257 
258 		price = currentPrice();
259 		accounted = _value + _bonus;
260 
261 		uint available = tokensAvailable();
262 		uint tokens = accounted / price;
263 		refund = (tokens > available);
264 	}
265 
266 	/// Any applicable bonus to `_value`.
267 	function bonus(uint _value)
268 		public
269 		constant
270 		when_active
271 		returns (uint extra)
272 	{
273 		return _value * uint(currentBonus) / 100;
274 	}
275 
276 	/// True if the sale is ongoing.
277 	function isActive() public constant returns (bool) { return now >= beginTime && now < endTime; }
278 
279 	/// True if all buyins have finalised.
280 	function allFinalised() public constant returns (bool) { return now >= endTime && totalAccounted == totalFinalised; }
281 
282 	/// Returns true if the sender of this transaction is a basic account.
283 	function isBasicAccount(address _who) internal constant returns (bool) {
284 		uint senderCodeSize;
285 		assembly {
286 			senderCodeSize := extcodesize(_who)
287 		}
288 	    return senderCodeSize == 0;
289 	}
290 
291 	// Modifiers:
292 
293 	/// Ensure the sale is ongoing.
294 	modifier when_active { require (isActive()); _; }
295 
296 	/// Ensure the sale has not begun.
297 	modifier before_beginning { require (now < beginTime); _; }
298 
299 	/// Ensure the sale is ended.
300 	modifier when_ended { require (now >= endTime); _; }
301 
302 	/// Ensure we're not halted.
303 	modifier when_not_halted { require (!halted); _; }
304 
305 	/// Ensure `_who` is a participant.
306 	modifier only_buyins(address _who) { require (buyins[_who].accounted != 0); _; }
307 
308 	/// Ensure sender is admin.
309 	modifier only_admin { require (msg.sender == admin); _; }
310 
311 	/// Ensure that the signature is valid, `who` is a certified, basic account,
312 	/// the gas price is sufficiently low and the value is sufficiently high.
313 	modifier only_eligible(address who, uint8 v, bytes32 r, bytes32 s) {
314 		require (
315 			ecrecover(STATEMENT_HASH, v, r, s) == who &&
316 			certifier.certified(who) &&
317 			isBasicAccount(who) &&
318 			msg.value >= DUST_LIMIT
319 		);
320 		_;
321 	}
322 
323 	/// Ensure sender is not a contract.
324 	modifier only_basic(address who) { require (isBasicAccount(who)); _; }
325 
326 	// State:
327 
328 	struct Account {
329 		uint128 accounted;	// including bonus & hit
330 		uint128 received;	// just the amount received, without bonus & hit
331 	}
332 
333 	/// Those who have bought in to the auction.
334 	mapping (address => Account) public buyins;
335 
336 	/// Total amount of ether received, excluding phantom "bonus" ether.
337 	uint public totalReceived = 0;
338 
339 	/// Total amount of ether accounted for, including phantom "bonus" ether.
340 	uint public totalAccounted = 0;
341 
342 	/// Total amount of ether which has been finalised.
343 	uint public totalFinalised = 0;
344 
345 	/// The current end time. Gets updated when new funds are received.
346 	uint public endTime;
347 
348 	/// The price per token; only valid once the sale has ended and at least one
349 	/// participant has finalised.
350 	uint public endPrice;
351 
352 	/// Must be false for any public function to be called.
353 	bool public halted;
354 
355 	/// The current percentage of bonus that purchasers get.
356 	uint8 public currentBonus = 15;
357 
358 	/// The last block that had a new participant.
359 	uint32 public lastNewInterest;
360 
361 	// Constants after constructor:
362 
363 	/// The tokens contract.
364 	Token public tokenContract;
365 
366 	/// The certifier.
367 	Certifier public certifier;
368 
369 	/// The treasury address; where all the Ether goes.
370 	address public treasury;
371 
372 	/// The admin address; auction can be paused or halted at any time by this.
373 	address public admin;
374 
375 	/// The time at which the sale begins.
376 	uint public beginTime;
377 
378 	/// Maximum amount of tokens to mint. Once totalAccounted / currentPrice is
379 	/// greater than this, the sale ends.
380 	uint public tokenCap;
381 
382 	// Era stuff (isolated)
383 	/// The era for which the current consolidated data represents.
384 	uint public eraIndex;
385 
386 	/// The size of the era in seconds.
387 	uint constant public ERA_PERIOD = 5 minutes;
388 
389 	// Static constants:
390 
391 	/// Anything less than this is considered dust and cannot be used to buy in.
392 	uint constant public DUST_LIMIT = 5 finney;
393 
394 	/// The hash of the statement which must be signed in order to buyin.
395 	/// The meaning of this hash is:
396 	///
397 	/// parity.api.util.sha3(parity.api.util.asciiToHex("\x19Ethereum Signed Message:\n" + tscs.length + tscs))
398 	/// where `toUTF8 = x => unescape(encodeURIComponent(x))`
399 	/// and `tscs` is the toUTF8 called on the contents of https://gist.githubusercontent.com/gavofyork/5a530cad3b19c1cafe9148f608d729d2/raw/a116b507fd6d96036037f3affd393994b307c09a/gistfile1.txt
400 	bytes32 constant public STATEMENT_HASH = 0x2cedb9c5443254bae6c4f44a31abcb33ec27a0bd03eb58e22e38cdb8b366876d;
401 
402 	/// Minimum duration after sale begins that bonus is active.
403 	uint constant public BONUS_MIN_DURATION = 1 hours;
404 
405 	/// Minimum duration after sale begins that bonus is active.
406 	uint constant public BONUS_MAX_DURATION = 24 hours;
407 
408 	/// Number of consecutive blocks where there must be no new interest before bonus ends.
409 	uint constant public BONUS_LATCH = 2;
410 
411 	/// Number of Wei in one USD, constant.
412 	uint constant public USDWEI = 3226 szabo;
413 
414 	/// Divisor of the token.
415 	uint constant public DIVISOR = 1000;
416 }