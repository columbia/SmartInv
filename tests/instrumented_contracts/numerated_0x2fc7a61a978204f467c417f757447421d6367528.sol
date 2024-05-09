1 pragma solidity 0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24   	require(msg.sender != address(0));
25 
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 }
55 
56 
57 library SafeMath {
58 
59   /**
60   * @dev Multiplies two numbers, throws on overflow.
61   */
62   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63 	if (a == 0) {
64 	  return 0;
65 	}
66 	uint256 c = a * b;
67 	assert(c / a == b);
68 	return c;
69   }
70 
71   /**
72   * @dev Integer division of two numbers, truncating the quotient.
73   */
74   function div(uint256 a, uint256 b) internal pure returns (uint256) {
75 	// assert(b > 0); // Solidity automatically throws when dividing by 0
76 	uint256 c = a / b;
77 	// assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 	return c;
79   }
80 
81   /**
82   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
83   */
84   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85 	assert(b <= a);
86 	return a - b;
87   }
88 
89   /**
90   * @dev Adds two numbers, throws on overflow.
91   */
92   function add(uint256 a, uint256 b) internal pure returns (uint256) {
93 	uint256 c = a + b;
94 	assert(c >= a);
95 	return c;
96   }
97 }
98 
99 contract EthernalCup is Ownable {
100 	using SafeMath for uint256;
101 
102 
103 	/// Buy is emitted when a national team is bought
104 	event Buy(
105 		address owner,
106 		uint country,
107 		uint price
108 	);
109 
110 	event BuyCup(
111 		address owner,
112 		uint price
113 	);
114 
115 	uint public constant LOCK_START = 1531663200; // 2018/07/15 2:00pm (UTC)
116 	uint public constant LOCK_END = 1500145200; // 2018/07/15 19:00pm (UTC)
117 	uint public constant TOURNAMENT_ENDS = 1531677600; // 2018/07/15 18:00pm (UTC)
118 
119 	int public constant BUY_INCREASE = 20;
120 
121 	uint startPrice = 0.1 ether;
122 
123 	// The way the purchase occurs, the purchase will pay 20% more of the current price
124 	// so the actual price is 30 ether
125 	uint cupStartPrice = 25 ether;
126 
127 	uint public constant DEV_FEE = 3;
128 	uint public constant POOL_FEE = 5;
129 
130 	bool public paused = false;
131 
132 	// 0 "Russia"
133 	// 1 "Saudi Arabia
134 	// 2 "Egypt"
135 	// 3 "Uruguay"
136 	// 4 "Morocco"
137 	// 5 "Iran"
138 	// 6 "Portugal"
139 	// 7 "Spain"
140 	// 8 "France"
141 	// 9 "Australia"
142 	// 10 "Peru"
143 	// 11 "Denmark"
144 	// 12 "Argentina"
145 	// 13 "Iceland"
146 	// 14 "Croatia"
147 	// 15 "Nigeria"
148 	// 16 "Costa Rica
149 	// 17 "Serbia"
150 	// 18 "Brazil"
151 	// 19 "Switzerland"
152 	// 20 "Germany"
153 	// 21 "Mexico"
154 	// 22 "Sweden"
155 	// 23 "Korea Republic
156 	// 24 "Belgium"
157 	// 25 "Panama"
158 	// 26 "Tunisia"
159 	// 27 "England"
160 	// 28 "Poland"
161 	// 29 "Senegal"
162 	// 30 "Colombia"
163 	// 31 "Japan"
164 
165 	struct Country {
166 		address owner;
167 		uint8 id;
168 		uint price;
169 	}
170 
171 	struct EthCup {
172 		address owner;
173 		uint price;
174 	}
175 
176 	EthCup public cup;
177 
178 	mapping (address => uint) public balances;
179 	mapping (uint8 => Country) public countries;
180 
181 	/// withdrawWallet is the fixed destination of funds to withdraw. It might
182 	/// differ from owner address to allow for a cold storage address.
183 	address public withdrawWallet;
184 
185 	function () public payable {
186 
187 		balances[withdrawWallet] += msg.value;
188 	}
189 
190 	constructor() public {
191 		require(msg.sender != address(0));
192 
193 		withdrawWallet = msg.sender;
194 	}
195 
196 	modifier unlocked() {
197 		require(getTime() < LOCK_START || getTime() > LOCK_END);
198 		_;
199 	}
200 
201 	/**
202    	* @dev Throws if game is not paused
203    	*/
204 	modifier isPaused() {
205 		require(paused == true);
206 		_;
207 	}
208 
209 	/**
210    	* @dev Throws if game is paused
211    	*/
212 	modifier buyAvailable() {
213 		require(paused == false);
214 		_;
215 	}
216 
217 	/**
218    	* @dev Throws if game is paused
219    	*/
220 	modifier cupAvailable() {
221 		require(cup.owner != address(0));
222 		_;
223 	}
224 
225 	function addCountries() external onlyOwner {
226 
227 		for(uint8 i = 0; i < 32; i++) {
228 			countries[i] = Country(withdrawWallet, i, startPrice);
229 		}			
230 	}
231 
232 	/// @dev Set address withdaw wallet
233 	/// @param _address The address where the balance will be withdrawn
234 	function setWithdrawWallet(address _address) external onlyOwner {
235 
236 		uint balance = balances[withdrawWallet];
237 
238 		balances[withdrawWallet] = 0; // Set to zero previous address balance
239 
240 		withdrawWallet = _address;
241 
242 		// Add the previous balance to the new address
243 		balances[withdrawWallet] = balance;
244 	}
245 
246 
247 	///	Buy a country
248 	///	@param id - The country id
249 	function buy(uint8 id) external payable buyAvailable unlocked {
250 
251 		require(id < 32);
252 		
253 		uint price = getPrice(countries[id].price);
254 
255 		require(msg.value > startPrice);
256 		require(msg.value >= price);
257 
258 		uint fee = msg.value.mul(DEV_FEE).div(100);
259 
260 		// Add sell price minus fees to previous country owner
261 		balances[countries[id].owner] += msg.value.sub(fee);
262 	
263 
264 		// Add fee to developers balance
265 		balances[withdrawWallet] += fee;
266 
267 		// Set new owner, with new message
268 		countries[id].owner = msg.sender;
269 		countries[id].price = msg.value;
270 
271 		// Trigger buy event
272 		emit Buy(msg.sender, id, msg.value);
273 
274 	}
275 
276 	///	Buy the cup from previous owner
277 	function buyCup() external payable buyAvailable cupAvailable {
278 
279 		uint price = getPrice(cup.price);
280 
281 		require(msg.value >= price);
282 
283 		uint fee = msg.value.mul(DEV_FEE).div(100);
284 
285 		// Add sell price minus fees to previous cup owner
286 		balances[cup.owner] += msg.value.sub(fee);
287 	
288 		// Add fee to developers balance
289 		balances[withdrawWallet] += fee;
290 
291 		// Set new owner, with new message
292 		cup.owner = msg.sender;
293 		cup.price = msg.value;
294 
295 		// Trigger buy event
296 		emit BuyCup(msg.sender, msg.value);
297 
298 	}
299 
300 	/// Get new price
301 	function getPrice(uint price) public pure returns (uint) {
302 
303 		return uint(int(price) + ((int(price) * BUY_INCREASE) / 100));
304 	}
305 
306 
307 	/// Withdraw the user balance in the contract to the user address.
308 	function withdraw() external returns (bool) {
309 
310 		uint amount = balances[msg.sender];
311 
312 		require(amount > 0);
313 
314 		balances[msg.sender] = 0;
315 
316 		if(!msg.sender.send(amount)) {
317 			balances[msg.sender] = amount;
318 
319 			return false;
320 		}
321 
322 		return true;
323 	}
324 
325 	/// Get user balance
326 	function getBalance() external view returns(uint) {
327 		return balances[msg.sender];
328 	}
329 
330 	/// Get user balance by address
331 	function getBalanceByAddress(address user) external view onlyOwner returns(uint) {
332 		return balances[user];
333 	}
334 
335 	/// @notice Get a country by its id
336 	/// @param id The country id
337 	function getCountryById(uint8 id) external view returns (address, uint, uint) {
338 		return (
339 			countries[id].owner,
340 			countries[id].id,
341 			countries[id].price
342 		);
343 	}
344 
345 	/// Pause the game preventing any buys
346 	/// This will only be done to award the cup
347 	/// The game will automatically stops purchases during
348 	/// the tournament final
349 	function pause() external onlyOwner {
350 
351 		require(paused == false);
352 
353 		paused = true;
354 	}
355 
356 	/// Resume all trading
357 	function resume() external onlyOwner {
358 
359 		require(paused == true);
360 
361 		paused = false;
362 	}
363 
364 	/// Award cup to the tournament champion
365 	/// Can only be awarded once, and only if the tournament has finished
366 	function awardCup(uint8 id) external onlyOwner isPaused {
367 
368 		address owner = countries[id].owner;
369 
370 		require(getTime() > TOURNAMENT_ENDS);
371 		require(cup.owner == address(0));
372 		require(cup.price == 0);
373 		require(owner != address(0));
374 
375 		cup = EthCup(owner, cupStartPrice);
376 
377 	}
378 
379 	function getTime() public view returns (uint) {
380 		return now;
381 	}
382 
383 }