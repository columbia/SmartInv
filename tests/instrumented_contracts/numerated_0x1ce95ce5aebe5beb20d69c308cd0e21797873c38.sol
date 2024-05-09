1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83 
84   /**
85   * @dev total number of tokens in existence
86   */
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99 
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     emit Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127   mapping (address => mapping (address => uint256)) internal allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amount of tokens to be transferred
135    */
136   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[_from]);
139     require(_value <= allowed[_from][msg.sender]);
140 
141     balances[_from] = balances[_from].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144     emit Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    *
151    * Beware that changing an allowance with this method brings the risk that someone may use both the old
152    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) public returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     emit Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public view returns (uint256) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   /**
191    * @dev Decrease the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To decrement
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _subtractedValue The amount of tokens to decrease the allowance by.
199    */
200   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201     uint oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue > oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211 }
212 
213 
214 
215 
216 /**
217  * @title Ownable
218  * @dev The Ownable contract has an owner address, and provides basic authorization control
219  * functions, this simplifies the implementation of "user permissions".
220  */
221 contract Ownable {
222   address public owner;
223 
224 
225   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
226 
227 
228   /**
229    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
230    * account.
231    */
232   constructor() public {
233     owner = msg.sender;
234   }
235 
236   /**
237    * @dev Throws if called by any account other than the owner.
238    */
239   modifier onlyOwner() {
240     require(msg.sender == owner);
241     _;
242   }
243 
244   /**
245    * @dev Allows the current owner to transfer control of the contract to a newOwner.
246    * @param newOwner The address to transfer ownership to.
247    */
248   function transferOwnership(address newOwner) public onlyOwner {
249     require(newOwner != address(0));
250     emit OwnershipTransferred(owner, newOwner);
251     owner = newOwner;
252   }
253 
254 }
255 
256 
257 contract Authorizable is Ownable {
258 
259     mapping(address => bool) public authorized;
260 
261     modifier onlyAuthorized() {
262         require(authorized[msg.sender]);
263         _;
264     }
265 
266     function addAuthorized(address _toAdd) onlyOwner public {
267         authorized[_toAdd] = true;
268     }
269 
270     function removeAuthorized(address _toRemove) onlyOwner public {
271         authorized[_toRemove] = false;
272     }
273 
274 }
275 
276 
277 contract LiteNetCoin is StandardToken, Authorizable{
278 	
279 	uint256 public INITIAL_SUPPLY = 300000000 * 1 ether; // Всего токенов
280 	string public constant name = "LiteNetCoin";
281     string public constant symbol = "LNC";
282 	uint8 public constant decimals = 18;
283 	
284 	constructor() public  {
285         totalSupply_ = INITIAL_SUPPLY;
286 		balances[owner] = totalSupply_;
287     }
288 	
289 	function totalSupply() public view returns (uint256) {
290 		return totalSupply_;
291     }
292 }
293 
294 
295 
296 contract Crowdsale is LiteNetCoin {
297 
298 	using SafeMath for uint256;
299 
300     LiteNetCoin public token = new LiteNetCoin();
301 	
302 	uint256 public constant BASE_RATE = 2500;
303  
304 	// Старт pre sale 1
305 	uint64 public constant PRE_SALE_START_1 = 1526256000; // 14/05/2018/00/00/00
306 	//uint64 public constant PRE_SALE_FINISH_1 = 1526860800; // 21/05/2018/00/00/00
307 	
308 	// Старт pre sale 2
309 	uint64 public constant PRE_SALE_START_2 = 1527465600; // 28/05/2018/00/00/00
310 	//uint64 public constant PRE_SALE_FINISH_2 = 1528588800; // 10/06/2018/00/00/00
311 	
312 	// Старт pre sale 3
313 	uint64 public constant PRE_SALE_START_3 = 1529884800; // 25/06/2018/00/00/00
314 	//uint64 public constant PRE_SALE_FINISH_3 = 1530403200; // 01/07/2018/00/00/00
315 	
316 	// Старт pre sale 4
317 	
318 	//uint64 public constant PRE_SALE_START_4 = 1525996800; // 27/08/2018/00/00/00
319 	uint64 public constant PRE_SALE_START_4 = 1535328000; // 27/08/2018/00/00/00
320 	//uint64 public constant PRE_SALE_FINISH_4 = 1518134400; // 02/09/2018/00/00/00
321 	
322 	// Старт pre ICO 
323 	uint64 public constant PRE_ICO_START = 1538870400; // 07/10/2018/00/00/00
324 	//uint64 public constant PRE_ICO_FINISH = 1539475200; // 14/10/2018/00/00/00
325 	
326 	// Старт ICO 
327 	uint64 public constant ICO_START = 1541030400; // 01/11/2018/00/00/00
328 	
329 	//Конец ICO
330 	uint64 public constant ICO_FINISH = 1541376000; // 05/11/2018/00/00/00
331  
332 	// ICO открыто или закрыто
333 	bool public icoClosed = false;
334 
335 	uint256 totalBuyTokens_ = 0;
336 
337 	event BoughtTokens(address indexed to, uint256 value);
338 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
339 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
340 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
341 	
342 
343 	enum TokenDistributions { crowdsale, reserve, bounty, team, founders }
344 	mapping(uint => uint256) public distributions;
345 	
346 	address public teamTokens = 0xC7FDAE4f201D76281975D890d5491D90Ec433B0E;
347 	address public notSoldTokens = 0x6CccCD6fa8184D29950dF21DDDE1069F5B37F3d1;
348 	
349 	
350 	constructor() public  {
351 		distributions[uint8(TokenDistributions.crowdsale)] = 240000000 * 1 ether;
352 		distributions[uint8(TokenDistributions.founders)] = 12000000 * 1 ether;
353 		distributions[uint8(TokenDistributions.reserve)] = 30000000 * 1 ether;
354 		distributions[uint8(TokenDistributions.bounty)] = 9000000 * 1 ether;
355 		distributions[uint8(TokenDistributions.team)] = 9000000 * 1 ether;
356 	}
357 
358 	// меняем основной кошелек
359 	function changeOwner(address _newOwner) external onlyOwner{
360         owner = _newOwner;
361     }
362 	// меняем кошелек для команды, резерва и т.д.
363 	function changeTeamTokens(address _teamTokens) external onlyOwner{
364         teamTokens = _teamTokens;
365     }
366 	// меняем кошелек для непроданных токенов
367 	function changeNotSoldTokens(address _notSoldTokens) external onlyOwner{
368         notSoldTokens = _notSoldTokens;
369     }
370 
371 
372 	// Функция доставляет токены на кошелек покупателя при поступлении "эфира"
373     function() public payable {
374 		buyTokens(msg.sender);
375     }
376     
377     // получает адрес получаетля токенов
378     function buyTokens(address _addr) public payable {
379 		require(msg.value >= 0.001 ether);
380 		require(distributions[0] > 0);
381 		require(totalBuyTokens_ <= INITIAL_SUPPLY );
382 		require(getCurrentRound() > 0);
383 		
384 		uint discountPercent = getCurrentDiscountPercent();
385 		
386 		uint256 weiAmount = msg.value;
387         uint256 tokens = getRate(weiAmount);
388 		uint256 bonusTokens = tokens.mul(discountPercent).div(100);
389 		tokens += bonusTokens;
390 		totalBuyTokens_ = totalBuyTokens_.add(tokens);
391 
392 	    token.transfer(_addr, tokens);
393 		totalSupply_ = totalSupply_.sub(tokens);
394 		distributions[0] = distributions[0].sub(tokens);
395 		
396 	    owner.transfer(msg.value);
397 		
398 		emit TokenPurchase(msg.sender, _addr, weiAmount, tokens);
399     }
400 
401 
402 	
403 	function getCurrentRound() public view returns (uint8 round) {
404         round = 0;
405 		
406 		if(now > ICO_START + 3 days  && now <= ICO_START + 5 days)      round = 7;
407 		if(now > ICO_START        && now <= ICO_START        + 3 days)  round = 6;
408 		if(now > PRE_ICO_START    && now <= PRE_ICO_START    + 7 days)  round = 5;
409 		if(now > PRE_SALE_START_4 && now <= PRE_SALE_START_4 + 6 days)  round = 4;
410 		if(now > PRE_SALE_START_3 && now <= PRE_SALE_START_3 + 6 days)  round = 3;
411 		if(now > PRE_SALE_START_2 && now <= PRE_SALE_START_2 + 13 days) round = 2;
412 		if(now > PRE_SALE_START_1 && now <= PRE_SALE_START_1 + 8 days)  round = 1;
413 		
414 
415 		/* if(now > ICO_START        ) round = 6;
416 		if(now > PRE_ICO_START    ) round = 5;
417 		if(now > PRE_SALE_START_4 ) round = 4;
418 		if(now > PRE_SALE_START_3 ) round = 3;
419 		if(now > PRE_SALE_START_2 ) round = 2;
420 		if(now > PRE_SALE_START_1 ) round = 1; */
421 		
422 		
423         return round;
424     }
425 	
426 	
427 	function getCurrentDiscountPercent() constant returns (uint){
428 		uint8 round = getCurrentRound();
429 		uint discountPercent = 0;
430 		
431 		
432 		if(round == 1 ) discountPercent = 65;
433 		if(round == 2 ) discountPercent = 65;
434 		if(round == 3 ) discountPercent = 60;
435 		if(round == 4 ) discountPercent = 55;
436 		if(round == 5 ) discountPercent = 40;
437 		if(round == 6 ) discountPercent = 30;
438 		if(round == 7 ) discountPercent = 0;
439 		
440 		return discountPercent;
441 		
442 	}
443 	
444 
445 	function totalBuyTokens() public view returns (uint256) {
446 		return totalBuyTokens_;
447 	}
448 	
449 	function getRate(uint256 _weiAmount) internal view returns (uint256) {
450 		return _weiAmount.mul(BASE_RATE);
451 	}
452 	
453 	
454 	function sendOtherTokens(address _addr,uint256 _amount) onlyOwner onlyAuthorized isNotIcoClosed public {
455         require(totalBuyTokens_ <= INITIAL_SUPPLY);
456 		
457 		token.transfer(_addr, _amount);
458 		totalSupply_ = totalSupply_.sub(_amount);
459 		totalBuyTokens_ = totalBuyTokens_.add(_amount);
460 		
461     }
462 	
463 	
464 	function sendBountyTokens(address _addr,uint256 _amount) onlyOwner onlyAuthorized isNotIcoClosed public {
465         require(distributions[3] > 0);
466 		sendOtherTokens(_addr, _amount);
467 		distributions[3] = distributions[3].sub(_amount);
468     }
469 	
470 
471 	
472 	// Закрываем ICO 
473     function close() public onlyOwner isNotIcoClosed {
474         // Закрываем ICO
475 		require(now > ICO_FINISH);
476 		
477 		if(distributions[0] > 0){
478 			token.transfer(notSoldTokens, distributions[0]);
479 			totalSupply_ = totalSupply_.sub(distributions[0]);
480 			totalBuyTokens_ = totalBuyTokens_.add(distributions[0]);
481 			distributions[0] = 0;
482 		}
483 		token.transfer(teamTokens, distributions[1] + distributions[2] +  distributions[4]);
484 		
485 		totalSupply_ = totalSupply_.sub(distributions[1] + distributions[2] +  distributions[4]);
486 		totalBuyTokens_ = totalBuyTokens_.add(distributions[1] + distributions[2] +  distributions[4]);
487 		
488 		distributions[1] = 0;
489 		distributions[2] = 0;
490 		distributions[4] = 0;
491 		
492 		
493         icoClosed = true;
494     }
495 	
496 	modifier isNotIcoClosed {
497         require(!icoClosed);
498         _;
499     }
500   
501 }