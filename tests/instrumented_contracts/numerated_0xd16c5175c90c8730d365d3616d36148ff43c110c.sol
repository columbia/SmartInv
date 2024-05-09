1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     require(newOwner != address(0));
57     owner = newOwner;
58   }
59 
60 }
61 
62 contract Pausable is Ownable {
63   event Pause();
64   event Unpause();
65 
66   bool public paused = false;
67 
68 
69   /**
70    * @dev Modifier to make a function callable only when the contract is not paused.
71    */
72   modifier whenNotPaused() {
73     require(!paused);
74     _;
75   }
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is paused.
79    */
80   modifier whenPaused() {
81     require(paused);
82     _;
83   }
84 
85   /**
86    * @dev called by the owner to pause, triggers stopped state
87    */
88   function pause() onlyOwner whenNotPaused public {
89     paused = true;
90     Pause();
91   }
92 
93   /**
94    * @dev called by the owner to unpause, returns to normal state
95    */
96   function unpause() onlyOwner whenPaused public {
97     paused = false;
98     Unpause();
99   }
100 }
101 
102 contract HasNoEther is Ownable {
103 
104   /**
105   * @dev Constructor that rejects incoming Ether
106   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
107   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
108   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
109   * we could use assembly to access msg.value.
110   */
111   function HasNoEther() payable {
112     require(msg.value == 0);
113   }
114 
115   /**
116    * @dev Disallows direct send by settings a default function without the `payable` flag.
117    */
118   function() external {
119   }
120 
121   /**
122    * @dev Transfer all Ether held by the contract to the owner.
123    */
124   function reclaimEther() external onlyOwner {
125     assert(owner.send(this.balance));
126   }
127 }
128 
129 contract ERC20Basic {
130   uint256 public totalSupply;
131   function balanceOf(address who) constant returns (uint256);
132   function transfer(address to, uint256 value) returns (bool);
133   event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) returns (bool) {
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) constant returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 contract ERC20 is ERC20Basic {
165   function allowance(address owner, address spender) constant returns (uint256);
166   function transferFrom(address from, address to, uint256 value) returns (bool);
167   function approve(address spender, uint256 value) returns (bool);
168   event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 contract LimitedTransferToken is ERC20 {
172 
173   /**
174    * @dev Checks whether it can transfer or otherwise throws.
175    */
176   modifier canTransfer(address _sender, uint256 _value) {
177    require(_value <= transferableTokens(_sender, uint64(now)));
178    _;
179   }
180 
181   /**
182    * @dev Checks modifier and allows transfer if tokens are not locked.
183    * @param _to The address that will recieve the tokens.
184    * @param _value The amount of tokens to be transferred.
185    */
186   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) returns (bool) {
187     return super.transfer(_to, _value);
188   }
189 
190   /**
191   * @dev Checks modifier and allows transfer if tokens are not locked.
192   * @param _from The address that will send the tokens.
193   * @param _to The address that will recieve the tokens.
194   * @param _value The amount of tokens to be transferred.
195   */
196   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) returns (bool) {
197     return super.transferFrom(_from, _to, _value);
198   }
199 
200   /**
201    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
202    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
203    * specific logic for limiting token transferability for a holder over time.
204    */
205   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
206     return balanceOf(holder);
207   }
208 }
209 
210 contract StandardToken is ERC20, BasicToken {
211 
212   mapping (address => mapping (address => uint256)) allowed;
213 
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param _from address The address which you want to send tokens from
218    * @param _to address The address which you want to transfer to
219    * @param _value uint256 the amout of tokens to be transfered
220    */
221   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
222     var _allowance = allowed[_from][msg.sender];
223 
224     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
225     // require (_value <= _allowance);
226 
227     balances[_to] = balances[_to].add(_value);
228     balances[_from] = balances[_from].sub(_value);
229     allowed[_from][msg.sender] = _allowance.sub(_value);
230     Transfer(_from, _to, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) returns (bool) {
240 
241     // To change the approve amount you first have to reduce the addresses`
242     //  allowance to zero by calling `approve(_spender, 0)` if it is not
243     //  already 0 to mitigate the race condition described here:
244     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
246 
247     allowed[msg.sender][_spender] = _value;
248     Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifing the amount of tokens still available for the spender.
257    */
258   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
259     return allowed[_owner][_spender];
260   }
261 
262 }
263 
264 contract BurnableToken is StandardToken {
265 
266     /**
267      * @dev Burns a specific amount of tokens.
268      * @param _value The amount of token to be burned.
269      */
270     function burn(uint _value)
271         public
272     {
273         require(_value > 0);
274 
275         address burner = msg.sender;
276         balances[burner] = balances[burner].sub(_value);
277         totalSupply = totalSupply.sub(_value);
278         Burn(burner, _value);
279     }
280 
281     event Burn(address indexed burner, uint indexed value);
282 }
283 
284 contract MintableToken is StandardToken, Ownable {
285   event Mint(address indexed to, uint256 amount);
286   event MintFinished();
287 
288   bool public mintingFinished = false;
289 
290 
291   modifier canMint() {
292     require(!mintingFinished);
293     _;
294   }
295 
296   /**
297    * @dev Function to mint tokens
298    * @param _to The address that will recieve the minted tokens.
299    * @param _amount The amount of tokens to mint.
300    * @return A boolean that indicates if the operation was successful.
301    */
302   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
303     totalSupply = totalSupply.add(_amount);
304     balances[_to] = balances[_to].add(_amount);
305     Mint(_to, _amount);
306     Transfer(0x0, _to, _amount);
307     return true;
308   }
309 
310   /**
311    * @dev Function to stop minting new tokens.
312    * @return True if the operation was successful.
313    */
314   function finishMinting() onlyOwner returns (bool) {
315     mintingFinished = true;
316     MintFinished();
317     return true;
318   }
319 }
320 
321 contract BearCoin is BurnableToken, MintableToken, LimitedTransferToken, Pausable, HasNoEther {
322 	struct Tether {
323 		bytes5 currency;
324 		uint32 amount;
325 		uint32 price;
326 		uint32 startBlock;
327 		uint32 endBlock;
328 	}
329 
330 	address[] public addressById;
331 	mapping (string => uint256) idByName;
332 	mapping (address => string) nameByAddress;
333 
334 	// Ether/Wei have the same conversion as Bear/Cub
335 	uint256 public constant INITIAL_SUPPLY = 2000000 ether;
336 
337 	string public constant symbol = "BEAR";
338 	uint256 public constant decimals = 18;
339 	string public constant name = "BearCoin";
340 
341 	string constant genesis = "CR30001";
342 	uint256 public genesisBlock = 0;
343 
344 	mapping (address => Tether[]) public currentTethers;
345 	address public controller;
346 
347 	event Tethered(address indexed holder, string holderName, string currency, uint256 amount, uint32 price, uint256 indexed tetherID, uint timestamp, string message);
348 	event Untethered(address indexed holder,string holderName, string currency, uint256 amount, uint32 price, uint32 finalPrice, uint256 outcome, uint256 indexed tetherID, uint timestamp);
349 	event NameRegistered(address indexed a, uint256 id, string userName, uint timestamp);
350 	event NameChanged(address indexed a, uint256 id, string newUserName, string oldUserName, uint timestamp);
351 
352 	function BearCoin() {
353 		balances[msg.sender] = INITIAL_SUPPLY;
354 		totalSupply = INITIAL_SUPPLY;
355 		addressById.push(0x0);
356 		idByName[genesis] = 0;
357 		nameByAddress[0x0] = genesis;
358 		genesisBlock = block.number;
359 	}
360 
361 	// Non-upgradable function required for LimitedTransferToken
362 	function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
363 		uint256 count = tetherCount(holder);
364 
365 		if (count == 0) return super.transferableTokens(holder, time);
366 
367 		uint256 tetheredTokens = 0;
368 		for (uint256 i = 0; i < count; i++) {
369 			// All tethers are initialized with an endBlock of 0
370 			if (currentTethers[holder][i].endBlock == 0) {
371 				tetheredTokens = tetheredTokens.add(_finneyToWei(currentTethers[holder][i].amount));
372 			}
373 		}
374 
375 		return balances[holder].sub(tetheredTokens);
376 	}
377 
378 	// only x modifiers
379 	modifier onlyController() {
380 		require(msg.sender == controller);
381 		_;
382 	}
383 
384 	// Set roles
385 	function setController(address a) onlyOwner {
386 		controller = a;
387 	}
388 
389 	// Controller-only functions
390 	function addTether(address a, string _currency, uint256 amount, uint32 price, string m) external onlyController whenNotPaused {
391 		// Make sure there are enough BearCoins to tether
392 		require(transferableTokens(a, 0) >= amount);
393 		bytes5 currency = _stringToBytes5(_currency);
394 		uint256 count = currentTethers[a].push(Tether(currency, _weiToFinney(amount), price, uint32(block.number.sub(genesisBlock)), 0));
395 		Tethered(a, nameByAddress[a], _currency, amount, price, count - 1, now, m);
396 	}
397 	function setTether(address a, uint256 tetherID, uint32 finalPrice, uint256 outcome) external onlyController whenNotPaused {
398 		currentTethers[a][tetherID].endBlock = uint32(block.number.sub(genesisBlock));
399 		Tether memory tether = currentTethers[a][tetherID];
400 		Untethered(a, nameByAddress[a], _bytes5ToString(tether.currency), tether.amount, tether.price, finalPrice, outcome, tetherID, now);
401 	}
402 	function controlledMint(address _to, uint256 _amount) external onlyController whenNotPaused returns (bool) {
403 		totalSupply = totalSupply.add(_amount);
404 		balances[_to] = balances[_to].add(_amount);
405 		Mint(_to, _amount);
406 		Transfer(0x0, _to, _amount);
407 		return true;
408 	}
409 	function controlledBurn(address _from, uint256 _value) external onlyController whenNotPaused returns (bool) {
410 		require(_value > 0);
411 
412 		balances[_from] = balances[_from].sub(_value);
413 		totalSupply = totalSupply.sub(_value);
414 		Burn(_from, _value);
415 		return true;
416 	}
417 
418 	function registerName(address a, string n) external onlyController whenNotPaused {
419 		require(!isRegistered(a));
420 		require(getIdByName(n) == 0);
421 		require(a != 0x0);
422 		require(_nameValid(n));
423 		uint256 length = addressById.push(a);
424 		uint256 id = length - 1;
425 		idByName[_toLower(n)] = id;
426 		nameByAddress[a] = n;
427 		NameRegistered(a, id, n, now);
428 	}
429 	function changeName(address a, string n) external onlyController whenNotPaused {
430 		require(isRegistered(a));
431 		require(getIdByName(n) == 0);
432 		require(a != 0x0);
433 		require(_nameValid(n));
434 		string memory old = nameByAddress[a];
435 		uint256 id = getIdByName(old);
436 		idByName[_toLower(old)] = 0;
437 		idByName[_toLower(n)] = id;
438 		nameByAddress[a] = n;
439 		NameChanged(a, id, n, old, now);
440 	}
441 
442 	// Getters
443 	function getTether(address a, uint256 tetherID) public constant returns (string, uint256, uint32, uint256, uint256) {
444 		Tether storage tether = currentTethers[a][tetherID];
445 		return (_bytes5ToString(tether.currency), _finneyToWei(tether.amount), tether.price, uint256(tether.startBlock).add(genesisBlock), uint256(tether.endBlock).add(genesisBlock));
446 	}
447 	function getTetherInts(address a, uint256 tetherID) public constant returns (uint256, uint32, uint32, uint32) {
448 		Tether memory tether = currentTethers[a][tetherID];
449 		return (_finneyToWei(tether.amount), tether.price, tether.startBlock, tether.endBlock);
450 	}
451 	function tetherCount(address a) public constant returns (uint256) {
452 		return currentTethers[a].length;
453 	}
454 	function getAddressById(uint256 id) returns (address) {
455 		return addressById[id];
456 	}
457 	function getIdByName(string n) returns (uint256) {
458 		return idByName[_toLower(n)];
459 	}
460 	function getNameByAddress(address a) returns (string) {
461 		return nameByAddress[a];
462 	}
463 	function getAddressCount() returns (uint256) {
464 		return addressById.length;
465 	}
466 
467 	// Utility functions
468 	function verifyTetherCurrency(address a, uint256 tetherID, string currency) public constant returns (bool) {
469 		return currentTethers[a][tetherID].currency == _stringToBytes5(currency);
470 	}
471 	function verifyTetherLoss(address a, uint256 tetherID, uint256 price) public constant returns (bool) {
472 		return currentTethers[a][tetherID].price < uint32(price);
473 	}
474 	function isRegistered(address a) returns (bool) {
475 		return keccak256(nameByAddress[a]) != keccak256('');
476 	}
477 
478 	// Internal helper functions
479 	function _nameValid(string s) internal returns (bool) {
480 		return bytes(s).length != 0 && keccak256(s) != keccak256(genesis) && bytes(s).length <= 32;
481 	}
482 	function _bytes5ToString(bytes5 b) internal returns (string memory s) {
483 		bytes memory bs = new bytes(5);
484 		for (uint8 i = 0; i < 5; i++) {
485 			bs[i] = b[i];
486 		}
487 		s = string(bs);
488 	}
489 	function _stringToBytes5(string memory s) internal returns (bytes5 b) {
490 		assembly {
491 			b := mload(add(s, 32))
492 		}
493 	}
494 	function _toLower(string str) internal returns (string) {
495 		bytes memory bStr = bytes(str);
496 		bytes memory bLower = new bytes(bStr.length);
497 		for (uint i = 0; i < bStr.length; i++) {
498 			// Uppercase character...
499 			if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
500 				// So we add 32 to make it lowercase
501 				bLower[i] = bytes1(int(bStr[i]) + 32);
502 			} else {
503 				bLower[i] = bStr[i];
504 			}
505 		}
506 		return string(bLower);
507 	}
508 	function _finneyToWei(uint32 _n) returns (uint256) {
509 		uint256 n = uint256(_n);
510 		uint256 f = 1 finney;
511 		return n.mul(f);
512 	}
513 	function _weiToFinney(uint256 n) returns (uint32) {
514 		uint256 f = 1 finney;
515 		uint256 p = n.div(f);
516 		return uint32(p);
517 	}
518 
519 }