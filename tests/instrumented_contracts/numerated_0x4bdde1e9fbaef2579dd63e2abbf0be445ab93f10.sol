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
46 
47 contract CityMayor {
48 
49 	using SafeMath for uint256;
50 
51 	//
52 	// ERC-20
53 	//
54 
55    	string public name = "CityCoin";
56    	string public symbol = "CITY";
57    	uint8 public decimals = 0;
58 
59 	mapping(address => uint256) balances;
60 
61 	event Approval(address indexed owner, address indexed spender, uint256 value);
62 	event Transfer(address indexed from, address indexed to, uint256 value);
63 
64 	/**
65 	* @dev total number of tokens in existence
66 	*/
67 	uint256 totalSupply_;
68 	function totalSupply() public view returns (uint256) {
69 		return totalSupply_;
70 	}
71 
72 	/**
73 	* @dev transfer token for a specified address
74 	* @param _to The address to transfer to.
75 	* @param _value The amount to be transferred.
76 	*/
77 	function transfer(address _to, uint256 _value) public returns (bool) {
78 		require(_to != address(0));
79 		require(_value <= balances[msg.sender]);
80 
81 		// SafeMath.sub will throw if there is not enough balance.
82 		balances[msg.sender] = balances[msg.sender].sub(_value);
83 		balances[_to] = balances[_to].add(_value);
84 		Transfer(msg.sender, _to, _value);
85 		return true;
86 	}
87 
88 	/**
89 	* @dev Gets the balance of the specified address.
90 	* @param _owner The address to query the the balance of.
91 	* @return An uint256 representing the amount owned by the passed address.
92 	*/
93 	function balanceOf(address _owner) public view returns (uint256 balance) {
94 		return balances[_owner];
95 	}
96 
97 	mapping (address => mapping (address => uint256)) internal allowed;
98 
99 
100 	/**
101 	* @dev Transfer tokens from one address to another
102 	* @param _from address The address which you want to send tokens from
103 	* @param _to address The address which you want to transfer to
104 	* @param _value uint256 the amount of tokens to be transferred
105 	*/
106 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107 		require(_to != address(0));
108 		require(_value <= balances[_from]);
109 		require(_value <= allowed[_from][msg.sender]);
110 
111 		balances[_from] = balances[_from].sub(_value);
112 		balances[_to] = balances[_to].add(_value);
113 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114 		Transfer(_from, _to, _value);
115 		return true;
116 	}
117 
118 	/**
119 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
120 	*
121 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
122 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
123 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
124 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125 	* @param _spender The address which will spend the funds.
126 	* @param _value The amount of tokens to be spent.
127 	*/
128 	function approve(address _spender, uint256 _value) public returns (bool) {
129 		allowed[msg.sender][_spender] = _value;
130 		Approval(msg.sender, _spender, _value);
131 		return true;
132 	}
133 
134 	/**
135 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
136 	* @param _owner address The address which owns the funds.
137 	* @param _spender address The address which will spend the funds.
138 	* @return A uint256 specifying the amount of tokens still available for the spender.
139 	*/
140 	function allowance(address _owner, address _spender) public view returns (uint256) {
141 		return allowed[_owner][_spender];
142 	}
143 
144 	/**
145 	* @dev Increase the amount of tokens that an owner allowed to a spender.
146 	*
147 	* approve should be called when allowed[_spender] == 0. To increment
148 	* allowed value is better to use this function to avoid 2 calls (and wait until
149 	* the first transaction is mined)
150 	* From MonolithDAO Token.sol
151 	* @param _spender The address which will spend the funds.
152 	* @param _addedValue The amount of tokens to increase the allowance by.
153 	*/
154 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
155 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157 		return true;
158 	}
159 
160 	/**
161 	* @dev Decrease the amount of tokens that an owner allowed to a spender.
162 	*
163 	* approve should be called when allowed[_spender] == 0. To decrement
164 	* allowed value is better to use this function to avoid 2 calls (and wait until
165 	* the first transaction is mined)
166 	* From MonolithDAO Token.sol
167 	* @param _spender The address which will spend the funds.
168 	* @param _subtractedValue The amount of tokens to decrease the allowance by.
169 	*/
170 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
171 		uint oldValue = allowed[msg.sender][_spender];
172 		if (_subtractedValue > oldValue) {
173 			allowed[msg.sender][_spender] = 0;
174 			} else {
175 				allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
176 			}
177 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178 			return true;
179 		}
180 
181    	//
182    	// Game Meta values
183    	//
184 
185    	address public unitedNations; // the UN organisation
186 
187    	uint16 public MAX_CITIES = 5000; // maximum amount of cities in our world
188    	uint256 public UNITED_NATIONS_FUND = 5000000; // initial funding for the UN
189    	uint256 public ECONOMY_BOOST = 5000; // minted CITYs when a new city is being bought 
190 
191    	uint256 public BUY_CITY_FEE = 3; // UN fee (% of ether) to buy a city from someon / 100e
192    	uint256 public ECONOMY_BOOST_TRADE = 100; // _immutable_ gift (in CITY) from the UN when a city is traded (shared among the cities of the relevant country)
193 
194    	uint256 public MONUMENT_UN_FEE = 3; // UN fee (CITY) to buy a monument
195    	uint256 public MONUMENT_CITY_FEE = 3; // additional fee (CITY) to buy a monument (shared to the monument's city)
196 
197    	//
198    	// Game structures
199    	//
200 
201    	struct country {
202    		string name;
203    		uint16[] cities;
204    	}
205 
206    	struct city {
207    		string name;
208    		uint256 price;
209    		address owner;
210 
211    		uint16 countryId;
212    		uint256[] monuments;
213 
214    		bool buyable; // set to true when it can be bought
215 
216    		uint256 last_purchase_price;
217    	}
218 
219    	struct monument {
220    		string name;
221    		uint256 price;
222    		address owner;
223 
224    		uint16 cityId;
225    	}
226 
227    	city[] public cities; // cityId -> city
228    	country[] public countries; // countryId -> country
229    	monument[] public monuments; // monumentId -> monument
230 
231    	// total amount of offers (escrowed money)
232 	uint256 public totalOffer;
233 
234    	//
235    	// Game events
236    	//
237 
238 
239 	event NewCity(uint256 cityId, string name, uint256 price, uint16 countryId);
240 	event NewMonument(uint256 monumentId, string name, uint256 price, uint16 cityId);
241 
242 	event CityForSale(uint16 cityId, uint256 price);
243 	event CitySold(uint16 cityId, uint256 price, address previousOwner, address newOwner, uint256 offerId);
244 
245 	event MonumentSold(uint256 monumentId, uint256 price);
246 
247    	// 
248    	// Admin stuff
249    	//
250 
251    	// constructor
252    	function CityMayor() public {
253    		unitedNations = msg.sender;
254    		balances[unitedNations] = UNITED_NATIONS_FUND; // initial funding for the united nations
255    		uint256 perFounder = 500000;
256    		balances[address(0xe1811eC49f493afb1F4B42E3Ef4a3B9d62d9A01b)] = perFounder; // david
257    		balances[address(0x1E4F1275bB041586D7Bec44D2E3e4F30e0dA7Ba4)] = perFounder; // simon
258    		balances[address(0xD5d6301dE62D82F461dC29824FC597D38d80c424)] = perFounder; // eric
259    		// total supply updated
260    		totalSupply_ = UNITED_NATIONS_FUND + 3 * perFounder;
261    	}
262 
263    	// this function is used to let admins give cities back to owners of previous contracts
264    	function AdminBuyForSomeone(uint16 _cityId, address _owner) public {
265    		// admin only
266    		require(msg.sender == unitedNations);
267 	   	// fetch
268 	   	city memory fetchedCity = cities[_cityId];
269 	   	// requires
270 		require(fetchedCity.buyable == true);
271 		require(fetchedCity.owner == 0x0); 
272 	   	// transfer ownership
273 	   	cities[_cityId].owner = _owner;
274 	   	// update city metadata
275 	   	cities[_cityId].buyable = false;
276 	   	cities[_cityId].last_purchase_price = fetchedCity.price;
277 	   	// increase economy of region according to ECONOMY_BOOST
278 	   	uint16[] memory fetchedCities = countries[fetchedCity.countryId].cities;
279 	   	uint256 perCityBoost = ECONOMY_BOOST / fetchedCities.length;
280 	   	for(uint16 ii = 0; ii < fetchedCities.length; ii++){
281 	   		address _to = cities[fetchedCities[ii]].owner;
282 	   		if(_to != 0x0) { // MINT only if address exists
283 	   			balances[_to] = balances[_to].add(perCityBoost);
284 	   			totalSupply_ += perCityBoost; // update the total supply
285 	   		}
286 	   	}
287 	   	// event
288 	   	CitySold(_cityId, fetchedCity.price, 0x0, _owner, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);	
289    	}
290 
291    	// this function allows to make an offer from someone else
292 	function makeOfferForCityForSomeone(uint16 _cityId, uint256 _price, address from) public payable {
293 		// only for admins
294 		require(msg.sender == unitedNations);
295 		// requires
296 		require(cities[_cityId].owner != 0x0);
297 		require(_price > 0);
298 		require(msg.value >= _price);
299 		require(cities[_cityId].owner != from);
300 		// add the offer
301 		uint256 lastId = offers.push(offer(_cityId, _price, from)) - 1;
302 		// increment totalOffer
303 		totalOffer = totalOffer.add(_price);
304 		// event
305 		OfferForCity(lastId, _cityId, _price, from, cities[_cityId].owner);
306 	}
307 
308 	// withdrawing funds
309 	function adminWithdraw(uint256 _amount) public {
310 		require(msg.sender == 0xD5d6301dE62D82F461dC29824FC597D38d80c424 || msg.sender == 0x1E4F1275bB041586D7Bec44D2E3e4F30e0dA7Ba4 || msg.sender == 0xe1811eC49f493afb1F4B42E3Ef4a3B9d62d9A01b || msg.sender == unitedNations);
311 		// do not touch the escrowed money
312 		uint256 totalAvailable = this.balance.sub(totalOffer);
313 		if(_amount > totalAvailable) {
314 			_amount = totalAvailable;
315 		}
316 		// divide the amount for founders
317 		uint256 perFounder = _amount / 3;
318 		address(0xD5d6301dE62D82F461dC29824FC597D38d80c424).transfer(perFounder); // eric
319 		address(0x1E4F1275bB041586D7Bec44D2E3e4F30e0dA7Ba4).transfer(perFounder); // simon
320 		address(0xe1811eC49f493afb1F4B42E3Ef4a3B9d62d9A01b).transfer(perFounder); // david
321 	}
322 
323 	//
324 	// Admin adding stuff
325 	//
326 
327 	// we need to add a country before we can add a city
328 	function adminAddCountry(string _name) public returns (uint256) {
329 		// requires
330 		require(msg.sender == unitedNations);
331 		// add country
332 		uint256 lastId = countries.push(country(_name, new uint16[](0))) - 1; 
333 		//
334 		return lastId;
335 	}
336 	// adding a city will mint ECONOMY_BOOST citycoins (country must exist)
337 	function adminAddCity(string _name, uint256 _price, uint16 _countryId) public returns (uint256) {
338 		// requires
339 		require(msg.sender == unitedNations);
340 		require(cities.length < MAX_CITIES);
341 		// add city
342 		uint256 lastId = cities.push(city(_name, _price, 0, _countryId, new uint256[](0), true, 0)) - 1;
343 		countries[_countryId].cities.push(uint16(lastId));
344 		// event
345 		NewCity(lastId, _name, _price, _countryId);
346 		//
347 		return lastId;
348 	}
349 
350 	// adding a monument (city must exist)
351 	function adminAddMonument(string _name, uint256 _price, uint16 _cityId) public returns (uint256) {
352 		// requires
353 		require(msg.sender == unitedNations);
354 		require(_price > 0);
355 		// add monument
356 		uint256 lastId = monuments.push(monument(_name, _price, 0, _cityId)) - 1;
357 		cities[_cityId].monuments.push(lastId);
358 		// event
359 		NewMonument(lastId, _name, _price, _cityId);
360 		//
361 		return lastId;
362 	}
363 
364 	// Edit a city if it hasn't been bought yet
365 	function adminEditCity(uint16 _cityId, string _name, uint256 _price, address _owner) public {
366 		// requires
367 		require(msg.sender == unitedNations);
368 		require(cities[_cityId].owner == 0x0);
369 		//
370 		cities[_cityId].name = _name;
371 		cities[_cityId].price = _price;
372 		cities[_cityId].owner = _owner;
373 	}
374 
375 	// 
376 	// Buy and manage a city
377 	//
378 
379 	function buyCity(uint16 _cityId) public payable {
380 		// fetch
381 		city memory fetchedCity = cities[_cityId];
382 		// requires
383 		require(fetchedCity.buyable == true);
384 		require(fetchedCity.owner == 0x0); 
385 		require(msg.value >= fetchedCity.price);
386 		// transfer ownership
387 		cities[_cityId].owner = msg.sender;
388 		// update city metadata
389 		cities[_cityId].buyable = false;
390 		cities[_cityId].last_purchase_price = fetchedCity.price;
391 		// increase economy of region according to ECONOMY_BOOST
392 		uint16[] memory fetchedCities = countries[fetchedCity.countryId].cities;
393 		uint256 perCityBoost = ECONOMY_BOOST / fetchedCities.length;
394 		for(uint16 ii = 0; ii < fetchedCities.length; ii++){
395 			address _to = cities[fetchedCities[ii]].owner;
396 			if(_to != 0x0) { // MINT only if address exists
397 				balances[_to] = balances[_to].add(perCityBoost);
398 				totalSupply_ += perCityBoost; // update the total supply
399 			}
400 		}
401 		// event
402 		CitySold(_cityId, fetchedCity.price, 0x0, msg.sender, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
403 	}
404 
405 	//
406 	// Economy boost:
407 	// this is called by functions below that will "buy a city from someone else"
408 	// it will draw ECONOMY_BOOST_TRADE CITYs from the UN funds and split them in the relevant country
409 	//
410 
411 	function economyBoost(uint16 _countryId, uint16 _excludeCityId) private {
412 		if(balances[unitedNations] < ECONOMY_BOOST_TRADE) {
413 			return; // unless the UN has no more funds
414 		}
415 		uint16[] memory fetchedCities = countries[_countryId].cities;
416 		if(fetchedCities.length == 1) {
417 			return;
418 		}
419 		uint256 perCityBoost = ECONOMY_BOOST_TRADE / (fetchedCities.length - 1); // excluding the bought city
420 		for(uint16 ii = 0; ii < fetchedCities.length; ii++){
421 			address _to = cities[fetchedCities[ii]].owner;
422 			if(_to != 0x0 && fetchedCities[ii] != _excludeCityId) { // only if address exists AND not the current city
423 				balances[_to] = balances[_to].add(perCityBoost);
424 				balances[unitedNations] -= perCityBoost;
425 			}
426 		}
427 	}
428 
429 	//
430 	// Sell a city
431 	//
432 
433 	// step 1: owner sets buyable = true
434 	function sellCityForEther(uint16 _cityId, uint256 _price) public {
435 		// requires
436 		require(cities[_cityId].owner == msg.sender);
437 		// for sale
438 		cities[_cityId].price = _price;
439 		cities[_cityId].buyable = true;
440 		// event
441 		CityForSale(_cityId, _price);
442 	}
443 
444 	event CityNotForSale(uint16 cityId);
445 
446 	// step 2: owner can always cancel 
447 	function cancelSellCityForEther(uint16 _cityId) public {
448 		// requires
449 		require(cities[_cityId].owner == msg.sender);
450 		//
451 		cities[_cityId].buyable = false;
452 		// event
453 		CityNotForSale(_cityId);
454 	}
455 
456 	// step 3: someone else accepts the offer
457 	function resolveSellCityForEther(uint16 _cityId) public payable {
458 		// fetch
459 		city memory fetchedCity = cities[_cityId];
460 		// requires
461 		require(fetchedCity.buyable == true);
462 		require(msg.value >= fetchedCity.price);
463 		require(fetchedCity.owner != msg.sender);
464 		// calculate the fee
465 		uint256 fee = BUY_CITY_FEE.mul(fetchedCity.price) / 100;
466 		// pay the price
467 		address previousOwner =	fetchedCity.owner;
468 		previousOwner.transfer(fetchedCity.price.sub(fee));
469 		// transfer of ownership
470 		cities[_cityId].owner = msg.sender;
471 		// update metadata
472 		cities[_cityId].buyable = false;
473 		cities[_cityId].last_purchase_price = fetchedCity.price;
474 		// increase economy of region
475 		economyBoost(fetchedCity.countryId, _cityId);
476 		// event
477 		CitySold(_cityId, fetchedCity.price, previousOwner, msg.sender, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
478 	}
479 
480 	//
481 	// Make an offer for a city
482 	//
483 
484 	struct offer {
485 		uint16 cityId;
486 		uint256 price;
487 		address from;
488 	}
489 
490 	offer[] public offers;
491 
492 	event OfferForCity(uint256 offerId, uint16 cityId, uint256 price, address offererAddress, address owner);
493 	event CancelOfferForCity(uint256 offerId);
494 
495 	// 1. we make an offer for some cityId that we don't own yet (we deposit money in escrow)
496 	function makeOfferForCity(uint16 _cityId, uint256 _price) public payable {
497 		// requires
498 		require(cities[_cityId].owner != 0x0);
499 		require(_price > 0);
500 		require(msg.value >= _price);
501 		require(cities[_cityId].owner != msg.sender);
502 		// add the offer
503 		uint256 lastId = offers.push(offer(_cityId, _price, msg.sender)) - 1;
504 		// increment totalOffer
505 		totalOffer = totalOffer.add(_price);
506 		// event
507 		OfferForCity(lastId, _cityId, _price, msg.sender, cities[_cityId].owner);
508 	}
509 
510 	// 2. we cancel it (getting back our money)
511 	function cancelOfferForCity(uint256 _offerId) public {
512 		// fetch
513 		offer memory offerFetched = offers[_offerId];
514 		// requires
515 		require(offerFetched.from == msg.sender);
516 		// refund
517 		msg.sender.transfer(offerFetched.price);
518 		// decrement totaloffer
519 		totalOffer = totalOffer.sub(offerFetched.price);
520 		// remove offer
521 		offers[_offerId].cityId = 0;
522 		offers[_offerId].price = 0;
523 		offers[_offerId].from = 0x0;
524 		// event
525 		CancelOfferForCity(_offerId);
526 	}
527 
528 	// 3. the city owner can accept the offer
529 	function acceptOfferForCity(uint256 _offerId, uint16 _cityId, uint256 _price) public {
530 		// fetch
531 		city memory fetchedCity = cities[_cityId];
532 		offer memory offerFetched = offers[_offerId];
533 		// requires
534 		require(offerFetched.cityId == _cityId);
535 		require(offerFetched.from != 0x0);
536 		require(offerFetched.from != msg.sender);
537 		require(offerFetched.price == _price);
538 		require(fetchedCity.owner == msg.sender);
539 		// compute the fee
540 		uint256 fee = BUY_CITY_FEE.mul(_price) / 100;
541 		// transfer the escrowed money
542 		uint256 priceSubFee = _price.sub(fee);
543 		cities[_cityId].owner.transfer(priceSubFee);
544 		// decrement tracked amount of escrowed ethers
545 		totalOffer = totalOffer.sub(priceSubFee);
546 		// transfer of ownership
547 		cities[_cityId].owner = offerFetched.from;
548 		// update metadata
549 		cities[_cityId].last_purchase_price = _price;
550 		cities[_cityId].buyable = false; // in case it was also set to be purchasable
551 		// increase economy of region 
552 		economyBoost(fetchedCity.countryId, _cityId);
553 		// event
554 		CitySold(_cityId, _price, msg.sender, offerFetched.from, _offerId);
555 		// remove offer
556 		offers[_offerId].cityId = 0;
557 		offers[_offerId].price = 0;
558 		offers[_offerId].from = 0x0;
559 	}
560 
561 	//
562 	// in-game use of CITYs
563 	//
564 
565 	/* 
566    	uint256 public MONUMENT_UN_FEE = 3; // UN fee (CITY) to buy a monument
567    	uint256 public MONUMENT_CITY_FEE = 3; // additional fee (CITY) to buy a monument (shared to the monument's city)
568    	*/
569 
570 	// anyone can buy a monument from someone else (with CITYs)
571 	function buyMonument(uint256 _monumentId, uint256 _price) public {
572 		// fetch
573 		monument memory fetchedMonument = monuments[_monumentId];
574 		// requires
575 		require(fetchedMonument.price > 0);
576 		require(fetchedMonument.price == _price);
577 		require(balances[msg.sender] >= _price);
578 		require(fetchedMonument.owner != msg.sender);
579 		// pay first!
580 		balances[msg.sender] = balances[msg.sender].sub(_price);
581 		// compute fee
582 		uint256 UN_fee = MONUMENT_UN_FEE.mul(_price) / 100;
583 		uint256 city_fee = MONUMENT_CITY_FEE.mul(_price) / 100;
584 		// previous owner gets paid
585 		uint256 toBePaid = _price.sub(UN_fee);
586 		toBePaid = toBePaid.sub(city_fee);
587 		balances[fetchedMonument.owner] = balances[fetchedMonument.owner].add(toBePaid);
588 		// UN gets a fee
589 		balances[unitedNations] = balances[unitedNations].add(UN_fee);
590 		// city gets a fee
591 		address cityOwner = cities[fetchedMonument.cityId].owner;
592 		balances[cityOwner] = balances[cityOwner].add(city_fee);
593 		// transfer of ownership
594 		monuments[_monumentId].owner = msg.sender;
595 		// price increase of the monument
596 		monuments[_monumentId].price = monuments[_monumentId].price.mul(2);
597 		// event
598 		MonumentSold(_monumentId, _price);
599 	}
600 
601 }