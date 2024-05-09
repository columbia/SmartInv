1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     emit Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     emit Unpause();
117   }
118 }
119 
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   uint256 totalSupply_;
133 
134   /**
135   * @dev total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 contract ERC20 is ERC20Basic {
168   function allowance(address owner, address spender) public view returns (uint256);
169   function transferFrom(address from, address to, uint256 value) public returns (bool);
170   function approve(address spender, uint256 value) public returns (bool);
171   event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 contract StandardToken is ERC20, BasicToken {
175 
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     emit Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    *
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     emit Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(address _owner, address _spender) public view returns (uint256) {
220     return allowed[_owner][_spender];
221   }
222 
223   /**
224    * @dev Increase the amount of tokens that an owner allowed to a spender.
225    *
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
234     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To decrement
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _subtractedValue The amount of tokens to decrease the allowance by.
248    */
249   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 contract ParticipantToken is StandardToken, Pausable {
263   uint16 public totalParticipants = 0;
264   mapping(address => bool) internal participants;
265 
266   modifier onlyParticipant() {
267     require(isParticipant(msg.sender));
268     _;
269   }
270 
271   constructor() public {
272     addParticipant(owner);
273   }
274   
275   function transfer(address _to, uint256 _value) public onlyParticipant whenNotPaused returns (bool) {
276     require(isParticipant(_to));
277     
278     super.transfer(_to, _value);
279   }
280   
281   function transferFrom(address _from, address _to, uint256 _value) public onlyParticipant whenNotPaused returns (bool) {
282     require(isParticipant(_from));
283     require(isParticipant(_to));
284     
285     super.transferFrom(_from, _to, _value);
286   }
287   
288   function isParticipant(address _address) public view returns (bool) {
289     return participants[_address] == true;
290   }
291   
292   function addParticipant(address _address) public onlyOwner whenNotPaused {
293     require(isParticipant(_address) == false);
294     
295     participants[_address] = true;
296     totalParticipants++;
297   }
298   
299   function removeParticipant(address _address) public onlyOwner whenNotPaused {
300     require(isParticipant(_address));
301     require(balances[_address] == 0);
302     
303     participants[_address] = false;
304     totalParticipants--;
305   }
306 }
307 
308 contract DistributionToken is ParticipantToken {
309   uint256 public tokenDistributionDuration = 30 days;
310   uint256 public currentDistributionAmount;
311   uint256 public tokenDistributionStartTime;
312   uint256 public tokenDistributionEndTime;
313   address public tokenDistributionPool;
314   
315   mapping(address => uint256) private unclaimedTokens;
316   mapping(address => uint256) private lastUnclaimedTokenUpdates;
317   
318   event TokenDistribution(address participant, uint256 value);
319   
320   constructor() public {
321     tokenDistributionPool = owner;
322   }
323   
324   function transfer(address _to, uint256 _value) public returns (bool) {
325     require((_to != tokenDistributionPool && msg.sender != tokenDistributionPool) || now >= tokenDistributionEndTime);
326     
327     super.transfer(_to, _value);
328   }
329   
330   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
331     require((_to != tokenDistributionPool && _from != tokenDistributionPool) || now >= tokenDistributionEndTime);
332     
333     super.transferFrom(_from, _to, _value);
334   }
335   
336   function claimTokens() public onlyParticipant whenNotPaused returns (bool) {
337     require(tokenDistributionEndTime > 0 && now < tokenDistributionEndTime);
338     require(msg.sender != tokenDistributionPool);
339     require(lastUnclaimedTokenUpdates[msg.sender] < tokenDistributionStartTime);
340     
341     unclaimedTokens[msg.sender] = calcClaimableTokens();
342     lastUnclaimedTokenUpdates[msg.sender] = now;
343     
344     uint256 value = unclaimedTokens[msg.sender];
345     unclaimedTokens[msg.sender] = 0;
346     
347     balances[tokenDistributionPool] = balances[tokenDistributionPool].sub(value);
348     balances[msg.sender] = balances[msg.sender].add(value);
349     emit TokenDistribution(msg.sender, value);
350     return true;
351   }
352   
353   function claimableTokens() public view onlyParticipant returns (uint256) {
354     if (lastUnclaimedTokenUpdates[msg.sender] >= tokenDistributionStartTime) {
355       return unclaimedTokens[msg.sender];
356     }
357     
358     return calcClaimableTokens();
359   }
360   
361   function setTokenDistributionPool(address _tokenDistributionPool) public onlyOwner whenNotPaused returns (bool) {
362     require(tokenDistributionEndTime < now);
363     require(isParticipant(_tokenDistributionPool));
364     
365     tokenDistributionPool = _tokenDistributionPool;
366     return true;
367   }
368   
369   function startTokenDistribution() public onlyOwner whenNotPaused returns(bool) {
370     require(tokenDistributionEndTime < now);
371     require(balanceOf(tokenDistributionPool) > 0);
372     
373     currentDistributionAmount = balanceOf(tokenDistributionPool);
374     tokenDistributionEndTime = now.add(tokenDistributionDuration);
375     tokenDistributionStartTime = now;
376     return true;
377   }
378 
379   function calcClaimableTokens() private view onlyParticipant returns(uint256) {
380     return (currentDistributionAmount.mul(balanceOf(msg.sender))).div(totalSupply_);
381   }
382 }
383 
384 contract DividendToken is DistributionToken {
385   uint256 public dividendDistributionDuration = 30 days;
386   uint256 public currentDividendAmount;
387   uint256 public dividendDistributionStartTime;
388   uint256 public dividendDistributionEndTime;
389   address public dividendDistributionPool;
390   
391   mapping(address => uint256) private unclaimedDividends;
392   mapping(address => uint256) private lastUnclaimedDividendUpdates;
393   mapping(address => uint256) private unclaimedOCDividends;
394   mapping(address => uint256) private lastUnclaimedOCDividendUpdates;
395   
396   event DividendDistribution(address participant, uint256 value);
397   event OCDividendClaim(address participant, uint256 value);
398   event OCDividendDistribution(address participant, uint256 value);
399   
400   constructor() public {
401     dividendDistributionPool = owner;
402   }
403   
404   function transfer(address _to, uint256 _value) public returns (bool) {
405     require((_to != dividendDistributionPool && msg.sender != dividendDistributionPool) || now >= dividendDistributionEndTime);
406     
407     super.transfer(_to, _value);
408   }
409   
410   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
411     require((_to != dividendDistributionPool && _from != dividendDistributionPool) || now >= dividendDistributionEndTime);
412     
413     super.transferFrom(_from, _to, _value);
414   }
415   
416   function claimDividend() public onlyParticipant whenNotPaused returns (bool) {
417     require(dividendDistributionEndTime > 0 && now < dividendDistributionEndTime);
418     require(msg.sender != dividendDistributionPool);
419     
420     updateUnclaimedDividend();
421     
422     uint256 value = unclaimedDividends[msg.sender];
423     unclaimedDividends[msg.sender] = 0;
424     
425     balances[dividendDistributionPool] = balances[dividendDistributionPool].sub(value);
426     balances[msg.sender] = balances[msg.sender].add(value);
427     emit DividendDistribution(msg.sender, value);
428     return true;
429   }
430   
431   function claimableDividend() public view onlyParticipant returns (uint256) {
432     if (lastUnclaimedDividendUpdates[msg.sender] >= dividendDistributionStartTime) {
433       return unclaimedDividends[msg.sender];
434     }
435     
436     return calcDividend();
437   }
438   
439   function claimOCDividend() public onlyParticipant whenNotPaused returns (bool) {
440     require(dividendDistributionEndTime > 0 && now < dividendDistributionEndTime);
441     require(msg.sender != dividendDistributionPool);
442     
443     updateUnclaimedDividend();
444     
445     uint256 value = unclaimedDividends[msg.sender];
446     unclaimedDividends[msg.sender] = 0;
447     
448     unclaimedOCDividends[msg.sender] = value;
449     lastUnclaimedOCDividendUpdates[msg.sender] = now;
450     
451     balances[dividendDistributionPool] = balances[dividendDistributionPool].sub(value);
452     balances[owner] = balances[owner].add(value);
453     emit OCDividendClaim(msg.sender, value);
454     return true;
455   }
456   
457   function claimableOCDividend(address _address) public view onlyOwner returns (uint256) {
458     if (isParticipant(_address) == false) {
459       return 0;
460     }
461     
462     if (dividendDistributionEndTime <= 0 || now >= dividendDistributionEndTime) {
463       return 0;
464     }
465     
466     if (lastUnclaimedOCDividendUpdates[_address] < dividendDistributionStartTime) {
467       return 0;
468     }
469     
470     return unclaimedOCDividends[_address];
471   }
472   
473   function payoutOCDividend(address _address) public onlyOwner whenNotPaused returns (bool) {
474     require(isParticipant(_address));
475     require(dividendDistributionEndTime > 0 && now < dividendDistributionEndTime);
476     require(unclaimedOCDividends[_address] > 0);
477     
478     uint256 value = unclaimedOCDividends[_address];
479     unclaimedOCDividends[_address] = 0;
480     emit OCDividendDistribution(_address, value);
481     return true;
482   }
483   
484   function setDividendDistributionPool(address _dividendDistributionPool) public onlyOwner whenNotPaused returns (bool) {
485     require(dividendDistributionEndTime < now);
486     require(isParticipant(_dividendDistributionPool));
487     
488     dividendDistributionPool = _dividendDistributionPool;
489     return true;
490   }
491   
492   function startDividendDistribution() public onlyOwner whenNotPaused returns(bool) {
493     require(dividendDistributionEndTime < now);
494     require(balanceOf(dividendDistributionPool) > 0);
495     
496     currentDividendAmount = balanceOf(dividendDistributionPool);
497     dividendDistributionEndTime = now.add(dividendDistributionDuration);
498     dividendDistributionStartTime = now;
499     return true;
500   }
501 
502   function calcDividend() private view onlyParticipant returns(uint256) {
503     return (currentDividendAmount.mul(balanceOf(msg.sender))).div(totalSupply_);
504   }
505   
506   function updateUnclaimedDividend() private whenNotPaused {
507     require(lastUnclaimedDividendUpdates[msg.sender] < dividendDistributionStartTime);
508     
509     unclaimedDividends[msg.sender] = calcDividend();
510     lastUnclaimedDividendUpdates[msg.sender] = now;
511   }
512 }
513 
514 contract ThisToken is DividendToken {
515   string public name = "ThisToken";
516   string public symbol = "THIS";
517   uint8 public decimals = 18;
518 
519   function setTotalSupply(uint256 _totalSupply) public onlyOwner whenNotPaused {
520     require(_totalSupply != totalSupply_);
521 
522     uint256 diff;
523 
524     if (_totalSupply < totalSupply_) {
525       diff = totalSupply_.sub(_totalSupply);
526       balances[owner] = balances[owner].sub(diff);
527     } else {
528       diff = _totalSupply.sub(totalSupply_);
529       balances[owner] = balances[owner].add(diff);
530     }
531 
532     totalSupply_ = _totalSupply;
533   }
534 }