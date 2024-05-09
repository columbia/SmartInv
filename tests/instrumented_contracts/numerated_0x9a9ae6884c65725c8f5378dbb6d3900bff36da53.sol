1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7  */
8 library SafeMath {
9 	function mul(uint256 a, uint256 b) pure internal returns (uint256) {
10 		uint256 c = a * b;
11 		assert(a == 0 || c / a == b);
12 		return c;
13 	}
14 
15 	function div(uint256 a, uint256 b) pure internal returns (uint256) {
16 		// assert(b > 0); // Solidity automatically throws when dividing by 0
17 		uint256 c = a / b;
18 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
19 		return c;
20 	}
21 
22 	function sub(uint256 a, uint256 b) pure internal returns (uint256) {
23 		assert(b <= a);
24 		return a - b;
25 	}
26 
27 	function add(uint256 a, uint256 b) pure internal returns (uint256) {
28 		uint256 c = a + b;
29 		assert(c >= a);
30 		return c;
31 	}
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40 	address public owner;
41 
42 
43 	/**
44 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45 	 * account.
46 	 */
47 	function Ownable() public {
48 		owner = msg.sender;
49 	}
50 
51 
52 	/**
53 	 * @dev Throws if called by any account other than the owner.
54 	 */
55 	modifier onlyOwner() {
56 		if (msg.sender != owner) {
57 			revert();
58 		}
59 		_;
60 	}
61 
62 
63 	/**
64 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
65 	 * @param newOwner The address to transfer ownership to.
66 	 */
67 	function transferOwnership(address newOwner) public onlyOwner {
68 		if (newOwner != address(0)) {
69 			owner = newOwner;
70 		}
71 	}
72 
73 }
74 
75 /**
76  * @title ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 contract ERC20 {
80 	uint256 public tokenTotalSupply;
81 
82 	function balanceOf(address who) public view returns(uint256);
83 
84 	function allowance(address owner, address spender) public view returns(uint256);
85 
86 	function transfer(address to, uint256 value) public returns (bool success);
87 	event Transfer(address indexed from, address indexed to, uint256 value);
88 
89 	function transferFrom(address from, address to, uint256 value) public returns (bool success);
90 
91 	function approve(address spender, uint256 value) public returns (bool success);
92 	event Approval(address indexed owner, address indexed spender, uint256 value);
93 
94 	function totalSupply() public view returns (uint256 availableSupply);
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implemantation of the basic standart token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract SaveToken is ERC20, Ownable {
105 	using SafeMath for uint;
106 
107 	string public name = "SaveToken";
108 	string public symbol = "SAVE";
109 	uint public decimals = 18;
110 
111 	mapping(address => uint256) affiliate;
112 	function getAffiliate(address who) public view returns(uint256) {
113 		return affiliate[who];
114 	}
115 
116     struct AffSender {
117         bytes32 aff_code;
118         uint256 amount;
119     }
120     uint public no_aff = 0;
121 	mapping(uint => AffSender) affiliate_senders;
122 	function getAffiliateSender(bytes32 who) public view returns(uint256) {
123 	    
124 	    for (uint i = 0; i < no_aff; i++) {
125             if(affiliate_senders[i].aff_code == who)
126             {
127                 return affiliate_senders[i].amount;
128             }
129         }
130         
131 		return 1;
132 	}
133 	function getAffiliateSenderPosCode(uint pos) public view returns(bytes32) {
134 	    if(pos >= no_aff)
135 	    {
136 	        return 1;
137 	    }
138 	    return affiliate_senders[pos].aff_code;
139 	}
140 	function getAffiliateSenderPosAmount(uint pos) public view returns(uint256) {
141 	    if(pos >= no_aff)
142 	    {
143 	        return 2;
144 	    }
145 	    return affiliate_senders[pos].amount;
146 	}
147 
148 	uint256 public tokenTotalSupply = 0;
149 	uint256 public trashedTokens = 0;
150 	uint256 public hardcap = 350 * 1000000 * (10 ** decimals); // 350 million tokens
151 
152 	uint public ethToToken = 6000; // 1 eth buys 6 thousands tokens
153 	uint public noContributors = 0;
154 
155 
156 	//-----------------------------bonus periods
157 	uint public tokenBonusForFirst = 10; // multiplyer in %
158 	uint256 public soldForFirst = 0;
159 	uint256 public maximumTokensForFirst = 55 * 1000000 * (10 ** decimals); // 55 million
160 
161 	uint public tokenBonusForSecond = 5; // multiplyer in %
162 	uint256 public soldForSecond = 0;
163 	uint256 public maximumTokensForSecond = 52.5 * 1000000 * (10 ** decimals); // 52 million 500 thousands
164 
165 	uint public tokenBonusForThird = 4; // multiplyer in %
166 	uint256 public soldForThird = 0;
167 	uint256 public maximumTokensForThird = 52 * 1000000 * (10 ** decimals); // 52 million
168 
169 	uint public tokenBonusForForth = 3; // multiplyer in %
170 	uint256 public soldForForth = 0;
171 	uint256 public maximumTokensForForth = 51.5 * 1000000 * (10 ** decimals); // 51 million 500 thousands
172 
173 	uint public tokenBonusForFifth = 0; // multiplyer in %
174 	uint256 public soldForFifth = 0;
175 	uint256 public maximumTokensForFifth = 50 * 1000000 * (10 ** decimals); // 50 million
176 
177 	uint public presaleStart = 1519344000; //2018-02-23T00:00:00+00:00
178 	uint public presaleEnd = 1521849600; //2018-03-24T00:00:00+00:00
179     uint public weekOneStart = 1524355200; //2018-04-22T00:00:00+00:00
180     uint public weekTwoStart = 1525132800; //2018-05-01T00:00:00+00:00
181     uint public weekThreeStart = 1525824000; //2018-05-09T00:00:00+00:00
182     uint public weekFourStart = 1526601600; //2018-05-18T00:00:00+00:00
183     uint public tokenSaleEnd = 1527292800; //2018-05-26T00:00:00+00:00
184     
185     uint public saleOn = 1;
186     uint public disown = 0;
187 
188 	//uint256 public maximumTokensForReserve = 89 * 1000000 * (10 ** decimals); // 89 million
189 	address public ownerVault;
190 
191 	mapping(address => uint256) balances;
192 	mapping(address => mapping(address => uint256)) allowed;
193 
194 	/**
195 	 * @dev Fix for the ERC20 short address attack.
196 	 */
197 	modifier onlyPayloadSize(uint size) {
198 		if (msg.data.length < size + 4) {
199 			revert();
200 		}
201 		_;
202 	}
203 
204 	/**
205 	 * @dev modifier to allow token creation only when the hardcap has not been reached
206 	 */
207 	modifier isUnderHardCap() {
208 		require(tokenTotalSupply <= hardcap);
209 		_;
210 	}
211 
212 	/**
213 	 * @dev Constructor
214 	 */
215 	function SaveToken() public {
216 		ownerVault = msg.sender;
217 	}
218 
219 	/**
220 	 * @dev transfer token for a specified address
221 	 * @param _to The address to transfer to.
222 	 * @param _value The amount to be transferred.
223 	 */
224 	function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
225 
226 		balances[msg.sender] = balances[msg.sender].sub(_value);
227 		balances[_to] = balances[_to].add(_value);
228 		Transfer(msg.sender, _to, _value);
229 
230 		return true;
231 	}
232 
233 	/**
234 	 * @dev Transfer tokens from one address to another
235 	 * @param _from address The address which you want to send tokens from
236 	 * @param _to address The address which you want to transfer to
237 	 * @param _value uint256 the amout of tokens to be transfered
238 	 */
239 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool success) {
240 		uint256 _allowance = allowed[_from][msg.sender];
241 		balances[_to] = balances[_to].add(_value);
242 		balances[_from] = balances[_from].sub(_value);
243 		allowed[_from][msg.sender] = _allowance.sub(_value);
244 		Transfer(_from, _to, _value);
245 
246 		return true;
247 	}
248 
249 	/**
250 	 * @dev Transfer tokens from one address to another according to off exchange agreements
251 	 * @param _from address The address which you want to send tokens from
252 	 * @param _to address The address which you want to transfer to
253 	 * @param _value uint256 the amount of tokens to be transferred
254 	 */
255 	function masterTransferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public onlyOwner returns (bool success) {
256 	    if(disown == 1) revert();
257 	    
258 		balances[_to] = balances[_to].add(_value);
259 		balances[_from] = balances[_from].sub(_value);
260 		Transfer(_from, _to, _value);
261 
262 		return true;
263 	}
264 
265 	function totalSupply() public view returns (uint256 availableSupply) {
266 		return tokenTotalSupply;
267 	}
268 
269 	/**
270 	 * @dev Gets the balance of the specified address.
271 	 * @param _owner The address to query the the balance of.
272 	 * @return An uint256 representing the amount owned by the passed address.
273 	 */
274 	function balanceOf(address _owner) public view returns(uint256 balance) {
275 		return balances[_owner];
276 	}
277 
278 	/**
279 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
280 	 * @param _spender The address which will spend the funds.
281 	 * @param _value The amount of tokens to be spent.
282 	 */
283 	function approve(address _spender, uint256 _value) public returns (bool success) {
284 
285 		// To change the approve amount you first have to reduce the addresses`
286 		//  allowance to zero by calling `approve(_spender, 0)` if it is not
287 		//  already 0 to mitigate the race condition described here:
288 		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289 		if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
290 			revert();
291 		}
292 
293 		allowed[msg.sender][_spender] = _value;
294 		Approval(msg.sender, _spender, _value);
295 
296 		return true;
297 	}
298 
299 	/**
300 	 * @dev Function to check the amount of tokens than an owner allowed to a spender.
301 	 * @param _owner address The address which owns the funds.
302 	 * @param _spender address The address which will spend the funds.
303 	 * @return A uint256 specifying the amount of tokens still available for the spender.
304 	 */
305 	function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
306 		return allowed[_owner][_spender];
307 	}
308 
309 	/**
310 	 * @dev Allows the owner to change the token exchange rate.
311 	 * @param _ratio the new eth to token ration
312 	 */
313 	function changeEthToTokenRation(uint8 _ratio) public onlyOwner {
314 		if (_ratio != 0) {
315 			ethToToken = _ratio;
316 		}
317 	}
318 
319 	/**
320 	 * @dev convenience show balance
321 	 */
322 	function showEthBalance() view public returns(uint256 remaining) {
323 		return this.balance;
324 	}
325 
326 	/**
327 	 * @dev burn tokens if need to
328 	 * @param value token with decimals
329 	 * @param from burn address
330 	 */
331 	function decreaseSupply(uint256 value, address from) public onlyOwner returns (bool) {
332 	    if(disown == 1) revert();
333 	    
334 		balances[from] = balances[from].sub(value);
335 		trashedTokens = trashedTokens.add(value);
336 		tokenTotalSupply = tokenTotalSupply.sub(value);
337 		Transfer(from, 0, value);
338 		return true;
339 	}
340 
341 	/**
342 	 *  Send ETH with affilate code.
343 	 */
344 	function BuyTokensWithAffiliate(address _affiliate) public isUnderHardCap payable
345 	{
346 		affiliate[_affiliate] += msg.value;
347 		if (_affiliate == msg.sender){  revert(); }
348 		BuyTokens();
349 	}
350 
351 	/**
352 	 *  Allows owner to create tokens without ETH
353 	 */
354 	function mintTokens(address _address, uint256 amount) public onlyOwner isUnderHardCap
355 	{
356 	    if(disown == 1) revert();
357 	    
358 		if (amount + tokenTotalSupply > hardcap) revert();
359 		if (amount < 1) revert();
360 
361 		//add tokens to balance
362 		balances[_address] = balances[_address] + amount;
363 
364 		//increase total tokens
365 		tokenTotalSupply = tokenTotalSupply.add(amount);
366 		Transfer(this, _address, amount);
367 		noContributors++;
368 	}
369 
370 	/**
371 	 *  @dev Change owner vault.
372 	 */
373 	function changeOwnerVault(address new_vault) public onlyOwner
374 	{
375 	    ownerVault = new_vault;
376     }
377     
378 	/**
379 	 *  @dev Change periods.
380 	 */
381 	function changePeriod(uint period_no, uint new_value) public onlyOwner
382 	{
383 		if(period_no == 1)
384 		{
385 		    presaleStart = new_value;
386 		}
387 		else if(period_no == 2)
388 		{
389 		    presaleEnd = new_value;
390 		}
391 		else if(period_no == 3)
392 		{
393 		    weekOneStart = new_value;
394 		}
395 		else if(period_no == 4)
396 		{
397 		    weekTwoStart = new_value;
398 		}
399 		else if(period_no == 5)
400 		{
401 		    weekThreeStart = new_value;
402 		}
403 		else if(period_no == 6)
404 		{
405 		    weekFourStart = new_value;
406 		}
407 		else if(period_no == 7)
408 		{
409 		    tokenSaleEnd = new_value;
410 		}
411 	}
412 
413 	/**
414 	 *  @dev Change saleOn.
415 	 */
416 	function changeSaleOn(uint new_value) public onlyOwner
417 	{
418 	    if(disown == 1) revert();
419 	    
420 		saleOn = new_value;
421 	}
422 
423 	/**
424 	 *  @dev No more god like.
425 	 */
426 	function changeDisown(uint new_value) public onlyOwner
427 	{
428 	    if(new_value == 1)
429 	    {
430 	        disown = 1;
431 	    }
432 	}
433 
434 	/**
435 	 * @dev Allows anyone to create tokens by depositing ether.
436 	 */
437 	function BuyTokens() public isUnderHardCap payable {
438 		uint256 tokens;
439 		uint256 bonus;
440 
441         if(saleOn == 0) revert();
442         
443 		if (now < presaleStart) revert();
444 
445 		//this is pause period
446 		if (now >= presaleEnd && now <= weekOneStart) revert();
447 
448 		//sale has ended
449 		if (now >= tokenSaleEnd) revert();
450 
451 		//pre-sale
452 		if (now >= presaleStart && now <= presaleEnd)
453 		{
454 			bonus = ethToToken.mul(msg.value).mul(tokenBonusForFirst).div(100);
455 			tokens = ethToToken.mul(msg.value).add(bonus);
456 			soldForFirst = soldForFirst.add(tokens);
457 			if (soldForFirst > maximumTokensForFirst) revert();
458 		}
459 
460 		//public first week
461 		if (now >= weekOneStart && now <= weekTwoStart)
462 		{
463 			bonus = ethToToken.mul(msg.value).mul(tokenBonusForSecond).div(100);
464 			tokens = ethToToken.mul(msg.value).add(bonus);
465 			soldForSecond = soldForSecond.add(tokens);
466 			if (soldForSecond > maximumTokensForSecond.add(maximumTokensForFirst).sub(soldForFirst)) revert();
467 		}
468 
469 		//public second week
470 		if (now >= weekTwoStart && now <= weekThreeStart)
471 		{
472 			bonus = ethToToken.mul(msg.value).mul(tokenBonusForThird).div(100);
473 			tokens = ethToToken.mul(msg.value).add(bonus);
474 			soldForThird = soldForThird.add(tokens);
475 			if (soldForThird > maximumTokensForThird.add(maximumTokensForFirst).sub(soldForFirst).add(maximumTokensForSecond).sub(soldForSecond)) revert();
476 		}
477 
478 		//public third week
479 		if (now >= weekThreeStart && now <= weekFourStart)
480 		{
481 			bonus = ethToToken.mul(msg.value).mul(tokenBonusForForth).div(100);
482 			tokens = ethToToken.mul(msg.value).add(bonus);
483 			soldForForth = soldForForth.add(tokens);
484 			if (soldForForth > maximumTokensForForth.add(maximumTokensForFirst).sub(soldForFirst).add(maximumTokensForSecond).sub(soldForSecond).add(maximumTokensForThird).sub(soldForThird)) revert();
485 		}
486 
487 		//public forth week
488 		if (now >= weekFourStart && now <= tokenSaleEnd)
489 		{
490 			bonus = ethToToken.mul(msg.value).mul(tokenBonusForFifth).div(100);
491 			tokens = ethToToken.mul(msg.value).add(bonus);
492 			soldForFifth = soldForFifth.add(tokens);
493 			if (soldForFifth > maximumTokensForFifth.add(maximumTokensForFirst).sub(soldForFirst).add(maximumTokensForSecond).sub(soldForSecond).add(maximumTokensForThird).sub(soldForThird).add(maximumTokensForForth).sub(soldForForth)) revert();
494 		}
495 
496 		if (tokens == 0)
497 		{
498 			revert();
499 		}
500 
501         if (tokens + tokenTotalSupply > hardcap) revert();
502 		
503 		//add tokens to balance
504 		balances[msg.sender] = balances[msg.sender] + tokens;
505 
506 		//increase total tokens
507 		tokenTotalSupply = tokenTotalSupply.add(tokens);
508 		Transfer(this, msg.sender, tokens);
509 		noContributors++;
510 	}
511 
512 	/**
513     * @dev Allows the owner to send the funds to the vault.
514     * @param _amount the amount in wei to send
515     */
516 	function withdrawEthereum(uint256 _amount) public onlyOwner {
517 		require(_amount <= this.balance); // wei
518 
519 		if (!ownerVault.send(_amount)) {
520 			revert();
521 		}
522 		Transfer(this, ownerVault, _amount);
523 	}
524 
525 
526 	// 	function getReservedTokens() public view returns (uint256)
527 	// 	{
528 	// 		if (checkIsPublicTime() == false) return 0;
529 	// 		return hardcap - maximumTokensForPublic + maximumTokensForPrivate - tokenTotalSupply;
530 	// 	}
531 
532 	function transferReservedTokens(uint256 _amount) public onlyOwner
533 	{
534 	    if(disown == 1) revert();
535 	    
536 		if (now <= tokenSaleEnd) revert();
537 
538 		assert(_amount <= (hardcap - tokenTotalSupply) );
539 
540 		balances[ownerVault] = balances[ownerVault] + _amount;
541 		tokenTotalSupply = tokenTotalSupply + _amount;
542 		Transfer(this, ownerVault, _amount);
543 	}
544 
545 	function() external payable {
546 		BuyTokens();
547 
548 	}
549 }