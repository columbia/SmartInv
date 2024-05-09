1 pragma solidity ^0.4.11;
2 
3 /* Ethart Registrar Contract:
4 
5 	https://ethart.com - The Ethereum Art Network
6 
7 	Ethart ARCHITECTURE
8 	-------------------
9 						_________________________________________
10 						V										V
11 	Controller --> Registrar <--> Factory Contract1 --> Artwork Contract1
12 								  Factory Contract2	    Artwork Contract2
13 								  		...					...
14 								  Factory ContractN	    Artwork ContractN
15 
16 	Controller: The controller contract is the owner of the Registrar contract and can
17 		- Set a new owner
18 		- Control the assets of the Registrar (withdraw ETH, transfer, sell, burn pieces owned by the Registrar)
19 		- The plan is to have the controller contract be a DAO in preparation for a possible ICO
20 	
21 	Registrar:
22 		- The Registrar contract acts as the central registry for all sha256 hashes in the Ethart factory contract network.
23 		- Approved Factory Contracts can register sha256 hashes using the Registrar interface.
24 		- ethartArtReward of the art produced and ethartRevenueReward of turnover of the contract network will be awarded to the Registrar.
25 	
26 	Factory Contracts:
27 		- Factory Contracts can spawn Artwork Contracts in line with artists specifications
28 		- Factory Contracts will only spawn Artwork Contracts who's sha256 hashes are unique per the Registrar's sha256 registry
29 		- Factory Contracts will register every new Artwork Contract with it's details with the Registrar contract
30 	
31 	Artwork Contracts:
32 		- Artwork Contracts act as minimalist decentralised exchanges for their pieces in line with specified conditions
33 		- Artwork Contracts will interact with the Registrar to issue buyers of pieces a predetermined amount of Patron tokens based on the transaction value 
34 		- Artwork Contracts can be interacted with by the Controller via the Registrar using their interfaces to transfer, sell, burn etc pieces
35 	
36 	(c) Stefan Pernar 2017 - all rights reserved
37 	(c) ERC20 functions BokkyPooBah 2017. The MIT Licence.
38 */
39 
40 contract Interface {
41 
42 	// Ethart network interface
43 	function registerArtwork (address _contract, bytes32 _SHA256Hash, uint256 _editionSize, string _title, string _fileLink, uint256 _ownerCommission, address _artist, bool _indexed, bool _ouroboros);
44 	function isSHA256HashRegistered (bytes32 _SHA256Hash) returns (bool _registered);			// Check if a sha256 hash is registered
45 	function isFactoryApproved (address _factory) returns (bool _approved);						// Check if an address is a registered factory contract
46 	function issuePatrons (address _to, uint256 _amount);										// Issues Patron tokens according to conditions specified in factory contracts
47 	function approveFactoryContract (address _factoryContractAddress, bool _approved);			// Approves/disapproves factory contracts.
48 	function changeOwner (address newOwner);													// Change the registrar's owner.
49 
50 	function offerPieceForSaleByAddress (address _contract, uint256 _price);					// Sell a piece owned by the registrar.
51 	function offerPieceForSale (uint256 _price);
52 	function fillBidByAddress (address _contract);												// Fill a bid with an unindexed piece owned by the registrar
53 	function fillBid();
54 	function cancelSaleByAddress (address _contract);											// Cancel the sale of an unindexed piece owned by the registrar
55 	function cancelSale();
56 	function offerIndexedPieceForSaleByAddress (address _contract, uint256 _index, uint256 _price);				// Sell an indexed piece owned by the registrar.
57 	function offerIndexedPieceForSale(uint256 _index, uint256 _price);
58 	function fillIndexedBidByAddress (address _contract, uint256 _index);						// Fill a bid with an indexed piece owned by the registrar
59 	function fillIndexedBid (uint256 _index);
60 	function cancelIndexedSaleByAddress (address _contract);									// Cancel the sale of an unindexed piece owned by the registrar
61 	function cancelIndexedSale();
62 
63 	function transferByAddress (address _contract, uint256 _amount, address _to);				// Transfers unindexed pieces owned by the registrar contract
64 	function transferIndexedByAddress (address _contract, uint256 _index, address _to);			// Transfers indexed pieces owned by the registrar contract
65 	function approveByAddress (address _contract, address _spender, uint256 _amount);			// Sets an allowance for unindexed pieces owned by the registrar contract
66 	function approveIndexedByAddress (address _contract, address _spender, uint256 _index);		// Sets an allowance for indexed pieces owned by the registrar contract
67 	function burnByAddress (address _contract, uint256 _amount);								// Burn an unindexed piece owned by the registrar contract
68 	function burnFromByAddress (address _contract, uint256 _amount, address _from);				// Burn an unindexed piece owned by annother address
69 	function burnIndexedByAddress (address _contract, uint256 _index);							// Burn an indexed piece owned by the registrar contract
70 	function burnIndexedFromByAddress (address _contract, address _from, uint256 _index);		// Burn an indexed piece owned by another address
71 
72 	// ERC20 interface
73 	function totalSupply() constant returns (uint256 totalSupply);									// Returns the total supply of an artwork or token
74 	function balanceOf(address _owner) constant returns (uint256 balance);							// Returns an address' balance of an artwork or token
75  	function transfer(address _to, uint256 _value) returns (bool success);							// Transfers pieces of art or tokens to an address
76  	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);		// Transfers pieces of art of tokens owned by another address to an address
77 	function approve(address _spender, uint256 _value) returns (bool success);						// Sets an allowance for an address
78 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);		// Returns the allowance of an address for another address
79 
80 	// Additional token functions
81 	function burn(uint256 _amount) returns (bool success);										// Burns (removes from circulation) unindexed pieces of art or tokens.
82 																								// In the case of 'ouroboros' pieces this function also returns the piece's
83 																								// components to the message sender
84 	
85 	function burnFrom(address _from, uint256 _amount) returns (bool success);					// Burns (removes from circulation) unindexed pieces of art or tokens
86 																								// owned by another address. In the case of 'ouroboros' pieces this
87 																								// function also returns the piece's components to the message sender
88 	
89 	// Extended ERC20 interface for indexed pieces
90 	function transferIndexed (address _to, uint256 __index) returns (bool success);				// Transfers an indexed piece of art
91 	function transferFromIndexed (address _from, address _to, uint256 _index) returns (bool success);	// Transfers an indexed piece of art from another address
92 	function approveIndexed (address _spender, uint256 _index) returns (bool success);			// Sets an allowance for an indexed piece of art for another address
93 	function burnIndexed (uint256 _index);														// Burns (removes from circulation) indexed pieces of art or tokens.
94 																								// In the case of 'ouroboros' pieces this function also returns the
95 																								// piece's components to the message sender
96 	
97 	function burnIndexedFrom (address _owner, uint256 _index);									// Burns (removes from circulation) indexed pieces of art or tokens
98 																								// owned by another address. In the case of 'ouroboros' pieces this
99 																								// function also returns the piece's components to the message sender
100 
101 }
102 
103 contract Registrar {
104 
105 	// Patron token ERC20 public variables
106 	string public constant symbol = "ART";
107 	string public constant name = "Patron - Ethart Network Token";
108 	uint8 public constant decimals = 18;
109 	uint256 _totalPatronSupply;
110 
111 	event Transfer(address indexed _from, address _to, uint256 _value);
112 	event Approval(address indexed _owner, address _spender, uint256 _value);
113 	event Burn(address indexed _owner, uint256 _amount);
114 
115     // Patron token balances for each account
116 	mapping(address => uint256) public balances;						// Patron token balances
117 
118 	event NewArtwork(address _contract, bytes32 _SHA256Hash, uint256 _editionSize, string _title, string _fileLink, uint256 _ownerCommission, address _artist, bool _indexed, bool _ouroboros);
119 
120 	// Owner of account approves the transfer of an amount of Patron tokens to another account
121 	mapping(address => mapping (address => uint256)) allowed;			// Patron token allowances
122 	
123 	// Mitigating ERC20 short address attacks (http://vessenes.com/the-erc20-short-address-attack-explained/)
124 	modifier onlyPayloadSize(uint size)
125 	{
126 		require(msg.data.length >= size + 4);
127 		_;
128 	}
129 	
130 	// BEGIN ERC20 functions (c) BokkyPooBah 2017. The MIT Licence.
131 
132 	function totalSupply() constant returns (uint256 totalPatronSupply) {
133 		totalPatronSupply = _totalPatronSupply;
134 		}
135 
136 	// What is the balance of a particular account?
137 	function balanceOf(address _owner) constant returns (uint256 balance) {
138  		return balances[_owner];
139 		}
140 
141 	// Transfer the balance from owner's account to another account
142 	function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) returns (bool success) {
143 		if (balances[msg.sender] >= _amount 
144 			&& _amount > 0
145  		   	&& balances[_to] + _amount > balances[_to]
146 			&& _to != 0x0)										// use burn() instead
147 			{
148 			balances[msg.sender] -= _amount;
149 			balances[_to] += _amount;
150 			Transfer(msg.sender, _to, _amount);
151  		   	return true;
152 			}
153 			else { return false;}
154  		 }
155 
156 	// Send _value amount of tokens from address _from to address _to
157 	// The transferFrom method is used for a withdraw workflow, allowing contracts to send
158  	// tokens on your behalf, for example to "deposit" to a contract address and/or to charge
159  	// fees in sub-currencies; the command should fail unless the _from account has
160  	// deliberately authorised the sender of the message via some mechanism; we propose
161  	// these standardised APIs for approval:
162  	function transferFrom( address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) returns (bool success)
163 		{
164 			if (balances[_from] >= _amount
165 				&& allowed[_from][msg.sender] >= _amount
166 				&& _amount > 0
167 				&& balances[_to] + _amount > balances[_to]
168 				&& _to != 0x0)										// use burn() instead
169 					{
170 					balances[_from] -= _amount;
171 					allowed[_from][msg.sender] -= _amount;
172 					balances[_to] += _amount;
173 					Transfer(_from, _to, _amount);
174 					return true;
175 					} else {return false;}
176 		}
177 
178 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
179 	// If this function is called again it overwrites the current allowance with _value.
180 	// To be extra secure set allowance to 0 and check that none of the allowance was spend between you sending the tx and it getting mined. Only then decrease/increase the allowance.
181 	// See https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#heading=h.m9fhqynw2xvt
182 	function approve(address _spender, uint256 _amount) returns (bool success) {
183 		allowed[msg.sender][_spender] = _amount;
184 		Approval(msg.sender, _spender, _amount);
185 		return true;
186 		}
187 
188 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
189 		return allowed[_owner][_spender];
190 		}
191 
192 	// END ERC20 functions (c) BokkyPooBah 2017. The MIT Licence.
193 	
194 	// Additional Patron token functions
195 	
196 	function burn(uint256 _amount) returns (bool success) {
197 			if (balances[msg.sender] >= _amount) {
198 				balances[msg.sender] -= _amount;
199 				_totalPatronSupply -= _amount;
200 				Burn(msg.sender, _amount);
201 				return true;
202 			}
203 			else {throw;}
204 		}
205 
206 	function burnFrom(address _from, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
207 		if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
208 			balances[_from] -= _value;
209 			allowed[_from][msg.sender] -= _value;
210 			_totalPatronSupply -= _value;
211 			Burn(_from, _value);
212 			return true;
213 		}
214 		else {throw;}
215 	}
216 
217 	// BEGIN safe math functions by Open Zeppelin
218 	// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
219 
220 	function mul(uint256 a, uint256 b) internal returns (uint256) {
221 		uint256 c = a * b;
222 		assert(a == 0 || c / a == b);
223 		return c;
224 	}
225 
226 	function div(uint256 a, uint256 b) internal returns (uint256) {
227 		// assert(b > 0); // Solidity automatically throws when dividing by 0
228 		uint256 c = a / b;
229 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 		return c;
231 	}
232 
233 	function sub(uint256 a, uint256 b) internal returns (uint256) {
234 		assert(b <= a);
235 		return a - b;
236 	}
237 
238 	function add(uint256 a, uint256 b) internal returns (uint256) {
239 		uint256 c = a + b;
240 		assert(c >= a);
241 		return c;
242 	}
243 
244 	// END safe math functions by Open Zeppelin
245 
246 	// Ethart variables
247 	
248 	// Register of all SHA256 Hashes
249     mapping (bytes32 => address) public SHA256HashRegister;
250 	
251 	// Register of all approved factory contracts
252 	mapping (address => bool) public approvedFactories;
253 	
254 	// Register of all approved artwork contracts
255 	
256 	// Register of all approved contracts for amending pending withdrawals and issuing Patron tokens
257 	mapping (address => bool) public approvedContracts;
258 	
259 	// Register of all referrers (referee => referrer) used for the affiliate program
260 	mapping (address => address) public referred;
261 	
262 	// Referrer for an artist has to be set _before_ the first piece has been created by an address
263 	mapping (address => bool) public cantSetReferrer;
264 
265 	// Register of all artworks and their details by their respective addresses
266 	struct artwork {
267 		bytes32 SHA256Hash;
268 		uint256 editionSize;
269 		string title;
270 		string fileLink;
271 		uint256 ownerCommission;
272 		address artist;
273 		address factory;
274 		bool isIndexed;
275 		bool isOuroboros;}
276 	
277 	mapping (address => artwork) public artworkRegister;
278 
279 	// An indexed register of all of an artist's artworks
280 
281 	// Enter artist address and a running number to get the artist's artwork addresses
282 	mapping(address => mapping (uint256 => address)) public artistsArtworks;
283 
284 	// A running number counting an artist's artworks
285 	mapping(address => uint256) public artistsArtworkCount;						
286 
287 	// Keeps track of the number of artwork contracts in the network
288 	uint256 public artworkCount;
289 
290 	// An index of all the artwork contracts in the network
291 	mapping (uint256 => address) public artworkIndex;
292 
293 	// All pending withdrawals
294 	mapping (address => uint256) public pendingWithdrawals;
295 	uint256 public totalPendingWithdrawals;
296 
297 	// The address of the Registrar's owner
298 	address public owner;
299 	
300 	// Determines how many Patrons are issues per donation
301 	uint256 public donationMultiplier;
302 	
303 	// Determines how many Patrons are issues per purchase of an artwork in basis points (10,000 = 100%)
304 	uint256 public patronRewardMultiplier;
305 	
306 	// Determines how much Ethart is entitled to artworks/revenue percentages in basis points (10,000 = 100%)
307 	uint256 public ethartRevenueReward;
308 	uint256 public ethartArtReward;
309 	
310 	// Determines how much of a percentage a referrer get of ethartRevenueReward
311 	uint256 public referrerReward;
312 
313 	// Functions with this modifier can only be executed by a specific address
314 	modifier onlyBy (address _account)
315 	{
316 		require(msg.sender == _account);
317 		_;
318 		}
319 
320 	// Functions with this modifier can only be executed by approved factory contracts
321 	modifier registeredFactoriesOnly ()
322 	{
323 		require(approvedFactories[msg.sender]);
324 		_;
325 	}
326 
327 	// Functions with this modifier can only be executed by approved contracts
328 	modifier approvedContractsOnly ()
329 	{
330 		require(approvedContracts[msg.sender]);
331 		_;
332 	}
333 
334 	// Set the referrer of an artist. This has to be done before an artist creates their first artwork.
335 	function setReferrer (address _referrer)
336 		{
337 			if (referred[msg.sender] == 0x0 && !cantSetReferrer[msg.sender] && _referrer != msg.sender)
338 			{
339 				referred[msg.sender] = _referrer;
340 			}
341 		}
342 
343 	function getReferrer (address _artist) returns (address _referrer)
344 		{
345 			return referred[_artist];
346 		}
347 	
348 	function setReferrerReward (uint256 _referrerReward) onlyBy (owner)
349 		{
350 			uint a;
351 			if (_referrerReward > 10000 - ethartRevenueReward) {throw;}
352 			a = 10000 / _referrerReward;
353 			// 10000 / _referrerReward has to be an even number
354 			if (a * _referrerReward != 10000) {throw;}
355 			referrerReward = _referrerReward;
356 		}
357 	
358 	function getReferrerReward () returns (uint256 _referrerReward)
359 		{
360 			return referrerReward;
361 		}
362 
363 	// Constructor
364 	function Registrar () {
365 		owner = msg.sender;
366 		
367 		// Donors receive 100 Patrons per 1 wei donation
368 		donationMultiplier = 100;
369 		
370 		// Patrons receive 2.5 Patrons (25,000 basis points) per 1 wei purchases
371 		patronRewardMultiplier = 25000;
372 		
373 		// Ethart receives 2.5% of revenues and artwork's edition sizes
374 		ethartRevenueReward = 250;
375 		ethartArtReward = 250;
376 		
377 		// For balanced figures patronRewardMultiplier / donationMultiplier <= ethartRevenueReward
378 		
379 		// Referrers receive 10% of ethartRevenueReward
380 		referrerReward = 1000;
381 	}
382 
383 	function setPatronReward (uint256 _donationMultiplier) onlyBy (owner)
384 		{
385 			donationMultiplier = _donationMultiplier;
386 			patronRewardMultiplier = ethartRevenueReward * _donationMultiplier;
387 			if (patronRewardMultiplier / donationMultiplier > ethartRevenueReward) {throw;}
388 		}
389 
390 	function setEthartRevenueReward (uint256 _ethartRevenueReward) onlyBy (owner)
391 		{
392 			uint256 a;
393 			// Ethart revenue reward can never be greater than 10%
394 			if (_ethartRevenueReward >1000) {throw;}
395 			a = 10000 / _ethartRevenueReward;
396 			// Should 10000 / _ethartRevenueReward not be even throw
397 			if (a * _ethartRevenueReward < 10000) {throw;}
398 			ethartRevenueReward = _ethartRevenueReward;
399 		}
400 	
401 	function getEthartRevenueReward () returns (uint256 _ethartRevenueReward)
402 		{
403 			return ethartRevenueReward;
404 		}
405 
406 	function setEthartArtReward (uint256 _ethartArtReward) onlyBy (owner)
407 		{
408 			uint256 a;
409 			// Ethart art reward can never be greater than 10%
410 			if (_ethartArtReward >1000) {throw;}
411 			a = 10000 / _ethartArtReward;
412 			// Should 10000 / _ethartArtReward not be even throw
413 			if (a * _ethartArtReward < 10000) {throw;}
414 			ethartArtReward = _ethartArtReward;
415 		}
416 
417 	function getEthartArtReward () returns (uint256 _ethartArtReward)
418 		{
419 			return ethartArtReward;
420 		}
421 
422 	// Allows the current owner to assign a new owner
423 	function changeOwner (address newOwner) onlyBy (owner) 
424 		{
425 			owner = newOwner;
426 		}
427 
428 	// Allows approved contracts to issue Patron tokens
429 	function issuePatrons (address _to, uint256 _amount) approvedContractsOnly
430 		{
431 			balances[_to] += _amount / 10000 * patronRewardMultiplier;
432 			_totalPatronSupply += _amount / 10000 * patronRewardMultiplier;
433 		}
434 
435 	// Change the amount of Patron tokens a donor receives
436 	function setDonationReward (uint256 _multiplier) onlyBy (owner)
437 		{
438 			donationMultiplier = _multiplier;
439 		}
440 
441 	// Receive Patron tokens in returns for donations
442 	// Not going to worry about a theoretical Integer overflow here.
443 	function donate () payable
444 		{
445 			balances[msg.sender] += msg.value * donationMultiplier;
446 			_totalPatronSupply += msg.value * donationMultiplier;
447 			asyncSend(this, msg.value);
448 		}
449 
450 	function registerArtwork (address _contract, bytes32 _SHA256Hash, uint256 _editionSize, string _title, string _fileLink, uint256 _ownerCommission, address _artist, bool _indexed, bool _ouroboros) registeredFactoriesOnly
451 		{
452 		if (SHA256HashRegister[_SHA256Hash] == 0x0) {
453 		   	SHA256HashRegister[_SHA256Hash] = _contract;
454 			approvedContracts[_contract] = true;
455 			cantSetReferrer[_artist] = true;
456 			artworkRegister[_contract].SHA256Hash = _SHA256Hash;
457 			artworkRegister[_contract].editionSize = _editionSize;
458 			artworkRegister[_contract].title = _title;
459 			artworkRegister[_contract].fileLink = _fileLink;
460 			artworkRegister[_contract].ownerCommission = _ownerCommission;
461 			artworkRegister[_contract].artist = _artist;
462 			artworkRegister[_contract].factory = msg.sender;
463 			artworkRegister[_contract].isIndexed = _indexed;
464 			artworkRegister[_contract].isOuroboros = _ouroboros;
465 			artworkIndex[artworkCount] = _contract;
466 			artistsArtworks[_artist][artistsArtworkCount[_artist]] = _contract;
467 			artistsArtworkCount[_artist]++;
468 			NewArtwork (_contract, _SHA256Hash, _editionSize, _title, _fileLink, _ownerCommission, _artist, _indexed, _ouroboros);
469 			artworkCount++;
470 			}
471 			else {throw;}
472 		}
473 
474 	// Check if a specific sha256 hash has been used by another artwork before
475 	function isSHA256HashRegistered (bytes32 _SHA256Hash) returns (bool _registered)
476 		{
477 		if (SHA256HashRegister[_SHA256Hash] == 0x0)
478 			{return false;}
479 		else {return true;}
480 		}
481 
482 	// Approve factory contracts
483 	function approveFactoryContract (address _factoryContractAddress, bool _approved) onlyBy (owner)
484 		{
485 			approvedFactories[_factoryContractAddress] = _approved;
486 		}
487 	
488 	// Open Zeppelin asyncSend function for pull payments
489 	function asyncSend (address _payee, uint256 _amount) approvedContractsOnly
490 		{
491 			pendingWithdrawals[_payee] = add(pendingWithdrawals[_payee], _amount);
492 			totalPendingWithdrawals = add(totalPendingWithdrawals, _amount);
493 		}
494 
495 	function withdrawPaymentsRegistrar (address _dest, uint256 _payment) onlyBy (owner)
496 		{
497 			if (_payment == 0) {
498 				throw;
499 			}
500 
501 			if (this.balance < _payment) {
502 				throw;
503 			}
504 			
505 			totalPendingWithdrawals = sub(totalPendingWithdrawals, _payment);
506 			pendingWithdrawals[this] = sub(pendingWithdrawals[this], _payment);
507 
508 			if (!_dest.send(_payment)) {
509 				throw;
510 			}
511 		}
512 
513 	function withdrawPayments() {
514 		address payee = msg.sender;
515 		uint256 payment = pendingWithdrawals[payee];
516 
517 		if (payment == 0) {
518 			throw;
519 		}
520 
521 		if (this.balance < payment) {
522 			throw;
523 		}
524 
525 		totalPendingWithdrawals = sub(totalPendingWithdrawals, payment);
526 		pendingWithdrawals[payee] = 0;
527 
528 		if (!payee.send(payment)) {
529 			throw;
530 		}
531 	}
532 
533 	function transferByAddress (address _contract, uint256 _amount, address _to) onlyBy (owner) 
534 		{
535 			Interface c = Interface(_contract);
536 			c.transfer(_to, _amount);
537 		}
538 
539 	function transferIndexedByAddress (address _contract, uint256 _index, address _to) onlyBy (owner)
540 		{
541 			Interface c = Interface(_contract);
542 			c.transferIndexed(_to, _index);
543 		}
544 
545 	function approveByAddress (address _contract, address _spender, uint256 _amount) onlyBy (owner)
546 		{
547 			Interface c = Interface(_contract);
548 			c.approve(_spender, _amount);
549 		}	
550 
551 	function approveIndexedByAddress (address _contract, address _spender, uint256 _index) onlyBy (owner)
552 		{
553 			Interface c = Interface(_contract);
554 			c.approveIndexed(_spender, _index);
555 		}
556 
557 	function burnByAddress (address _contract, uint256 _amount) onlyBy (owner)
558 		{
559 			Interface c = Interface(_contract);
560 			c.burn(_amount);
561 		}
562 
563 	function burnFromByAddress (address _contract, uint256 _amount, address _from) onlyBy (owner)
564 		{
565 			Interface c = Interface(_contract);
566 			c.burnFrom (_from, _amount);
567 		}
568 
569 	function burnIndexedByAddress (address _contract, uint256 _index) onlyBy (owner)
570 		{
571 			Interface c = Interface(_contract);
572 			c.burnIndexed(_index);
573 		}
574 
575 	function burnIndexedFromByAddress (address _contract, address _from, uint256 _index) onlyBy (owner)
576 		{
577 			Interface c = Interface(_contract);
578 			c.burnIndexedFrom(_from, _index);
579 		}
580 
581 	function offerPieceForSaleByAddress (address _contract, uint256 _price) onlyBy (owner)
582 		{
583 			Interface c = Interface(_contract);
584 			c.offerPieceForSale(_price);
585 		}
586 
587 	// Fill a bid with an unindexed piece owned by the registrar
588 	function fillBidByAddress (address _contract) onlyBy (owner)
589 		{
590 			Interface c = Interface(_contract);
591 			c.fillBid();
592 		}
593 
594 	// Cancel the sale of an unindexed piece owned by the registrar
595 	function cancelSaleByAddress (address _contract) onlyBy (owner)	
596 		{
597 			Interface c = Interface(_contract);
598 			c.cancelSale();
599 		}
600 
601 	// Sell an indexed piece owned by the registrar.
602 	function offerIndexedPieceForSaleByAddress (address _contract, uint256 _index, uint256 _price) onlyBy (owner)
603 		{
604 			Interface c = Interface(_contract);
605 			c.offerIndexedPieceForSale(_index, _price);
606 		}
607 
608 	// Fill a bid with an indexed piece owned by the registrar
609 	function fillIndexedBidByAddress (address _contract, uint256 _index) onlyBy (owner)	
610 		{
611 			Interface c = Interface(_contract);
612 			c.fillIndexedBid(_index);
613 		}
614 
615 	// Cancel the sale of an unindexed piece owned by the registrar
616 	function cancelIndexedSaleByAddress (address _contract) onlyBy (owner)
617 		{
618 			Interface c = Interface(_contract);
619 			c.cancelIndexedSale();
620 		}
621 	
622 	// use donate () for donations and you will get donationMultiplier * your donation in Patron tokens. Yay!
623 	function() payable
624 		{
625 			if (!approvedContracts[msg.sender]) {throw;}
626 		}
627 }