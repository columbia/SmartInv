1 pragma solidity ^0.4.24;
2 
3 /**
4  * Libraries
5  */
6 
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * Helper contracts
51  */
52 
53 
54 contract Ownable {
55   address public owner;
56   address public coowner;
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66     coowner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner || msg.sender == coowner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81 
82     function setOwner(address newOwner) onlyOwner public {
83         require(newOwner != address(0));
84         emit OwnershipTransferred(coowner, newOwner);
85         coowner = newOwner;
86     }
87 }
88 
89 contract Pausable is Ownable {
90   event Pause();
91   event Unpause();
92 
93   bool public paused = false;
94 
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is not paused.
98    */
99   modifier whenNotPaused() {
100     require(!paused);
101     _;
102   }
103 
104   /**
105    * @dev Modifier to make a function callable only when the contract is paused.
106    */
107   modifier whenPaused() {
108     require(paused);
109     _;
110   }
111 
112   /**
113    * @dev called by the owner to pause, triggers stopped state
114    */
115   function pause() onlyOwner whenNotPaused public {
116     paused = true;
117     emit Pause();
118   }
119 
120   /**
121    * @dev called by the owner to unpause, returns to normal state
122    */
123   function unpause() onlyOwner whenPaused public {
124     paused = false;
125     emit Unpause();
126   }
127 }
128 
129 
130 contract ERC20Basic {
131   function totalSupply() public view returns (uint256);
132   function balanceOf(address who) public view returns (uint256);
133   function transfer(address to, uint256 value) public returns (bool);
134   event Transfer(address indexed from, address indexed to, uint256 value);
135 }
136 
137 contract ERC20 is ERC20Basic {
138   function allowance(address owner, address spender) public view returns (uint256);
139   function transferFrom(address from, address to, uint256 value) public returns (bool);
140   function approve(address spender, uint256 value) public returns (bool);
141   event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 contract CrowdsaleToken is ERC20 {
145   string public name;
146   string public symbol;
147   uint8 public decimals;
148 
149  constructor(string _name, string _symbol, uint8 _decimals) public {
150     name = _name;
151     symbol = _symbol;
152     decimals = _decimals;
153   }
154 }
155 
156 contract BasicToken is ERC20Basic {
157   using SafeMath for uint256;
158 
159   mapping(address => uint256) balances;
160 
161   uint256 public totalSupply_;
162 
163   /**
164   * @dev total number of tokens in existence
165   */
166   function totalSupply() public view returns (uint256) {
167     return totalSupply_.sub(balances[address(0)]);
168   }
169 
170   /**
171   * @dev transfer token for a specified address
172   * @param _to The address to transfer to.
173   * @param _value The amount to be transferred.
174   */
175   function transfer(address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[msg.sender]);
178 
179     // SafeMath.sub will throw if there is not enough balance.
180     balances[msg.sender] = balances[msg.sender].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     emit Transfer(msg.sender, _to, _value);
183     return true;
184   }
185 
186   /**
187   * @dev Gets the balance of the specified address.
188   * @param _owner The address to query the the balance of.
189   * @return An uint256 representing the amount owned by the passed address.
190   */
191   function balanceOf(address _owner) public view returns (uint256 balance) {
192     return balances[_owner];
193   }
194 
195 }
196 
197 contract Burnable is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
202     require(_to != address(0));
203     require(_value <= balances[_from]);
204     require(_value <= allowed[_from][msg.sender]);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     emit Transfer(_from, _to, _value);
210     return true;
211   }
212 
213 
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     emit Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
231     uint oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue > oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   function burn(address account, uint256 value) internal {
242     require(account != address(0));
243     totalSupply_ = totalSupply_.sub(value);
244     balances[account] = balances[account].sub(value);
245     emit Transfer(account, address(0), value);
246   }
247 
248   /**
249    * @dev Internal function that burns an amount of the token of a given
250    * account, deducting from the sender's allowance for said account. Uses the
251    * internal burn function.
252    * @param account The account whose tokens will be burnt.
253    * @param value The amount that will be burnt.
254    */
255    
256   function burnFrom(address account, uint256 value) internal {
257     allowed[account][msg.sender] = allowed[account][msg.sender].sub(value);
258     burn(account, value);
259   }
260 
261 }
262 
263 
264 /**
265  * MSG Token / Crowdsale
266  */
267 
268 contract MSG is Ownable, Pausable, Burnable, CrowdsaleToken {
269     using SafeMath for uint256;
270 
271     string name = "MoreStamps Global Token";
272     string symbol = "MSG";
273     uint8 decimals = 18;
274 
275     // Manual kill switch
276     bool crowdsaleConcluded = false;
277 
278     // start and end timestamps where investments are allowed (both inclusive)
279     uint256 public startTime;
280     uint256 public switchTime;
281     uint256 public endTime;
282 
283     // minimum investment
284     uint256 minimumInvestPreSale = 10E17;
285     uint256 minimumInvestCrowdSale = 5E17;
286 
287     // custom bonus amounts
288     uint256 public preSaleBonus = 15;
289     uint256 public crowdSaleBonus = 10;
290 
291     // address where funds are collected
292     address public wallet;
293 
294     // how many token units a buyer gets per wei
295     uint256 public preSaleRate = 1986;
296     uint256 public crowdSaleRate = 1420;
297 
298     // how many token per each round
299     uint256 public preSaleLimit = 20248800E18;
300     uint256 public crowdSaleLimit = 73933200E18;
301 
302     // amount of raised in wei
303     uint256 public weiRaised;
304     uint256 public tokensSold;
305     
306     //token allocation addresses
307     address STRATEGIC_PARTNERS_WALLET = 0x19CFB0E3F83831b726273b81760AE556600785Ec;
308 
309     // Initial token allocation (40%)
310     bool tokensAllocated = false;
311 
312     uint256 public contributors = 0;
313     mapping(address => uint256) public contributions;
314     
315     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
316     constructor() 
317         CrowdsaleToken(name, symbol, decimals) public {
318     
319         totalSupply_ = 156970000E18;
320         
321         //crowdsale allocation 
322         balances[this] = totalSupply_;
323 
324         startTime = 1543622400;
325         switchTime = 1547596800;
326         endTime = 1550275200;
327 
328         wallet = msg.sender;
329     }
330 
331     // fallback function can be used to buy tokens
332     function () external whenNotPaused payable {
333         buyTokens(msg.sender);
334     }
335 
336     function envokeTokenAllocation() public onlyOwner {
337         require(!tokensAllocated);
338         this.transfer(STRATEGIC_PARTNERS_WALLET, 62788000E18); //40% of totalSupply_
339         tokensAllocated = true;
340     }
341 
342     // low level token purchase function
343     function buyTokens(address _beneficiary) public whenNotPaused payable returns (uint256) {
344         require(!hasEnded());
345         require(_beneficiary != address(0));
346         require(validPurchase());
347         require(minimumInvest(msg.value));
348 
349         address beneficiary = _beneficiary;
350         uint256 weiAmount = msg.value;
351 
352         // calculate token amount to be sent
353         uint256 tokens = getTokenAmount(weiAmount);
354 
355         // if we run out of tokens
356         bool isLess = false;
357         if (!hasEnoughTokensLeft(weiAmount)) {
358             isLess = true;
359 
360             uint256 percentOfValue = tokensLeft().mul(100).div(tokens);
361             require(percentOfValue <= 100);
362 
363             tokens = tokens.mul(percentOfValue).div(100);
364             weiAmount = weiAmount.mul(percentOfValue).div(100);
365 
366             // send back unused ethers
367             beneficiary.transfer(msg.value.sub(weiAmount));
368         }
369 
370         // update raised ETH amount
371         weiRaised = weiRaised.add(weiAmount);
372         tokensSold = tokensSold.add(tokens);
373 
374         //check if new beneficiary
375         if(contributions[beneficiary] == 0) {
376             contributors = contributors.add(1);
377         }
378 
379         //keep track of purchases per beneficiary;
380         contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
381 
382         //transfer purchased tokens
383         this.transfer(beneficiary, tokens);
384 
385         //forwardFunds(weiAmount); //manual withdraw 
386         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
387         return (tokens);
388     }
389 
390     /**
391      * Editors
392      */
393 
394 
395     function setRate(uint256 _preSaleRate, uint256 _crowdSaleRate) onlyOwner public {
396       require(_preSaleRate >= 0);
397       require(_crowdSaleRate >= 0);
398       preSaleRate = _preSaleRate;
399       crowdSaleRate = _crowdSaleRate;
400     }
401 
402     function setBonus(uint256 _preSaleBonus, uint256 _crowdSaleBonus) onlyOwner public {
403       require(_preSaleBonus >= 0);
404       require(_crowdSaleBonus >= 0);
405       preSaleBonus = _preSaleBonus;
406       crowdSaleBonus = _crowdSaleBonus;
407     }
408 
409     function setMinInvestment(uint256 _investmentPreSale, uint256 _investmentCrowdSale) onlyOwner public {
410       require(_investmentPreSale > 0);
411       require(_investmentCrowdSale > 0);
412       minimumInvestPreSale = _investmentPreSale;
413       minimumInvestCrowdSale = _investmentCrowdSale;
414     }
415 
416     function changeEndTime(uint256 _endTime) onlyOwner public {
417         require(_endTime > startTime);
418         endTime = _endTime;
419     }
420 
421     function changeSwitchTime(uint256 _switchTime) onlyOwner public {
422         require(endTime > _switchTime);
423         require(_switchTime > startTime);
424         switchTime = _switchTime;
425     }
426 
427     function changeStartTime(uint256 _startTime) onlyOwner public {
428         require(endTime > _startTime);
429         startTime = _startTime;
430     }
431 
432     function setWallet(address _wallet) onlyOwner public {
433         require(_wallet != address(0));
434         wallet = _wallet;
435     }
436 
437     /**
438      * End crowdsale manually
439      */
440 
441     function endSale() onlyOwner public {
442       // close crowdsale
443       crowdsaleConcluded = true;
444     }
445 
446     function resumeSale() onlyOwner public {
447       // close crowdsale
448       crowdsaleConcluded = false;
449     }
450 
451     /**
452      * When at risk, evacuate tokens
453      */
454 
455     function evacuateTokens(uint256 _amount) external onlyOwner {
456         owner.transfer(_amount);
457     }
458 
459     function manualTransfer(ERC20 _tokenInstance, uint256 _tokens, address beneficiary) external onlyOwner returns (bool success) {
460         tokensSold = tokensSold.add(_tokens);
461         _tokenInstance.transfer(beneficiary, _tokens);
462         return true;
463     }
464 
465     /**
466      * Calculations
467      */
468 
469     // @return true if crowdsale event has ended
470     function hasEnded() public view returns (bool) {
471         return now > endTime || this.balanceOf(this) == 0 || crowdsaleConcluded;
472     }
473 
474     function getBaseAmount(uint256 _weiAmount) public view returns (uint256) {
475         uint256 currentRate = getCurrentRate();
476         return _weiAmount.mul(currentRate);
477     }
478 
479     function getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
480         uint256 tokens = getBaseAmount(_weiAmount);
481         uint256 percentage = getCurrentBonus();
482         if (percentage > 0) {
483             tokens = tokens.add(tokens.mul(percentage).div(100));
484         }
485 
486         assert(tokens > 0);
487         return (tokens);
488     }
489 
490     // send ether to the fund collection wallet
491     function forwardFunds(uint256 _amount) external onlyOwner {
492         wallet.transfer(_amount);
493     }
494 
495     // @return true if the transaction can buy tokens
496     function validPurchase() internal view returns (bool) {
497         bool withinPeriod = now >= startTime && now <= endTime;
498         bool nonZeroPurchase = msg.value != 0;
499         return withinPeriod && nonZeroPurchase;
500     }
501 
502     function minimumInvest(uint256 _weiAmount) internal view returns (bool) {
503         uint256 currentMinimum = getCurrentMinimum();
504         if(_weiAmount >= currentMinimum) return true;
505         return false;
506     }
507 
508     function getCurrentMinimum() public view returns (uint256) {
509         if(now >= startTime && now <= switchTime) return minimumInvestPreSale;
510         if(now >= switchTime && now <= endTime) return minimumInvestCrowdSale;        
511         return 0;        
512     }
513 
514     function getCurrentRate() public view returns (uint256) {
515         if(now >= startTime && now <= switchTime) return preSaleRate;
516         if(now >= switchTime && now <= endTime) return crowdSaleRate;        
517         return 0;
518     }
519 
520     function getCurrentBonus() public view returns (uint256) {
521         if(now >= startTime && now <= switchTime) return preSaleBonus;
522         if(now >= switchTime && now <= endTime) return crowdSaleBonus;        
523         return 0;
524     }
525 
526     function tokensLeft() public view returns (uint256) {
527         if(now >= startTime && now <= switchTime) return this.balanceOf(this).sub(crowdSaleLimit);
528         if(now >= switchTime && now <= endTime) return this.balanceOf(this);
529         return 0;
530     }
531 
532     function hasEnoughTokensLeft(uint256 _weiAmount) public payable returns (bool) {
533         return tokensLeft().sub(_weiAmount) >= getBaseAmount(_weiAmount);
534     }
535 }