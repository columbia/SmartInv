1 pragma solidity ^0.4.11;
2 
3 /* Ethart Registrar Contract:
4 
5 	Ethart ARCHITECTURE
6 	-------------------
7 						_________________________________________
8 						V										V
9 	Controller --> Registrar <--> Factory Contract1 --> Artwork Contract1
10 								  Factory Contract2	    Artwork Contract2
11 								  		...					...
12 								  Factory ContractN	    Artwork ContractN
13 
14 	Controller: The controler contract is the owner of the Registrar contract and can
15 		- Set a new owner
16 		- Controll the assets of the Registrar (withdraw ETH, transfer, sell, burn pieces owned by the Registrar)
17 		- The plan is to replace the controller contract with a DAO in preperation for a possible ICO
18 	
19 	Registrar:
20 		- The Registrar contract atcs as the central registry for all sha256 hashes in the Ethart factory contract network.
21 		- Approved Factory Contracts can register sha256 hashes using the Registrar interface.
22 		- 2.5% of the art produced and 2.5% of turnover of the contract network will be transfered to the Registrar.
23 	
24 	Factory Contracts:
25 		- Factory Contracts can spawn Artwork Contracts in line with artists specifications
26 		- Factory Contracts will only spawn Artwork Contracts who's sha256 hashes are unique per the Registrar's sha256 registry
27 		- Factory Contracts will register every new Artwork Contract with it's details with the Registrar contract
28 	
29 	Artwork Contracts:
30 		- Artwork Contracts act as minimalist decentralized exchanges for their pieces in line with specified conditions
31 		- Artwork Contracts will interact with the Registrar to issue buyers of pieces a predetermined amount of Patron tokens based on the transaction value 
32 		- Artwork Contracts can be interacted with by the Controller via the Registrar using their interfaces to transfer, sell, burn etc pieces
33 	
34 	(c) Stefan Pernar 2017 - all rights reserved
35 	(c) ERC20 functions BokkyPooBah 2017. The MIT Licence.
36 */
37 
38 contract Interface {
39 
40 	// Ethart network interface
41 	function registerArtwork (address _contract, bytes32 _SHA256Hash, uint256 _editionSize, string _title, string _fileLink, uint256 _ownerCommission, address _artist, bool _indexed, bool _ouroboros);
42 	function isSHA256HashRegistered (bytes32 _SHA256Hash) returns (bool _registered);			// Check if a sha256 hash is registared
43 	function isFactoryApproved (address _factory) returns (bool _approved);						// Check if an address is a registred factory contract
44 	function issuePatrons (address _to, uint256 _amount);										// Issues Patron tokens according to conditions specified in factory contracts
45     function approveFactoryContract (address _factoryContractAddress, bool _approved);			// Approves/disapproves factory contracts.
46 	function changeOwner (address newOwner);													// Change the registrar's owner.
47 
48 	function offerPieceForSaleByAddress (address _contract, uint256 _price);					// Sell a piece owned by the registrar.
49 	function offerPieceForSale (uint256 _price);
50 	function fillBidByAddress (address _contract);												// Fill a bid with an unindexed piece owned by the registrar
51 	function fillBid();
52 	function cancelSaleByAddress (address _contract);											// Cancel the sale of an unindexed piece owned by the registrar
53 	function cancelSale();
54 	function offerIndexedPieceForSaleByAddress (address _contract, uint256 _index, uint256 _price);				// Sell an indexed piece owned by the registrar.
55 	function offerIndexedPieceForSale(uint256 _index, uint256 _price);
56 	function fillIndexedBidByAddress (address _contract, uint256 _index);						// Fill a bid with an indexed piece owned by the registrar
57 	function fillIndexedBid (uint256 _index);
58 	function cancelIndexedSaleByAddress (address _contract);									// Cancel the sale of an unindexed piece owned by the registrar
59 	function cancelIndexedSale();
60 
61     function transferByAddress (address _contract, uint256 _amount, address _to);				// Transfers unindexed pieces owned by the registrar contract
62     function transferIndexedByAddress (address _contract, uint256 _index, address _to);		// Transfers indexed pieces owned by the registrar contract
63 	function approveByAddress (address _contract, address _spender, uint256 _amount);			// Sets an allowance for unindexed pieces owned by the registrar contract
64 	function approveIndexedByAddress (address _contract, address _spender, uint256 _index);		// Sets an allowance for indexed pieces owned by the registrar contract
65 	function burnByAddress (address _contract, uint256 _amount);								// Burn an unindexed piece owned by the registrar contract
66 	function burnFromByAddress (address _contract, uint256 _amount, address _from);				// Burn an unindexed piece owned by annother address
67 	function burnIndexedByAddress (address _contract, uint256 _index);							// Burn an indexed piece owned by the registrar contract
68 	function burnIndexedFromByAddress (address _contract, address _from, uint256 _index);		// Burn an indexed piece owned by another address
69 
70 	// ERC20 interface
71     function totalSupply() constant returns (uint256 totalSupply);									// Returns the total supply of an artwork or token
72 	function balanceOf(address _owner) constant returns (uint256 balance);							// Returns an address' balance of an artwork or token
73  	function transfer(address _to, uint256 _value) returns (bool success);							// Transfers pieces of art or tokens to an address
74  	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);		// Transfers pieces of art of tokens owned by another address to an address
75 	function approve(address _spender, uint256 _value) returns (bool success);						// Sets an allowance for an address
76 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);		// Returns the allowance of an address for another address
77 
78 	// Additional token functions
79 	function burn(uint256 _amount) returns (bool success);										// Burns (removes from circulation) unindexed pieces of art or tokens.
80 																								// In the case of 'ouroboros' pieces this function also returns the piece's
81 																								// components to the message sender
82 	
83 	function burnFrom(address _from, uint256 _amount) returns (bool success);					// Burns (removes from circulation) unindexed pieces of art or tokens
84 																								// owned by another address. In the case of 'ouroboros' pieces this
85 																								// function also returns the piece's components to the message sender
86 	
87 	// Extended ERC20 interface for indexed pieces
88 	function transferIndexed (address _to, uint256 __index) returns (bool success);			// Transfers an indexed piece of art
89 	function transferFromIndexed (address _from, address _to, uint256 _index) returns (bool success);	// Transfers an indexed piece of art from another address
90 	function approveIndexed (address _spender, uint256 _index) returns (bool success);			// Sets an allowance for an indexed piece of art for another address
91 	function burnIndexed (uint256 _index);														// Burns (removes from circulation) indexed pieces of art or tokens.
92 																								// In the case of 'ouroboros' pieces this function also returns the
93 																								// piece's components to the message sender
94 	
95 	function burnIndexedFrom (address _owner, uint256 _index);									// Burns (removes from circulation) indexed pieces of art or tokens
96 																								// owned by another address. In the case of 'ouroboros' pieces this
97 																								// function also returns the piece's components to the message sender
98 
99 }
100 
101 contract Registrar {
102 
103 	// Patron token ERC20 public variables
104 	string public constant symbol = "ART";
105 	string public constant name = "Patron - Ethart Network Token";
106 	uint8 public constant decimals = 18;
107 	uint256 _totalPatronSupply;
108 
109 	event Transfer(address indexed _from, address _to, uint256 _value);
110 	event Approval(address indexed _owner, address _spender, uint256 _value);
111 	event Burn(address indexed _owner, uint256 _amount);
112 
113     // Patron token balances for each account
114 	mapping(address => uint256) public balances;						// Patron token balances
115 
116 	event NewArtwork(address _contract, bytes32 _SHA256Hash, uint256 _editionSize, string _title, string _fileLink, uint256 _ownerCommission, address _artist, bool _indexed, bool _ouroboros);
117 
118 
119  	// Owner of account approves the transfer of an amount of Patron tokens to another account
120  	mapping(address => mapping (address => uint256)) allowed;			// Patron token allowances
121 	
122 	// BEGIN ERC20 functions (c) BokkyPooBah 2017. The MIT Licence.
123 
124     function totalSupply() constant returns (uint256 totalPatronSupply) {
125 		totalPatronSupply = _totalPatronSupply;
126 		}
127 
128 	// What is the balance of a particular account?
129 	function balanceOf(address _owner) constant returns (uint256 balance) {
130  		return balances[_owner];
131 		}
132 
133 	// Transfer the balance from owner's account to another account
134 	function transfer(address _to, uint256 _amount) returns (bool success) {
135 		if (balances[msg.sender] >= _amount 
136 			&& _amount > 0
137  		   	&& balances[_to] + _amount > balances[_to]
138 			&& _to != 0x0)										// use burn() instead
139 			{
140 			balances[msg.sender] -= _amount;
141 			balances[_to] += _amount;
142 			Transfer(msg.sender, _to, _amount);
143  		   	return true;
144 			}
145 			else { return false;}
146  		 }
147 
148 	// Send _value amount of tokens from address _from to address _to
149 	// The transferFrom method is used for a withdraw workflow, allowing contracts to send
150  	// tokens on your behalf, for example to "deposit" to a contract address and/or to charge
151  	// fees in sub-currencies; the command should fail unless the _from account has
152  	// deliberately authorized the sender of the message via some mechanism; we propose
153  	// these standardized APIs for approval:
154  	function transferFrom( address _from, address _to, uint256 _amount) returns (bool success)
155 		{
156 			if (balances[_from] >= _amount
157 				&& allowed[_from][msg.sender] >= _amount
158 				&& _amount > 0
159 				&& balances[_to] + _amount > balances[_to]
160 				&& _to != 0x0)										// use burn() instead
161 					{
162 					balances[_from] -= _amount;
163 					allowed[_from][msg.sender] -= _amount;
164 					balances[_to] += _amount;
165 					Transfer(_from, _to, _amount);
166 					return true;
167 					} else {return false;}
168 		}
169 
170 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
171 	// If this function is called again it overwrites the current allowance with _value.
172 	function approve(address _spender, uint256 _amount) returns (bool success) {
173 		allowed[msg.sender][_spender] = _amount;
174 		Approval(msg.sender, _spender, _amount);
175 		return true;
176 		}
177 
178 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
179 		return allowed[_owner][_spender];
180 		}
181 
182 	// END ERC20 functions (c) BokkyPooBah 2017. The MIT Licence.
183 	
184 	// Additional Patron token functions
185 	
186 	function burn(uint256 _amount) returns (bool success) {
187 			if (balances[msg.sender] >= _amount) {
188 				balances[msg.sender] -= _amount;
189 				_totalPatronSupply -= _amount;
190 				Burn(msg.sender, _amount);
191 				return true;
192 			}
193 			else {throw;}
194 		}
195 
196 	function burnFrom(address _from, uint256 _value) returns (bool success) {
197 		if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
198 			balances[_from] -= _value;
199 			allowed[_from][msg.sender] -= _value;
200 			_totalPatronSupply -= _value;
201 			Burn(_from, _value);
202 			return true;
203 		}
204 		else {throw;}
205 	}
206 
207 	// Ethart variables
208     mapping (bytes32 => address) public SHA256HashRegister;		// Register of all SHA256 Hashes
209 	mapping (address => bool) public approvedFactories;			// Register of all approved factory contracts
210 	mapping (address => bool) public approvedContracts;			// Register of all approved artwork contracts
211 	mapping (address => address) public referred;				// Register of all referrers (referree => referrer) used for the affiliate program
212 	mapping (address => bool) public cantSetReferrer;			// Referrer for an artist has to be set _before_ the first piece has been created by an address
213 
214 	struct artwork {
215 		bytes32 SHA256Hash;
216 		uint256 editionSize;
217 		string title;
218 		string fileLink;
219 		uint256 ownerCommission;
220 		address artist;
221 		address factory;
222 		bool isIndexed;
223 		bool isOuroboros;}
224 	
225 	mapping (address => artwork) public artworkRegister;		// Register of all artworks and their details
226 
227 	// An indexed register of all of an artist's artworks
228 	mapping(address => mapping (uint256 => address)) public artistsArtworks;	// Enter artist address and a running number to get the artist's artwork addresses.
229 	mapping(address => uint256) public artistsArtworkCount;						// A running number counting an artist's artworks
230 	mapping(address => address) public artworksFactory;							// Maps all artworks to their respective factory contracts
231 
232 	uint256 artworkCount;										// Keeps track of the number of artwork contracts in the network
233 	
234 	mapping (uint256 => address) public artworkIndex;			// An index of all the artwork contracts in the network
235 
236 	address public owner;										// The address of the contract owner
237 	
238 	uint256 public donationMultiplier;
239 
240     // Functions with this modifier can only be executed by a specific address
241     modifier onlyBy (address _account)
242     {
243         require(msg.sender == _account);
244         _;
245     }
246 
247     // Functions with this modifier can only be executed by approved factory contracts
248     modifier registerdFactoriesOnly ()
249     {
250         require(approvedFactories[msg.sender]);
251         _;
252     }
253 
254 	modifier approvedContractsOnly ()
255 	{
256 		require(approvedContracts[msg.sender]);
257 		_;
258 	}
259 
260 	function setReferrer (address _referrer)
261 		{
262 			if (referred[msg.sender] == 0x0 && !cantSetReferrer[msg.sender])
263 			{
264 				referred[msg.sender] = _referrer;
265 			}
266 		}
267 
268 	function Registrar () {
269 		owner = msg.sender;
270 		donationMultiplier = 100;
271 	}
272 
273 	// allows the current owner to assign a new owner
274 	function changeOwner (address newOwner) onlyBy (owner) 
275 		{
276 			owner = newOwner;
277 		}
278 
279 	function issuePatrons (address _to, uint256 _amount) approvedContractsOnly
280 		{
281 			balances[_to] += _amount;
282 			_totalPatronSupply += _amount;
283 		}
284 
285 	function setDonationReward (uint256 _multiplier) onlyBy (owner)
286 		{
287 			donationMultiplier = _multiplier;
288 		}
289 
290 	function donate () payable
291 		{
292 			balances[msg.sender] += msg.value * donationMultiplier;
293 			_totalPatronSupply += msg.value * donationMultiplier;
294 		}
295 
296 	function registerArtwork (address _contract, bytes32 _SHA256Hash, uint256 _editionSize, string _title, string _fileLink, uint256 _ownerCommission, address _artist, bool _indexed, bool _ouroboros) registerdFactoriesOnly
297 		{
298 		if (SHA256HashRegister[_SHA256Hash] == 0x0) {
299 		   	SHA256HashRegister[_SHA256Hash] = _contract;
300 			approvedContracts[_contract] = true;
301 			cantSetReferrer[_artist] = true;
302 			artworkRegister[_contract].SHA256Hash = _SHA256Hash;
303 			artworkRegister[_contract].editionSize = _editionSize;
304 			artworkRegister[_contract].title = _title;
305 			artworkRegister[_contract].fileLink = _fileLink;
306 			artworkRegister[_contract].ownerCommission = _ownerCommission;
307 			artworkRegister[_contract].artist = _artist;
308 			artworkRegister[_contract].factory = msg.sender;
309 			artworkRegister[_contract].isIndexed = _indexed;
310 			artworkRegister[_contract].isOuroboros = _ouroboros;
311 			artworkIndex[artworkCount] = _contract;
312 			artistsArtworks[_artist][artistsArtworkCount[_artist]] = _contract;
313 			artistsArtworkCount[_artist]++;
314 			artworksFactory[_contract] = msg.sender;
315 			NewArtwork (_contract, _SHA256Hash, _editionSize, _title, _fileLink, _ownerCommission, _artist, _indexed, _ouroboros);
316 			artworkCount++;
317 			}
318 			else {throw;}
319 		}
320 
321 	function isSHA256HashRegistered (bytes32 _SHA256Hash) returns (bool _registered)
322 		{
323 		if (SHA256HashRegister[_SHA256Hash] == 0x0)
324 			{return false;}
325 		else {return true;}
326 		}
327 
328 
329 	function approveFactoryContract (address _factoryContractAddress, bool _approved) onlyBy (owner)
330 		{
331 			approvedFactories[_factoryContractAddress] = _approved;
332 		}
333 
334 	function isFactoryApproved (address _factory) returns (bool _approved)
335 		{
336 			if (approvedFactories[_factory])
337 			{
338 				return true;
339 			}
340 			else {return false;}
341 		}
342 
343 	function withdrawFunds (uint256 _ETHAmount, address _to) onlyBy (owner)
344 		{
345 			if (this.balance >= _ETHAmount)
346 			{
347 				_to.transfer(_ETHAmount);
348 			}
349 			else {throw;}
350 		}
351 
352 	function transferByAddress (address _contract, uint256 _amount, address _to) onlyBy (owner) 
353 		{
354 			Interface c = Interface(_contract);
355 			c.transfer(_to, _amount);
356 		}
357 
358 	function transferIndexedByAddress (address _contract, uint256 _index, address _to) onlyBy (owner)
359 		{
360 			Interface c = Interface(_contract);
361 			c.transferIndexed(_to, _index);
362 		}
363 
364 	function approveByAddress (address _contract, address _spender, uint256 _amount) onlyBy (owner)
365 		{
366 			Interface c = Interface(_contract);
367 			c.approve(_spender, _amount);
368 		}	
369 
370 	function approveIndexedByAddress (address _contract, address _spender, uint256 _index) onlyBy (owner)
371 		{
372 			Interface c = Interface(_contract);
373 			c.approveIndexed(_spender, _index);
374 		}
375 
376 	function burnByAddress (address _contract, uint256 _amount) onlyBy (owner)
377 		{
378 			Interface c = Interface(_contract);
379 			c.burn(_amount);
380 		}
381 
382 	function burnFromByAddress (address _contract, uint256 _amount, address _from) onlyBy (owner)
383 		{
384 			Interface c = Interface(_contract);
385 			c.burnFrom (_from, _amount);
386 		}
387 
388 	function burnIndexedByAddress (address _contract, uint256 _index) onlyBy (owner)
389 		{
390 			Interface c = Interface(_contract);
391 			c.burnIndexed(_index);
392 		}
393 
394 	function burnIndexedFromByAddress (address _contract, address _from, uint256 _index) onlyBy (owner)
395 		{
396 			Interface c = Interface(_contract);
397 			c.burnIndexedFrom(_from, _index);
398 		}
399 
400 	function offerPieceForSaleByAddress (address _contract, uint256 _price) onlyBy (owner)
401 		{
402 			Interface c = Interface(_contract);
403 			c.offerPieceForSale(_price);
404 		}
405 
406 	function fillBidByAddress (address _contract) onlyBy (owner)							// Fill a bid with an unindexed piece owned by the registrar
407 		{
408 			Interface c = Interface(_contract);
409 			c.fillBid();
410 		}
411 
412 	function cancelSaleByAddress (address _contract) onlyBy (owner)							// Cancel the sale of an unindexed piece owned by the registrar
413 		{
414 			Interface c = Interface(_contract);
415 			c.cancelSale();
416 		}
417 
418 	function offerIndexedPieceForSaleByAddress (address _contract, uint256 _index, uint256 _price) onlyBy (owner)			// Sell an indexed piece owned by the registrar.
419 		{
420 			Interface c = Interface(_contract);
421 			c.offerIndexedPieceForSale(_index, _price);
422 		}
423 
424 	function fillIndexedBidByAddress (address _contract, uint256 _index) onlyBy (owner)					// Fill a bid with an indexed piece owned by the registrar
425 		{
426 			Interface c = Interface(_contract);
427 			c.fillIndexedBid(_index);
428 		}
429 
430 	function cancelIndexedSaleByAddress (address _contract) onlyBy (owner)								// Cancel the sale of an unindexed piece owned by the registrar
431 		{
432 			Interface c = Interface(_contract);
433 			c.cancelIndexedSale();
434 		}
435 	
436 	function() payable
437 		{
438 			if (!approvedContracts[msg.sender]) {throw;}						// use donate () for donations and you will get donationMultiplier * your donation in Patron tokens. Yay!
439 		}
440 
441 	// Semi uinversal call function for unforseen future Ethart network contract types and use cases. String format: "<functionName>(address,address,uint256,uint256,bool,string,bytes32)"
442 	function callContractFunctionByAddress(address _contract, string functionNameAndTypes, address _address1, address _address2, uint256 _value1, uint256 _value2, bool _bool, string _string, bytes32 _bytes32) onlyBy (owner)
443 	{
444 		if(!_contract.call(bytes4(sha3(functionNameAndTypes)),_address1, _address2, _value1, _value2, _bool, _string, _bytes32)) {throw;}
445 	}
446 }