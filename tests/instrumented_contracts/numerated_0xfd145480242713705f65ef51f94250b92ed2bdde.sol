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
212 }
213 
214 
215 contract BurnableToken is BasicToken {
216 
217   event Burn(address indexed burner, uint256 value);
218 
219   /**
220    * @dev Burns a specific amount of tokens.
221    * @param _value The amount of token to be burned.
222    */
223   function burn(uint256 _value) public {
224     _burn(msg.sender, _value);
225   }
226 
227   function _burn(address _who, uint256 _value) internal {
228     require(_value <= balances[_who]);
229     // no need to require value <= totalSupply, since that would imply the
230     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
231 
232     balances[_who] = balances[_who].sub(_value);
233     totalSupply_ = totalSupply_.sub(_value);
234     emit Burn(_who, _value);
235     emit Transfer(_who, address(0), _value);
236   }
237 }
238 
239 contract StandardToken is ERC20, BasicToken {
240 
241   mapping (address => mapping (address => uint256)) internal allowed;
242 
243 
244   /**
245    * @dev Transfer tokens from one address to another
246    * @param _from address The address which you want to send tokens from
247    * @param _to address The address which you want to transfer to
248    * @param _value uint256 the amount of tokens to be transferred
249    */
250   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
251     require(_to != address(0));
252     require(_value <= balances[_from]);
253     require(_value <= allowed[_from][msg.sender]);
254 
255     balances[_from] = balances[_from].sub(_value);
256     balances[_to] = balances[_to].add(_value);
257     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
258     emit Transfer(_from, _to, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
264    *
265    * Beware that changing an allowance with this method brings the risk that someone may use both the old
266    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269    * @param _spender The address which will spend the funds.
270    * @param _value The amount of tokens to be spent.
271    */
272   function approve(address _spender, uint256 _value) public returns (bool) {
273     allowed[msg.sender][_spender] = _value;
274     emit Approval(msg.sender, _spender, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Function to check the amount of tokens that an owner allowed to a spender.
280    * @param _owner address The address which owns the funds.
281    * @param _spender address The address which will spend the funds.
282    * @return A uint256 specifying the amount of tokens still available for the spender.
283    */
284   function allowance(address _owner, address _spender) public view returns (uint256) {
285     return allowed[_owner][_spender];
286   }
287 
288   /**
289    * @dev Increase the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To increment
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _addedValue The amount of tokens to increase the allowance by.
297    */
298   function increaseApproval(address _spender, uint _addedValue) public returns (bool){
299     allowed[msg.sender][_spender] = (
300       allowed[msg.sender][_spender].add(_addedValue));
301     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305   /**
306    * @dev Decrease the amount of tokens that an owner allowed to a spender.
307    *
308    * approve should be called when allowed[_spender] == 0. To decrement
309    * allowed value is better to use this function to avoid 2 calls (and wait until
310    * the first transaction is mined)
311    * From MonolithDAO Token.sol
312    * @param _spender The address which will spend the funds.
313    * @param _subtractedValue The amount of tokens to decrease the allowance by.
314    */
315   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){
316     uint oldValue = allowed[msg.sender][_spender];
317     if (_subtractedValue > oldValue) {
318       allowed[msg.sender][_spender] = 0;
319     } else {
320       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
321     }
322     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 }
326 
327 contract PausableToken is StandardToken, Pausable {
328 
329   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
330     return super.transfer(_to, _value);
331   }
332 
333   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
334     return super.transferFrom(_from, _to, _value);
335   }
336 
337   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
338     return super.approve(_spender, _value);
339   }
340 
341   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
342     return super.increaseApproval(_spender, _addedValue);
343   }
344 
345   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success)
346   {
347     return super.decreaseApproval(_spender, _subtractedValue);
348   }
349 }
350 
351 contract ComissionList is Claimable {
352   using SafeMath for uint256;
353 
354   struct Transfer {
355     uint256 stat;
356     uint256 perc;
357   }
358 
359   mapping (string => Transfer) refillPaySystemInfo;
360   mapping (string => Transfer) widthrawPaySystemInfo;
361 
362   Transfer transferInfo;
363 
364   event RefillCommisionIsChanged(string _paySystem, uint256 stat, uint256 perc);
365   event WidthrawCommisionIsChanged(string _paySystem, uint256 stat, uint256 perc);
366   event TransferCommisionIsChanged(uint256 stat, uint256 perc);
367 
368   // установить информацию по комиссии для пополняемой платёжной системы
369   function setRefillFor(string _paySystem, uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {
370     refillPaySystemInfo[_paySystem].stat = _stat;
371     refillPaySystemInfo[_paySystem].perc = _perc;
372 
373     RefillCommisionIsChanged(_paySystem, _stat, _perc);
374   }
375 
376   // установить информацию по комиссии для снимаеомй платёжной системы
377   function setWidthrawFor(string _paySystem,uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {
378     widthrawPaySystemInfo[_paySystem].stat = _stat;
379     widthrawPaySystemInfo[_paySystem].perc = _perc;
380 
381     WidthrawCommisionIsChanged(_paySystem, _stat, _perc);
382   }
383 
384   // установить информацию по комиссии для перевода
385   function setTransfer(uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {
386     transferInfo.stat = _stat;
387     transferInfo.perc = _perc;
388 
389     TransferCommisionIsChanged(_stat, _perc);
390   }
391 
392   // взять процент по комиссии для пополняемой платёжной системы
393   function getRefillStatFor(string _paySystem) public view returns (uint256) {
394     return refillPaySystemInfo[_paySystem].perc;
395   }
396 
397   // взять фикс по комиссии для пополняемой платёжной системы
398   function getRefillPercFor(string _paySystem) public view returns (uint256) {
399     return refillPaySystemInfo[_paySystem].stat;
400   }
401 
402   // взять процент по комиссии для снимаемой платёжной системы
403   function getWidthrawStatFor(string _paySystem) public view returns (uint256) {
404     return widthrawPaySystemInfo[_paySystem].perc;
405   }
406 
407   // взять фикс по комиссии для снимаемой платёжной системы
408   function getWidthrawPercFor(string _paySystem) public view returns (uint256) {
409     return widthrawPaySystemInfo[_paySystem].stat;
410   }
411 
412   // взять процент по комиссии для перевода
413   function getTransferPerc() public view returns (uint256) {
414     return transferInfo.perc;
415   }
416   
417   // взять фикс по комиссии для перевода
418   function getTransferStat() public view returns (uint256) {
419     return transferInfo.stat;
420   }
421 
422   // рассчитать комиссию со снятия для платёжной системы и суммы
423   function calcWidthraw(string _paySystem, uint256 _value) public view returns(uint256) {
424     uint256 _totalComission;
425     _totalComission = widthrawPaySystemInfo[_paySystem].stat + (_value / 100 ) * widthrawPaySystemInfo[_paySystem].perc;
426 
427     return _totalComission;
428   }
429 
430   // рассчитать комиссию с пополнения для платёжной системы и суммы
431   function calcRefill(string _paySystem, uint256 _value) public view returns(uint256) {
432     uint256 _totalComission;
433     _totalComission = refillPaySystemInfo[_paySystem].stat + (_value / 100 ) * refillPaySystemInfo[_paySystem].perc;
434 
435     return _totalComission;
436   }
437 
438   // рассчитать комиссию с перевода для платёжной системы и суммы
439   function calcTransfer(uint256 _value) public view returns(uint256) {
440     uint256 _totalComission;
441     _totalComission = transferInfo.stat + (_value / 100 ) * transferInfo.perc;
442 
443     return _totalComission;
444   }
445 }
446 
447 contract AddressList is Claimable {
448     string public name;
449     mapping (address => bool) public onList;
450 
451     function AddressList(string _name, bool nullValue) public {
452         name = _name;
453         onList[0x0] = nullValue;
454     }
455     event ChangeWhiteList(address indexed to, bool onList);
456 
457     // Set whether _to is on the list or not. Whether 0x0 is on the list
458     // or not cannot be set here - it is set once and for all by the constructor.
459     function changeList(address _to, bool _onList) onlyOwner public {
460         require(_to != 0x0);
461         if (onList[_to] != _onList) {
462             onList[_to] = _onList;
463             ChangeWhiteList(_to, _onList);
464         }
465     }
466 }
467 
468 contract EvaCurrency is PausableToken, BurnableToken {
469   string public name = "EvaUSD";
470   string public symbol = "EUSD";
471 
472   ComissionList public comissionList;
473   AddressList public moderList;
474 
475   uint8 public constant decimals = 3;
476 
477   mapping(address => uint) lastUsedNonce;
478 
479   address public staker;
480 
481   event Mint(address indexed to, uint256 amount);
482 
483   function EvaCurrency(string _name, string _symbol) public {
484     name = _name;
485     symbol = _symbol;
486     staker = msg.sender;
487   }
488 
489   function changeName(string _name, string _symbol) onlyOwner public {
490       name = _name;
491       symbol = _symbol;
492   }
493 
494   function setComissionList(ComissionList _comissionList, AddressList _moderList) onlyOwner public {
495     comissionList = _comissionList;
496     moderList = _moderList;
497   }
498 
499   modifier onlyModer() {
500     require(moderList.onList(msg.sender));
501     _;
502   }
503 
504   // Перевод между кошельками по VRS
505   function transferOnBehalf(address _to, uint _amount, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) onlyModer public returns (bool success) {
506     uint256 fee;
507     uint256 resultAmount;
508     bytes32 hash = keccak256(_to, _amount, _nonce, address(this));
509     address sender = ecrecover(hash, _v, _r, _s);
510 
511     require(lastUsedNonce[sender] < _nonce);
512     require(_amount <= balances[sender]);
513 
514     fee = comissionList.calcTransfer(_amount);
515     resultAmount = _amount.sub(fee);
516 
517     balances[sender] = balances[sender].sub(_amount);
518     balances[_to] = balances[_to].add(resultAmount);
519     balances[staker] = balances[staker].add(fee);
520     lastUsedNonce[sender] = _nonce;
521     
522     emit Transfer(sender, _to, _amount);
523     emit Transfer(sender, address(0), fee);
524     return true;
525   }
526 
527   // Вывод с кошелька по VRS
528   function withdrawOnBehalf(uint _amount, string _paySystem, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) onlyModer public returns (bool success) {
529     uint256 fee;
530     uint256 resultAmount;
531     bytes32 hash = keccak256(address(0), _amount, _nonce, address(this));
532     address sender = ecrecover(hash, _v, _r, _s);
533 
534     require(lastUsedNonce[sender] < _nonce);
535     require(_amount <= balances[sender]);
536 
537     fee = comissionList.calcWidthraw(_paySystem, _amount);
538     resultAmount = _amount.sub(fee);
539 
540     balances[sender] = balances[sender].sub(_amount);
541     balances[staker] = balances[staker].add(fee);
542     totalSupply_ = totalSupply_.sub(resultAmount);
543 
544     emit Transfer(sender, address(0), resultAmount);
545     Burn(sender, resultAmount);
546     return true;
547   }
548 
549   // Пополнение баланса пользователя
550   // _to - адрес пополняемого кошелька, _amount - сумма, _paySystem - платёжная система
551   function refill(address _to, uint256 _amount, string _paySystem) onlyModer public returns (bool success) {
552       uint256 fee;
553       uint256 resultAmount;
554 
555       fee = comissionList.calcRefill(_paySystem, _amount);
556       resultAmount = _amount.sub(fee);
557 
558       balances[_to] = balances[_to].add(resultAmount);
559       balances[staker] = balances[staker].add(fee);
560       totalSupply_ = totalSupply_.add(_amount);
561 
562       emit Transfer(address(0), _to, resultAmount);
563       Mint(_to, resultAmount);
564       return true;
565   }
566 
567   function changeStaker(address _staker) onlyOwner public returns (bool success) {
568     staker = _staker;
569   }
570   
571   function getNullAddress() public view returns (address) {
572     return address(0);
573   }
574 }