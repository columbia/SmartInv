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
171 contract SEXNToken is StandardToken, Ownable {
172   using SafeMath for uint256;
173 
174   string public constant name = "SexChain";
175   string public constant symbol = "SEXN";
176   uint8 public constant decimals = 18;
177 
178   struct lockInfo {
179     uint256 amount;            // Total number of token locks
180     uint256 start;             // The time when the lock was started.
181     uint256 transfered;        // The number of tokens that have been unlocked.
182     uint256 duration;          // The lock time for each cycle.
183     uint256 releaseCount;      // locking cycle.
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
203   uint256 public constant DURATION = 24 * 3600;  // a day
204 
205   /* The maximum amount of single users for pre-sales in the first period is 20,000. */
206   uint256 public constant CAT_FIRST = 20000 * (10 ** 18);
207 
208   enum PresaleAction {
209     Ready,
210     FirstPresaleActivity,
211     SecondPresaleActivity,
212     ThirdPresaleActivity,
213     END
214   }
215 
216   PresaleAction public saleAction = PresaleAction.Ready;
217 
218 
219   address private PRESALE_ADDRESS = 0xFD8C2759Fcf6E0BB57128d5dFCf1747AE9C7e3a1;         // Presale         
220   address private FOUNDATION_ADDRESS = 0x096D756888F725ab56eA5bD2002102d10271BEc3;      // Community rewards 
221   address private COMMERCIAL_PLAN_ADDRESS = 0x51bE0d2Ed867cB68450Bee2Fcbf11a5960843bbd; // commercial plan  
222   address private POS_ADDRESS = 0x17c5fD5915DfaDe37EC0C04f1D70Ee495d6957af;             // DPOS                     
223   address private TEAM_ADDRESS = 0xE38e1dB1fD7915D2ed877E8cE53697E57EC2417e;            // Technical team   
224   address private COMMUNITY_TEAM_ADDRESS = 0xa34C472688D92511beb8fCDA42269a0526CfCCf0;  // community team   
225 
226   address public wallet = 0xDcE9E02972fDfEd54F4b307C75bd0755067cBc90;
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
252   /* For security reasons, need to change the wallet address */
253   function changeWallet(address _newWallet) public {
254       require(_newWallet != address(0x0));
255       require(msg.sender == wallet);
256       
257       wallet = _newWallet;
258   }
259 
260   /* Query the number of tokens for which an address is locked. */
261   function getLockBalance(address _owner) public view returns(uint256){
262     return _lockupBalances[_owner];
263   }
264 
265   /* Check the remaining quantity of presale in this round. */
266   function getRemainingPreSalesAmount() public view returns(uint256){
267     return balances[PRESALE_ADDRESS];
268   }
269 
270   /*Gets the unlocked time of the specified address. */
271   function getLockTime(address _owner) public view returns(uint256){
272     // start + ( lockCycle * duration )
273     return _lockInfo[_owner].start.add(
274         _lockInfo[_owner].releaseCount.mul(_lockInfo[_owner].duration));
275   }
276 
277   /**
278    * @dev Set the time and amount of presale for each period.
279    * @param _round uint8  The number of presale activities
280    * @param _startTime uint256  The current round of presales begins.
281    * @param _stopTime uint256  The end of the round of presales.
282    * @param _rate uint256   How many token units a buyer gets per wei.
283    * @param _amount uint256  The number of presale tokens.
284    */
285   function setSaleInfo(uint8 _round ,uint256 _startTime, uint256 _stopTime, uint256 _rate, uint256 _amount) external notpreSaleActive onlyOwner {
286     require(_round == 1 || _round == 2 || _round == 3);
287     require(_startTime < _stopTime);
288     require(_rate != 0 && _amount >= 0);
289     require(_startTime > now); 
290     require(!preSaleFinished);
291 
292     balances[msg.sender] = balances[msg.sender].sub(_amount);
293     balances[PRESALE_ADDRESS] = balances[PRESALE_ADDRESS].add(_amount);
294 
295     startTime = _startTime;
296     endTime = _stopTime;
297     rate = _rate;
298     _caluLocktime(_round);
299   }
300 
301   function _caluLocktime(uint8 _round) internal {
302     require(_round == 1 || _round == 2 || _round == 3);
303     if (_round == 1 ){
304       saleAction = PresaleAction.FirstPresaleActivity;
305       lockCycle = 200;        // 200 days
306     }
307 
308     if (_round == 2){
309       saleAction = PresaleAction.SecondPresaleActivity;
310       lockCycle = 150;        // 150 days
311     }
312 
313     if (_round == 3){
314       saleAction = PresaleAction.ThirdPresaleActivity;
315       lockCycle = 120;        // 120 days
316     }
317   }
318 
319 
320   /* End the setup of presale activities. */
321   function closeSale() public onlyOwner notpreSaleActive {
322     preSaleFinished = true;
323     saleAction = PresaleAction.END;
324   }
325 
326 
327   /**
328    * @dev Distribute tokens from presale address to an address.
329    * @param _to address  The address which you want to distribute to
330    * @param _amount uint256  The amount of tokens to be distributed
331    * @param _lockCycle uint256  Token locking cycle.
332    * @param _duration uint256  The lock time for each cycle.
333    */
334   function _distribute(address _to, uint256 _amount, uint256 _lockCycle, uint256 _duration) internal returns(bool)  {
335     ////Do not allow multiple distributions of the same address. Avoid locking time reset.
336     require(_lockInfo[_to].amount == 0 );
337     require(_lockupBalances[_to] == 0);
338 
339     _lockInfo[_to].amount = _amount;
340     _lockInfo[_to].releaseCount = _lockCycle;
341     _lockInfo[_to].start = now;
342     _lockInfo[_to].transfered = 0;
343     _lockInfo[_to].duration = _duration;
344     
345     //Easy to query locked balance
346     _lockupBalances[_to] = _amount;
347 
348     return true;
349   }
350 
351   /* Distribute tokens from presale address to an address. */
352   function distribute(address _to, uint256 _amount) public onlyOwner beginSaleActive {
353     require(_to != 0x0);
354     require(_amount != 0);
355     
356     _distribute(_to, _amount,lockCycle, DURATION);
357     
358     balances[PRESALE_ADDRESS] = balances[PRESALE_ADDRESS].sub(_amount);
359     emit Transfer(PRESALE_ADDRESS, _to, _amount);
360   }
361 
362 
363   /* Calculate the unlockable balance */
364   function _releasableAmount(address _owner, uint256 time) internal view returns (uint256){
365     lockInfo storage userLockInfo = _lockInfo[_owner]; 
366     if (userLockInfo.transfered == userLockInfo.amount){
367       return 0;
368     }
369 
370     // Unlockable tokens per cycle.
371     uint256 amountPerRelease = userLockInfo.amount.div(userLockInfo.releaseCount); //amount/cnt
372     // Total unlockable balance.
373     uint256 amount = amountPerRelease.mul((time.sub(userLockInfo.start)).div(userLockInfo.duration));
374 
375     if (amount > userLockInfo.amount){
376       amount = userLockInfo.amount;
377     }
378     // 
379     amount = amount.sub(userLockInfo.transfered);
380 
381     return amount;
382   }
383 
384 
385   /* Unlock locked tokens */
386   function relaseLock() internal returns(uint256){
387     uint256 amount = _releasableAmount(msg.sender, now);
388     if (amount > 0){
389       _lockInfo[msg.sender].transfered = _lockInfo[msg.sender].transfered.add(amount);
390       balances[msg.sender] = balances[msg.sender].add(amount);
391       _lockupBalances[msg.sender] = _lockupBalances[msg.sender].sub(amount);
392       emit UnLock(msg.sender, amount);
393     }
394     return 0;
395   }
396 
397 
398   function _initialize() internal {
399 
400     uint256 PRESALE_SUPPLY = totalSupply.mul(20).div(100);          // 20% for presale
401     uint256 DPOS_SUPPLY = totalSupply.mul(30).div(100);             // 30% for DPOS
402     uint256 COMMUNITY_REWARDS_SUPPLY = totalSupply.mul(20).div(100);// 20% for community rewards
403     uint256 COMMUNITY_TEAM_SUPPLY = totalSupply.mul(10).div(100);   // 10% for community team
404     uint256 COMMERCIAL_PLAN_SUPPLY = totalSupply * 10 / 100;        // 10% for commercial plan
405     uint256 TEAM_SUPPLY = totalSupply.mul(10).div(100);             // 10% for technical team 
406 
407     balances[msg.sender] = PRESALE_SUPPLY;
408     balances[FOUNDATION_ADDRESS] = COMMUNITY_REWARDS_SUPPLY;
409     balances[POS_ADDRESS] = DPOS_SUPPLY;
410     balances[COMMERCIAL_PLAN_ADDRESS] = COMMERCIAL_PLAN_SUPPLY;
411 
412     //This part of the token locks for one year。
413     _distribute(COMMUNITY_TEAM_ADDRESS, COMMUNITY_TEAM_SUPPLY, 1, 365 days);
414 
415     //This part of the token is locked until August 1, divided into 2 phases to unlock.
416     _distribute(0x7C88a1EC1D25c232464549ea9eF72B9bDc2a010A, TEAM_SUPPLY.mul(20).div(100), 2, 70 days); //0801
417 
418     // This part of the token locks for one year。
419     _distribute(TEAM_ADDRESS, TEAM_SUPPLY.mul(80).div(100), 1, 365 days);
420 
421   }
422 
423 
424 
425   function SEXNToken() public {
426     totalSupply = 580000000 * (10 ** 18); // 580 million
427     _initialize();
428   }
429 
430 
431   /**
432    * Fallback function
433    * 
434    * The function without name is the default function that is called whenever anyone sends funds to a contract
435    * sell tokens automatic
436    */
437   function () external payable beginSaleActive {
438       sellTokens();
439   }
440 
441 
442   /**
443    * @dev Sell tokens to msg.sender
444    *
445    */
446   function sellTokens() public payable beginSaleActive {
447     require(msg.value > 0);
448 
449     uint256 amount = msg.value;
450     uint256 tokens = amount.mul(rate);
451 
452     // check there are tokens for sale;
453     require(tokens <= balances[PRESALE_ADDRESS]);
454 
455     if (saleAction == PresaleAction.FirstPresaleActivity){
456       // The maximum amount of single users for presales in the first period is 20,000.
457       require (tokens <= CAT_FIRST);
458     }
459 
460     // send tokens to buyer
461     _distribute(msg.sender, tokens, lockCycle, DURATION);
462 
463     
464     balances[PRESALE_ADDRESS] = balances[PRESALE_ADDRESS].sub(tokens);
465 
466     emit Transfer(PRESALE_ADDRESS, msg.sender, tokens);
467     emit SellTokens(msg.sender, tokens, rate);
468 
469     forwardFunds();
470   }
471 
472 
473   // send ether to the fund collection wallet
474   // override to create custom fund forwarding mechanisms
475   function forwardFunds() internal {
476       wallet.transfer(msg.value);
477   }
478 
479 
480   function balanceOf(address _owner) public view returns (uint256 balance) {
481     return balances[_owner].add(_lockupBalances[_owner]);
482   }
483 
484 
485   function transfer(address _to, uint256 _value) public returns (bool) {
486     if (_lockupBalances[msg.sender] > 0){
487       relaseLock();
488     }
489 
490     return  super.transfer( _to, _value);
491   }
492 
493 }