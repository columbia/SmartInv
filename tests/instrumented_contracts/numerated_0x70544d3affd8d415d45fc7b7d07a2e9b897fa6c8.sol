1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
175 	constructor(address addr) public
176 	{
177 		master = addr;
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
197 		}
198 		inited = true;
199 	}
200 
201 
202 	function() public payable
203 	{
204 		buy_spice_melange();
205 	}
206 
207 
208 	function get_owner_planets(uint256 page) external view returns (uint256[] fees, bytes32[] datas, uint256[] ids, uint256[] order)
209 	{
210 		require(msg.sender != address(0));
211 
212 		fees = new uint256[](PAGE_SIZE);
213 		datas = new bytes32[](PAGE_SIZE);
214 		ids = new uint256[](PAGE_SIZE);
215 		order = new uint256[](PAGE_SIZE);
216 
217 		uint256 start = page.mul(PAGE_SIZE);
218 
219 		for(uint8 i = 0; i < PAGE_SIZE; i++)
220 		{
221 			if(i + start < players[msg.sender].planets.length)
222 			{
223 				uint256 tmp = players[msg.sender].planets[i + start];
224 				fees[i] = nodes[tmp].planet.fee.div(koef);
225 				datas[i] = nodes[tmp].planet.data;
226 				ids[i] = tmp;
227 				order[i] = i + start;
228 			}
229 		}
230 	}
231 
232 
233 	function set_master(address adr) public onlyOwner
234 	{
235 		require(adr != address(0));
236 		require(msg.sender != address(this));
237 
238 		master = adr;
239 	}
240 
241 
242 	function set_koef(uint256 _koef) public onlyOwner
243 	{
244 		require(_koef > 0);
245 
246 		koef = _koef;
247 	}
248 
249 
250 	function get_planet_price() public view returns (uint256)
251 	{
252 		return PLANET_PRICE.div(koef).add(FEE_SILO.div(koef));
253 	}
254 
255 
256 	function get_planet_info(uint id) external view returns (uint256 fee, bytes32 data, address owner, uint256 prev, uint256 next)
257 	{
258 		fee = nodes[id].planet.fee.div(koef);
259 		data = nodes[id].planet.data;
260 		owner = nodes[id].planet.owner;
261 		prev = nodes[id].prev;
262 		next = nodes[id].next;
263 	}
264 
265 
266 	function get_info(uint256 id) public view returns (uint256[] fees, bytes32[] datas, address[] addresses, uint256[] infos)
267 	{
268 		fees = new uint256[](12);
269 		datas = new bytes32[](12);
270 		addresses = new address[](14);
271 		infos = new uint256[](14);
272 
273 		uint8 i;
274 
275 		for(i = 0; i < 12; i++)
276 		{
277 			if(i < nodes.length)
278 			{
279 				fees[i] = nodes[id].planet.fee.div(koef);
280 				datas[i] = nodes[id].planet.data;
281 				addresses[i] = nodes[id].planet.owner;
282 				infos[i] = id;
283 
284 				id = nodes[id].next;
285 			}
286 		}
287 
288 		addresses[i] = silo_addr;
289 		infos[i] = silo;
290 		i++;
291 		if(now < silo_timer)
292 			infos[i] = silo_timer - now;
293 
294 	}
295 
296 
297 	function get_player_state() external view returns (uint256 balance, uint256 position, uint8 state, uint256 discount,
298 		uint256 planet_price, uint256 owned_len)
299 	{
300 		balance = players[msg.sender].balance;
301 		position = players[msg.sender].position;
302 		state = players[msg.sender].state;
303 		discount = players[msg.sender].discount;
304 		planet_price = PLANET_PRICE.div(koef);
305 		planet_price = planet_price.sub(planet_price.mul(discount).div(100)).add(FEE_SILO.div(koef));
306 		owned_len = players[msg.sender].planets.length;
307 	}
308 
309 
310 	function create_planet() private
311 	{
312 		bytes32 hash = keccak256(abi.encodePacked(uint256(blockhash(block.number - 11)) + uint256(msg.sender) + uint256(nodes.length)));
313 
314 		uint256 fee = (uint256(hash) % FEE_RANGE).add(FEE_MIN);
315 
316 		uint256 id = 0;
317 
318 		if(nodes.length > 0)
319 		{
320 			id = uint256(hash) % nodes.length;
321 		}
322 
323 		insert(Planet(fee, hash, address(0)), id);
324 	}
325 
326 
327 	function buy_spice_melange() public payable
328 	{
329 		require(msg.sender == tx.origin);
330 		require(msg.sender != address(0));
331 		require(msg.sender != address(this));
332 		require(msg.value > 0);
333 
334 		if(players[msg.sender].state == 0 && nodes.length > 0)
335 		{
336 			bytes32 hash = keccak256(abi.encodePacked(uint256(blockhash(block.number - 11)) + uint256(msg.sender) + uint256(nodes.length)));
337 
338 			players[msg.sender].position = uint256(hash) % nodes.length;
339 
340 			players[msg.sender].state = 1;
341 		}
342 
343 		players[msg.sender].balance = players[msg.sender].balance.add(msg.value);
344 	}
345 
346 
347 	function sell_spice_melange(uint256 amount) public returns (uint256)
348 	{
349 		require(msg.sender == tx.origin);
350 		require(msg.sender != address(0));
351 		require(msg.sender != address(this));
352 		require(players[msg.sender].state > 0);
353 		require(amount <= players[msg.sender].balance);
354 
355 		if(amount > 0)
356 		{
357 			players[msg.sender].balance = players[msg.sender].balance.sub(amount);
358 
359 			if(!msg.sender.send(amount))
360 			{
361 				return 0;
362 			}
363 		}
364 		return amount;
365 	}
366 
367 
368 	function move() public
369 	{
370 		require(msg.sender == tx.origin);
371 		require(msg.sender != address(0));
372 		require(msg.sender != address(this));
373 		require(players[msg.sender].balance > 0);
374 		require(players[msg.sender].state > 0);
375 
376 		uint256 id = players[msg.sender].position;
377 
378 		while(true)
379 		{
380 			id = nodes[id].next;
381 
382 			if(nodes[id].planet.owner == address(0))
383 			{
384 				players[msg.sender].position = id;
385 				break;
386 			}
387 			else if(nodes[id].planet.owner == msg.sender)
388 			{
389 				players[msg.sender].position = id;
390 			}
391 			else
392 			{
393 				uint256 fee = nodes[id].planet.fee.div(koef);
394 
395 				if(fee > players[msg.sender].balance)
396 					break;
397 
398 				players[msg.sender].balance = players[msg.sender].balance.sub(fee);
399 				players[nodes[id].planet.owner].balance = players[nodes[id].planet.owner].balance.add(fee);
400 
401 				players[msg.sender].position = id;
402 			}
403 		}
404 	}
405 
406 
407 	function step() public
408 	{
409 		require(msg.sender == tx.origin);
410 		require(msg.sender != address(0));
411 		require(msg.sender != address(this));
412 		require(players[msg.sender].balance > 0);
413 		require(players[msg.sender].state > 0);
414 
415 		uint256 id = players[msg.sender].position;
416 
417 		id = nodes[id].next;
418 
419 		if(nodes[id].planet.owner == address(0))
420 		{
421 			players[msg.sender].position = id;
422 		}
423 		else if(nodes[id].planet.owner == msg.sender)
424 		{
425 			players[msg.sender].position = id;
426 		}
427 		else
428 		{
429 			uint256 fee = nodes[id].planet.fee.div(koef);
430 			if(fee > players[msg.sender].balance)
431 				return;
432 			players[msg.sender].balance = players[msg.sender].balance.sub(fee);
433 			players[nodes[id].planet.owner].balance = players[nodes[id].planet.owner].balance.add(fee);
434 			players[msg.sender].position = id;
435 		}
436 
437 		return;
438 	}
439 
440 
441 	function buy_planet() public
442 	{
443 		require(msg.sender == tx.origin);
444 		require(msg.sender != address(0));
445 		require(msg.sender != address(this));
446 		require(players[msg.sender].state > 0);
447 
448 		uint256 price = PLANET_PRICE.div(koef);
449 
450 		price = price.sub(price.mul(players[msg.sender].discount).div(100)).add(FEE_SILO.div(koef));
451 
452 		require(players[msg.sender].balance >= price);
453 
454 		uint256 id = players[msg.sender].position;
455 
456 		require(nodes[id].planet.owner == address(0));
457 
458 		players[msg.sender].balance = players[msg.sender].balance.sub(price);
459 
460 		players[msg.sender].planets.push(id);
461 
462 		nodes[id].planet.owner = msg.sender;
463 
464 		if(!create_flag)
465 		{
466 			create_flag = true;
467 		}
468 		else
469 		{
470 			create_planet();
471 			create_planet();
472 			create_planet();
473 
474 			create_flag = false;
475 		}
476 
477 		if(now < silo_timer)
478 		{
479 			silo_addr = msg.sender;
480 			silo_timer = silo_timer.add(TIMER_STEP);
481 			silo = silo.add(FEE_SILO);
482 		}
483 		else
484 		{
485 			if(silo > 0 && silo_addr != address(0))
486 				players[silo_addr].balance = players[silo_addr].balance.add(silo);
487 
488 			silo_addr = msg.sender;
489 			silo_timer = now.add(TIMER_STEP);
490 			silo = FEE_SILO;
491 
492 		}
493 
494 		if(players[msg.sender].discount < 50)
495 			players[msg.sender].discount = players[msg.sender].discount.add(1);
496 
497 		master.transfer(price);
498 	}
499 
500 
501 	function get_len() external view returns(uint256)
502 	{
503 		return nodes.length;
504 	}
505 
506 
507 	function insert(Planet planet, uint256 prev) private returns(uint256)
508 	{
509 		Node memory node;
510 
511 		if(nodes.length == 0)
512 		{
513 			node = Node(planet, 0, 0);
514 		}
515 		else
516 		{
517 			require(prev < nodes.length);
518 
519 			node = Node(planet, prev, nodes[prev].next);
520 
521 			nodes[node.next].prev = nodes.length;
522 			nodes[prev].next = nodes.length;
523 		}
524 
525 		return nodes.push(node) - 1;
526 	}
527 }