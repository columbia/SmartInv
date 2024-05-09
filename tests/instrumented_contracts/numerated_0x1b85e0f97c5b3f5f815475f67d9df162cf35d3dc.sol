1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract HasManager {
46   address public manager;
47 
48   modifier onlyManager {
49     require(msg.sender == manager);
50     _;
51   }
52 
53   function transferManager(address _newManager) public onlyManager() {
54     require(_newManager != address(0));
55     manager = _newManager;
56   }
57 }
58 
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 contract IWingsController {
67   uint256 public ethRewardPart;
68   uint256 public tokenRewardPart;
69 }
70 
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner) public onlyOwner {
99     require(newOwner != address(0));
100     OwnershipTransferred(owner, newOwner);
101     owner = newOwner;
102   }
103 
104 }
105 
106 contract ICrowdsaleProcessor is Ownable, HasManager {
107   modifier whenCrowdsaleAlive() {
108     require(isActive());
109     _;
110   }
111 
112   modifier whenCrowdsaleFailed() {
113     require(isFailed());
114     _;
115   }
116 
117   modifier whenCrowdsaleSuccessful() {
118     require(isSuccessful());
119     _;
120   }
121 
122   modifier hasntStopped() {
123     require(!stopped);
124     _;
125   }
126 
127   modifier hasBeenStopped() {
128     require(stopped);
129     _;
130   }
131 
132   modifier hasntStarted() {
133     require(!started);
134     _;
135   }
136 
137   modifier hasBeenStarted() {
138     require(started);
139     _;
140   }
141 
142   // Minimal acceptable hard cap
143   uint256 constant public MIN_HARD_CAP = 1 ether;
144 
145   // Minimal acceptable duration of crowdsale
146   uint256 constant public MIN_CROWDSALE_TIME = 3 days;
147 
148   // Maximal acceptable duration of crowdsale
149   uint256 constant public MAX_CROWDSALE_TIME = 50 days;
150 
151   // Becomes true when timeframe is assigned
152   bool public started;
153 
154   // Becomes true if cancelled by owner
155   bool public stopped;
156 
157   // Total collected Ethereum: must be updated every time tokens has been sold
158   uint256 public totalCollected;
159 
160   // Total amount of project's token sold: must be updated every time tokens has been sold
161   uint256 public totalSold;
162 
163   // Crowdsale minimal goal, must be greater or equal to Forecasting min amount
164   uint256 public minimalGoal;
165 
166   // Crowdsale hard cap, must be less or equal to Forecasting max amount
167   uint256 public hardCap;
168 
169   // Crowdsale duration in seconds.
170   // Accepted range is MIN_CROWDSALE_TIME..MAX_CROWDSALE_TIME.
171   uint256 public duration;
172 
173   // Start timestamp of crowdsale, absolute UTC time
174   uint256 public startTimestamp;
175 
176   // End timestamp of crowdsale, absolute UTC time
177   uint256 public endTimestamp;
178 
179   // Allows to transfer some ETH into the contract without selling tokens
180   function deposit() public payable {}
181 
182   // Returns address of crowdsale token, must be ERC20 compilant
183   function getToken() public returns(address);
184 
185   // Transfers ETH rewards amount (if ETH rewards is configured) to Forecasting contract
186   function mintETHRewards(address _contract, uint256 _amount) public onlyManager();
187 
188   // Mints token Rewards to Forecasting contract
189   function mintTokenRewards(address _contract, uint256 _amount) public onlyManager();
190 
191   // Releases tokens (transfers crowdsale token from mintable to transferrable state)
192   function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful();
193 
194   // Stops crowdsale. Called by CrowdsaleController, the latter is called by owner.
195   // Crowdsale may be stopped any time before it finishes.
196   function stop() public onlyManager() hasntStopped();
197 
198   // Validates parameters and starts crowdsale
199   function start(uint256 _startTimestamp, uint256 _endTimestamp, address _fundingAddress)
200     public onlyManager() hasntStarted() hasntStopped();
201 
202   // Is crowdsale failed (completed, but minimal goal wasn't reached)
203   function isFailed() public constant returns (bool);
204 
205   // Is crowdsale active (i.e. the token can be sold)
206   function isActive() public constant returns (bool);
207 
208   // Is crowdsale completed successfully
209   function isSuccessful() public constant returns (bool);
210 }
211 
212 contract BasicToken is ERC20Basic {
213   using SafeMath for uint256;
214 
215   mapping(address => uint256) balances;
216 
217   uint256 totalSupply_;
218 
219   /**
220   * @dev total number of tokens in existence
221   */
222   function totalSupply() public view returns (uint256) {
223     return totalSupply_;
224   }
225 
226   /**
227   * @dev transfer token for a specified address
228   * @param _to The address to transfer to.
229   * @param _value The amount to be transferred.
230   */
231   function transfer(address _to, uint256 _value) public returns (bool) {
232     require(_to != address(0));
233     require(_value <= balances[msg.sender]);
234 
235     // SafeMath.sub will throw if there is not enough balance.
236     balances[msg.sender] = balances[msg.sender].sub(_value);
237     balances[_to] = balances[_to].add(_value);
238     Transfer(msg.sender, _to, _value);
239     return true;
240   }
241 
242   /**
243   * @dev Gets the balance of the specified address.
244   * @param _owner The address to query the the balance of.
245   * @return An uint256 representing the amount owned by the passed address.
246   */
247   function balanceOf(address _owner) public view returns (uint256 balance) {
248     return balances[_owner];
249   }
250 
251 }
252 
253 contract DefaultToken is BasicToken {
254 
255   string public name;
256   string public symbol;
257   uint8 public decimals;
258 
259   constructor(string _name, string _symbol, uint8 _decimals) {
260     name = _name;
261     symbol = _symbol;
262     decimals = _decimals;
263   }
264 }
265 
266 contract BasicCrowdsale is ICrowdsaleProcessor {
267   event CROWDSALE_START(uint256 startTimestamp, uint256 endTimestamp, address fundingAddress);
268 
269   // Where to transfer collected ETH
270   address public fundingAddress;
271 
272   // Ctor.
273   function BasicCrowdsale(
274     address _owner,
275     address _manager
276   )
277     public
278   {
279     owner = _owner;
280     manager = _manager;
281   }
282 
283   // called by CrowdsaleController to transfer reward part of ETH
284   // collected by successful crowdsale to Forecasting contract.
285   // This call is made upon closing successful crowdfunding process
286   // iff agreed ETH reward part is not zero
287   function mintETHRewards(
288     address _contract,  // Forecasting contract
289     uint256 _amount     // agreed part of totalCollected which is intended for rewards
290   )
291     public
292     onlyManager() // manager is CrowdsaleController instance
293   {
294     require(_contract.call.value(_amount)());
295   }
296 
297   // cancels crowdsale
298   function stop() public onlyManager() hasntStopped()  {
299     // we can stop only not started and not completed crowdsale
300     if (started) {
301       require(!isFailed());
302       require(!isSuccessful());
303     }
304     stopped = true;
305   }
306 
307   // called by CrowdsaleController to setup start and end time of crowdfunding process
308   // as well as funding address (where to transfer ETH upon successful crowdsale)
309   function start(
310     uint256 _startTimestamp,
311     uint256 _endTimestamp,
312     address _fundingAddress
313   )
314     public
315     onlyManager()   // manager is CrowdsaleController instance
316     hasntStarted()  // not yet started
317     hasntStopped()  // crowdsale wasn't cancelled
318   {
319     require(_fundingAddress != address(0));
320 
321     // start time must not be earlier than current time
322     require(_startTimestamp >= block.timestamp);
323 
324     // range must be sane
325     require(_endTimestamp > _startTimestamp);
326     duration = _endTimestamp - _startTimestamp;
327 
328     // duration must fit constraints
329     require(duration >= MIN_CROWDSALE_TIME && duration <= MAX_CROWDSALE_TIME);
330 
331     startTimestamp = _startTimestamp;
332     endTimestamp = _endTimestamp;
333     fundingAddress = _fundingAddress;
334 
335     // now crowdsale is considered started, even if the current time is before startTimestamp
336     started = true;
337 
338     CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);
339   }
340 
341   // must return true if crowdsale is over, but it failed
342   function isFailed()
343     public
344     constant
345     returns(bool)
346   {
347     return (
348       // it was started
349       started &&
350 
351       // crowdsale period has finished
352       block.timestamp >= endTimestamp &&
353 
354       // but collected ETH is below the required minimum
355       totalCollected < minimalGoal
356     );
357   }
358 
359   // must return true if crowdsale is active (i.e. the token can be bought)
360   function isActive()
361     public
362     constant
363     returns(bool)
364   {
365     return (
366       // it was started
367       started &&
368 
369       // hard cap wasn't reached yet
370       totalCollected < hardCap &&
371 
372       // and current time is within the crowdfunding period
373       block.timestamp >= startTimestamp &&
374       block.timestamp < endTimestamp
375     );
376   }
377 
378   // must return true if crowdsale completed successfully
379   function isSuccessful()
380     public
381     constant
382     returns(bool)
383   {
384     return (
385       // either the hard cap is collected
386       totalCollected >= hardCap ||
387 
388       // ...or the crowdfunding period is over, but the minimum has been reached
389       (block.timestamp >= endTimestamp && totalCollected >= minimalGoal)
390     );
391   }
392 }
393 
394 contract Bridge is BasicCrowdsale {
395 
396   using SafeMath for uint256;
397 
398   event CUSTOM_CROWDSALE_TOKEN_ADDED(address token, uint8 decimals);
399   event CUSTOM_CROWDSALE_FINISH();
400 
401   // Crowdsale token must be ERC20-compliant
402   DefaultToken token;
403 
404   // Crowdsale state
405   bool completed;
406 
407   // Constructor
408   constructor(
409     uint256 _minimalGoal,
410     uint256 _hardCap,
411     address _token
412   )
413     BasicCrowdsale(msg.sender, msg.sender) // owner, manager
414   {
415     minimalGoal = _minimalGoal;
416     hardCap = _hardCap;
417     token = DefaultToken(_token);
418   }
419 
420   /*
421      Here goes ICrowdsaleProcessor methods implementation
422   */
423 
424   // Returns address of crowdsale token
425   function getToken()
426     public
427     returns (address)
428   {
429     return address(token);
430   }
431 
432   // Mints token Rewards to Forecasting contract
433   // called by CrowdsaleController
434   function mintTokenRewards(
435     address _contract,
436     uint256 _amount    // agreed part of totalSold which is intended for rewards
437   )
438     public
439     onlyManager()
440   {
441     // in our example we are transferring tokens instead of minting them
442     token.transfer(_contract, _amount);
443   }
444 
445   function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful() {
446   }
447 
448   /*
449      Crowdsale methods implementation
450   */
451 
452   // Fallback payable function
453   function() public payable {
454   }
455 
456   // Update information about collected ETH and sold tokens amount
457   function notifySale(uint256 _ethAmount, uint256 _tokensAmount)
458     public
459     hasBeenStarted()
460     hasntStopped()
461     whenCrowdsaleAlive()
462     onlyOwner()
463   {
464     totalCollected = totalCollected.add(_ethAmount);
465     totalSold = totalSold.add(_tokensAmount);
466   }
467 
468   // Validates parameters and starts crowdsale
469   // called by CrowdsaleController
470   function start(
471     uint256 _startTimestamp,
472     uint256 _endTimestamp,
473     address _fundingAddress
474   )
475     public
476     hasntStarted()
477     hasntStopped()
478     onlyManager()
479   {
480     started = true;
481 
482     emit CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);
483   }
484 
485   // Finish crowdsale
486   function finish()
487     public
488     hasntStopped()
489     hasBeenStarted()
490     whenCrowdsaleAlive()
491     onlyOwner()
492   {
493     completed = true;
494 
495     emit CUSTOM_CROWDSALE_FINISH();
496   }
497 
498   function isFailed()
499     public
500     view
501     returns (bool)
502   {
503     return (false);
504   }
505 
506   function isActive()
507     public
508     view
509     returns (bool)
510   {
511     return (started && !completed);
512   }
513 
514   function isSuccessful()
515     public
516     view
517     returns (bool)
518   {
519     return (completed);
520   }
521 
522   // Find out the amount of rewards in ETH and tokens
523   function calculateRewards() public view returns (uint256, uint256) {
524     uint256 tokenRewardPart = IWingsController(manager).tokenRewardPart();
525     uint256 ethRewardPart = IWingsController(manager).ethRewardPart();
526 
527     uint256 tokenReward = totalSold.mul(tokenRewardPart) / 1000000;
528     uint256 ethReward = (ethRewardPart == 0) ? 0 : (totalCollected.mul(ethRewardPart) / 1000000);
529 
530     return (ethReward, tokenReward);
531   }
532 
533   // Change token address (in case you've used the dafault token address during bridge deployment)
534   function changeToken(address _newToken) public onlyOwner() {
535     token = DefaultToken(_newToken);
536 
537     emit CUSTOM_CROWDSALE_TOKEN_ADDED(address(token), uint8(token.decimals()));
538   }
539 }