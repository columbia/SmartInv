1 pragma solidity ^0.4.23;
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
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Claimable is Ownable {
81   address public pendingOwner;
82 
83   /**
84    * @dev Modifier throws if called by any account other than the pendingOwner.
85    */
86   modifier onlyPendingOwner() {
87     require(msg.sender == pendingOwner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to set the pendingOwner address.
93    */
94   function transferOwnership(address newOwner) public onlyOwner{
95     pendingOwner = newOwner;
96   }
97 
98   /**
99    * @dev Allows the pendingOwner address to finalize the transfer.
100    */
101   function claimOwnership() onlyPendingOwner public {
102     OwnershipTransferred(owner, pendingOwner);
103     owner = pendingOwner;
104     pendingOwner = address(0);
105   }
106 }
107 
108 contract Pausable is Ownable {
109   event Pause();
110   event Unpause();
111 
112   bool public paused = false;
113 
114 
115   /**
116    * @dev Modifier to make a function callable only when the contract is not paused.
117    */
118   modifier whenNotPaused() {
119     require(!paused);
120     _;
121   }
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is paused.
125    */
126   modifier whenPaused() {
127     require(paused);
128     _;
129   }
130 
131   /**
132    * @dev called by the owner to pause, triggers stopped state
133    */
134   function pause() onlyOwner whenNotPaused public {
135     paused = true;
136     emit Pause();
137   }
138 
139   /**
140    * @dev called by the owner to unpause, returns to normal state
141    */
142   function unpause() onlyOwner whenPaused public {
143     paused = false;
144     emit Unpause();
145   }
146 }
147 
148 /**
149  * @title ERC20Basic
150  * @dev Simpler version of ERC20 interface
151  * @dev see https://github.com/ethereum/EIPs/issues/179
152  */
153 contract ERC20Basic {
154   function totalSupply() public view returns (uint256);
155   function balanceOf(address who) public view returns (uint256);
156   function transfer(address to, uint256 value) public returns (bool);
157   event Transfer(address indexed from, address indexed to, uint256 value);
158 }
159 
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
175 contract BasicToken is ERC20Basic {
176   using SafeMath for uint256;
177 
178   mapping(address => uint256) public balances;
179 
180   uint256 totalSupply_;
181 
182   /**
183   * @dev total number of tokens in existence
184   */
185   function totalSupply() public view returns (uint256) {
186     return totalSupply_;
187   }
188 
189   /**
190   * @dev transfer token for a specified address
191   * @param _to The address to transfer to.
192   * @param _value The amount to be transferred.
193   */
194   function transfer(address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     require(_value <= balances[msg.sender]);
197 
198     balances[msg.sender] = balances[msg.sender].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     emit Transfer(msg.sender, _to, _value);
201     return true;
202   }
203 
204   /**
205   * @dev Gets the balance of the specified address.
206   * @param _owner The address to query the the balance of.
207   * @return An uint256 representing the amount owned by the passed address.
208   */
209   function balanceOf(address _owner) public view returns (uint256) {
210     return balances[_owner];
211   }
212 
213 }
214 
215 
216 contract BurnableToken is BasicToken {
217 
218   event Burn(address indexed burner, uint256 value);
219 
220   /**
221    * @dev Burns a specific amount of tokens.
222    * @param _value The amount of token to be burned.
223    */
224   function burn(uint256 _value) public {
225     _burn(msg.sender, _value);
226   }
227 
228   function _burn(address _who, uint256 _value) internal {
229     require(_value <= balances[_who]);
230     // no need to require value <= totalSupply, since that would imply the
231     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
232 
233     balances[_who] = balances[_who].sub(_value);
234     totalSupply_ = totalSupply_.sub(_value);
235     emit Burn(_who, _value);
236     emit Transfer(_who, address(0), _value);
237   }
238 }
239 
240 contract StandardToken is ERC20, BasicToken {
241 
242   mapping (address => mapping (address => uint256)) internal allowed;
243 
244 
245   /**
246    * @dev Transfer tokens from one address to another
247    * @param _from address The address which you want to send tokens from
248    * @param _to address The address which you want to transfer to
249    * @param _value uint256 the amount of tokens to be transferred
250    */
251   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
252     require(_to != address(0));
253     require(_value <= balances[_from]);
254     require(_value <= allowed[_from][msg.sender]);
255 
256     balances[_from] = balances[_from].sub(_value);
257     balances[_to] = balances[_to].add(_value);
258     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259     emit Transfer(_from, _to, _value);
260     return true;
261   }
262 
263   /**
264    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
265    *
266    * Beware that changing an allowance with this method brings the risk that someone may use both the old
267    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
268    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
269    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270    * @param _spender The address which will spend the funds.
271    * @param _value The amount of tokens to be spent.
272    */
273   function approve(address _spender, uint256 _value) public returns (bool) {
274     allowed[msg.sender][_spender] = _value;
275     emit Approval(msg.sender, _spender, _value);
276     return true;
277   }
278 
279   /**
280    * @dev Function to check the amount of tokens that an owner allowed to a spender.
281    * @param _owner address The address which owns the funds.
282    * @param _spender address The address which will spend the funds.
283    * @return A uint256 specifying the amount of tokens still available for the spender.
284    */
285   function allowance(address _owner, address _spender) public view returns (uint256) {
286     return allowed[_owner][_spender];
287   }
288 
289   /**
290    * @dev Increase the amount of tokens that an owner allowed to a spender.
291    *
292    * approve should be called when allowed[_spender] == 0. To increment
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    * @param _spender The address which will spend the funds.
297    * @param _addedValue The amount of tokens to increase the allowance by.
298    */
299   function increaseApproval(address _spender, uint _addedValue) public returns (bool){
300     allowed[msg.sender][_spender] = (
301       allowed[msg.sender][_spender].add(_addedValue));
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306   /**
307    * @dev Decrease the amount of tokens that an owner allowed to a spender.
308    *
309    * approve should be called when allowed[_spender] == 0. To decrement
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param _spender The address which will spend the funds.
314    * @param _subtractedValue The amount of tokens to decrease the allowance by.
315    */
316   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){
317     uint oldValue = allowed[msg.sender][_spender];
318     if (_subtractedValue > oldValue) {
319       allowed[msg.sender][_spender] = 0;
320     } else {
321       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
322     }
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 }
327 
328 contract PausableToken is StandardToken, Pausable {
329 
330   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
331     return super.transfer(_to, _value);
332   }
333 
334   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
335     return super.transferFrom(_from, _to, _value);
336   }
337 
338   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
339     return super.approve(_spender, _value);
340   }
341 
342   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
343     return super.increaseApproval(_spender, _addedValue);
344   }
345 
346   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success)
347   {
348     return super.decreaseApproval(_spender, _subtractedValue);
349   }
350 }
351 
352 contract ComissionList is Claimable {
353   using SafeMath for uint256;
354 
355   struct Transfer {
356     uint256 stat;
357     uint256 perc;
358   }
359 
360   mapping (string => Transfer) refillPaySystemInfo;
361   mapping (string => Transfer) widthrawPaySystemInfo;
362 
363   Transfer transferInfo;
364 
365   event RefillCommisionIsChanged(string _paySystem, uint256 stat, uint256 perc);
366   event WidthrawCommisionIsChanged(string _paySystem, uint256 stat, uint256 perc);
367   event TransferCommisionIsChanged(uint256 stat, uint256 perc);
368 
369   // установить информацию по комиссии для пополняемой платёжной системы
370   function setRefillFor(string _paySystem, uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {
371     refillPaySystemInfo[_paySystem].stat = _stat;
372     refillPaySystemInfo[_paySystem].perc = _perc;
373 
374     RefillCommisionIsChanged(_paySystem, _stat, _perc);
375   }
376 
377   // установить информацию по комиссии для снимаеомй платёжной системы
378   function setWidthrawFor(string _paySystem,uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {
379     widthrawPaySystemInfo[_paySystem].stat = _stat;
380     widthrawPaySystemInfo[_paySystem].perc = _perc;
381 
382     WidthrawCommisionIsChanged(_paySystem, _stat, _perc);
383   }
384 
385   // установить информацию по комиссии для перевода
386   function setTransfer(uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {
387     transferInfo.stat = _stat;
388     transferInfo.perc = _perc;
389 
390     TransferCommisionIsChanged(_stat, _perc);
391   }
392 
393   // взять процент по комиссии для пополняемой платёжной системы
394   function getRefillStatFor(string _paySystem) public view returns (uint256) {
395     return refillPaySystemInfo[_paySystem].perc;
396   }
397 
398   // взять фикс по комиссии для пополняемой платёжной системы
399   function getRefillPercFor(string _paySystem) public view returns (uint256) {
400     return refillPaySystemInfo[_paySystem].stat;
401   }
402 
403   // взять процент по комиссии для снимаемой платёжной системы
404   function getWidthrawStatFor(string _paySystem) public view returns (uint256) {
405     return widthrawPaySystemInfo[_paySystem].perc;
406   }
407 
408   // взять фикс по комиссии для снимаемой платёжной системы
409   function getWidthrawPercFor(string _paySystem) public view returns (uint256) {
410     return widthrawPaySystemInfo[_paySystem].stat;
411   }
412 
413   // взять процент по комиссии для перевода
414   function getTransferPerc() public view returns (uint256) {
415     return transferInfo.perc;
416   }
417   
418   // взять фикс по комиссии для перевода
419   function getTransferStat() public view returns (uint256) {
420     return transferInfo.stat;
421   }
422 
423   // рассчитать комиссию со снятия для платёжной системы и суммы
424   function calcWidthraw(string _paySystem, uint256 _value) public view returns(uint256) {
425     uint256 _totalComission;
426     _totalComission = widthrawPaySystemInfo[_paySystem].stat + (_value / 100 ) * widthrawPaySystemInfo[_paySystem].perc;
427 
428     return _totalComission;
429   }
430 
431   // рассчитать комиссию с пополнения для платёжной системы и суммы
432   function calcRefill(string _paySystem, uint256 _value) public view returns(uint256) {
433     uint256 _totalComission;
434     _totalComission = refillPaySystemInfo[_paySystem].stat + (_value / 100 ) * refillPaySystemInfo[_paySystem].perc;
435 
436     return _totalComission;
437   }
438 
439   // рассчитать комиссию с перевода для платёжной системы и суммы
440   function calcTransfer(uint256 _value) public view returns(uint256) {
441     uint256 _totalComission;
442     _totalComission = transferInfo.stat + (_value / 100 ) * transferInfo.perc;
443 
444     return _totalComission;
445   }
446 }
447 
448 contract EvaCurrency is PausableToken, BurnableToken {
449   string public name = "EvaUSD";
450   string public symbol = "EUSD";
451 
452   ComissionList public comissionList;
453 
454   uint8 public constant decimals = 3;
455 
456   mapping(address => uint) lastUsedNonce;
457 
458   address public staker;
459 
460   event Mint(address indexed to, uint256 amount);
461 
462   function EvaCurrency(string _name, string _symbol) public {
463     name = _name;
464     symbol = _symbol;
465     staker = msg.sender;
466   }
467 
468   function changeName(string _name, string _symbol) onlyOwner public {
469       name = _name;
470       symbol = _symbol;
471   }
472 
473   function setComissionList(ComissionList _comissionList) onlyOwner public {
474     comissionList = _comissionList;
475   }
476 
477   modifier onlyStaker() {
478     require(msg.sender == staker);
479     _;
480   }
481 
482   // Перевод между кошельками по VRS
483   function transferOnBehalf(address _to, uint _amount, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) onlyStaker public returns (bool success) {
484     uint256 fee;
485     uint256 resultAmount;
486     bytes32 hash = keccak256(_to, _amount, _nonce, address(this));
487     address sender = ecrecover(hash, _v, _r, _s);
488 
489     require(lastUsedNonce[sender] < _nonce);
490     require(_amount <= balances[sender]);
491 
492     fee = comissionList.calcTransfer(_amount);
493     resultAmount = _amount.sub(fee);
494 
495     balances[sender] = balances[sender].sub(_amount);
496     balances[_to] = balances[_to].add(resultAmount);
497     balances[staker] = balances[staker].add(fee);
498     lastUsedNonce[sender] = _nonce;
499     
500     emit Transfer(sender, _to, _amount);
501     emit Transfer(sender, address(0), fee);
502     return true;
503   }
504 
505   function withdrawOnBehalf(uint _amount, string _paySystem, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) onlyStaker public returns (bool success) {
506     uint256 fee;
507     uint256 resultAmount;
508     bytes32 hash = keccak256(address(0), _amount, _nonce, address(this));
509     address sender = ecrecover(hash, _v, _r, _s);
510 
511     require(lastUsedNonce[sender] < _nonce);
512     require(_amount <= balances[sender]);
513 
514     fee = comissionList.calcWidthraw(_paySystem, _amount);
515     resultAmount = _amount.sub(fee);
516 
517     balances[sender] = balances[sender].sub(_amount);
518     balances[staker] = balances[staker].add(fee);
519     totalSupply_ = totalSupply_.sub(resultAmount);
520 
521     emit Transfer(sender, address(0), resultAmount);
522     Burn(sender, resultAmount);
523     return true;
524   }
525 
526   // Пополнение баланса пользователя, так-же отправляет комиссию для staker
527   // _to - адрес пополняемого кошелька, _amount - сумма, _paySystem - платёжная система
528   function refill(address _to, uint256 _amount, string _paySystem) onlyStaker public returns (bool success) {
529       uint256 fee;
530       uint256 resultAmount;
531 
532       fee = comissionList.calcRefill(_paySystem, _amount);
533       resultAmount = _amount.sub(fee);
534 
535       balances[_to] = balances[_to].add(resultAmount);
536       balances[staker] = balances[staker].add(fee);
537       totalSupply_ = totalSupply_.add(_amount);
538 
539       emit Transfer(address(0), _to, resultAmount);
540       Mint(_to, resultAmount);
541       return true;
542   }
543 
544   function changeStaker(address _staker) onlyOwner public returns (bool success) {
545     staker = _staker;
546   }
547   
548   function getNullAddress() public view returns (address) {
549     return address(0);
550   }
551 }