1 pragma solidity 0.4.15;
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
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
59     require(_startTime >= now);
60     require(_endTime >= _startTime);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startTime = _startTime;
66     endTime = _endTime;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold.
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) public payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     bool withinPeriod = now >= startTime && now <= endTime;
111     bool nonZeroPurchase = msg.value != 0;
112     return withinPeriod && nonZeroPurchase;
113   }
114 
115   // @return true if crowdsale event has ended
116   function hasEnded() public constant returns (bool) {
117     return now > endTime;
118   }
119 
120 
121 }
122 
123 contract Ownable {
124   address public owner;
125 
126 
127   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   function Ownable() {
135     owner = msg.sender;
136   }
137 
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147 
148   /**
149    * @dev Allows the current owner to transfer control of the contract to a newOwner.
150    * @param newOwner The address to transfer ownership to.
151    */
152   function transferOwnership(address newOwner) onlyOwner public {
153     require(newOwner != address(0));
154     OwnershipTransferred(owner, newOwner);
155     owner = newOwner;
156   }
157 
158 }
159 
160 contract BlockbidCrowdsale is Crowdsale, Ownable {
161 
162   uint public goal;
163   uint public cap;
164   uint public earlybonus;
165   uint public standardrate;
166   bool public goalReached = false;
167   bool public paused = false;
168   uint public constant weeklength = 604800;
169 
170   mapping(address => uint) public weiContributed;
171   address[] public contributors;
172 
173   event LogClaimRefund(address _address, uint _value);
174 
175   modifier notPaused() {
176     if (paused) {
177       revert();
178     }
179     _;
180   }
181 
182   function BlockbidCrowdsale(uint _goal, uint _cap, uint _startTime, uint _endTime, uint _rate, uint _earlyBonus, address _wallet)
183   Crowdsale(_startTime, _endTime, _rate, _wallet) public {
184     require(_cap > 0);
185     require(_goal > 0);
186 
187     standardrate = _rate;
188     earlybonus = _earlyBonus;
189     cap = _cap;
190     goal = _goal;
191   }
192 
193   // @return true if the transaction can buy tokens
194   /*
195   Added: - Must be under Cap
196          - Requires user to send atleast 1 token's worth of ether
197          - Needs to call updateRate() function to validate how much ether = 1 token
198          -
199   */
200   function validPurchase() internal constant returns (bool) {
201 
202     updateRate();
203 
204     bool withinPeriod = (now >= startTime && now <= endTime);
205     bool withinPurchaseLimit = (msg.value >= 0.1 ether && msg.value <= 100 ether);
206     bool withinCap = (token.totalSupply() <= cap);
207     return withinPeriod && withinPurchaseLimit && withinCap;
208   }
209 
210   // function that will determine how many tokens have been created
211   function tokensPurchased() internal constant returns (uint) {
212     return rate.mul(msg.value).mul(100000000).div(1 ether);
213   }
214 
215   /*
216     function will identify what period of crowdsale we are in and update
217     the rate.
218     Rates are lower (e.g. 1:360 instead of 1:300) early on
219     to give early bird discounts
220   */
221   function updateRate() internal returns (bool) {
222 
223     if (now >= startTime.add(weeklength.mul(4))) {
224       rate = 200;
225     }
226     else if (now >= startTime.add(weeklength.mul(3))) {
227       rate = standardrate;
228     }
229     else if (now >= startTime.add(weeklength.mul(2))) {
230       rate = standardrate.add(earlybonus.sub(40));
231     }
232     else if (now >= startTime.add(weeklength)) {
233       rate = standardrate.add(earlybonus.sub(20));
234     }
235     else {
236       rate = standardrate.add(earlybonus);
237     }
238 
239     return true;
240   }
241 
242   function buyTokens(address beneficiary) notPaused public payable {
243     require(beneficiary != 0x0);
244 
245     // enable wallet to deposit funds post ico and goals not reached
246     if (msg.sender == wallet) {
247       require(hasEnded());
248       require(!goalReached);
249     }
250     // everybody else goes through standard validation
251     else {
252       require(validPurchase());
253     }
254 
255     // update state
256     weiRaised = weiRaised.add(msg.value);
257 
258     // if user already a contributor
259     if (weiContributed[beneficiary] > 0) {
260       weiContributed[beneficiary] = weiContributed[beneficiary].add(msg.value);
261     }
262     // new contributor
263     else {
264       weiContributed[beneficiary] = msg.value;
265       contributors.push(beneficiary);
266     }
267 
268     // update tokens for each individual
269     token.mint(beneficiary, tokensPurchased());
270     TokenPurchase(msg.sender, beneficiary, msg.value, tokensPurchased());
271     token.mint(wallet, (tokensPurchased().div(4)));
272 
273     if (token.totalSupply() > goal) {
274       goalReached = true;
275     }
276 
277     // don't forward funds if wallet belongs to owner
278     if (msg.sender != wallet) {
279       forwardFunds();
280     }
281   }
282 
283   function getContributorsCount() public constant returns(uint) {
284     return contributors.length;
285   }
286 
287   // if crowdsale is unsuccessful, investors can claim refunds here
288   function claimRefund() notPaused public returns (bool) {
289     require(!goalReached);
290     require(hasEnded());
291     uint contributedAmt = weiContributed[msg.sender];
292     require(contributedAmt > 0);
293     weiContributed[msg.sender] = 0;
294     msg.sender.transfer(contributedAmt);
295     LogClaimRefund(msg.sender, contributedAmt);
296     return true;
297   }
298 
299   // allow owner to pause ico in case there is something wrong
300   function setPaused(bool _val) onlyOwner public returns (bool) {
301     paused = _val;
302     return true;
303   }
304 
305   // destroy contract and send all remaining ether back to wallet
306   function kill() onlyOwner public {
307     require(!goalReached);
308     require(hasEnded());
309     selfdestruct(wallet);
310   }
311 
312   // create BID token
313   function createTokenContract() internal returns (MintableToken) {
314     return new BlockbidMintableToken();
315   }
316 
317 }
318 
319 contract ERC20Basic {
320   uint256 public totalSupply;
321   function balanceOf(address who) public constant returns (uint256);
322   function transfer(address to, uint256 value) public returns (bool);
323   event Transfer(address indexed from, address indexed to, uint256 value);
324 }
325 
326 contract BasicToken is ERC20Basic {
327   using SafeMath for uint256;
328 
329   mapping(address => uint256) balances;
330 
331   /**
332   * @dev transfer token for a specified address
333   * @param _to The address to transfer to.
334   * @param _value The amount to be transferred.
335   */
336   function transfer(address _to, uint256 _value) public returns (bool) {
337     require(_to != address(0));
338 
339     // SafeMath.sub will throw if there is not enough balance.
340     balances[msg.sender] = balances[msg.sender].sub(_value);
341     balances[_to] = balances[_to].add(_value);
342     Transfer(msg.sender, _to, _value);
343     return true;
344   }
345 
346   /**
347   * @dev Gets the balance of the specified address.
348   * @param _owner The address to query the the balance of.
349   * @return An uint256 representing the amount owned by the passed address.
350   */
351   function balanceOf(address _owner) public constant returns (uint256 balance) {
352     return balances[_owner];
353   }
354 
355 }
356 
357 contract ERC20 is ERC20Basic {
358   function allowance(address owner, address spender) public constant returns (uint256);
359   function transferFrom(address from, address to, uint256 value) public returns (bool);
360   function approve(address spender, uint256 value) public returns (bool);
361   event Approval(address indexed owner, address indexed spender, uint256 value);
362 }
363 
364 contract StandardToken is ERC20, BasicToken {
365 
366   mapping (address => mapping (address => uint256)) allowed;
367 
368 
369   /**
370    * @dev Transfer tokens from one address to another
371    * @param _from address The address which you want to send tokens from
372    * @param _to address The address which you want to transfer to
373    * @param _value uint256 the amount of tokens to be transferred
374    */
375   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
376     require(_to != address(0));
377 
378     uint256 _allowance = allowed[_from][msg.sender];
379 
380     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
381     // require (_value <= _allowance);
382 
383     balances[_from] = balances[_from].sub(_value);
384     balances[_to] = balances[_to].add(_value);
385     allowed[_from][msg.sender] = _allowance.sub(_value);
386     Transfer(_from, _to, _value);
387     return true;
388   }
389 
390   /**
391    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
392    *
393    * Beware that changing an allowance with this method brings the risk that someone may use both the old
394    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
395    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
396    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
397    * @param _spender The address which will spend the funds.
398    * @param _value The amount of tokens to be spent.
399    */
400   function approve(address _spender, uint256 _value) public returns (bool) {
401     allowed[msg.sender][_spender] = _value;
402     Approval(msg.sender, _spender, _value);
403     return true;
404   }
405 
406   /**
407    * @dev Function to check the amount of tokens that an owner allowed to a spender.
408    * @param _owner address The address which owns the funds.
409    * @param _spender address The address which will spend the funds.
410    * @return A uint256 specifying the amount of tokens still available for the spender.
411    */
412   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
413     return allowed[_owner][_spender];
414   }
415 
416   /**
417    * approve should be called when allowed[_spender] == 0. To increment
418    * allowed value is better to use this function to avoid 2 calls (and wait until
419    * the first transaction is mined)
420    * From MonolithDAO Token.sol
421    */
422   function increaseApproval (address _spender, uint _addedValue)
423     returns (bool success) {
424     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
425     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
426     return true;
427   }
428 
429   function decreaseApproval (address _spender, uint _subtractedValue)
430     returns (bool success) {
431     uint oldValue = allowed[msg.sender][_spender];
432     if (_subtractedValue > oldValue) {
433       allowed[msg.sender][_spender] = 0;
434     } else {
435       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
436     }
437     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
438     return true;
439   }
440 
441 }
442 
443 contract MintableToken is StandardToken, Ownable {
444   event Mint(address indexed to, uint256 amount);
445   event MintFinished();
446 
447   bool public mintingFinished = false;
448 
449 
450   modifier canMint() {
451     require(!mintingFinished);
452     _;
453   }
454 
455   /**
456    * @dev Function to mint tokens
457    * @param _to The address that will receive the minted tokens.
458    * @param _amount The amount of tokens to mint.
459    * @return A boolean that indicates if the operation was successful.
460    */
461   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
462     totalSupply = totalSupply.add(_amount);
463     balances[_to] = balances[_to].add(_amount);
464     Mint(_to, _amount);
465     Transfer(0x0, _to, _amount);
466     return true;
467   }
468 
469   /**
470    * @dev Function to stop minting new tokens.
471    * @return True if the operation was successful.
472    */
473   function finishMinting() onlyOwner public returns (bool) {
474     mintingFinished = true;
475     MintFinished();
476     return true;
477   }
478 }
479 
480 contract BlockbidMintableToken is MintableToken {
481 
482   string public constant name = "Blockbid Token";
483   string public constant symbol = "BID";
484   uint8 public constant decimals = 8;
485 
486 }