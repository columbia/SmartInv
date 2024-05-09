1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 {
38   function balanceOf(address who) public view returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   function allowance(address owner, address spender) public view returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 /**
48  * @title Ownable
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Ownable {
53   address public owner;
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() public {
62     owner = msg.sender;
63   }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     emit OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 }
83 
84 
85 contract StandardToken is ERC20 {
86   using SafeMath for uint256;
87 
88   uint256 public totalSupply;
89 
90   mapping(address => uint256) balances;
91   mapping(address => mapping (address => uint256)) allowed;
92 
93     /**
94    * @dev Gets the balance of the specified address.
95    * @param _owner The address to query the the balance of.
96    * @return An uint256 representing the amount owned by the passed address.
97    */
98   function balanceOf(address _owner) public view returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102   /**
103    * Internal transfer, only can be called by this contract
104    */
105   function _transfer(address _from, address _to, uint _value) internal {
106     require(_value > 0);
107     require(balances[_from] >= _value);
108 
109     balances[_from] = balances[_from].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     emit Transfer(_from, _to, _value);
112   }
113   
114   /**
115    * @dev transfer token for a specified address
116    * @param _to The address to transfer to.
117    * @param _value The amount to be transferred.
118    */
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121 
122     _transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require (_value <= allowed[_from][msg.sender]);
135 
136     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137     _transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     // To change the approve amount you first have to reduce the addresses`
148     //  allowance to zero by calling `approve(_spender, 0)` if it is not
149     //  already 0 to mitigate the race condition described here:
150     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
152     allowed[msg.sender][_spender] = _value;
153     emit Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint256 specifying the amount of tokens still available for the spender.
162    */
163   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
164     return allowed[_owner][_spender];
165   }
166 
167 }
168 
169 
170 
171 contract SEXNTestToken is StandardToken, Ownable {
172   using SafeMath for uint256;
173 
174   string public constant name = "Sex Test Chain";
175   string public constant symbol = "ST";
176   uint8 public constant decimals = 18;
177 
178   struct lockInfo {
179     uint256 amount;            // Total number of token locks
180     uint256 start;             // The time when the lock was started.
181     uint256 transfered;        // The number of tokens that have been unlocked.
182     uint256 duration;          // The lock time for each cycle.
183     uint256 releaseCount;        // locking cycle.
184   }
185 
186   mapping(address => lockInfo) internal _lockInfo;
187   // Query locked balance
188   mapping(address => uint256) internal _lockupBalances;
189 
190   bool public preSaleFinished = false;
191 
192   // start and end timestamps where investments are allowed (both inclusive) 
193   uint256 public startTime;
194   uint256 public endTime;
195 
196   // how many token units a buyer gets per wei
197   uint256 public rate;
198 
199   //The number of locks for each round of presale. eg: 5 is 5 days
200   uint256 public lockCycle;
201 
202   // The length of one lock cycle, 
203   // uint256 public constant DURATION = 24 * 3600;  // a day
204   uint256 public constant DURATION = 5 * 60;  // 5 min
205 
206   /* The maximum amount of single users for pre-sales in the first period is 20,000. */
207   uint256 public constant CAT_FIRST = 20000 * (10 ** 18);
208 
209   enum PresaleAction {
210     Ready,
211     FirstPresaleActivity,
212     SecondPresaleActivity,
213     ThirdPresaleActivity,
214     END
215   }
216 
217   PresaleAction public saleAction = PresaleAction.Ready;
218 
219 
220   address private PRESALE_ADDRESS = 0x8Aa8f4e3220838245f04fBf80A00378187dAe2bc;         // Presale          
221   address private FOUNDATION_ADDRESS = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;      // Community rewards 
222   address private COMMERCIAL_PLAN_ADDRESS = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB; // commercial plan  
223   address private TEAM_ADDRESS = 0x583031D1113aD414F02576BD6afaBfb302140225;            // Team            
224   address private COMMUNITY_TEAM_ADDRESS = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;  // community team   
225 
226   address public wallet = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
227 
228 
229   /////////////////
230   /// Event
231   /////////////////
232 
233   event UnLock(address indexed beneficiary, uint256 amount);
234   event SellTokens(address indexed recipient, uint256 sellTokens, uint256 rate);
235 
236   /////////////////
237   /// Modifier
238   /////////////////
239 
240   /* check presale is active */
241   modifier beginSaleActive() {
242     require(now >= startTime && now <= endTime);
243     _;
244   }
245 
246   /* check presale is not active */
247   modifier notpreSaleActive() {
248     require(now <= startTime || now >= endTime);
249     _;
250   }
251 
252 
253   /* Query the number of tokens for which an address is locked. */
254   function getLockBalance(address _owner) public view returns(uint256){
255     return _lockupBalances[_owner];
256   }
257 
258   /* Check the remaining quantity of presale in this round. */
259   function getRemainingPreSalesAmount() public view returns(uint256){
260     return balances[PRESALE_ADDRESS];
261   }
262 
263   /*Gets the unlocked time of the specified address. */
264   function getLockTime(address _owner) public view returns(uint256){
265     // start + ( lockCycle * duration )
266     return _lockInfo[_owner].start.add(
267         _lockInfo[_owner].releaseCount.mul(_lockInfo[_owner].duration));
268   }
269 
270   /**
271    * @dev Set the time and amount of presale for each period.
272    * @param _round uint8  The number of presale activities
273    * @param _startTime uint256  The current round of presales begins.
274    * @param _stopTime uint256  The end of the round of presales.
275    * @param _rate uint256   How many token units a buyer gets per wei.
276    * @param _amount uint256  The number of presale tokens.
277    */
278   function setSaleInfo(uint8 _round ,uint256 _startTime, uint256 _stopTime, uint256 _rate, uint256 _amount) external notpreSaleActive onlyOwner {
279     require(_round == 1 || _round == 2 || _round == 3);
280     require(_startTime < _stopTime);
281     require(_rate != 0 && _amount >= 0);
282     require(_startTime > now); 
283     require(!preSaleFinished);
284 
285     balances[msg.sender] = balances[msg.sender].sub(_amount);
286     balances[PRESALE_ADDRESS] = balances[PRESALE_ADDRESS].add(_amount);
287 
288     startTime = _startTime;
289     endTime = _stopTime;
290     rate = _rate;
291     _caluLocktime(_round);
292   }
293 
294   function _caluLocktime(uint8 _round) internal {
295     require(_round == 1 || _round == 2 || _round == 3);
296     if (_round == 1 ){
297       saleAction = PresaleAction.FirstPresaleActivity;
298       lockCycle = 200;        // 200 days
299     }
300 
301     if (_round == 2){
302       saleAction = PresaleAction.SecondPresaleActivity;
303       lockCycle = 150;        // 150 days
304     }
305 
306     if (_round == 3){
307       saleAction = PresaleAction.ThirdPresaleActivity;
308       lockCycle = 120;        // 120 days
309     }
310   }
311 
312 
313   /* End the setup of presale activities. */
314   function closeSale() public onlyOwner notpreSaleActive {
315     preSaleFinished = true;
316     saleAction = PresaleAction.END;
317   }
318 
319 
320   /**
321    * @dev Distribute tokens from presale address to an address.
322    * @param _to address  The address which you want to distribute to
323    * @param _amount uint256  The amount of tokens to be distributed
324    * @param _lockCycle uint256  Token locking cycle.
325    * @param _duration uint256  The lock time for each cycle.
326    */
327   function _distribute(address _to, uint256 _amount, uint256 _lockCycle, uint256 _duration) internal returns(bool)  {
328     ////Do not allow multiple distributions of the same address. Avoid locking time reset.
329     require(_lockInfo[_to].amount == 0 );
330     require(_lockupBalances[_to] == 0);
331 
332     _lockInfo[_to].amount = _amount;
333     _lockInfo[_to].releaseCount = _lockCycle;
334     _lockInfo[_to].start = now;
335     _lockInfo[_to].transfered = 0;
336     _lockInfo[_to].duration = _duration;
337     
338     //Easy to query locked balance
339     _lockupBalances[_to] = _amount;
340 
341     return true;
342   }
343 
344   /* Distribute tokens from presale address to an address. */
345   function distribute(address _to, uint256 _amount) public onlyOwner beginSaleActive {
346     require(_to != 0x0);
347     require(_amount != 0);
348     
349     _distribute(_to, _amount,lockCycle, DURATION);
350     
351     balances[PRESALE_ADDRESS] = balances[PRESALE_ADDRESS].sub(_amount);
352     emit Transfer(PRESALE_ADDRESS, _to, _amount);
353   }
354 
355 
356   /* Calculate the unlockable balance */
357   function _releasableAmount(address _owner, uint256 time) internal view returns (uint256){
358     lockInfo storage userLockInfo = _lockInfo[_owner]; 
359     if (userLockInfo.transfered == userLockInfo.amount){
360       return 0;
361     }
362 
363     // Unlockable tokens per cycle.
364     uint256 amountPerRelease = userLockInfo.amount.div(userLockInfo.releaseCount); //amount/cnt
365     // Total unlockable balance.
366     uint256 amount = amountPerRelease.mul((time.sub(userLockInfo.start)).div(userLockInfo.duration));
367 
368     if (amount > userLockInfo.amount){
369       amount = userLockInfo.amount;
370     }
371     // 
372     amount = amount.sub(userLockInfo.transfered);
373 
374     return amount;
375   }
376 
377 
378   /* Unlock locked tokens */
379   function relaseLock() internal returns(uint256){
380     uint256 amount = _releasableAmount(msg.sender, now);
381     if (amount > 0){
382       _lockInfo[msg.sender].transfered = _lockInfo[msg.sender].transfered.add(amount);
383       balances[msg.sender] = balances[msg.sender].add(amount);
384       _lockupBalances[msg.sender] = _lockupBalances[msg.sender].sub(amount);
385       emit UnLock(msg.sender, amount);
386     }
387     return 0;
388   }
389 
390 
391   function _initialize() internal {
392 
393     uint256 PRESALE_SUPPLY = totalSupply.mul(20).div(100);          // 20% for presale
394     uint256 FOUNDATION_SUPPLY = totalSupply.mul(30).div(100);       // 30% for foundation pow
395     uint256 COMMUNITY_REWARDS_SUPPLY = totalSupply.mul(20).div(100);// 20% for community rewards
396     uint256 COMMUNITY_TEAM_SUPPLY = totalSupply.mul(10).div(100);   // 10% for community team
397     uint256 COMMERCIAL_PLAN_SUPPLY = totalSupply * 10 / 100;        // 10% for commercial plan
398     uint256 TEAM_SUPPLY = totalSupply.mul(10).div(100);             // 10% for team 
399 
400     balances[msg.sender] = PRESALE_SUPPLY;
401     balances[FOUNDATION_ADDRESS] = FOUNDATION_SUPPLY + COMMUNITY_REWARDS_SUPPLY;
402     balances[COMMERCIAL_PLAN_ADDRESS] = COMMERCIAL_PLAN_SUPPLY;
403 
404     _distribute(COMMUNITY_TEAM_ADDRESS, COMMUNITY_TEAM_SUPPLY, 1, 365 days);
405     _lockupBalances[COMMUNITY_TEAM_ADDRESS] = COMMUNITY_TEAM_SUPPLY;
406 
407     _distribute(TEAM_ADDRESS, TEAM_SUPPLY, 1, 365 days);
408     _lockupBalances[TEAM_ADDRESS] = TEAM_SUPPLY;
409   }
410 
411 
412 
413   function SEXNTestToken() public {
414     totalSupply = 580000000 * (10 ** 18); // 580 million
415     _initialize();
416   }
417 
418 
419   /**
420    * Fallback function
421    * 
422    * The function without name is the default function that is called whenever anyone sends funds to a contract
423    * sell tokens automatic
424    */
425   function () external payable beginSaleActive {
426       sellTokens();
427   }
428 
429 
430   /**
431    * @dev Sell tokens to msg.sender
432    *
433    */
434   function sellTokens() public payable beginSaleActive {
435     require(msg.value > 0);
436 
437     uint256 amount = msg.value;
438     uint256 tokens = amount.mul(rate);
439 
440     // check there are tokens for sale;
441     require(tokens <= balances[PRESALE_ADDRESS]);
442 
443     if (saleAction == PresaleAction.FirstPresaleActivity){
444       // The maximum amount of single users for presales in the first period is 20,000.
445       require (tokens <= CAT_FIRST);
446     }
447 
448     // send tokens to buyer
449     _distribute(msg.sender, tokens, lockCycle, DURATION);
450 
451     
452     balances[PRESALE_ADDRESS] = balances[PRESALE_ADDRESS].sub(tokens);
453 
454     emit Transfer(PRESALE_ADDRESS, msg.sender, tokens);
455     emit SellTokens(msg.sender, tokens, rate);
456 
457     forwardFunds();
458   }
459 
460 
461   // send ether to the fund collection wallet
462   // override to create custom fund forwarding mechanisms
463   function forwardFunds() internal {
464       wallet.transfer(msg.value);
465   }
466 
467 
468   function balanceOf(address _owner) public view returns (uint256 balance) {
469     return balances[_owner].add(_lockupBalances[_owner]);
470   }
471 
472 
473   function transfer(address _to, uint256 _value) public returns (bool) {
474     if (_lockupBalances[msg.sender] > 0){
475       relaseLock();
476     }
477 
478     return  super.transfer( _to, _value);
479   }
480 
481 }