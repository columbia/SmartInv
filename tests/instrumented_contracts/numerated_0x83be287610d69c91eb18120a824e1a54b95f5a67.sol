1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances. 
61  */
62 contract BasicToken is ERC20Basic {
63     
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of. 
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157     
158   address public owner;
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   function Ownable() {
165     owner = msg.sender;
166   }
167 
168   /**
169    * @dev Throws if called by any account other than the owner.
170    */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     require(newOwner != address(0));      
182     owner = newOwner;
183   }
184 
185 }
186 
187 /**
188  * @title Mintable token
189  * @dev Simple ERC20 Token example, with mintable token creation
190  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
191  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
192  */
193 
194 contract MintableToken is StandardToken, Ownable {
195     
196   event Mint(address indexed to, uint256 amount);
197   
198   event MintFinished();
199 
200   bool public mintingFinished = false;
201 
202   modifier canMint() {
203     require(!mintingFinished);
204     _;
205   }
206 
207   /**
208    * @dev Function to mint tokens
209    * @param _to The address that will recieve the minted tokens.
210    * @param _amount The amount of tokens to mint.
211    * @return A boolean that indicates if the operation was successful.
212    */
213   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
214     totalSupply = totalSupply.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     Mint(_to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner returns (bool) {
225     mintingFinished = true;
226     MintFinished();
227     return true;
228   }
229   
230 }
231 
232 /**
233  * @title Pausable
234  * @dev Base contract which allows children to implement an emergency stop mechanism.
235  */
236 contract Pausable is Ownable {
237     
238   event Pause();
239   
240   event Unpause();
241 
242   bool public paused = false;
243 
244   /**
245    * @dev modifier to allow actions only when the contract IS paused
246    */
247   modifier whenNotPaused() {
248     require(!paused);
249     _;
250   }
251 
252   /**
253    * @dev modifier to allow actions only when the contract IS NOT paused
254    */
255   modifier whenPaused() {
256     require(paused);
257     _;
258   }
259 
260   /**
261    * @dev called by the owner to pause, triggers stopped state
262    */
263   function pause() onlyOwner whenNotPaused {
264     paused = true;
265     Pause();
266   }
267 
268   /**
269    * @dev called by the owner to unpause, returns to normal state
270    */
271   function unpause() onlyOwner whenPaused {
272     paused = false;
273     Unpause();
274   }
275   
276 }
277 
278 
279 contract FidcomToken is MintableToken {
280     
281   string public constant name = "Fidcom Test";
282    
283   string public constant symbol = "FIDCT";
284     
285   uint32 public constant decimals = 18;
286 
287   bool public transferAllowed = false;
288 
289   modifier whenTransferAllowed() {
290     require(transferAllowed);
291     _;
292   }
293 
294   function allowTransfer() onlyOwner {
295     transferAllowed = true;
296   }
297 
298   function transfer(address _to, uint256 _value) whenTransferAllowed returns (bool) {
299     return super.transfer(_to, _value);
300   }
301 
302   function transferFrom(address _from, address _to, uint256 _value) whenTransferAllowed returns (bool) {
303     return super.transferFrom(_from, _to, _value);
304   }
305     
306 }
307 
308 
309 contract StagedCrowdsale is Ownable {
310 
311   using SafeMath for uint;
312 
313   struct Stage {
314     uint period;
315     uint hardCap;
316     uint price;
317     uint invested;
318     uint closed;
319   }
320 
321   uint public start;
322 
323   uint public totalPeriod;
324 
325   uint public totalHardCap;
326  
327   uint public totalInvested;
328 
329   Stage[] public stages;
330 
331   function stagesCount() constant returns(uint) {
332     return stages.length;
333   }
334 
335   function setStart(uint newStart) onlyOwner {
336     start = newStart;
337   }
338 
339   function addStage(uint period, uint hardCap, uint price) onlyOwner {
340     require(period>0 && hardCap >0 && price > 0);
341     stages.push(Stage(period, hardCap, price, 0, 0));
342     totalPeriod = totalPeriod.add(period);
343     totalHardCap = totalHardCap.add(hardCap);
344   }
345 
346   function removeStage(uint8 number) onlyOwner {
347     require(number >=0 && number < stages.length);
348 
349     Stage storage stage = stages[number];
350     totalHardCap = totalHardCap.sub(stage.hardCap);    
351     totalPeriod = totalPeriod.sub(stage.period);
352 
353     delete stages[number];
354 
355     for (uint i = number; i < stages.length - 1; i++) {
356       stages[i] = stages[i+1];
357     }
358 
359     stages.length--;
360   }
361 
362   function changeStage(uint8 number, uint period, uint hardCap, uint price) onlyOwner {
363     require(number >= 0 &&number < stages.length);
364 
365     Stage storage stage = stages[number];
366 
367     totalHardCap = totalHardCap.sub(stage.hardCap);    
368     totalPeriod = totalPeriod.sub(stage.period);    
369 
370     stage.hardCap = hardCap;
371     stage.period = period;
372     stage.price = price;
373 
374     totalHardCap = totalHardCap.add(hardCap);    
375     totalPeriod = totalPeriod.add(period);    
376   }
377 
378   function insertStage(uint8 numberAfter, uint period, uint hardCap, uint price) onlyOwner {
379     require(numberAfter < stages.length);
380 
381 
382     totalPeriod = totalPeriod.add(period);
383     totalHardCap = totalHardCap.add(hardCap);
384 
385     stages.length++;
386 
387     for (uint i = stages.length - 2; i > numberAfter; i--) {
388       stages[i + 1] = stages[i];
389     }
390 
391     stages[numberAfter + 1] = Stage(period, hardCap, price, 0, 0);
392   }
393 
394   function clearStages() onlyOwner {
395     for (uint i = 0; i < stages.length; i++) {
396       delete stages[i];
397     }
398     stages.length -= stages.length;
399     totalPeriod = 0;
400     totalHardCap = 0;
401   }
402 
403   modifier saleIsOn() {
404     require(stages.length > 0 && now >= start && now < lastSaleDate());
405     _;
406   }
407   
408   modifier isUnderHardCap() {
409     require(totalInvested <= totalHardCap);
410     _;
411   }
412   
413   function lastSaleDate() constant returns(uint) {
414     require(stages.length > 0);
415     uint lastDate = start;
416     for(uint i=0; i < stages.length; i++) {
417       if(stages[i].invested >= stages[i].hardCap) {
418         lastDate = stages[i].closed;
419       } else {
420         lastDate = lastDate.add(stages[i].period * 1 days);
421       }
422     }
423     return lastDate;
424   }
425 
426   function currentStage() saleIsOn constant returns(uint) {
427     uint previousDate = start;
428     for(uint i=0; i < stages.length; i++) {
429       if(stages[i].invested < stages[i].hardCap) {
430         if(now >= previousDate && now < previousDate + stages[i].period * 1 days) {
431           return i;
432         }
433         previousDate = previousDate.add(stages[i].period * 1 days);
434       } else {
435         previousDate = stages[i].closed;
436       }
437     }
438     return 0;
439   }
440 
441   function updateStageWithInvested() internal {
442     uint stageIndex = currentStage();
443     totalInvested = totalInvested.add(msg.value);
444     Stage storage stage = stages[stageIndex];
445     stage.invested = stage.invested.add(msg.value);
446     if(stage.invested >= stage.hardCap) {
447       stage.closed = now;
448     }
449   }
450 
451 
452 }
453 
454 contract Crowdsale is StagedCrowdsale, Pausable {
455     
456   address public multisigWallet;
457   
458   address public foundersTokensWallet;
459   
460   address public bountyTokensWallet;
461   
462   uint public percentRate = 1000;
463 
464   uint public foundersPercent;
465   
466   uint public bountyPercent;
467   
468   FidcomToken public token = new FidcomToken();
469 
470   function setFoundersPercent(uint newFoundersPercent) onlyOwner {
471     require(newFoundersPercent > 0 && newFoundersPercent < percentRate);
472     foundersPercent = newFoundersPercent;
473   }
474   
475   function setBountyPercent(uint newBountyPercent) onlyOwner {
476     require(newBountyPercent > 0 && newBountyPercent < percentRate);
477     bountyPercent = newBountyPercent;
478   }
479   
480   function setMultisigWallet(address newMultisigWallet) onlyOwner {
481     multisigWallet = newMultisigWallet;
482   }
483 
484   function setFoundersTokensWallet(address newFoundersTokensWallet) onlyOwner {
485     foundersTokensWallet = newFoundersTokensWallet;
486   }
487 
488   function setBountyTokensWallet(address newBountyTokensWallet) onlyOwner {
489     bountyTokensWallet = newBountyTokensWallet;
490   }
491 
492   function finishMinting() public whenNotPaused onlyOwner {
493     uint issuedTokenSupply = token.totalSupply();
494     uint summaryTokensPercent = bountyPercent + foundersPercent;
495     uint summaryFoundersTokens = issuedTokenSupply.mul(summaryTokensPercent).div(percentRate - summaryTokensPercent);
496     uint totalSupply = summaryFoundersTokens + issuedTokenSupply;
497     uint foundersTokens = totalSupply.div(percentRate).mul(foundersPercent);
498     uint bountyTokens = totalSupply.div(percentRate).mul(bountyPercent);
499     token.mint(foundersTokensWallet, foundersTokens);
500     token.mint(bountyTokensWallet, bountyTokens);
501     token.finishMinting();
502     token.allowTransfer();
503     token.transferOwnership(owner);
504   }
505 
506   function createTokens() whenNotPaused isUnderHardCap saleIsOn payable {
507     require(msg.value > 0);
508     uint stageIndex = currentStage();
509     Stage storage stage = stages[stageIndex];
510     multisigWallet.transfer(msg.value);
511     uint price = stage.price;
512     uint tokens = msg.value.div(price).mul(1 ether);
513     updateStageWithInvested();
514     token.mint(msg.sender, tokens);
515   }
516 
517   function() external payable {
518     createTokens();
519   }
520 
521   function retrieveTokens(address anotherToken) public onlyOwner {
522     ERC20 alienToken = ERC20(anotherToken);
523     alienToken.transfer(multisigWallet, token.balanceOf(this));
524   }
525 
526 }