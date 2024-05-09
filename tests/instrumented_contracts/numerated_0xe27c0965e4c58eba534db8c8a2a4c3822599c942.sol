1 /**
2  * https://GreenRabbit.site
3  *
4  * Welcome to Green Rabbit's smart Kingdom.
5  *
6  * Here you can collect or earn GRC tokens (Green Rabbit's Coins) and sell it for Ethereum.
7  * Send Ethereum to the contract address for buying GRC tokens.
8  * Attention: purchase price more than sale price by 11.1%
9  *
10  * The price of GRC tokens will be increased by 1% per day.
11  * 
12  * For create the kingdom, you should to spend GRC tokens for increasing the number of citizens or warriors of your kingdom. 
13  *
14  * If you want to be just an investor, don't add citizens or warriors and your kingdom won't be created.
15  * 
16  * Each citizen of your Kingdom will pay tribute to you. One citizen pays tribute equal kingdom prosperity, per 7 days.
17  * Your warriors can attack random kingdoms and can pick up their coins. One warrior can pick up number of GRC equal (100 - attacked kingdom defence).
18  * After attack, number of your warriors will be reduced by percent of defence of attacked kingdom.
19  * Send 0.01 ether to the contract 0x76d7aed5ab1c4a5e210d0ccac747d097f9d58966 for attack random kingdom.
20  * Attention: You won't lose warriors, if attacked kingdom have GRC number less than 10000.
21  *
22  * Each kingdom have prosperity and defence levels. Sum of prosperity and defence levels always will be equal 100.
23  * You can increase prosperity and reduce defence level by 10 sending 0.000333 ether to the contract address. Maximum prosperity is 100.
24  * You can increase defence and reduce prosperity level by 10 sending 0.000444 ether to the contract address. Maximum defence is 90.
25  *
26  * Citizens will pay GRC tokens depending on their level of prosperity, the more it is, the more they will pay.
27  * Attention! You can lost part of your coins, if your defence is not high and your kingdom would be under attack.
28  *
29  * Send from 0 to 0.00001 ether to this contract address for sell all your GRC tokens.
30  * Send 0.000111 ether to spend your tokens to add citizens to your kingdom. 
31  * Send 0.000222 ether to spend your tokens to add warriors to your kingdom. 
32  * Send 0.000333 ether to set +10 prosperity and -10 defence level of your kingdom. 
33  * Send 0.000444 ether to set +10 defence and -10 prosperity level of your kingdom. 
34  *
35  * Use 200000 of Gas limit for your transactions.
36  *
37  * Admin commissions: 5% from GRC tokens buying.
38  *
39  * Game will be paused for 3 days when balance is null and will be auto restarted, all kingdoms and tokens will be burnt.
40  * 
41  */
42 
43 pragma solidity ^0.4.25;
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that revert on error
49  */
50 library SafeMath {
51 
52     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
53         if (_a == 0) {
54             return 0;
55         }
56 
57         uint256 c = _a * _b;
58         require(c / _a == _b);
59 
60         return c;
61     }
62 
63     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
64         require(_b > 0);
65         uint256 c = _a / _b;
66 
67         return c;
68     }
69 
70     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
71         require(_b <= _a);
72         uint256 c = _a - _b;
73 
74         return c;
75     }
76 
77     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
78         uint256 c = _a + _b;
79         require(c >= _a);
80 
81         return c;
82     }
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 interface IERC20 {
90     function totalSupply() external view returns (uint256);
91     function balanceOf(address who) external view returns (uint256);
92     function transfer(address to, uint256 value) external returns (bool);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95 }
96 
97 contract Ownable {
98 	address private owner;
99 	
100     constructor() public {
101         owner = msg.sender;
102     }
103 
104     modifier onlyOwner() {
105         require(msg.sender == owner);
106         _;
107     }	
108 }
109 
110 contract ERC20 is Ownable {
111     using SafeMath for uint256;
112 
113     mapping (address => uint256) private _balances;
114 
115 	uint256 private _totalSupply;
116 	
117 	 
118     /**
119     * @dev Total number of tokens in existence
120     */
121     function totalSupply() external view returns (uint256) {
122         return _totalSupply;
123     }
124 
125     /**
126     * @dev Gets the balance of the specified address.
127     * @param owner The address to query the balance of.
128     * @return An uint256 representing the amount owned by the passed address.
129     */
130     function balanceOf(address owner) public view returns (uint256) {
131         return _balances[owner];
132     }
133 
134     /**
135     * @dev Transfer token for a specified address
136     * @param from The address to transfer from.
137     * @param to The address to transfer to.
138     * @param value The amount to be transferred.
139     */
140     function transfer(address from, address to, uint256 value) public onlyOwner returns (bool) {
141         _transfer(from, to, value);
142         return true;
143     }
144 
145     /**
146     * @dev Mint token for a specified address
147     * @param account The address to mint to.
148     * @param value The amount to be minted.
149     */
150     function mint(address account, uint256 value) public onlyOwner returns (bool) {
151         _mint(account, value);
152         return true;
153     }
154 	
155     /**
156     * @dev Burn token for a specified address
157     * @param account The address to burn from.
158     * @param value The amount to be burnt.
159     */
160     function burn(address account, uint256 value) public onlyOwner returns (bool) {
161         _burn(account, value);
162         return true;
163     }	
164 	
165     /**
166     * @dev Transfer token for a specified addresses
167     * @param from The address to transfer from.
168     * @param to The address to transfer to.
169     * @param value The amount to be transferred.
170     */
171     function _transfer(address from, address to, uint256 value) internal {
172         require(to != address(0));
173 
174         _balances[from] = _balances[from].sub(value);
175         _balances[to] = _balances[to].add(value);
176     }
177 
178     /**
179      * @dev Internal function that mints an amount of the token and assigns it to
180      * an account. This encapsulates the modification of balances such that the
181      * proper events are emitted.
182      * @param account The account that will receive the created tokens.
183      * @param value The amount that will be created.
184      */
185     function _mint(address account, uint256 value) internal {
186         require(account != address(0));
187 
188         _totalSupply = _totalSupply.add(value);
189         _balances[account] = _balances[account].add(value);
190     }
191 
192     /**
193      * @dev Internal function that burns an amount of the token of a given
194      * account.
195      * @param account The account whose tokens will be burnt.
196      * @param value The amount that will be burnt.
197      */
198     function _burn(address account, uint256 value) internal {
199         require(account != address(0));
200 
201         _totalSupply = _totalSupply.sub(value);
202         _balances[account] = _balances[account].sub(value);
203     }
204 
205 
206 }
207 
208 contract KingdomStorage is ERC20 {
209     using SafeMath for uint256;
210 
211     uint private _kingdomsCount;
212 
213     struct Kingdom {
214         uint numberOfCitizens;
215 		uint numberOfWarriors;
216 		uint prosperity;
217 		uint defence;
218 		uint lostCoins; //lost tokens in wars
219         uint tributeCheckpoint;
220     }
221 
222 	mapping (uint => address) private kingdomAddress;
223     mapping (address => Kingdom) private kingdoms;
224 	
225 	event War(address indexed _attacked, address indexed _invader, uint _lostCoins, uint _slayedWarriors);
226 
227     function addCitizens(address _address, uint _number, bool _are_warriors) external onlyOwner {
228 		if (kingdoms[_address].prosperity == 0) {
229 			// create the new kingdom
230 			kingdomAddress[_kingdomsCount] = _address;
231 			kingdoms[_address].prosperity = 50;
232 			kingdoms[_address].defence = 50;	
233 			_kingdomsCount++;
234 		}
235 		
236         if (_are_warriors) {
237 			// add warriors	
238 			kingdoms[_address].numberOfWarriors = kingdoms[_address].numberOfWarriors.add(_number);
239 		} else {
240 			// add citizens
241 			kingdoms[_address].numberOfCitizens = kingdoms[_address].numberOfCitizens.add(_number);
242 			kingdoms[_address].tributeCheckpoint = block.timestamp;
243 		}
244 
245     }
246 	
247     function getTribute(address _address) external onlyOwner {
248 		uint tributeValue = getTributeValue(_address);
249 		if (tributeValue > 0) {
250 			mint(_address, tributeValue);
251 			kingdoms[_address].tributeCheckpoint = block.timestamp;
252 			kingdoms[_address].lostCoins = 0;
253 		}
254     }
255 	
256 	function startWar(address _invader, address _attacked) external onlyOwner {
257 		uint invaderWarriorsNumber = getWarriorsNumber(_invader);
258 		require (invaderWarriorsNumber >0);
259 		
260 		uint attackedKingdomBalance = balanceOf(_attacked);		
261 		uint attackedKingdomWealth = getTributeValue(_attacked).add(attackedKingdomBalance);
262 		uint attackedKingdomDefence = getDefence(_attacked); 
263 		
264 		// one warrior picks up number of GRC equal (100 - attacked kingdom defence)
265 		uint attackPower = invaderWarriorsNumber.mul(100 - attackedKingdomDefence); 
266 		if (attackPower > attackedKingdomWealth)
267 			attackPower = attackedKingdomWealth;
268 		
269 		// defence action: slay warriors
270 		uint slayedWarriors;
271 		// dont slay, if attackedKingdomWealth <= 10000 GRC
272 		if (attackedKingdomWealth > 10000) {
273 			slayedWarriors = invaderWarriorsNumber.mul(attackedKingdomDefence).div(100);	
274 			kingdoms[_invader].numberOfWarriors -= slayedWarriors;
275 		}
276 		
277 		// invader action: pick up tokens
278 		uint lostCoins;
279 		
280 		if (attackedKingdomBalance >= attackPower) {
281 			transfer(_attacked, _invader, attackPower);
282 			lostCoins += attackPower;
283 			attackPower = 0;
284 		} else if (attackedKingdomBalance > 0) {
285 			transfer(_attacked, _invader, attackedKingdomBalance);
286 			lostCoins += attackedKingdomBalance;
287 			attackPower -= attackedKingdomBalance;
288 		} 
289 
290 		if (attackPower > 0) {
291 			kingdoms[_attacked].lostCoins += attackPower;
292 			mint(_invader, attackPower);
293 			lostCoins += attackPower;
294 		}
295 		
296 		emit War(_attacked, _invader, lostCoins, slayedWarriors);
297 	}
298 	
299 	function warFailed(address _invader) external onlyOwner {
300 		emit War(address(0), _invader, 0, 0);
301 	}
302 	
303     function increaseProsperity(address _address) external onlyOwner {
304 		// minimum defence = 0%, maximum prosperity = 100%
305 		if (kingdoms[_address].prosperity <= 90) {
306 			kingdoms[_address].prosperity += 10;
307 			kingdoms[_address].defence -= 10;
308 		}
309     }	
310 	
311     function increaseDefence(address _address) external onlyOwner {
312 		// maximum defence = 90%, minimum prosperity = 10%
313 		if (kingdoms[_address].defence <= 80) {
314 			kingdoms[_address].defence += 10;
315 			kingdoms[_address].prosperity -= 10;
316 		}
317     }	
318 
319     function getTributeValue(address _address) public view returns(uint) {
320 		uint numberOfCitizens = getCitizensNumber(_address);
321 		if (numberOfCitizens > 0) {
322 			// one citizen gives tribute equal kingdom prosperity, per 7 days;
323 			return numberOfCitizens.mul(getProsperity(_address)).mul(block.timestamp.sub(getTributeCheckpoint(_address))).div(7 days).sub(getLostCoins(_address)); 
324 		}
325 		return 0;
326     }	
327 
328     function getProsperity(address _address) public view returns(uint) {
329 		return kingdoms[_address].prosperity;
330     }
331 	
332     function getDefence(address _address) public view returns(uint) {
333 		return kingdoms[_address].defence;
334     }	
335     function getLostCoins(address _address) public view returns(uint) {
336 		return kingdoms[_address].lostCoins;
337     }	
338 
339     function getCitizensNumber(address _address) public view returns(uint) {
340         return kingdoms[_address].numberOfCitizens;
341     }
342 
343     function getWarriorsNumber(address _address) public view returns(uint) {
344         return kingdoms[_address].numberOfWarriors;
345     }
346 	
347     function getTributeCheckpoint(address _address) public view returns(uint) {
348         return kingdoms[_address].tributeCheckpoint;
349     }
350 
351     function getKingdomAddress(uint _kingdomId) external view returns(address) {
352         return kingdomAddress[_kingdomId];
353     }
354 	
355 	function kingdomsCount() external view returns(uint) {
356         return _kingdomsCount;
357     }
358 }
359 
360 contract GreenRabbitKingdom is IERC20 {
361     using SafeMath for uint;
362 
363     address admin;
364 
365     uint invested;
366     uint payed;
367     uint startTime;
368 	uint tokenStartPrice;
369 	
370 	string public name = 'GreenRabbitCoin';
371 	string public symbol = 'GRC';
372 	uint public decimals = 0;
373 	
374     event LogNewGame(uint _startTime);
375 	
376     KingdomStorage private kingdom;
377 
378     modifier notOnPause() {
379         require(startTime <= block.timestamp, "Game paused");
380         _;
381     }
382 
383     constructor() public {
384         admin = msg.sender;
385         kingdom = new KingdomStorage();
386         startTime = now;
387 		tokenStartPrice = 1 szabo; //0.000001 ETH
388     }
389  
390     function() external payable {
391         if (msg.value == 0 && msg.value <= 0.00001 ether) {
392             sellTokens();
393         } else if (msg.value == 0.000111 ether) {
394 			//add citizens, not warriors
395             addCitizens(false);
396         } else if (msg.value == 0.000222 ether) {
397 			//add warriors
398             addCitizens(true);
399         } else if (msg.value == 0.000333 ether) {
400             increaseProsperity();
401         } else if (msg.value == 0.000444 ether) {
402             increaseDefence();
403 		} else {            
404 			buyTokens();
405         }
406     }
407 
408     /**
409      * @dev ERC20 function
410      */
411     function totalSupply() external view returns (uint256) {
412         return kingdom.totalSupply();
413     }
414 
415     /**
416      * @dev ERC20 function
417      */
418     function transfer(address to, uint256 value) external returns (bool) {
419 		// get tribute from your citizens before
420 		kingdom.getTribute(msg.sender);
421         return kingdom.transfer(msg.sender, to, value);
422     }	
423 
424     /**
425      * @dev ERC20 function
426      */
427 	function balanceOf(address owner) public view returns (uint256) {
428         return kingdom.balanceOf(owner);
429     }
430 	
431     function buyTokens() notOnPause public payable {
432 		require (msg.value >= 0.001 ether);
433 		uint tokensValue = msg.value.div(getTokenSellPrice()).mul(90).div(100);
434 		kingdom.mint(msg.sender, tokensValue);
435 		admin.send(msg.value / 20); //5%
436 		emit Transfer(address(0), msg.sender, tokensValue);
437     }
438 
439     function sellTokens() notOnPause public {
440 		// get tribute from your citizens before
441 		kingdom.getTribute(msg.sender);
442 		
443         uint tokensValue = balanceOf(msg.sender); 
444 		uint payout = tokensValue.mul(getTokenSellPrice());
445 
446         if (payout > 0) {
447 
448             if (payout > address(this).balance) {
449 				msg.sender.transfer(address(this).balance);
450                 nextGame();
451                 return;
452             }
453 
454             msg.sender.transfer(payout);
455 			
456 			kingdom.burn(msg.sender, tokensValue);
457 			emit Transfer(msg.sender, address(0), tokensValue);
458         }		
459     }
460 	
461 	function addCitizens(bool _are_warriors) notOnPause public {
462 		// get tribute from your citizens before adding new citizens
463 		kingdom.getTribute(msg.sender);
464 		
465 		uint CitizensNumber = balanceOf(msg.sender).div(100);
466 		if (CitizensNumber > 0) {
467 			kingdom.addCitizens(msg.sender,CitizensNumber,_are_warriors);
468 			kingdom.burn(msg.sender, CitizensNumber * 100);
469 		}
470 	}
471 	
472     function attackKingdom(address _invader, uint _random) notOnPause public returns(bool) {
473 		// Only for invader's smart contract:
474 		// https://etherscan.io/address/0x76d7aed5ab1c4a5e210d0ccac747d097f9d58966
475 		require (msg.sender == 0x76d7aed5ab1c4a5e210d0ccac747d097f9d58966); 
476 		
477 		uint attackedKingdomId = _random % (kingdom.kingdomsCount());
478 		address attackedKingdomAddress = kingdom.getKingdomAddress(attackedKingdomId);
479 		
480 		if (_invader != attackedKingdomAddress) {
481 			kingdom.startWar(_invader, attackedKingdomAddress);
482 		} else {
483 			// you can't attack youself
484 			kingdom.warFailed(_invader);
485 		}
486 			
487         return true;
488     }	
489 	
490 	function increaseProsperity() notOnPause public {
491 		// get tribute from your citizens before
492 		kingdom.getTribute(msg.sender);
493 		kingdom.increaseProsperity(msg.sender);
494 	}
495 	
496 	function increaseDefence() notOnPause public {
497 		// get tribute from your citizens before
498 		kingdom.getTribute(msg.sender);		
499 		kingdom.increaseDefence(msg.sender);
500 	}
501 	
502 	function synchronizeTokensBalance() notOnPause public {
503 		// get tribute from your citizens 
504 		// for release real tokens that you can see them in your ERC-20 wallet 
505 		kingdom.getTribute(msg.sender);		
506 	}	
507 	
508 	function getTokenSellPrice() public view returns(uint) {
509 		//each day +1% to token price
510 		return tokenStartPrice.add( tokenStartPrice.div(100).mul(block.timestamp.sub(startTime).div(1 days)) );
511 	}
512 
513     function getGameAge() external view returns(uint) {
514 		if (block.timestamp > startTime)
515 			return block.timestamp.sub(startTime).div(1 days).add(1);
516 		else 
517 			return 0;
518     }
519 	
520     function getKingdomsCount() external view returns(uint) {
521         return kingdom.kingdomsCount();
522     }
523 	
524     function getKingdomData(address _address) external view returns(uint numberOfCitizens, uint numberOfWarriors, uint prosperity, uint defence, uint balance) {
525 		numberOfCitizens = kingdom.getCitizensNumber(_address);
526 		numberOfWarriors = kingdom.getWarriorsNumber(_address);
527 		prosperity = kingdom.getProsperity(_address);
528 		defence = kingdom.getDefence(_address);
529 		balance = kingdom.getTributeValue(_address) + balanceOf(_address);
530     }	
531 
532     function getBalance() external view returns(uint) {
533         return address(this).balance;
534     }
535 
536     function nextGame() private {
537         kingdom = new KingdomStorage();
538         startTime = block.timestamp + 3 days;
539         emit LogNewGame(startTime);
540     }
541 	
542 }