1 pragma solidity ^0.4.24;
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
248     uint256 availableTokens = 0;
249     for (uint i = 0; i < balancesLock[sender].length; i++) {
250       (uint lockTokens, uint lockTime) = getPurchases(sender, i);
251       if(now >= lockTime) {
252         availableTokens = availableTokens.add(lockTokens);
253       }
254     }
255     
256     return availableTokens;
257   }
258 
259   /**
260   * @dev Gets the balance of the specified address.
261   * @param _owner The address to query the the balance of.
262   * @return An uint256 representing the amount owned by the passed address.
263   */
264   function balanceOf(address _owner) public view returns (uint256) {
265     return checkVesting(_owner);
266   }
267   
268   function balanceOfUnlockTokens(address _owner) public view returns (uint256) {
269     return balances[_owner];
270   }
271 }
272 
273 /**
274  * @title Standard ERC20 token
275  *
276  * @dev Implementation of the basic standard token.
277  * https://github.com/ethereum/EIPs/issues/20
278  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
279  */
280 contract StandardToken is ERC20, BasicToken {
281   mapping (address => mapping (address => uint256)) internal allowed;
282 
283   /**
284    * @dev Transfer tokens from one address to another
285    * @param _from address The address which you want to send tokens from
286    * @param _to address The address which you want to transfer to
287    * @param _value uint256 the amount of tokens to be transferred
288    */
289   function transferFrom(
290     address _from,
291     address _to,
292     uint256 _value
293   )
294     public
295     whenNotPaused
296     returns (bool)
297   {
298     require(_to != address(0));
299     require(_value <= balances[_from]);
300     require(_value <= allowed[_from][msg.sender]);
301     require(_value <= checkVesting(_from));
302 
303     if (_to == rubusBlackAddress) {
304       require(!lock);
305       uint256 weiAmount = _value.mul(withdrawCommission).div(priceEthPerToken);
306       require(weiAmount <= uint256(address(this).balance));
307       
308       totalSupply_ = totalSupply_.sub(_value);
309       msg.sender.transfer(weiAmount);
310       withdrawWallet.transfer(weiAmount.mul(uint256(100).sub(withdrawCommission)).div(100));
311       
312       emit Withdraw(msg.sender, weiAmount, _value, priceEthPerToken, withdrawCommission);
313     } else {
314       balances[_to] = balances[_to].add(_value);
315     }
316 
317     balances[_from] = balances[_from].sub(_value);
318     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
319     emit Transfer(_from, _to, _value);
320     return true;
321   }
322 
323   /**
324    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
325    * Beware that changing an allowance with this method brings the risk that someone may use both the old
326    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
327    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
328    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
329    * @param _spender The address which will spend the funds.
330    * @param _value The amount of tokens to be spent.
331    */
332   function approve(address _spender, uint256 _value) public returns (bool) {
333     allowed[msg.sender][_spender] = _value;
334     emit Approval(msg.sender, _spender, _value);
335     return true;
336   }
337 
338   /**
339    * @dev Function to check the amount of tokens that an owner allowed to a spender.
340    * @param _owner address The address which owns the funds.
341    * @param _spender address The address which will spend the funds.
342    * @return A uint256 specifying the amount of tokens still available for the spender.
343    */
344   function allowance(
345     address _owner,
346     address _spender
347    )
348     public
349     view
350     returns (uint256)
351   {
352     return allowed[_owner][_spender];
353   }
354 
355   /**
356    * @dev Increase the amount of tokens that an owner allowed to a spender.
357    * approve should be called when allowed[_spender] == 0. To increment
358    * allowed value is better to use this function to avoid 2 calls (and wait until
359    * the first transaction is mined)
360    * From MonolithDAO Token.sol
361    * @param _spender The address which will spend the funds.
362    * @param _addedValue The amount of tokens to increase the allowance by.
363    */
364   function increaseApproval(
365     address _spender,
366     uint256 _addedValue
367   )
368     public
369     returns (bool)
370   {
371     allowed[msg.sender][_spender] = (
372       allowed[msg.sender][_spender].add(_addedValue));
373     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
374     return true;
375   }
376 
377   /**
378    * @dev Decrease the amount of tokens that an owner allowed to a spender.
379    * approve should be called when allowed[_spender] == 0. To decrement
380    * allowed value is better to use this function to avoid 2 calls (and wait until
381    * the first transaction is mined)
382    * From MonolithDAO Token.sol
383    * @param _spender The address which will spend the funds.
384    * @param _subtractedValue The amount of tokens to decrease the allowance by.
385    */
386   function decreaseApproval(
387     address _spender,
388     uint256 _subtractedValue
389   )
390     public
391     returns (bool)
392   {
393     uint256 oldValue = allowed[msg.sender][_spender];
394     if (_subtractedValue > oldValue) {
395       allowed[msg.sender][_spender] = 0;
396     } else {
397       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
398     }
399     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
400     return true;
401   }
402 }
403 
404 contract RubusFundBlackToken is StandardToken {
405 
406   string constant public name = "Rubus Fund Black Token";
407   uint256 constant public decimals = 18;
408   string constant public symbol = "RTB";
409 
410   event Lock(bool lockStatus);
411   event DeleteTokens(address user, uint256 tokensAmount);
412   event AddTokens(address user, uint256 tokensAmount);
413   event NewTokenPrice(uint256 tokenPrice);
414   event GetWei(uint256 weiAmount);
415   event AddWei(uint256 weiAmount);
416   
417   event DepositCommission(uint256 deposit);
418   event InvestCommission(uint256 invest);
419   event WithdrawCommission(uint256 withdraw);
420   
421   event DepositWallet(address deposit);
422   event InvestWallet(address invest);
423   event WithdrawWallet(address withdraw);
424 
425   constructor() public {
426     rubusBlackAddress = address(this);
427     setNewPrice(33333);
428     lockUp(false);
429     newDepositCommission(100);
430     newInvestCommission(80);
431     newWithdrawCommission(100);
432     newMinimalEthers(500000000000000000);
433     newTokenUnlockPercent(100);
434     newLockTimestamp(2592000);
435     newDepositWallet(0x73D5f035B8CB58b4aF065d6cE49fC8E7288536F3);
436     newInvestWallet(0xf0EF10870308013903bd6Dc8f86E7a7EAF1a86Ab);
437     newWithdraWallet(0x7c4C8b371d4348f7A1fd2e76f05aa60846b442DD);
438   }
439   
440   function _lockPaymentTokens(address sender, uint _amount, uint _date) internal {
441     balancesLock[sender].push(Purchase(_amount, _date));
442   }
443 
444   function () payable external whenNotPaused {
445     require(msg.value >= minimalEthers);
446     uint256 tokens = msg.value.mul(depositCommission).mul(priceEthPerToken).div(10000);
447     
448     totalSupply_ = totalSupply_.add(tokens);
449     uint256 lockTokens = tokens.mul(100).div(lockTokensPercent);
450     
451     // balancesLock[msg.sender] = balancesLock[msg.sender].add(tokens);
452     _lockPaymentTokens(msg.sender, lockTokens, now.add(lockTimestamp));
453     
454     balances[msg.sender] = balances[msg.sender].add(tokens);
455 
456     investWallet.transfer(msg.value.mul(investCommission).div(100));
457     depositWallet.transfer(msg.value.mul(uint256(100).sub(depositCommission)).div(100)); 
458     
459     emit Transfer(rubusBlackAddress, msg.sender, tokens);
460     emit Deposit(msg.sender, msg.value, tokens, priceEthPerToken, depositCommission);
461   }
462 
463   function getWei(uint256 weiAmount) external onlyOwner {
464     owner.transfer(weiAmount);
465     emit GetWei(weiAmount);
466   }
467 
468   function addEther() payable external onlyOwner {
469     emit AddWei(msg.value);
470   }
471 
472   function airdrop(address[] receiver, uint256[] amount) external onlyOwner {
473     require(receiver.length > 0 && receiver.length == amount.length);
474     
475     for(uint256 i = 0; i < receiver.length; i++) {
476       uint256 tokens = amount[i];
477       totalSupply_ = totalSupply_.add(tokens);
478       balances[receiver[i]] = balances[receiver[i]].add(tokens);
479       emit Transfer(address(this), receiver[i], tokens);
480       emit AddTokens(receiver[i], tokens);
481     }
482   }
483   
484   function deleteInvestorTokens(address[] user, uint256[] amount) external onlyOwner {
485     require(user.length > 0 && user.length == amount.length);
486     
487     for(uint256 i = 0; i < user.length; i++) {
488       uint256 tokens = amount[i];
489       require(tokens <= balances[user[i]]);
490       totalSupply_ = totalSupply_.sub(tokens);
491       balances[user[i]] = balances[user[i]].sub(tokens);
492       emit Transfer(user[i], address(this), tokens);
493       emit DeleteTokens(user[i], tokens);
494     }
495   }
496   
497   function setNewPrice(uint256 _ethPerToken) public onlyOwner {
498     priceEthPerToken = _ethPerToken;
499     emit NewTokenPrice(priceEthPerToken);
500   }
501 
502   function newDepositCommission(uint256 _newDepositCommission) public onlyOwner {
503     depositCommission = _newDepositCommission;
504     emit DepositCommission(depositCommission);
505   }
506   
507   function newInvestCommission(uint256 _newInvestCommission) public onlyOwner {
508     investCommission = _newInvestCommission;
509     emit InvestCommission(investCommission);
510   }
511   
512   function newWithdrawCommission(uint256 _newWithdrawCommission) public onlyOwner {
513     withdrawCommission = _newWithdrawCommission;
514     emit WithdrawCommission(withdrawCommission);
515   }
516   
517   function newDepositWallet(address _depositWallet) public onlyOwner {
518     depositWallet = _depositWallet;
519     emit DepositWallet(depositWallet);
520   }
521   
522   function newInvestWallet(address _investWallet) public onlyOwner {
523     investWallet = _investWallet;
524     emit InvestWallet(investWallet);
525   }
526   
527   function newWithdraWallet(address _withdrawWallet) public onlyOwner {
528     withdrawWallet = _withdrawWallet;
529     emit WithdrawWallet(withdrawWallet);
530   }
531 
532   function lockUp(bool _lock) public onlyOwner {
533     lock = _lock;
534     emit Lock(lock);
535   }
536   
537   function newMinimalEthers(uint256 _weiAMount) public onlyOwner {
538     minimalEthers = _weiAMount;
539   }
540   
541   function newTokenUnlockPercent(uint256 _lockTokensPercent) public onlyOwner {
542     lockTokensPercent = _lockTokensPercent;
543   }
544   
545   function newLockTimestamp(uint256 _lockTimestamp) public onlyOwner {
546     lockTimestamp = _lockTimestamp;
547   }
548 }