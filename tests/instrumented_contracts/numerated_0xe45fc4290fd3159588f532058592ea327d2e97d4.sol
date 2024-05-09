1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: contracts/TokenLockUp.sol
322 
323 contract TokenLockUp is StandardToken, Ownable {
324   using SafeMath for uint256;
325 
326   struct LockUp {
327     uint256 startTime;
328     uint256 endTime;
329     uint256 lockamount;
330   }
331 
332   string public name;
333   string public symbol;
334   uint public decimals;
335 
336   mapping (address => LockUp[]) addressLock;
337 
338   event Lock(address indexed from, address indexed to, uint256 amount, uint256 startTime, uint256 endTime);
339 
340   constructor (uint _initialSupply, string _name, string _symbol, uint _decimals) public {
341     require(_initialSupply >= 0);
342     require(_decimals >= 0);
343 
344     totalSupply_ = _initialSupply;
345     balances[msg.sender] = _initialSupply;
346     owner = msg.sender;
347     name = _name;
348     symbol = _symbol;
349     decimals = _decimals;
350     emit Transfer(address(0), msg.sender, _initialSupply);
351   }
352 
353   modifier checkLock (uint _amount) {
354     require(_amount >= 0);
355 
356     // mappingを取得
357     LockUp[] storage lockData = addressLock[msg.sender];
358 
359     uint256 lockAmountNow;
360     for (uint256 i = 0; i < lockData.length; i++) {
361       LockUp memory temp = lockData[i];
362 
363       // ロック期間内で最大のロック量をもつロックデータを取得する
364       if (block.timestamp >= temp.startTime && block.timestamp < temp.endTime) {
365         lockAmountNow = lockAmountNow.add(temp.lockamount);
366       }
367     }
368 
369     // 現在時間がLOCK UP期間か判断
370     if (lockAmountNow == 0) {
371       // 期間外 => 所有量と比較
372       require(balances[msg.sender] >= _amount);
373     } else {
374       // 期間内 => 所有量 - LOCK UP量 と比較
375       require(balances[msg.sender].sub(lockAmountNow) >= _amount);
376     }
377     _;
378   }
379 
380   function lockUp(address _to, uint256 _amount, uint256 _startTime, uint256 _endTime) public onlyOwner returns (bool) {
381     require(_to != address(0));
382     require(_amount >= 0);
383     require(_endTime >= 0);
384     require(_startTime < _endTime);
385 
386     LockUp memory temp;
387     temp.lockamount = _amount;
388     temp.startTime = block.timestamp.add(_startTime);
389     temp.endTime = block.timestamp.add(_endTime);
390     addressLock[_to].push(temp);
391     emit Lock(msg.sender, _to, _amount, temp.startTime, temp.endTime);
392     return true;
393   }
394 
395   function lockBatch(address[] _addresses, uint256[] _amounts, uint256[] _startTimes, uint256[] _endTimes) public onlyOwner returns (bool) {
396     require(_addresses.length == _amounts.length && _amounts.length == _startTimes.length && _startTimes.length == _endTimes.length);
397     for (uint256 i = 0; i < _amounts.length; i++) {
398       lockUp(_addresses[i], _amounts[i], _startTimes[i], _endTimes[i]);
399     }
400     return true;
401   }
402 
403   function getLockTime(address _to) public view returns (uint256, uint256) {
404     // mappingを取得
405     LockUp[] storage lockData = addressLock[_to];
406 
407     uint256 lockAmountNow;
408     uint256 lockLimit;
409     for (uint256 i = 0; i < lockData.length; i++) {
410       LockUp memory temp = lockData[i];
411 
412       // ロック期間内で最大のロック量をもつロックデータを取得する
413       if (block.timestamp >= temp.startTime && block.timestamp < temp.endTime) {
414         lockAmountNow = lockAmountNow.add(temp.lockamount);
415         if (lockLimit == 0 || lockLimit > temp.endTime) {
416           lockLimit = temp.endTime;
417         }
418       }
419     }
420     return (lockAmountNow, lockLimit);
421   }
422 
423   function deleteLockTime(address _to) public onlyOwner returns (bool) {
424     require(_to != address(0));
425     
426     delete addressLock[_to];
427     return true;
428   }
429 
430   function transfer(address _to, uint256 _value) public checkLock(_value) returns (bool) {
431     require(_value <= balances[msg.sender]);
432     require(_to != address(0));
433 
434     balances[msg.sender] = balances[msg.sender].sub(_value);
435     balances[_to] = balances[_to].add(_value);
436     emit Transfer(msg.sender, _to, _value);
437     return true;
438   }
439 
440   function transferBatch(address[] _addresses, uint256[] _amounts) public onlyOwner returns (bool) {
441     require(_addresses.length == _amounts.length);
442     uint256 sum;
443     for (uint256 i = 0; i < _amounts.length; i++) {
444       sum = sum + _amounts[i];
445     }
446     require(sum <= balances[msg.sender]);
447     for (uint256 j = 0; j < _amounts.length; j++) {
448       transfer(_addresses[j], _amounts[j]);
449     }
450     return true;
451   }
452 
453   function transferWithLock(address _to, uint256 _value, uint256 _startTime, uint256 _endTime) public onlyOwner returns (bool) {
454     require(_value <= balances[msg.sender]);
455     require(_to != address(0));
456 
457     balances[msg.sender] = balances[msg.sender].sub(_value);
458     balances[_to] = balances[_to].add(_value);
459     emit Transfer(msg.sender, _to, _value);
460 
461     lockUp(_to, _value, _startTime, _endTime);
462     return true;
463   }
464 
465   function transferWithLockBatch(address[] _addresses, uint256[] _amounts, uint256[] _startTimes, uint256[] _endTimes) public onlyOwner returns (bool) {
466     require(_addresses.length == _amounts.length && _amounts.length == _startTimes.length && _startTimes.length == _endTimes.length);
467     uint256 sum;
468     for (uint256 i = 0; i < _amounts.length; i++) {
469       sum = sum + _amounts[i];
470     }
471     require(sum <= balances[msg.sender]);
472     for (uint256 j = 0; j < _amounts.length; j++) {
473       transferWithLock(_addresses[j], _amounts[j], _startTimes[j], _endTimes[j]);
474     }
475     return true;
476   }
477 
478   /*** Mintable ***/
479   event Mint(address indexed to, uint256 amount);
480   event MintFinished();
481 
482   bool public mintingFinished = false;
483 
484   modifier canMint() {
485     require(!mintingFinished);
486     _;
487   }
488 
489   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
490     require(_to != address(0));
491 
492     totalSupply_ = totalSupply_.add(_amount);
493     balances[_to] = balances[_to].add(_amount);
494     emit Mint(_to, _amount);
495     emit Transfer(address(0), _to, _amount);
496     return true;
497   }
498 
499   function finishMinting() public onlyOwner canMint returns (bool) {
500     mintingFinished = true;
501     emit MintFinished();
502     return true;
503   }
504 
505   /*** Burnable ***/
506   event Burn(address indexed burner, uint256 value);
507 
508   function burn(uint256 _value) public {
509     _burn(msg.sender, _value);
510   }
511 
512   function _burn(address _who, uint256 _value) internal {
513     require(_value <= balances[_who]);
514 
515     balances[_who] = balances[_who].sub(_value);
516     totalSupply_ = totalSupply_.sub(_value);
517     emit Burn(_who, _value);
518     emit Transfer(_who, address(0), _value);
519   }
520 }