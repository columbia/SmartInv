1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9   	if (a == 0) {
10   		return 0;
11   	}
12   	uint256 c = a * b;
13   	assert(c / a == b);
14   	return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20  // we don't need "div"
21 /*  function div(uint256 a, uint256 b) internal pure returns (uint256) {
22   	// assert(b > 0); // Solidity automatically throws when dividing by 0
23   	uint256 c = a / b;
24   	// assert(a == b * c + a % b); // There is no case in which this doesn't hold
25   	return c;
26   }
27 */
28   /**
29   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32   	assert(b <= a);
33   	return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40   	uint256 c = a + b;
41   	assert(c >= a);
42   	return c;
43   }
44 }
45 
46 contract TokenCity {
47 
48 	using SafeMath for uint256;
49 
50 	//
51 	// ERC-20
52 	//
53 
54    	string public name = "CityCoin";
55    	string public symbol = "CITY";
56    	uint8 public decimals = 0;
57 
58 	mapping(address => uint256) balances;
59 
60 	event Approval(address indexed owner, address indexed spender, uint256 value);
61 	event Transfer(address indexed from, address indexed to, uint256 value);
62 
63 	/**
64 	* @dev total number of tokens in existence
65 	*/
66 	uint256 totalSupply_;
67 	function totalSupply() public view returns (uint256) {
68 		return totalSupply_;
69 	}
70 
71 	/**
72 	* @dev transfer token for a specified address
73 	* @param _to The address to transfer to.
74 	* @param _value The amount to be transferred.
75 	*/
76 	function transfer(address _to, uint256 _value) public returns (bool) {
77 		require(_to != address(0));
78 		require(_value <= balances[msg.sender]);
79 
80 		// SafeMath.sub will throw if there is not enough balance.
81 		balances[msg.sender] = balances[msg.sender].sub(_value);
82 		balances[_to] = balances[_to].add(_value);
83 		Transfer(msg.sender, _to, _value);
84 		return true;
85 	}
86 
87 	/**
88 	* @dev Gets the balance of the specified address.
89 	* @param _owner The address to query the the balance of.
90 	* @return An uint256 representing the amount owned by the passed address.
91 	*/
92 	function balanceOf(address _owner) public view returns (uint256 balance) {
93 		return balances[_owner];
94 	}
95 
96 	mapping (address => mapping (address => uint256)) internal allowed;
97 
98 
99 	/**
100 	* @dev Transfer tokens from one address to another
101 	* @param _from address The address which you want to send tokens from
102 	* @param _to address The address which you want to transfer to
103 	* @param _value uint256 the amount of tokens to be transferred
104 	*/
105 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106 		require(_to != address(0));
107 		require(_value <= balances[_from]);
108 		require(_value <= allowed[_from][msg.sender]);
109 
110 		balances[_from] = balances[_from].sub(_value);
111 		balances[_to] = balances[_to].add(_value);
112 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113 		Transfer(_from, _to, _value);
114 		return true;
115 	}
116 
117 	/**
118 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
119 	*
120 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
121 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
122 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
123 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124 	* @param _spender The address which will spend the funds.
125 	* @param _value The amount of tokens to be spent.
126 	*/
127 	function approve(address _spender, uint256 _value) public returns (bool) {
128 		allowed[msg.sender][_spender] = _value;
129 		Approval(msg.sender, _spender, _value);
130 		return true;
131 	}
132 
133 	/**
134 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
135 	* @param _owner address The address which owns the funds.
136 	* @param _spender address The address which will spend the funds.
137 	* @return A uint256 specifying the amount of tokens still available for the spender.
138 	*/
139 	function allowance(address _owner, address _spender) public view returns (uint256) {
140 		return allowed[_owner][_spender];
141 	}
142 
143 	/**
144 	* @dev Increase the amount of tokens that an owner allowed to a spender.
145 	*
146 	* approve should be called when allowed[_spender] == 0. To increment
147 	* allowed value is better to use this function to avoid 2 calls (and wait until
148 	* the first transaction is mined)
149 	* From MonolithDAO Token.sol
150 	* @param _spender The address which will spend the funds.
151 	* @param _addedValue The amount of tokens to increase the allowance by.
152 	*/
153 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
154 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
155 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156 		return true;
157 	}
158 
159 	/**
160 	* @dev Decrease the amount of tokens that an owner allowed to a spender.
161 	*
162 	* approve should be called when allowed[_spender] == 0. To decrement
163 	* allowed value is better to use this function to avoid 2 calls (and wait until
164 	* the first transaction is mined)
165 	* From MonolithDAO Token.sol
166 	* @param _spender The address which will spend the funds.
167 	* @param _subtractedValue The amount of tokens to decrease the allowance by.
168 	*/
169 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
170 		uint oldValue = allowed[msg.sender][_spender];
171 		if (_subtractedValue > oldValue) {
172 			allowed[msg.sender][_spender] = 0;
173 			} else {
174 				allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175 			}
176 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177 			return true;
178 		}
179 
180    	//
181    	// Game Meta values
182    	//
183 
184    	address public unitedNations; // the UN organisation
185 
186    	uint16 public MAX_CITIES = 5000; // maximum amount of cities in our world
187    	uint256 public UNITED_NATIONS_FUND = 5000000; // initial funding for the UN
188    	uint256 public ECONOMY_BOOST = 5000; // minted CITYs when a new city is being bought 
189 
190    	uint256 public BUY_CITY_FEE = 3; // UN fee (% of ether) to buy a city from someon / 100e
191    	uint256 public ECONOMY_BOOST_TRADE = 100; // _immutable_ gift (in CITY) from the UN when a city is traded (shared among the cities of the relevant country)
192 
193    	uint256 public MONUMENT_UN_FEE = 3; // UN fee (CITY) to buy a monument
194    	uint256 public MONUMENT_CITY_FEE = 3; // additional fee (CITY) to buy a monument (shared to the monument's city)
195 
196    	//
197    	// Game structures
198    	//
199 
200    	struct country {
201    		string name;
202    		uint16[] cities;
203    	}
204 
205    	struct city {
206    		string name;
207    		uint256 price;
208    		address owner;
209 
210    		uint16 countryId;
211    		uint256[] monuments;
212 
213    		bool buyable; // set to true when it can be bought
214 
215    		uint256 last_purchase_price;
216    	}
217 
218    	struct monument {
219    		string name;
220    		uint256 price;
221    		address owner;
222 
223    		uint16 cityId;
224    	}
225 
226    	city[] public cities; // cityId -> city
227    	country[] public countries; // countryId -> country
228    	monument[] public monuments; // monumentId -> monument
229 
230    	//
231    	// Game events
232    	//
233 
234 
235 	event NewCity(uint256 cityId, string name, uint256 price, uint16 countryId);
236 	event NewMonument(uint256 monumentId, string name, uint256 price, uint16 cityId);
237 
238 	event CityForSale(uint16 cityId, uint256 price);
239 	event CitySold(uint16 cityId, uint256 price, address previousOwner, address newOwner, uint256 offerId);
240 
241 	event MonumentSold(uint256 monumentId, uint256 price);
242 
243    	// 
244    	// Admin stuff
245    	//
246 
247    	// constructor
248    	function TokenCity() public {
249    		unitedNations = msg.sender;
250    		balances[unitedNations] = UNITED_NATIONS_FUND; // initial funding for the united nations
251    		uint256 perFounder = 500000;
252    		balances[address(0xe1811eC49f493afb1F4B42E3Ef4a3B9d62d9A01b)] = perFounder; // david
253    		balances[address(0x1E4F1275bB041586D7Bec44D2E3e4F30e0dA7Ba4)] = perFounder; // simon
254    		balances[address(0xD5d6301dE62D82F461dC29824FC597D38d80c424)] = perFounder; // eric
255    		// total supply updated
256    		totalSupply_ = UNITED_NATIONS_FUND + 3 * perFounder;
257    	}
258 
259 	// withdrawing funds
260 	function adminWithdraw(uint256 _amount) public {
261 		uint256 perFounder = _amount / 3;
262 		address(0xD5d6301dE62D82F461dC29824FC597D38d80c424).transfer(perFounder); // eric
263 		address(0x1E4F1275bB041586D7Bec44D2E3e4F30e0dA7Ba4).transfer(perFounder); // simon
264 		address(0xe1811eC49f493afb1F4B42E3Ef4a3B9d62d9A01b).transfer(perFounder); // david
265 	}
266 
267 	//
268 	// Admin adding stuff
269 	//
270 
271 	// we need to add a country before we can add a city
272 	function adminAddCountry(string _name) public returns (uint256) {
273 		// requires
274 		require(msg.sender == unitedNations);
275 		// add country
276 		uint256 lastId = countries.push(country(_name, new uint16[](0))) - 1; 
277 		//
278 		return lastId;
279 	}
280 	// adding a city will mint ECONOMY_BOOST citycoins (country must exist)
281 	function adminAddCity(string _name, uint256 _price, uint16 _countryId) public returns (uint256) {
282 		// requires
283 		require(msg.sender == unitedNations);
284 		require(cities.length < MAX_CITIES);
285 		// add city
286 		uint256 lastId = cities.push(city(_name, _price, 0, _countryId, new uint256[](0), true, 0)) - 1;
287 		countries[_countryId].cities.push(uint16(lastId));
288 		// event
289 		NewCity(lastId, _name, _price, _countryId);
290 		//
291 		return lastId;
292 	}
293 
294 	// adding a monument (city must exist)
295 	function adminAddMonument(string _name, uint256 _price, uint16 _cityId) public returns (uint256) {
296 		// requires
297 		require(msg.sender == unitedNations);
298 		require(_price > 0);
299 		// add monument
300 		uint256 lastId = monuments.push(monument(_name, _price, 0, _cityId)) - 1;
301 		cities[_cityId].monuments.push(lastId);
302 		// event
303 		NewMonument(lastId, _name, _price, _cityId);
304 		//
305 		return lastId;
306 	}
307 
308 	// Edit a city if it hasn't been bought yet
309 	function adminEditCity(uint16 _cityId, string _name, uint256 _price, address _owner) public {
310 		// requires
311 		require(msg.sender == unitedNations);
312 		require(cities[_cityId].owner == 0x0);
313 		//
314 		cities[_cityId].name = _name;
315 		cities[_cityId].price = _price;
316 		cities[_cityId].owner = _owner;
317 	}
318 
319 	// 
320 	// Buy and manage a city
321 	//
322 
323 	function buyCity(uint16 _cityId) public payable {
324 		// fetch
325 		city memory fetchedCity = cities[_cityId];
326 		// requires
327 		require(fetchedCity.buyable == true);
328 		require(fetchedCity.owner == 0x0); 
329 		require(msg.value >= fetchedCity.price);
330 		// transfer ownership
331 		cities[_cityId].owner = msg.sender;
332 		// update city metadata
333 		cities[_cityId].buyable = false;
334 		cities[_cityId].last_purchase_price = fetchedCity.price;
335 		// increase economy of region according to ECONOMY_BOOST
336 		uint16[] memory fetchedCities = countries[fetchedCity.countryId].cities;
337 		uint256 perCityBoost = ECONOMY_BOOST / fetchedCities.length;
338 		for(uint16 ii = 0; ii < fetchedCities.length; ii++){
339 			address _to = cities[fetchedCities[ii]].owner;
340 			if(_to != 0x0) { // MINT only if address exists
341 				balances[_to] = balances[_to].add(perCityBoost);
342 				totalSupply_ += perCityBoost; // update the total supply
343 			}
344 		}
345 		// event
346 		CitySold(_cityId, fetchedCity.price, 0x0, msg.sender, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
347 	}
348 
349 	//
350 	// Economy boost:
351 	// this is called by functions below that will "buy a city from someone else"
352 	// it will draw ECONOMY_BOOST_TRADE CITYs from the UN funds and split them in the relevant country
353 	//
354 
355 	function economyBoost(uint16 _countryId, uint16 _excludeCityId) private {
356 		if(balances[unitedNations] < ECONOMY_BOOST_TRADE) {
357 			return; // unless the UN has no more funds
358 		}
359 		uint16[] memory fetchedCities = countries[_countryId].cities;
360 		if(fetchedCities.length == 1) {
361 			return;
362 		}
363 		uint256 perCityBoost = ECONOMY_BOOST_TRADE / (fetchedCities.length - 1); // excluding the bought city
364 		for(uint16 ii = 0; ii < fetchedCities.length; ii++){
365 			address _to = cities[fetchedCities[ii]].owner;
366 			if(_to != 0x0 && fetchedCities[ii] != _excludeCityId) { // only if address exists AND not the current city
367 				balances[_to] = balances[_to].add(perCityBoost);
368 				balances[unitedNations] -= perCityBoost;
369 			}
370 		}
371 	}
372 
373 	//
374 	// Sell a city
375 	//
376 
377 	// step 1: owner sets buyable = true
378 	function sellCityForEther(uint16 _cityId, uint256 _price) public {
379 		// requires
380 		require(cities[_cityId].owner == msg.sender);
381 		// for sale
382 		cities[_cityId].price = _price;
383 		cities[_cityId].buyable = true;
384 		// event
385 		CityForSale(_cityId, _price);
386 	}
387 
388 	event CityNotForSale(uint16 cityId);
389 
390 	// step 2: owner can always cancel 
391 	function cancelSellCityForEther(uint16 _cityId) public {
392 		// requires
393 		require(cities[_cityId].owner == msg.sender);
394 		//
395 		cities[_cityId].buyable = false;
396 		// event
397 		CityNotForSale(_cityId);
398 	}
399 
400 	// step 3: someone else accepts the offer
401 	function resolveSellCityForEther(uint16 _cityId) public payable {
402 		// fetch
403 		city memory fetchedCity = cities[_cityId];
404 		// requires
405 		require(fetchedCity.buyable == true);
406 		require(msg.value >= fetchedCity.price);
407 		require(fetchedCity.owner != msg.sender);
408 		// calculate the fee
409 		uint256 fee = BUY_CITY_FEE.mul(fetchedCity.price) / 100;
410 		// pay the price
411 		address previousOwner =	fetchedCity.owner;
412 		previousOwner.transfer(fetchedCity.price.sub(fee));
413 		// transfer of ownership
414 		cities[_cityId].owner = msg.sender;
415 		// update metadata
416 		cities[_cityId].buyable = false;
417 		cities[_cityId].last_purchase_price = fetchedCity.price;
418 		// increase economy of region
419 		economyBoost(fetchedCity.countryId, _cityId);
420 		// event
421 		CitySold(_cityId, fetchedCity.price, previousOwner, msg.sender, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
422 	}
423 
424 	//
425 	// Make an offer for a city
426 	//
427 
428 	struct offer {
429 		uint16 cityId;
430 		uint256 price;
431 		address from;
432 	}
433 
434 	offer[] public offers;
435 
436 	event OfferForCity(uint256 offerId, uint16 cityId, uint256 price, address offererAddress, address owner);
437 	event CancelOfferForCity(uint256 offerId);
438 
439 	// 1. we make an offer for some cityId that we don't own yet (we deposit money in escrow)
440 	function makeOfferForCity(uint16 _cityId, uint256 _price) public payable {
441 		// requires
442 		require(cities[_cityId].owner != 0x0);
443 		require(_price > 0);
444 		require(msg.value >= _price);
445 		require(cities[_cityId].owner != msg.sender);
446 		// add the offer
447 		uint256 lastId = offers.push(offer(_cityId, _price, msg.sender)) - 1;
448 		// event
449 		OfferForCity(lastId, _cityId, _price, msg.sender, cities[_cityId].owner);
450 	}
451 
452 	// 2. we cancel it (getting back our money)
453 	function cancelOfferForCity(uint256 _offerId) public {
454 		// fetch
455 		offer memory offerFetched = offers[_offerId];
456 		// requires
457 		require(offerFetched.from == msg.sender);
458 		// refund
459 		msg.sender.transfer(offerFetched.price);
460 		// remove offer
461 		offers[_offerId].cityId = 0;
462 		offers[_offerId].price = 0;
463 		offers[_offerId].from = 0x0;
464 		// event
465 		CancelOfferForCity(_offerId);
466 	}
467 
468 	// 3. the city owner can accept the offer
469 	function acceptOfferForCity(uint256 _offerId, uint16 _cityId, uint256 _price) public {
470 		// fetch
471 		city memory fetchedCity = cities[_cityId];
472 		offer memory offerFetched = offers[_offerId];
473 		// requires
474 		require(offerFetched.cityId == _cityId);
475 		require(offerFetched.from != 0x0);
476 		require(offerFetched.from != msg.sender);
477 		require(offerFetched.price == _price);
478 		require(fetchedCity.owner == msg.sender);
479 		// compute the fee
480 		uint256 fee = BUY_CITY_FEE.mul(_price) / 100;
481 		// transfer the escrowed money
482 		cities[_cityId].owner.transfer(_price.sub(fee));
483 		// transfer of ownership
484 		cities[_cityId].owner = offerFetched.from;
485 		// update metadata
486 		cities[_cityId].last_purchase_price = _price;
487 		cities[_cityId].buyable = false; // in case it was also set to be purchasable
488 		// increase economy of region 
489 		economyBoost(fetchedCity.countryId, _cityId);
490 		// event
491 		CitySold(_cityId, _price, msg.sender, offerFetched.from, _offerId);
492 		// remove offer
493 		offers[_offerId].cityId = 0;
494 		offers[_offerId].price = 0;
495 		offers[_offerId].from = 0x0;
496 	}
497 
498 	//
499 	// in-game use of CITYs
500 	//
501 
502 	/* 
503    	uint256 public MONUMENT_UN_FEE = 3; // UN fee (CITY) to buy a monument
504    	uint256 public MONUMENT_CITY_FEE = 3; // additional fee (CITY) to buy a monument (shared to the monument's city)
505    	*/
506 
507    	// TODO: complicated function, test it thoroughly!
508 
509 	// anyone can buy a monument from someone else (with CITYs)
510 	function buyMonument(uint256 _monumentId, uint256 _price) public {
511 		// fetch
512 		monument memory fetchedMonument = monuments[_monumentId];
513 		// requires
514 		require(fetchedMonument.price > 0);
515 		require(fetchedMonument.price == _price);
516 		require(balances[msg.sender] >= _price);
517 		require(fetchedMonument.owner != msg.sender);
518 		// pay first!
519 		balances[msg.sender] = balances[msg.sender].sub(_price);
520 		// compute fee
521 		uint256 UN_fee = MONUMENT_UN_FEE.mul(_price) / 100;
522 		uint256 city_fee = MONUMENT_CITY_FEE.mul(_price) / 100;
523 		// previous owner gets paid
524 		uint256 toBePaid = _price.sub(UN_fee);
525 		toBePaid = toBePaid.sub(city_fee);
526 		balances[fetchedMonument.owner] = balances[fetchedMonument.owner].add(toBePaid);
527 		// UN gets a fee
528 		balances[unitedNations] = balances[unitedNations].add(UN_fee);
529 		// city gets a fee
530 		address cityOwner = cities[fetchedMonument.cityId].owner;
531 		balances[cityOwner] = balances[cityOwner].add(city_fee);
532 		// transfer of ownership
533 		monuments[_monumentId].owner = msg.sender;
534 		// price increase of the monument
535 		monuments[_monumentId].price = monuments[_monumentId].price.mul(2);
536 		// event
537 		MonumentSold(_monumentId, _price);
538 	}
539 
540 }