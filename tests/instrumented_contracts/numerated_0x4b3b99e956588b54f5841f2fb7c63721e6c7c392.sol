1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: contracts/CHOAM.sol
120 
121 contract CHOAM is Ownable
122 {
123 	using SafeMath for uint256;
124 
125 	uint256 public constant PLANET_PRICE = 	100000000000000000;
126 	uint256 public constant FEE_RANGE = 		29000000000000000;
127 	uint256 public constant FEE_MIN = 			5000000000000000;
128 	uint256 public constant FEE_SILO =			10000000000000000;
129 	uint256 public constant TIMER_STEP = 		120;
130 
131 	uint256 public constant PAGE_SIZE = 25;
132 
133 	address public master;
134 
135 	bool public inited = false;
136 
137 	uint256 public koef = 1;
138 
139 	bool private create_flag = false;
140 
141 	uint256 public silo;
142 
143 	address public silo_addr = address(0);
144 
145 	uint256 public silo_timer = now;
146 
147 	struct Player
148 	{
149 		uint256 balance;
150 		uint256 position;
151 		uint8 state;
152 		uint256 discount;
153 		uint256[] planets;
154 	}
155 
156 	mapping(address => Player) players;
157 
158 	struct Planet
159 	{
160 		uint256 fee;
161 		bytes32 data;
162 		address owner;
163 	}
164 
165 	struct Node
166 	{
167 		Planet planet;
168 		uint256 prev;
169 		uint256 next;
170 	}
171 
172 	Node[] public nodes;
173 
174 
175 	constructor() public
176 	{
177 		master = msg.sender;
178 	}
179 
180 
181 	function init() public onlyOwner
182 	{
183 		if(!inited)
184 		{
185 			create_planet();
186 			create_planet();
187 			create_planet();
188 			create_planet();
189 			create_planet();
190 			create_planet();
191 			create_planet();
192 			create_planet();
193 			create_planet();
194 			create_planet();
195 			create_planet();
196 			create_planet();
197 
198 			inited = true;
199 		}
200 	}
201 
202 
203 	function() public payable
204 	{
205 		buy_spice_melange();
206 	}
207 
208 
209 	function get_owner_planets(uint256 page) external view returns (uint256[] fees, bytes32[] datas, uint256[] ids, uint256[] order)
210 	{
211 		require(msg.sender != address(0));
212 
213 		fees = new uint256[](PAGE_SIZE);
214 		datas = new bytes32[](PAGE_SIZE);
215 		ids = new uint256[](PAGE_SIZE);
216 		order = new uint256[](PAGE_SIZE);
217 
218 		uint256 start = page.mul(PAGE_SIZE);
219 
220 		for(uint8 i = 0; i < PAGE_SIZE; i++)
221 		{
222 			if(i + start < players[msg.sender].planets.length)
223 			{
224 				uint256 tmp = players[msg.sender].planets[i + start];
225 				fees[i] = nodes[tmp].planet.fee.div(koef);
226 				datas[i] = nodes[tmp].planet.data;
227 				ids[i] = tmp;
228 				order[i] = i + start;
229 			}
230 		}
231 	}
232 
233 
234 	function set_master(address adr) public onlyOwner
235 	{
236 		require(adr != address(0));
237 		require(msg.sender != address(this));
238 
239 		master = adr;
240 	}
241 
242 
243 	function set_koef(uint256 _koef) public onlyOwner
244 	{
245 		require(_koef > 0);
246 
247 		koef = _koef;
248 	}
249 
250 
251 	function get_planet_price() public view returns (uint256)
252 	{
253 		return PLANET_PRICE.div(koef).add(FEE_SILO.div(koef));
254 	}
255 
256 
257 	function get_planet_info(uint id) external view returns (uint256 fee, bytes32 data, address owner, uint256 prev, uint256 next)
258 	{
259 		fee = nodes[id].planet.fee.div(koef);
260 		data = nodes[id].planet.data;
261 		owner = nodes[id].planet.owner;
262 		prev = nodes[id].prev;
263 		next = nodes[id].next;
264 	}
265 
266 
267 	function get_info(uint256 id) public view returns (uint256[] fees, bytes32[] datas, address[] addresses, uint256[] infos)
268 	{
269 		fees = new uint256[](12);
270 		datas = new bytes32[](12);
271 		addresses = new address[](14);
272 		infos = new uint256[](14);
273 
274 		uint8 i;
275 
276 		for(i = 0; i < 12; i++)
277 		{
278 			if(i < nodes.length)
279 			{
280 				fees[i] = nodes[id].planet.fee.div(koef);
281 				datas[i] = nodes[id].planet.data;
282 				addresses[i] = nodes[id].planet.owner;
283 				infos[i] = id;
284 
285 				id = nodes[id].next;
286 			}
287 		}
288 
289 		addresses[i] = silo_addr;
290 		infos[i] = silo;
291 		i++;
292 		if(now < silo_timer)
293 			infos[i] = silo_timer - now;
294 
295 	}
296 
297 
298 	function get_player_state() external view returns (uint256 balance, uint256 position, uint8 state, uint256 discount,
299 		uint256 planet_price, uint256 owned_len)
300 	{
301 		balance = players[msg.sender].balance;
302 		position = players[msg.sender].position;
303 		state = players[msg.sender].state;
304 		discount = players[msg.sender].discount;
305 		planet_price = PLANET_PRICE.div(koef);
306 		planet_price = planet_price.sub(planet_price.mul(discount).div(100)).add(FEE_SILO.div(koef));
307 		owned_len = players[msg.sender].planets.length;
308 	}
309 
310 
311 	function create_planet() private
312 	{
313 		bytes32 hash = keccak256(abi.encodePacked(uint256(blockhash(11)) + uint256(msg.sender) + uint256(nodes.length)));
314 
315 		uint256 fee = (uint256(hash) % FEE_RANGE).add(FEE_MIN);
316 
317 		uint256 id = 0;
318 
319 		if(nodes.length > 0)
320 		{
321 			id = uint256(hash) % nodes.length;
322 		}
323 
324 		insert(Planet(fee, hash, address(0)), id);
325 	}
326 
327 
328 	function buy_spice_melange() public payable
329 	{
330 		require(msg.sender == tx.origin);
331 		require(msg.sender != address(0));
332 		require(msg.sender != address(this));
333 		require(msg.value > 0);
334 
335 		if(players[msg.sender].state == 0 && nodes.length > 0)
336 		{
337 			bytes32 hash = keccak256(abi.encodePacked(uint256(blockhash(11)) + uint256(msg.sender) + uint256(nodes.length)));
338 
339 			players[msg.sender].position = uint256(hash) % nodes.length;
340 
341 			players[msg.sender].state = 1;
342 		}
343 
344 		players[msg.sender].balance = players[msg.sender].balance.add(msg.value);
345 	}
346 
347 
348 	function sell_spice_melange(uint256 amount) public returns (uint256)
349 	{
350 		require(msg.sender == tx.origin);
351 		require(msg.sender != address(0));
352 		require(msg.sender != address(this));
353 		require(players[msg.sender].state > 0);
354 		require(amount <= players[msg.sender].balance);
355 
356 		if(amount > 0)
357 		{
358 			players[msg.sender].balance = players[msg.sender].balance.sub(amount);
359 
360 			if(!msg.sender.send(amount))
361 			{
362 				return 0;
363 			}
364 		}
365 		return amount;
366 	}
367 
368 
369 	function move() public
370 	{
371 		require(msg.sender == tx.origin);
372 		require(msg.sender != address(0));
373 		require(msg.sender != address(this));
374 		require(players[msg.sender].balance > 0);
375 		require(players[msg.sender].state > 0);
376 
377 		uint256 id = players[msg.sender].position;
378 
379 		while(true)
380 		{
381 			id = nodes[id].next;
382 
383 			if(nodes[id].planet.owner == address(0))
384 			{
385 				players[msg.sender].position = id;
386 				break;
387 			}
388 			else if(nodes[id].planet.owner == msg.sender)
389 			{
390 				players[msg.sender].position = id;
391 			}
392 			else
393 			{
394 				uint256 fee = nodes[id].planet.fee.div(koef);
395 
396 				if(fee > players[msg.sender].balance)
397 					break;
398 
399 				players[msg.sender].balance = players[msg.sender].balance.sub(fee);
400 				players[nodes[id].planet.owner].balance = players[nodes[id].planet.owner].balance.add(fee);
401 
402 				players[msg.sender].position = id;
403 			}
404 		}
405 	}
406 
407 
408 	function step() public
409 	{
410 		require(msg.sender == tx.origin);
411 		require(msg.sender != address(0));
412 		require(msg.sender != address(this));
413 		require(players[msg.sender].balance > 0);
414 		require(players[msg.sender].state > 0);
415 
416 		uint256 id = players[msg.sender].position;
417 
418 		id = nodes[id].next;
419 
420 		if(nodes[id].planet.owner == address(0))
421 		{
422 			players[msg.sender].position = id;
423 		}
424 		else if(nodes[id].planet.owner == msg.sender)
425 		{
426 			players[msg.sender].position = id;
427 		}
428 		else
429 		{
430 			uint256 fee = nodes[id].planet.fee.div(koef);
431 			if(fee > players[msg.sender].balance)
432 				return;
433 			players[msg.sender].balance = players[msg.sender].balance.sub(fee);
434 			players[nodes[id].planet.owner].balance = players[nodes[id].planet.owner].balance.add(fee);
435 			players[msg.sender].position = id;
436 		}
437 
438 		return;
439 	}
440 
441 
442 	function buy_planet() public
443 	{
444 		require(msg.sender == tx.origin);
445 		require(msg.sender != address(0));
446 		require(msg.sender != address(this));
447 		require(players[msg.sender].state > 0);
448 
449 		uint256 price = PLANET_PRICE.div(koef);
450 
451 		price = price.sub(price.mul(players[msg.sender].discount).div(100)).add(FEE_SILO.div(koef));
452 
453 		require(players[msg.sender].balance >= price);
454 
455 		uint256 id = players[msg.sender].position;
456 
457 		require(nodes[id].planet.owner == address(0));
458 
459 		players[msg.sender].balance = players[msg.sender].balance.sub(price);
460 
461 		players[msg.sender].planets.push(id);
462 
463 		nodes[id].planet.owner = msg.sender;
464 
465 		if(!create_flag)
466 		{
467 			create_flag = true;
468 		}
469 		else
470 		{
471 			create_planet();
472 			create_planet();
473 			create_planet();
474 
475 			create_flag = false;
476 		}
477 
478 		if(now < silo_timer)
479 		{
480 			silo_addr = msg.sender;
481 			silo_timer = silo_timer.add(TIMER_STEP);
482 			silo = silo.add(FEE_SILO);
483 		}
484 		else
485 		{
486 			if(silo > 0 && silo_addr != address(0))
487 				players[silo_addr].balance = players[silo_addr].balance.add(silo);
488 
489 			silo_addr = msg.sender;
490 			silo_timer = now.add(TIMER_STEP);
491 			silo = FEE_SILO;
492 
493 		}
494 
495 		if(players[msg.sender].discount < 50)
496 			players[msg.sender].discount = players[msg.sender].discount.add(1);
497 
498 		master.transfer(price);
499 	}
500 
501 
502 	function get_len() external view returns(uint256)
503 	{
504 		return nodes.length;
505 	}
506 
507 
508 	function insert(Planet planet, uint256 prev) private returns(uint256)
509 	{
510 		Node memory node;
511 
512 		if(nodes.length == 0)
513 		{
514 			node = Node(planet, 0, 0);
515 		}
516 		else
517 		{
518 			require(prev < nodes.length);
519 
520 			node = Node(planet, prev, nodes[prev].next);
521 
522 			nodes[node.next].prev = nodes.length;
523 			nodes[prev].next = nodes.length;
524 		}
525 
526 		return nodes.push(node) - 1;
527 	}
528 }