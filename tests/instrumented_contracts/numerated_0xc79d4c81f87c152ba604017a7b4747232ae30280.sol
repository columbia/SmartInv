1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61   event OwnershipTransferred(
62     address previousOwner,
63     address newOwner
64   );
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner || msg.sender == address(this));
71     _;
72   }
73   
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address _newOwner) public onlyOwner {
87     _transferOwnership(_newOwner);
88   }
89 
90   /**
91    * @dev Transfers control of the contract to a newOwner.
92    * @param _newOwner The address to transfer ownership to.
93    */
94   function _transferOwnership(address _newOwner) internal {
95     require(_newOwner != address(0));
96     emit OwnershipTransferred(owner, _newOwner);
97     owner = _newOwner;
98   }
99 }
100 
101 /**
102  * @title Pausable
103  * @dev Base contract which allows children to implement an emergency stop mechanism.
104  */
105 contract Pausable is Ownable {
106   event Pause(bool isPause);
107 
108   bool public paused = false;
109 
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is not paused.
113    */
114   modifier whenNotPaused() {
115     require(!paused);
116     _;
117   }
118 
119   /**
120    * @dev Modifier to make a function callable only when the contract is paused.
121    */
122   modifier whenPaused() {
123     require(paused);
124     _;
125   }
126 
127   /**
128    * @dev called by the owner to pause, triggers stopped state
129    */
130   function pause() onlyOwner whenNotPaused public {
131     paused = true;
132     emit Pause(paused);
133   }
134 
135   /**
136    * @dev called by the owner to unpause, returns to normal state
137    */
138   function unpause() onlyOwner whenPaused public {
139     paused = false;
140     emit Pause(paused);
141   }
142 }
143 
144 /**
145  * @title ERC20Basic
146  * @dev Simpler version of ERC20 interface
147  * See https://github.com/ethereum/EIPs/issues/179
148  */
149 contract ERC20Basic {
150   function totalSupply() public view returns (uint256);
151   function balanceOf(address who) public view returns (uint256);
152   function transfer(address to, uint256 value) public returns (bool);
153   event Transfer(address indexed from, address indexed to, uint256 value);
154 }
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender)
162     public view returns (uint256);
163 
164   function transferFrom(address from, address to, uint256 value)
165     public returns (bool);
166 
167   function approve(address spender, uint256 value) public returns (bool);
168   event Approval(
169     address indexed owner,
170     address indexed spender,
171     uint256 value
172   );
173 }
174 
175 /**
176  * @title Basic token
177  * @dev Basic version of StandardToken, with no allowances.
178  */
179 contract BasicToken is ERC20Basic, Pausable {
180   using SafeMath for uint256;
181 
182   mapping(address => uint256) balances;
183   
184   struct Purchase {
185     uint unlockTokens;
186     uint unlockDate;
187   }
188   mapping(address => Purchase[]) balancesLock;
189 
190   uint256 totalSupply_;
191 
192   address public rubusBlackAddress;
193   uint256 public priceEthPerToken;
194   uint256 public depositCommission;
195   uint256 public withdrawCommission;
196   uint256 public investCommission;
197   address public depositWallet;
198   address public withdrawWallet;
199   address public investWallet;
200   bool public lock;
201   uint256 public minimalEthers;
202   uint256 public lockTokensPercent;
203   uint256 public lockTimestamp;
204   event Deposit(address indexed buyer, uint256 weiAmount, uint256 tokensAmount, uint256 tokenPrice, uint256 commission);
205   event Withdraw(address indexed buyer, uint256 weiAmount, uint256 tokensAmount, uint256 tokenPrice, uint256 commission);
206 
207   /**
208   * @dev Total number of tokens in existence
209   */
210   function totalSupply() public view returns (uint256) {
211     return totalSupply_;
212   }
213 
214   /**
215   * @dev Transfer token for a specified address
216   * @param _to The address to transfer to.
217   * @param _value The amount to be transferred.
218   */
219   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[msg.sender]);
222     require(_value <= checkVesting(msg.sender));
223 
224     if (_to == rubusBlackAddress) {
225       require(!lock);
226       uint256 weiAmount = _value.mul(withdrawCommission).div(priceEthPerToken);
227       require(weiAmount <= uint256(address(this).balance));
228       
229       totalSupply_ = totalSupply_.sub(_value);
230       msg.sender.transfer(weiAmount);
231       withdrawWallet.transfer(weiAmount.mul(uint256(100).sub(withdrawCommission)).div(100));
232       
233       emit Withdraw(msg.sender, weiAmount, _value, priceEthPerToken, withdrawCommission);
234     } else {
235       balances[_to] = balances[_to].add(_value);
236     }
237 
238     balances[msg.sender] = balances[msg.sender].sub(_value);
239     emit Transfer(msg.sender, _to, _value);
240     return true;
241   }
242   
243   function getPurchases(address sender, uint index) public view returns(uint, uint) {
244     return (balancesLock[sender][index].unlockTokens, balancesLock[sender][index].unlockDate);
245   }
246   
247   function checkVesting(address sender) public view returns (uint256) {
248     uint256 availableTokens = balances[sender];
249 
250     if (balancesLock[sender].length != 0) {
251       for (uint i = 0; i < balancesLock[sender].length; i++) {
252         (uint lockTokens, uint lockTime) = getPurchases(sender, i);
253         if (lockTime >= now) {
254           availableTokens = availableTokens.sub(lockTokens);
255         }
256       }
257     }
258     
259     return availableTokens;
260   }
261 
262   /**
263   * @dev Gets the balance of the specified address.
264   * @param _owner The address to query the the balance of.
265   * @return An uint256 representing the amount owned by the passed address.
266   */
267   function balanceOf(address _owner) public view returns (uint256) {
268     return checkVesting(_owner);
269   }
270   
271   function balanceOfUnlockTokens(address _owner) public view returns (uint256) {
272     return balances[_owner];
273   }
274 }
275 
276 /**
277  * @title Standard ERC20 token
278  *
279  * @dev Implementation of the basic standard token.
280  * https://github.com/ethereum/EIPs/issues/20
281  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
282  */
283 contract StandardToken is ERC20, BasicToken {
284   mapping (address => mapping (address => uint256)) internal allowed;
285 
286   /**
287    * @dev Transfer tokens from one address to another
288    * @param _from address The address which you want to send tokens from
289    * @param _to address The address which you want to transfer to
290    * @param _value uint256 the amount of tokens to be transferred
291    */
292   function transferFrom(
293     address _from,
294     address _to,
295     uint256 _value
296   )
297     public
298     whenNotPaused
299     returns (bool)
300   {
301     require(_to != address(0));
302     require(_value <= balances[_from]);
303     require(_value <= allowed[_from][msg.sender]);
304     require(_value <= checkVesting(_from));
305 
306     if (_to == rubusBlackAddress) {
307       require(!lock);
308       uint256 weiAmount = _value.mul(withdrawCommission).div(priceEthPerToken);
309       require(weiAmount <= uint256(address(this).balance));
310       
311       totalSupply_ = totalSupply_.sub(_value);
312       msg.sender.transfer(weiAmount);
313       withdrawWallet.transfer(weiAmount.mul(uint256(100).sub(withdrawCommission)).div(100));
314       
315       emit Withdraw(msg.sender, weiAmount, _value, priceEthPerToken, withdrawCommission);
316     } else {
317       balances[_to] = balances[_to].add(_value);
318     }
319 
320     balances[_from] = balances[_from].sub(_value);
321     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
322     emit Transfer(_from, _to, _value);
323     return true;
324   }
325 
326   /**
327    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
328    * Beware that changing an allowance with this method brings the risk that someone may use both the old
329    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
330    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
331    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332    * @param _spender The address which will spend the funds.
333    * @param _value The amount of tokens to be spent.
334    */
335   function approve(address _spender, uint256 _value) public returns (bool) {
336     allowed[msg.sender][_spender] = _value;
337     emit Approval(msg.sender, _spender, _value);
338     return true;
339   }
340 
341   /**
342    * @dev Function to check the amount of tokens that an owner allowed to a spender.
343    * @param _owner address The address which owns the funds.
344    * @param _spender address The address which will spend the funds.
345    * @return A uint256 specifying the amount of tokens still available for the spender.
346    */
347   function allowance(
348     address _owner,
349     address _spender
350    )
351     public
352     view
353     returns (uint256)
354   {
355     return allowed[_owner][_spender];
356   }
357 
358   /**
359    * @dev Increase the amount of tokens that an owner allowed to a spender.
360    * approve should be called when allowed[_spender] == 0. To increment
361    * allowed value is better to use this function to avoid 2 calls (and wait until
362    * the first transaction is mined)
363    * From MonolithDAO Token.sol
364    * @param _spender The address which will spend the funds.
365    * @param _addedValue The amount of tokens to increase the allowance by.
366    */
367   function increaseApproval(
368     address _spender,
369     uint256 _addedValue
370   )
371     public
372     returns (bool)
373   {
374     allowed[msg.sender][_spender] = (
375       allowed[msg.sender][_spender].add(_addedValue));
376     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
377     return true;
378   }
379 
380   /**
381    * @dev Decrease the amount of tokens that an owner allowed to a spender.
382    * approve should be called when allowed[_spender] == 0. To decrement
383    * allowed value is better to use this function to avoid 2 calls (and wait until
384    * the first transaction is mined)
385    * From MonolithDAO Token.sol
386    * @param _spender The address which will spend the funds.
387    * @param _subtractedValue The amount of tokens to decrease the allowance by.
388    */
389   function decreaseApproval(
390     address _spender,
391     uint256 _subtractedValue
392   )
393     public
394     returns (bool)
395   {
396     uint256 oldValue = allowed[msg.sender][_spender];
397     if (_subtractedValue > oldValue) {
398       allowed[msg.sender][_spender] = 0;
399     } else {
400       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
401     }
402     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
403     return true;
404   }
405 }
406 
407 contract RubusFundBlackToken is StandardToken {
408 
409   string constant public name = "Rubus Fund Black Token";
410   uint256 constant public decimals = 18;
411   string constant public symbol = "RTB";
412 
413   event Lock(bool lockStatus);
414   event DeleteTokens(address indexed user, uint256 tokensAmount);
415   event AddTokens(address indexed user, uint256 tokensAmount, uint256 _price);
416   event NewTokenPrice(uint256 tokenPrice);
417   event GetWei(uint256 weiAmount);
418   event AddWei(uint256 weiAmount);
419   
420   event DepositCommission(uint256 deposit);
421   event InvestCommission(uint256 invest);
422   event WithdrawCommission(uint256 withdraw);
423   
424   event DepositWallet(address deposit);
425   event InvestWallet(address invest);
426   event WithdrawWallet(address withdraw);
427 
428   constructor() public {
429     rubusBlackAddress = address(this);
430     setNewPrice(33333);
431     lockUp(false);
432     newDepositCommission(100);
433     newInvestCommission(80);
434     newWithdrawCommission(100);
435     newMinimalEthers(500000000000000000);
436     newTokenUnlockPercent(100);
437     newLockTimestamp(2160000);
438     newDepositWallet(0x73D5f035B8CB58b4aF065d6cE49fC8E7288536F3);
439     newInvestWallet(0xf0EF10870308013903bd6Dc8f86E7a7EAF1a86Ab);
440     newWithdraWallet(0x7c4C8b371d4348f7A1fd2e76f05aa60846b442DD);
441   }
442   
443   function _lockPaymentTokens(address sender, uint _amount, uint _date) internal {
444     balancesLock[sender].push(Purchase(_amount, _date));
445   }
446 
447   function priceOf() external view returns(uint256) {
448     return priceEthPerToken;
449   }
450 
451   function () payable external whenNotPaused {
452     require(msg.value >= minimalEthers);
453     uint256 tokens = msg.value.mul(depositCommission).mul(priceEthPerToken).div(10000);
454     
455     totalSupply_ = totalSupply_.add(tokens);
456     uint256 lockTokens = tokens.mul(100).div(lockTokensPercent);
457     
458     _lockPaymentTokens(msg.sender, lockTokens, now.add(lockTimestamp));
459     
460     balances[msg.sender] = balances[msg.sender].add(tokens);
461 
462     investWallet.transfer(msg.value.mul(investCommission).div(100));
463     depositWallet.transfer(msg.value.mul(uint256(100).sub(depositCommission)).div(100)); 
464     
465     emit Transfer(rubusBlackAddress, msg.sender, tokens);
466     emit Deposit(msg.sender, msg.value, tokens, priceEthPerToken, depositCommission);
467   }
468 
469   function getWei(uint256 weiAmount) external onlyOwner {
470     owner.transfer(weiAmount);
471     emit GetWei(weiAmount);
472   }
473 
474   function addEther() payable external onlyOwner {
475     emit AddWei(msg.value);
476   }
477 
478   function airdrop(address[] receiver, uint256[] amount) external onlyOwner {
479     require(receiver.length > 0 && receiver.length == amount.length);
480     
481     for(uint256 i = 0; i < receiver.length; i++) {
482       uint256 tokens = amount[i];
483       totalSupply_ = totalSupply_.add(tokens);
484       balances[receiver[i]] = balances[receiver[i]].add(tokens);
485       emit Transfer(address(this), receiver[i], tokens);
486       emit AddTokens(receiver[i], tokens, priceEthPerToken);
487     }
488   }
489   
490   function deleteInvestorTokens(address[] user, uint256[] amount) external onlyOwner {
491     require(user.length > 0 && user.length == amount.length);
492     
493     for(uint256 i = 0; i < user.length; i++) {
494       uint256 tokens = amount[i];
495       require(tokens <= balances[user[i]]);
496       totalSupply_ = totalSupply_.sub(tokens);
497       balances[user[i]] = balances[user[i]].sub(tokens);
498       emit Transfer(user[i], address(this), tokens);
499       emit DeleteTokens(user[i], tokens);
500     }
501   }
502   
503   function setNewPrice(uint256 _ethPerToken) public onlyOwner {
504     priceEthPerToken = _ethPerToken;
505     emit NewTokenPrice(priceEthPerToken);
506   }
507 
508   function newDepositCommission(uint256 _newDepositCommission) public onlyOwner {
509     depositCommission = _newDepositCommission;
510     emit DepositCommission(depositCommission);
511   }
512   
513   function newInvestCommission(uint256 _newInvestCommission) public onlyOwner {
514     investCommission = _newInvestCommission;
515     emit InvestCommission(investCommission);
516   }
517   
518   function newWithdrawCommission(uint256 _newWithdrawCommission) public onlyOwner {
519     withdrawCommission = _newWithdrawCommission;
520     emit WithdrawCommission(withdrawCommission);
521   }
522   
523   function newDepositWallet(address _depositWallet) public onlyOwner {
524     depositWallet = _depositWallet;
525     emit DepositWallet(depositWallet);
526   }
527   
528   function newInvestWallet(address _investWallet) public onlyOwner {
529     investWallet = _investWallet;
530     emit InvestWallet(investWallet);
531   }
532   
533   function newWithdraWallet(address _withdrawWallet) public onlyOwner {
534     withdrawWallet = _withdrawWallet;
535     emit WithdrawWallet(withdrawWallet);
536   }
537 
538   function lockUp(bool _lock) public onlyOwner {
539     lock = _lock;
540     emit Lock(lock);
541   }
542   
543   function newMinimalEthers(uint256 _weiAMount) public onlyOwner {
544     minimalEthers = _weiAMount;
545   }
546   
547   function newTokenUnlockPercent(uint256 _lockTokensPercent) public onlyOwner {
548     lockTokensPercent = _lockTokensPercent;
549   }
550   
551   function newLockTimestamp(uint256 _lockTimestamp) public onlyOwner {
552     lockTimestamp = _lockTimestamp;
553   }
554 }