1 pragma solidity ^0.4.13;
2 
3 interface MigrationAgent {
4   function migrateFrom(address _from, uint256 _value);
5 }
6 
7 contract PoolAllocations {
8 
9   // ERC20 basic token contract being held
10   ERC20Basic public token;
11 
12  // allocations map
13   mapping (address => lockEntry) public allocations;
14 
15   // lock entry
16   struct lockEntry {
17       uint256 totalAmount;        // total amount of token for a user
18       uint256 firstReleaseAmount; // amount to be released 
19       uint256 nextRelease;        // amount to be released every month
20       uint256 restOfTokens;       // the rest of tokens if not divisible
21       bool isFirstRelease;        // just flag
22       uint numPayoutCycles;       // only after 3 years
23   }
24 
25   // max number of payout cycles
26   uint public maxNumOfPayoutCycles;
27 
28   // first release date
29   uint public startDay;
30 
31   // defines how many of cycles should be released immediately
32   uint public cyclesStartFrom = 1;
33 
34   uint public payoutCycleInDays;
35 
36   function PoolAllocations(ERC20Basic _token) public {
37     token = _token;
38   }
39 
40   /**
41    * @dev claims tokens held by time lock
42    */
43   function claim() public {
44     require(now >= startDay);
45 
46      var elem = allocations[msg.sender];
47     require(elem.numPayoutCycles > 0);
48 
49     uint256 tokens = 0;
50     uint cycles = getPayoutCycles(elem.numPayoutCycles);
51 
52     if (elem.isFirstRelease) {
53       elem.isFirstRelease = false;
54       tokens += elem.firstReleaseAmount;
55       tokens += elem.restOfTokens;
56     } else {
57       require(cycles > 0);
58     }
59 
60     tokens += elem.nextRelease * cycles;
61 
62     elem.numPayoutCycles -= cycles;
63 
64     assert(token.transfer(msg.sender, tokens));
65   }
66 
67   function getPayoutCycles(uint payoutCyclesLeft) private constant returns (uint) {
68     uint cycles = uint((now - startDay) / payoutCycleInDays) + cyclesStartFrom;
69 
70     if (cycles > maxNumOfPayoutCycles) {
71        cycles = maxNumOfPayoutCycles;
72     }
73 
74     return cycles - (maxNumOfPayoutCycles - payoutCyclesLeft);
75   }
76 
77   function createAllocationEntry(uint256 total, uint256 first, uint256 next, uint256 rest) internal returns(lockEntry) {
78     return lockEntry(total, // total
79                      first, // first
80                      next,  // next
81                      rest,  // rest
82                      true,  //isFirstRelease
83                      maxNumOfPayoutCycles); //payoutCyclesLeft
84   }
85 }
86 
87 contract PoolBLock is PoolAllocations {
88 
89   uint256 public constant totalAmount = 911567810300063801255851777;
90 
91   function PoolBLock(ERC20Basic _token) PoolAllocations(_token) {
92 
93     // setup policy
94     maxNumOfPayoutCycles = 5; // 20% * 5 = 100%
95     startDay = now;
96     cyclesStartFrom = 1; // the first payout cycles is released immediately
97     payoutCycleInDays = 180 days; // 20% of tokens will be released every 6 months
98 
99     // allocations
100     allocations[0x2f09079059b85c11DdA29ed62FF26F99b7469950] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
101     allocations[0x3634acA3cf97dCC40584dB02d53E290b5b4b65FA] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
102     allocations[0x768D9F044b9c8350b041897f08cA77AE871AeF1C] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
103     allocations[0xb96De72d3fee8c7B6c096Ddeab93bf0b3De848c4] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
104     allocations[0x2f97bfD7a479857a9028339Ce2426Fc3C62D96Bd] = createAllocationEntry(182313562060012760251170357, 0, 36462712412002552050234071, 2);
105   }
106 }
107 
108 contract PoolCLock is PoolAllocations {
109 
110   uint256 public constant totalAmount = 911567810300063801255851777;
111 
112   function PoolCLock(ERC20Basic _token) PoolAllocations(_token) {
113     
114     // setup policy
115     maxNumOfPayoutCycles = 5; // 20% * 5 = 100%
116     startDay = now;
117     cyclesStartFrom = 1; // the first payout cycles is released immediately
118     payoutCycleInDays = 180 days; // 20% of tokens will be released every 6 months
119 
120     // allocations
121     allocations[0x0d02A3365dFd745f76225A0119fdD148955f821E] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
122     allocations[0x0deF4A4De337771c22Ac8C8D4b9C5Fec496841A5] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
123     allocations[0x467600367BdBA1d852dbd8C1661a5E6a2Be5F6C8] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
124     allocations[0x92E01739142386E4820eC8ddC3AFfF69de99641a] = createAllocationEntry(182313562060012760251170355, 0, 36462712412002552050234071, 0);
125     allocations[0x1E0a7E0706373d0b76752448ED33cA1E4070753A] = createAllocationEntry(182313562060012760251170357, 0, 36462712412002552050234071, 2);
126   }
127 }
128 
129 contract PoolDLock is PoolAllocations {
130 
131   uint256 public constant totalAmount = 546940686180038280753511066;
132 
133   function PoolDLock(ERC20Basic _token) PoolAllocations(_token) {
134     
135     // setup policy
136     maxNumOfPayoutCycles = 36; // total * .5 / 36
137     startDay = now + 3 years;  // first release date
138     cyclesStartFrom = 0;
139     payoutCycleInDays = 30 days; // 1/36 of tokens will be released every month
140 
141     // allocations
142     allocations[0x4311F6F65B411f546c7DD8841A344614297Dbf62] = createAllocationEntry(
143       182313562060012760251170355, // total
144       91156781030006380125585177,  // first release
145       2532132806389066114599588,   // next release
146       10                           // the rest
147     );
148      allocations[0x3b52Ab408cd499A1456af83AC095fCa23C014e0d] = createAllocationEntry(
149       182313562060012760251170355, // total
150       91156781030006380125585177,  // first release
151       2532132806389066114599588,   // next release
152       10                           // the rest
153     );
154      allocations[0x728D5312FbbdFBcC1b9582E619f6ceB6412B98E4] = createAllocationEntry(
155       182313562060012760251170356, // total
156       91156781030006380125585177,  // first release
157       2532132806389066114599588,   // next release
158       11                           // the rest
159     );
160   }
161 }
162 
163 contract Pausable {
164   event Pause();
165   event Unpause();
166 
167   bool public paused = false;
168   address public owner;
169 
170   function Pausable(address _owner) {
171     owner = _owner;
172   }
173 
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev modifier to allow actions only when the contract IS paused
181    */
182   modifier whenNotPaused() {
183     require(!paused);
184     _;
185   }
186 
187   /**
188    * @dev modifier to allow actions only when the contract IS NOT paused
189    */
190   modifier whenPaused {
191     require(paused);
192     _;
193   }
194 
195   /**
196    * @dev called by the owner to pause, triggers stopped state
197    */
198   function pause() onlyOwner whenNotPaused returns (bool) {
199     paused = true;
200     Pause();
201     return true;
202   }
203 
204   /**
205    * @dev called by the owner to unpause, returns to normal state
206    */
207   function unpause() onlyOwner whenPaused returns (bool) {
208     paused = false;
209     Unpause();
210     return true;
211   }
212 }
213 
214 library SafeMath {
215   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
216     uint256 c = a * b;
217     assert(a == 0 || c / a == b);
218     return c;
219   }
220 
221   function div(uint256 a, uint256 b) internal constant returns (uint256) {
222     // assert(b > 0); // Solidity automatically throws when dividing by 0
223     uint256 c = a / b;
224     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225     return c;
226   }
227 
228   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
229     assert(b <= a);
230     return a - b;
231   }
232 
233   function add(uint256 a, uint256 b) internal constant returns (uint256) {
234     uint256 c = a + b;
235     assert(c >= a);
236     return c;
237   }
238 }
239 
240 contract ERC20Basic {
241   uint256 public totalSupply;
242   function balanceOf(address who) constant returns (uint256);
243   function transfer(address to, uint256 value) returns (bool);
244   event Transfer(address indexed from, address indexed to, uint256 value);
245 }
246 
247 contract BasicToken is ERC20Basic {
248   using SafeMath for uint256;
249 
250   mapping(address => uint256) balances;
251 
252   /**
253    * @dev Fix for the ERC20 short address attack.
254    */
255   modifier onlyPayloadSize(uint numwords) {
256       assert(msg.data.length == numwords * 32 + 4);
257       _;
258   }
259 
260   /**
261   * @dev transfer token for a specified address
262   * @param _to The address to transfer to.
263   * @param _value The amount to be transferred.
264   */
265   function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool) {
266     balances[msg.sender] = balances[msg.sender].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     Transfer(msg.sender, _to, _value);
269     return true;
270   }
271 
272   /**
273   * @dev Gets the balance of the specified address.
274   * @param _owner The address to query the the balance of. 
275   * @return An uint256 representing the amount owned by the passed address.
276   */
277   function balanceOf(address _owner) constant returns (uint256 balance) {
278     return balances[_owner];
279   }
280 
281 }
282 
283 contract ERC20 is ERC20Basic {
284   function allowance(address owner, address spender) constant returns (uint256);
285   function transferFrom(address from, address to, uint256 value) returns (bool);
286   function approve(address spender, uint256 value) returns (bool);
287   event Approval(address indexed owner, address indexed spender, uint256 value);
288 }
289 
290 contract StandardToken is ERC20, BasicToken {
291 
292   mapping (address => mapping (address => uint256)) allowed;
293 
294 
295   /**
296    * @dev Transfer tokens from one address to another
297    * @param _from address The address which you want to send tokens from
298    * @param _to address The address which you want to transfer to
299    * @param _value uint256 the amout of tokens to be transfered
300    */
301   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool) {
302     var _allowance = allowed[_from][msg.sender];
303 
304     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
305     // require (_value <= _allowance);
306 
307     balances[_to] = balances[_to].add(_value);
308     balances[_from] = balances[_from].sub(_value);
309     allowed[_from][msg.sender] = _allowance.sub(_value);
310     Transfer(_from, _to, _value);
311     return true;
312   }
313 
314   /**
315    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
316    * @param _spender The address which will spend the funds.
317    * @param _value The amount of tokens to be spent.
318    */
319   function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool) {
320 
321     // To change the approve amount you first have to reduce the addresses`
322     //  allowance to zero by calling `approve(_spender, 0)` if it is not
323     //  already 0 to mitigate the race condition described here:
324     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
325     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
326 
327     allowed[msg.sender][_spender] = _value;
328     Approval(msg.sender, _spender, _value);
329     return true;
330   }
331 
332   /**
333    * @dev Function to check the amount of tokens that an owner allowed to a spender.
334    * @param _owner address The address which owns the funds.
335    * @param _spender address The address which will spend the funds.
336    * @return A uint256 specifing the amount of tokens still avaible for the spender.
337    */
338   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
339     return allowed[_owner][_spender];
340   }
341 
342 }
343 
344 contract BlockvToken is StandardToken, Pausable {
345 
346   string public constant name = "BLOCKv Token"; // Set the token name for display
347   string public constant symbol = "VEE";        // Set the token symbol for display
348   uint8  public constant decimals = 18;         // Set the number of decimals for display
349 
350   PoolBLock public poolBLock;
351   PoolCLock public poolCLock;
352   PoolDLock public poolDLock;
353 
354   uint256 public constant totalAmountOfTokens = 3646271241200255205023407108;
355   uint256 public constant amountOfTokensPoolA = 1276194934420089321758192488;
356   uint256 public constant amountOfTokensPoolB = 911567810300063801255851777;
357   uint256 public constant amountOfTokensPoolC = 911567810300063801255851777;
358   uint256 public constant amountOfTokensPoolD = 546940686180038280753511066;
359 
360   // migration
361   address public migrationMaster;
362   address public migrationAgent;
363   uint256 public totalMigrated;
364   event Migrate(address indexed _from, address indexed _to, uint256 _value);
365 
366   /**
367    * @dev BlockvToken Constructor
368    * Runs only on initial contract creation.
369    */
370   function BlockvToken(address _migrationMaster) Pausable(_migrationMaster) {
371     require(_migrationMaster != 0);
372     migrationMaster = _migrationMaster;
373 
374     totalSupply = totalAmountOfTokens; // Set the total supply
375 
376     balances[msg.sender] = amountOfTokensPoolA;
377     Transfer(0x0, msg.sender, amountOfTokensPoolA);
378   
379     // time-locked tokens
380     poolBLock = new PoolBLock(this);
381     poolCLock = new PoolCLock(this);
382     poolDLock = new PoolDLock(this);
383 
384     balances[poolBLock] = amountOfTokensPoolB;
385     balances[poolCLock] = amountOfTokensPoolC;
386     balances[poolDLock] = amountOfTokensPoolD;
387 
388     Transfer(0x0, poolBLock, amountOfTokensPoolB);
389     Transfer(0x0, poolCLock, amountOfTokensPoolC);
390     Transfer(0x0, poolDLock, amountOfTokensPoolD);
391   }
392 
393   /**
394    * @dev Transfer token for a specified address when not paused
395    * @param _to The address to transfer to.
396    * @param _value The amount to be transferred.
397    */
398   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
399     require(_to != address(0));
400     require(_to != address(this));
401     return super.transfer(_to, _value);
402   }
403 
404   /**
405    * @dev Transfer tokens from one address to another when not paused
406    * @param _from address The address which you want to send tokens from
407    * @param _to address The address which you want to transfer to
408    * @param _value uint256 the amount of tokens to be transferred
409    */
410   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
411     require(_to != address(0));
412     require(_from != _to);
413     require(_to != address(this));
414     return super.transferFrom(_from, _to, _value);
415   }
416 
417   /**
418    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
419    * @param _spender The address which will spend the funds.
420    * @param _value The amount of tokens to be spent.
421    */
422   function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
423     require(_spender != address(0));
424     require(_spender != address(this));
425     return super.approve(_spender, _value);
426   }
427 
428   /**
429   * Token migration support:
430   */
431 
432   /** 
433   * @notice Migrate tokens to the new token contract.
434   * @dev Required state: Operational Migration
435   * @param _value The amount of token to be migrated
436   */
437   function migrate(uint256 _value) external {
438     require(migrationAgent != 0);
439     require(_value != 0);
440     require(_value <= balances[msg.sender]);
441 
442     balances[msg.sender] = balances[msg.sender].sub(_value);
443     totalSupply = totalSupply.sub(_value);
444     totalMigrated = totalMigrated.add(_value);
445     MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
446     
447     Migrate(msg.sender, migrationAgent, _value);
448   }
449 
450   /**
451   * @dev Set address of migration target contract and enable migration process.
452   * @param _agent The address of the MigrationAgent contract
453   */
454   function setMigrationAgent(address _agent) external {
455     require(_agent != 0);
456     require(migrationAgent == 0);
457     require(msg.sender == migrationMaster);
458 
459     migrationAgent = _agent;
460   }
461 
462   function setMigrationMaster(address _master) external {
463     require(_master != 0);
464     require(msg.sender == migrationMaster);
465 
466     migrationMaster = _master;
467   }
468 }