1 pragma solidity ^0.4.23;
2 
3 
4 contract ERC20Basic {
5     function totalSupply() public view returns (uint256);
6     function balanceOf(address who) public view returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12     function allowance(address owner, address spender)
13         public view returns (uint256);
14 
15     function transferFrom(address from, address to, uint256 value)
16         public returns (bool);
17 
18     function approve(address spender, uint256 value) public returns (bool);
19     event Approval(
20     address indexed owner,
21     address indexed spender,
22     uint256 value
23     );
24 }
25 
26 
27 library SafeMath {
28 
29     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         if (a == 0) {
31             return 0;
32         }
33         c = a * b;
34         assert(c / a == b);
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return a / b;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 
55 contract BasicToken is ERC20Basic {
56     using SafeMath for uint256;
57 
58     mapping(address => uint256) balances;
59 
60     uint256 totalSupply_;
61 
62     function totalSupply() public view returns (uint256) {
63         return totalSupply_;
64     }
65 
66     function transfer(address _to, uint256 _value) public returns (bool) {
67         require(_to != address(0));
68         require(_value <= balances[msg.sender]);
69 
70         balances[msg.sender] = balances[msg.sender].sub(_value);
71         balances[_to] = balances[_to].add(_value);
72         emit Transfer(msg.sender, _to, _value);
73         return true;
74     }
75   
76     function balanceOf(address _owner) public view returns (uint256) {
77         return balances[_owner];
78     }
79 
80 }
81 
82 
83 
84 contract DefaultToken is BasicToken {
85 
86   string public name;
87   string public symbol;
88   uint8 public decimals;
89 
90   constructor(string _name, string _symbol, uint8 _decimals) public {
91     name = _name;
92     symbol = _symbol;
93     decimals = _decimals;
94   }
95 }
96 
97 
98 
99 // Wings Controller Interface
100 contract IWingsController {
101   uint256 public ethRewardPart;
102   uint256 public tokenRewardPart;
103 
104   function fitCollectedValueIntoRange(uint256 _totalCollected) public view returns (uint256);
105 }
106 
107 
108 contract HasManager {
109   address public manager;
110 
111   modifier onlyManager {
112     require(msg.sender == manager);
113     _;
114   }
115 
116   function transferManager(address _newManager) public onlyManager() {
117     require(_newManager != address(0));
118     manager = _newManager;
119   }
120 }
121 
122 contract Ownable {
123   address public owner;
124 
125 
126   event OwnershipRenounced(address indexed previousOwner);
127   event OwnershipTransferred(
128     address indexed previousOwner,
129     address indexed newOwner
130   );
131 
132 
133   /**
134    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
135    * account.
136    */
137   constructor() public {
138     owner = msg.sender;
139   }
140 
141   /**
142    * @dev Throws if called by any account other than the owner.
143    */
144   modifier onlyOwner() {
145     require(msg.sender == owner);
146     _;
147   }
148 
149   /**
150    * @dev Allows the current owner to relinquish control of the contract.
151    * @notice Renouncing to ownership will leave the contract without an owner.
152    * It will not be possible to call the functions with the `onlyOwner`
153    * modifier anymore.
154    */
155   function renounceOwnership() public onlyOwner {
156     emit OwnershipRenounced(owner);
157     owner = address(0);
158   }
159 
160   /**
161    * @dev Allows the current owner to transfer control of the contract to a newOwner.
162    * @param _newOwner The address to transfer ownership to.
163    */
164   function transferOwnership(address _newOwner) public onlyOwner {
165     _transferOwnership(_newOwner);
166   }
167 
168   /**
169    * @dev Transfers control of the contract to a newOwner.
170    * @param _newOwner The address to transfer ownership to.
171    */
172   function _transferOwnership(address _newOwner) internal {
173     require(_newOwner != address(0));
174     emit OwnershipTransferred(owner, _newOwner);
175     owner = _newOwner;
176   }
177 }
178 
179 
180 // Crowdsale contracts interface
181 contract ICrowdsaleProcessor is Ownable, HasManager {
182   modifier whenCrowdsaleAlive() {
183     require(isActive());
184     _;
185   }
186 
187   modifier whenCrowdsaleFailed() {
188     require(isFailed());
189     _;
190   }
191 
192   modifier whenCrowdsaleSuccessful() {
193     require(isSuccessful());
194     _;
195   }
196 
197   modifier hasntStopped() {
198     require(!stopped);
199     _;
200   }
201 
202   modifier hasBeenStopped() {
203     require(stopped);
204     _;
205   }
206 
207   modifier hasntStarted() {
208     require(!started);
209     _;
210   }
211 
212   modifier hasBeenStarted() {
213     require(started);
214     _;
215   }
216 
217   // Minimal acceptable hard cap
218   uint256 constant public MIN_HARD_CAP = 1 ether;
219 
220   // Minimal acceptable duration of crowdsale
221   uint256 constant public MIN_CROWDSALE_TIME = 3 days;
222 
223   // Maximal acceptable duration of crowdsale
224   uint256 constant public MAX_CROWDSALE_TIME = 50 days;
225 
226   // Becomes true when timeframe is assigned
227   bool public started;
228 
229   // Becomes true if cancelled by owner
230   bool public stopped;
231 
232   // Total collected forecast question currency
233   uint256 public totalCollected;
234 
235   // Total collected Ether
236   uint256 public totalCollectedETH;
237 
238   // Total amount of project's token sold: must be updated every time tokens has been sold
239   uint256 public totalSold;
240 
241   // Crowdsale minimal goal, must be greater or equal to Forecasting min amount
242   uint256 public minimalGoal;
243 
244   // Crowdsale hard cap, must be less or equal to Forecasting max amount
245   uint256 public hardCap;
246 
247   // Crowdsale duration in seconds.
248   // Accepted range is MIN_CROWDSALE_TIME..MAX_CROWDSALE_TIME.
249   uint256 public duration;
250 
251   // Start timestamp of crowdsale, absolute UTC time
252   uint256 public startTimestamp;
253 
254   // End timestamp of crowdsale, absolute UTC time
255   uint256 public endTimestamp;
256 
257   // Allows to transfer some ETH into the contract without selling tokens
258   function deposit() public payable {}
259 
260   // Returns address of crowdsale token, must be ERC20 compilant
261   function getToken() public returns(address);
262 
263   // Transfers ETH rewards amount (if ETH rewards is configured) to Forecasting contract
264   function mintETHRewards(address _contract, uint256 _amount) public onlyManager();
265 
266   // Mints token Rewards to Forecasting contract
267   function mintTokenRewards(address _contract, uint256 _amount) public onlyManager();
268 
269   // Releases tokens (transfers crowdsale token from mintable to transferrable state)
270   function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful();
271 
272   // Stops crowdsale. Called by CrowdsaleController, the latter is called by owner.
273   // Crowdsale may be stopped any time before it finishes.
274   function stop() public onlyManager() hasntStopped();
275 
276   // Validates parameters and starts crowdsale
277   function start(uint256 _startTimestamp, uint256 _endTimestamp, address _fundingAddress)
278     public onlyManager() hasntStarted() hasntStopped();
279 
280   // Is crowdsale failed (completed, but minimal goal wasn't reached)
281   function isFailed() public constant returns (bool);
282 
283   // Is crowdsale active (i.e. the token can be sold)
284   function isActive() public constant returns (bool);
285 
286   // Is crowdsale completed successfully
287   function isSuccessful() public constant returns (bool);
288 }
289 
290 
291 // Basic crowdsale implementation both for regualt and 3rdparty Crowdsale contracts
292 contract BasicCrowdsale is ICrowdsaleProcessor {
293   event CROWDSALE_START(uint256 startTimestamp, uint256 endTimestamp, address fundingAddress);
294 
295   // Where to transfer collected ETH
296   address public fundingAddress;
297 
298   // Ctor.
299   function BasicCrowdsale(
300     address _owner,
301     address _manager
302   )
303     public
304   {
305     owner = _owner;
306     manager = _manager;
307   }
308 
309   // called by CrowdsaleController to transfer reward part of ETH
310   // collected by successful crowdsale to Forecasting contract.
311   // This call is made upon closing successful crowdfunding process
312   // iff agreed ETH reward part is not zero
313   function mintETHRewards(
314     address _contract,  // Forecasting contract
315     uint256 _amount     // agreed part of totalCollected which is intended for rewards
316   )
317     public
318     onlyManager() // manager is CrowdsaleController instance
319   {
320     require(_contract.call.value(_amount)());
321   }
322 
323   // cancels crowdsale
324   function stop() public onlyManager() hasntStopped()  {
325     // we can stop only not started and not completed crowdsale
326     if (started) {
327       require(!isFailed());
328       require(!isSuccessful());
329     }
330     stopped = true;
331   }
332 
333   // called by CrowdsaleController to setup start and end time of crowdfunding process
334   // as well as funding address (where to transfer ETH upon successful crowdsale)
335   function start(
336     uint256 _startTimestamp,
337     uint256 _endTimestamp,
338     address _fundingAddress
339   )
340     public
341     onlyManager()   // manager is CrowdsaleController instance
342     hasntStarted()  // not yet started
343     hasntStopped()  // crowdsale wasn't cancelled
344   {
345     require(_fundingAddress != address(0));
346 
347     // start time must not be earlier than current time
348     require(_startTimestamp >= block.timestamp);
349 
350     // range must be sane
351     require(_endTimestamp > _startTimestamp);
352     duration = _endTimestamp - _startTimestamp;
353 
354     // duration must fit constraints
355     require(duration >= MIN_CROWDSALE_TIME && duration <= MAX_CROWDSALE_TIME);
356 
357     startTimestamp = _startTimestamp;
358     endTimestamp = _endTimestamp;
359     fundingAddress = _fundingAddress;
360 
361     // now crowdsale is considered started, even if the current time is before startTimestamp
362     started = true;
363 
364     CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);
365   }
366 
367   // must return true if crowdsale is over, but it failed
368   function isFailed()
369     public
370     constant
371     returns(bool)
372   {
373     return (
374       // it was started
375       started &&
376 
377       // crowdsale period has finished
378       block.timestamp >= endTimestamp &&
379 
380       // but collected ETH is below the required minimum
381       totalCollected < minimalGoal
382     );
383   }
384 
385   // must return true if crowdsale is active (i.e. the token can be bought)
386   function isActive()
387     public
388     constant
389     returns(bool)
390   {
391     return (
392       // it was started
393       started &&
394 
395       // hard cap wasn't reached yet
396       totalCollected < hardCap &&
397 
398       // and current time is within the crowdfunding period
399       block.timestamp >= startTimestamp &&
400       block.timestamp < endTimestamp
401     );
402   }
403 
404   // must return true if crowdsale completed successfully
405   function isSuccessful()
406     public
407     constant
408     returns(bool)
409   {
410     return (
411       // either the hard cap is collected
412       totalCollected >= hardCap ||
413 
414       // ...or the crowdfunding period is over, but the minimum has been reached
415       (block.timestamp >= endTimestamp && totalCollected >= minimalGoal)
416     );
417   }
418 }
419 
420 
421 /*
422   Standalone Bridge
423 */
424 contract Bridge is BasicCrowdsale {
425 
426   using SafeMath for uint256;
427 
428   event CUSTOM_CROWDSALE_TOKEN_ADDED(address token, uint8 decimals);
429   event CUSTOM_CROWDSALE_FINISH();
430 
431   // Crowdsale token must be ERC20-compliant
432   DefaultToken token;
433 
434   // Crowdsale state
435   bool completed;
436 
437   // Constructor
438   constructor(
439     //uint256 _minimalGoal,
440     //uint256 _hardCap,
441     //address _token
442   ) public
443     BasicCrowdsale(msg.sender, msg.sender) // owner, manager
444   {
445     minimalGoal = 1;
446     hardCap = 1;
447     token = DefaultToken(0x9998Db897783603c9344ED2678AB1B5D73d0f7C3);
448   }
449 
450   /*
451      Here goes ICrowdsaleProcessor methods implementation
452   */
453 
454   // Returns address of crowdsale token
455   function getToken()
456     public
457     returns (address)
458   {
459     return address(token);
460   }
461 
462   // Mints token Rewards to Forecasting contract
463   // called by CrowdsaleController
464   function mintTokenRewards(
465     address _contract,
466     uint256 _amount    // agreed part of totalSold which is intended for rewards
467   )
468     public
469     onlyManager()
470   {
471     // in our example we are transferring tokens instead of minting them
472     token.transfer(_contract, _amount);
473   }
474 
475   function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful() {
476   }
477 
478   /*
479      Crowdsale methods implementation
480   */
481 
482   // Fallback payable function
483   function() public payable {
484   }
485 
486   // Update information about collected ETH and sold tokens amount
487   function notifySale(uint256 _amount, uint256 _ethAmount, uint256 _tokensAmount)
488     public
489     hasBeenStarted()
490     hasntStopped()
491     whenCrowdsaleAlive()
492     onlyOwner()
493   {
494     totalCollected = totalCollected.add(_amount);
495     totalCollectedETH = totalCollectedETH.add(_ethAmount);
496     totalSold = totalSold.add(_tokensAmount);
497   }
498 
499   // Validates parameters and starts crowdsale
500   // called by CrowdsaleController
501   function start(
502     uint256 _startTimestamp,
503     uint256 _endTimestamp,
504     address _fundingAddress
505   )
506     public
507     hasntStarted()
508     hasntStopped()
509     onlyManager()
510   {
511     started = true;
512 
513     emit CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);
514   }
515 
516   // Finish crowdsale
517   function finish()
518     public
519     hasntStopped()
520     hasBeenStarted()
521     whenCrowdsaleAlive()
522     onlyOwner()
523   {
524     completed = true;
525 
526     emit CUSTOM_CROWDSALE_FINISH();
527   }
528 
529   function isFailed()
530     public
531     view
532     returns (bool)
533   {
534     return (false);
535   }
536 
537   function isActive()
538     public
539     view
540     returns (bool)
541   {
542     return (started && !completed);
543   }
544 
545   function isSuccessful()
546     public
547     view
548     returns (bool)
549   {
550     return (completed);
551   }
552 
553   // Find out the amount of rewards in ETH and tokens
554   function calculateRewards() public view returns (uint256, uint256) {
555     uint256 tokenRewardPart = IWingsController(manager).tokenRewardPart();
556     uint256 ethRewardPart = IWingsController(manager).ethRewardPart();
557     uint256 ethReward;
558     bool hasEthReward = (ethRewardPart != 0);
559 
560     uint256 tokenReward = totalSold.mul(tokenRewardPart) / 1000000;
561 
562     if (totalCollectedETH != 0) {
563       totalCollected = totalCollectedETH;
564     }
565 
566     totalCollected = IWingsController(manager).fitCollectedValueIntoRange(totalCollected);
567 
568     if (hasEthReward) {
569       ethReward = totalCollected.mul(ethRewardPart) / 1000000;
570     }
571 
572     return (ethReward, tokenReward);
573   }
574 
575   // Change token address (in case you've used the dafault token address during bridge deployment)
576   function changeToken(address _newToken) public onlyOwner() {
577     token = DefaultToken(_newToken);
578 
579     emit CUSTOM_CROWDSALE_TOKEN_ADDED(address(token), uint8(token.decimals()));
580   }
581 
582   // Gives owner ability to withdraw eth and wings from Bridge contract balance in case if some error during reward calculation occured
583   function withdraw() public onlyOwner() {
584     uint256 ethBalance = address(this).balance;
585     uint256 tokenBalance = token.balanceOf(address(this));
586 
587     if (ethBalance > 0) {
588       require(msg.sender.send(ethBalance));
589     }
590 
591     if (tokenBalance > 0) {
592       require(token.transfer(msg.sender, tokenBalance));
593     }
594   }
595 }