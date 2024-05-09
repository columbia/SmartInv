1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner public {
34     require(newOwner != address(0));
35     OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 }
39 
40 /**
41  * @title Pausable
42  * @dev Base contract which allows children to implement an emergency stop mechanism.
43  */
44 contract Pausable is Ownable {
45   event Pause();
46   event Unpause();
47 
48   bool public paused = false;
49 
50 
51   /**
52    * @dev Modifier to make a function callable only when the contract is not paused.
53    */
54   modifier whenNotPaused() {
55     require(!paused);
56     _;
57   }
58 
59   /**
60    * @dev Modifier to make a function callable only when the contract is paused.
61    */
62   modifier whenPaused() {
63     require(paused);
64     _;
65   }
66 
67   /**
68    * @dev called by the owner to pause, triggers stopped state
69    */
70   function pause() onlyOwner whenNotPaused public {
71     paused = true;
72     Pause();
73   }
74 
75   /**
76    * @dev called by the owner to unpause, returns to normal state
77    */
78   function unpause() onlyOwner whenPaused public {
79     paused = false;
80     Unpause();
81   }
82 }
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that throw on error
87  */
88 library SafeMath {
89   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
90     uint256 c = a * b;
91     assert(a == 0 || c / a == b);
92     return c;
93   }
94 
95   function div(uint256 a, uint256 b) internal constant returns (uint256) {
96     // assert(b > 0); // Solidity automatically throws when dividing by 0
97     uint256 c = a / b;
98     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99     return c;
100   }
101 
102   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   function add(uint256 a, uint256 b) internal constant returns (uint256) {
108     uint256 c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 contract Finalizable is Ownable {
115   bool public contractFinalized;
116 
117   modifier notFinalized() {
118     require(!contractFinalized);
119     _;
120   }
121 
122   function finalizeContract() onlyOwner {
123     contractFinalized = true;
124   }
125 }
126 
127 contract Shared is Ownable, Finalizable {
128   uint internal constant DECIMALS = 8;
129   
130   address internal constant REWARDS_WALLET = 0x30b002d3AfCb7F9382394f7c803faFBb500872D8;
131   address internal constant FRIENDS_FAMILY_WALLET = 0xd328eF879f78cDa773a3dFc79B4e590f20C22223;
132   address internal constant CROWDSALE_WALLET = 0x028e1Ce69E379b1678278640c7387ecc40DAa895;
133   address internal constant LIFE_CHANGE_WALLET = 0xEe4284f98D0568c7f65688f18A2F74354E17B31a;
134   address internal constant LIFE_CHANGE_VESTING_WALLET = 0x2D354bD67707223C9aC0232cd0E54f22b03483Cf;
135 }
136 
137 contract Controller is Shared, Pausable {
138   using SafeMath for uint;
139 
140   bool public initialized;
141 
142   ChristCoin public token;
143   Ledger public ledger;
144   address public crowdsale;
145 
146   uint public vestingAmount;
147   uint public vestingPaid;
148   uint public vestingStart;
149   uint public vestingDuration;
150 
151   function Controller(address _token, address _ledger, address _crowdsale) {
152     token = ChristCoin(_token);
153     ledger = Ledger(_ledger);
154     crowdsale = _crowdsale;
155   }
156 
157   function setToken(address _address) onlyOwner notFinalized {
158     token = ChristCoin(_address);
159   }
160 
161   function setLedger(address _address) onlyOwner notFinalized {
162     ledger = Ledger(_address);
163   }
164 
165   function setCrowdsale(address _address) onlyOwner notFinalized {
166     crowdsale = _address;
167   }
168 
169   modifier onlyToken() {
170     require(msg.sender == address(token));
171     _;
172   }
173 
174   modifier onlyCrowdsale() {
175     require(msg.sender == crowdsale);
176     _;
177   }
178 
179   modifier onlyTokenOrCrowdsale() {
180     require(msg.sender == address(token) || msg.sender == crowdsale);
181     _;
182   }
183 
184   modifier notVesting() {
185     require(msg.sender != LIFE_CHANGE_VESTING_WALLET);
186     _;
187   }
188 
189   function init() onlyOwner {
190     require(!initialized);
191     mintWithEvent(REWARDS_WALLET, 9 * (10 ** (9 + DECIMALS))); // 9 billion
192     mintWithEvent(FRIENDS_FAMILY_WALLET, 75 * (10 ** (6 + DECIMALS))); // 75 million
193     mintWithEvent(CROWDSALE_WALLET, 825 * (10 ** (6 + DECIMALS))); // 825 million
194     mintWithEvent(LIFE_CHANGE_WALLET, 100 * (10 ** (6 + DECIMALS))); // 100 million
195     initialized = true;
196   }
197 
198   function totalSupply() onlyToken constant returns (uint) {
199     return ledger.totalSupply();
200   }
201 
202   function balanceOf(address _owner) onlyTokenOrCrowdsale constant returns (uint) {
203     return ledger.balanceOf(_owner);
204   }
205 
206   function allowance(address _owner, address _spender) onlyToken constant returns (uint) {
207     return ledger.allowance(_owner, _spender);
208   }
209 
210   function transfer(address _from, address _to, uint _value) onlyToken notVesting whenNotPaused returns (bool success) {
211     return ledger.transfer(_from, _to, _value);
212   }
213 
214   function transferWithEvent(address _from, address _to, uint _value) onlyCrowdsale returns (bool success) {
215     success = ledger.transfer(_from, _to, _value);
216     if (success) {
217       token.controllerTransfer(msg.sender, _to, _value);
218     }
219   }
220 
221   function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken notVesting whenNotPaused returns (bool success) {
222     return ledger.transferFrom(_spender, _from, _to, _value);
223   }
224 
225   function approve(address _owner, address _spender, uint _value) onlyToken notVesting whenNotPaused returns (bool success) {
226     return ledger.approve(_owner, _spender, _value);
227   }
228 
229   function burn(address _owner, uint _amount) onlyToken whenNotPaused returns (bool success) {
230     return ledger.burn(_owner, _amount);
231   }
232 
233   function mintWithEvent(address _to, uint _amount) internal returns (bool success) {
234     success = ledger.mint(_to, _amount);
235     if (success) {
236       token.controllerTransfer(0x0, _to, _amount);
237     }
238   }
239 
240   function startVesting(uint _amount, uint _duration) onlyCrowdsale {
241     require(vestingAmount == 0);
242     vestingAmount = _amount;
243     vestingPaid = 0;
244     vestingStart = now;
245     vestingDuration = _duration;
246   }
247 
248   function withdrawVested(address _withdrawTo) returns (uint amountWithdrawn) {
249     require(msg.sender == LIFE_CHANGE_VESTING_WALLET);
250     require(vestingAmount > 0);
251     
252     uint _elapsed = now.sub(vestingStart);
253     uint _rate = vestingAmount.div(vestingDuration);
254     uint _unlocked = _rate.mul(_elapsed);
255 
256     if (_unlocked > vestingAmount) {
257        _unlocked = vestingAmount;
258     }
259 
260     if (_unlocked <= vestingPaid) {
261       amountWithdrawn = 0;
262       return;
263     }
264 
265     amountWithdrawn = _unlocked.sub(vestingPaid);
266     vestingPaid = vestingPaid.add(amountWithdrawn);
267 
268     ledger.transfer(LIFE_CHANGE_VESTING_WALLET, _withdrawTo, amountWithdrawn);
269     token.controllerTransfer(LIFE_CHANGE_VESTING_WALLET, _withdrawTo, amountWithdrawn);
270   }
271 }
272 
273 contract Ledger is Shared {
274   using SafeMath for uint;
275 
276   address public controller;
277   mapping(address => uint) public balanceOf;
278   mapping (address => mapping (address => uint)) public allowed;
279   uint public totalSupply;
280 
281   function setController(address _address) onlyOwner notFinalized {
282     controller = _address;
283   }
284 
285   modifier onlyController() {
286     require(msg.sender == controller);
287     _;
288   }
289 
290   function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
291     balanceOf[_from] = balanceOf[_from].sub(_value);
292     balanceOf[_to] = balanceOf[_to].add(_value);
293     return true;
294   }
295 
296   function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
297     var _allowance = allowed[_from][_spender];
298     balanceOf[_to] = balanceOf[_to].add(_value);
299     balanceOf[_from] = balanceOf[_from].sub(_value);
300     allowed[_from][_spender] = _allowance.sub(_value);
301     return true;
302   }
303 
304   function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
305     require((_value == 0) || (allowed[_owner][_spender] == 0));
306     allowed[_owner][_spender] = _value;
307     return true;
308   }
309 
310   function allowance(address _owner, address _spender) onlyController constant returns (uint remaining) {
311     return allowed[_owner][_spender];
312   }
313 
314   function burn(address _from, uint _amount) onlyController returns (bool success) {
315     balanceOf[_from] = balanceOf[_from].sub(_amount);
316     totalSupply = totalSupply.sub(_amount);
317     return true;
318   }
319 
320   function mint(address _to, uint _amount) onlyController returns (bool success) {
321     balanceOf[_to] += _amount;
322     totalSupply += _amount;
323     return true;
324   }
325 }
326 
327 contract ChristCoin is Shared {
328   using SafeMath for uint;
329 
330   string public name = "Christ Coin";
331   string public symbol = "CCLC";
332   uint8 public decimals = 8;
333 
334   Controller public controller;
335 
336   event Transfer(address indexed _from, address indexed _to, uint _value);
337   event Approval(address indexed _owner, address indexed _spender, uint _value);
338 
339   function setController(address _address) onlyOwner notFinalized {
340     controller = Controller(_address);
341   }
342 
343   modifier onlyController() {
344     require(msg.sender == address(controller));
345     _;
346   }
347 
348   function balanceOf(address _owner) constant returns (uint) {
349     return controller.balanceOf(_owner);
350   }
351 
352   function totalSupply() constant returns (uint) {
353     return controller.totalSupply();
354   }
355 
356   function transfer(address _to, uint _value) returns (bool success) {
357     success = controller.transfer(msg.sender, _to, _value);
358     if (success) {
359       Transfer(msg.sender, _to, _value);
360     }
361   }
362 
363   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
364     success = controller.transferFrom(msg.sender, _from, _to, _value);
365     if (success) {
366       Transfer(_from, _to, _value);
367     }
368   }
369 
370   function approve(address _spender, uint _value) returns (bool success) {
371     success = controller.approve(msg.sender, _spender, _value);
372     if (success) {
373       Approval(msg.sender, _spender, _value);
374     }
375   }
376 
377   function allowance(address _owner, address _spender) constant returns (uint) {
378     return controller.allowance(_owner, _spender);
379   }
380 
381   function burn(uint _amount) onlyOwner returns (bool success) {
382     success = controller.burn(msg.sender, _amount);
383     if (success) {
384       Transfer(msg.sender, 0x0, _amount);
385     }
386   }
387 
388   function controllerTransfer(address _from, address _to, uint _value) onlyController {
389     Transfer(_from, _to, _value);
390   }
391 
392   function controllerApproval(address _from, address _spender, uint _value) onlyController {
393     Approval(_from, _spender, _value);
394   }
395 }
396 
397 contract Crowdsale is Shared, Pausable {
398   using SafeMath for uint;
399 
400   uint public constant START = 1506945600;                          // October 2, 2017 7:00:00 AM CST
401   uint public constant END = 1512133200;                            // December 1, 2017 7:00:00 AM CST
402   uint public constant CAP = 375 * (10 ** (6 + DECIMALS));          // 375 million tokens
403   
404   uint public weiRaised;
405   uint public tokensDistributed;
406   uint public bonusTokensDistributed;
407   bool public crowdsaleFinalized;
408 
409   Controller public controller;
410   Round[] public rounds;
411   Round public currentRound;
412 
413   struct Round {
414     uint index;
415     uint endAmount;
416     uint rate;
417     uint incentiveDivisor;
418   }
419 
420   struct Purchase {
421     uint tokens;
422     uint bonus;
423   }
424 
425   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
426 
427   function Crowdsale() {
428     require(END >= START);
429 
430     rounds.push(Round(0, 75 * (10 ** (6 + DECIMALS)), 106382978723404, 10));
431     rounds.push(Round(1, 175 * (10 ** (6 + DECIMALS)), 212765957446808, 0));
432     rounds.push(Round(2, 375 * (10 ** (6 + DECIMALS)), 319148936170213, 0));
433     currentRound = rounds[0];
434   }
435 
436   function setController(address _address) onlyOwner {
437     controller = Controller(_address);
438   }
439 
440   function () payable whenNotPaused {
441     buyTokens(msg.sender);
442   }
443 
444   function buyTokens(address _beneficiary) payable whenNotPaused {
445     require(_beneficiary != 0x0);
446     require(validPurchase());
447 
448     processPurchase(msg.sender, _beneficiary, msg.value);
449     LIFE_CHANGE_WALLET.transfer(msg.value);  
450   }
451 
452   function processPurchase(address _from, address _beneficiary, uint _weiAmount) internal returns (Purchase purchase) {
453     purchase = getPurchase(_weiAmount, tokensDistributed);
454     require(tokensDistributed.add(purchase.tokens) <= CAP);
455     uint _tokensWithBonus = purchase.tokens.add(purchase.bonus);
456     bonusTokensDistributed = bonusTokensDistributed.add(purchase.bonus);
457     tokensDistributed = tokensDistributed.add(purchase.tokens);
458     weiRaised = weiRaised.add(_weiAmount);
459     controller.transferWithEvent(CROWDSALE_WALLET, _beneficiary, _tokensWithBonus);
460     TokenPurchase(_from, _beneficiary, _weiAmount, _tokensWithBonus);
461   }
462 
463   function getPurchase(uint _weiAmount, uint _tokensDistributed) internal returns (Purchase purchase) {
464     uint _roundTokensRemaining = currentRound.endAmount.sub(_tokensDistributed);
465     uint _roundWeiRemaining = _roundTokensRemaining.mul(currentRound.rate).div(10 ** DECIMALS);
466     uint _tokens = _weiAmount.div(currentRound.rate).mul(10 ** DECIMALS);
467     uint _incentiveDivisor = currentRound.incentiveDivisor;
468     
469     if (_tokens <= _roundTokensRemaining) {
470       purchase.tokens = _tokens;
471 
472       if (_incentiveDivisor > 0) {
473         purchase.bonus = _tokens.div(_incentiveDivisor);
474       }
475     } else {
476       currentRound = rounds[currentRound.index + 1];
477 
478       uint _roundBonus = 0;
479       if (_incentiveDivisor > 0) {
480         _roundBonus = _roundTokensRemaining.div(_incentiveDivisor);
481       }
482       
483       purchase = getPurchase(_weiAmount.sub(_roundWeiRemaining), _tokensDistributed.add(_roundTokensRemaining));
484       purchase.tokens = purchase.tokens.add(_roundTokensRemaining);
485       purchase.bonus = purchase.bonus.add(_roundBonus);
486     }
487   }
488 
489   function validPurchase() internal constant returns (bool) {
490     bool notAtCap = tokensDistributed < CAP;
491     bool nonZeroPurchase = msg.value != 0;
492     bool withinPeriod = now >= START && now <= END;
493 
494     return notAtCap && nonZeroPurchase && withinPeriod;
495   }
496 
497   function hasEnded() constant returns (bool) {
498     return crowdsaleFinalized || tokensDistributed == CAP || now > END;
499   }
500 
501   function finalizeCrowdsale() onlyOwner {
502     require(!crowdsaleFinalized);
503     require(hasEnded());
504     
505     uint _toVest = controller.balanceOf(CROWDSALE_WALLET);
506     if (tokensDistributed == CAP) {
507       _toVest = _toVest.sub(CAP.div(4)); // 25% bonus to token holders if sold out
508     }
509 
510     controller.transferWithEvent(CROWDSALE_WALLET, LIFE_CHANGE_VESTING_WALLET, _toVest);
511     controller.startVesting(_toVest, 7 years);
512 
513     crowdsaleFinalized = true;
514   }
515 }