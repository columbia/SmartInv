1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
17 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
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
69 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
115 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
136 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
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
257 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
258 
259 /**
260  * @title DetailedERC20 token
261  * @dev The decimals are only for visualization purposes.
262  * All the operations are done using the smallest and indivisible token unit,
263  * just as on Ethereum all the operations are done in wei.
264  */
265 contract DetailedERC20 is ERC20 {
266   string public name;
267   string public symbol;
268   uint8 public decimals;
269 
270   constructor(string _name, string _symbol, uint8 _decimals) public {
271     name = _name;
272     symbol = _symbol;
273     decimals = _decimals;
274   }
275 }
276 
277 // File: contracts/Smartcop.sol
278 
279 contract Smartcop is DetailedERC20, StandardToken {
280 
281     address public owner ;
282 
283     constructor() public
284         DetailedERC20("Azilowon", "AWN", 18)
285     {
286         totalSupply_ = 1000000000 * (uint(10)**decimals);
287         balances[msg.sender] = totalSupply_;
288         owner = msg.sender;
289     }
290 
291 }
292 
293 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
294 
295 /**
296  * @title SafeERC20
297  * @dev Wrappers around ERC20 operations that throw on failure.
298  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
299  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
300  */
301 library SafeERC20 {
302   function safeTransfer(
303     ERC20Basic _token,
304     address _to,
305     uint256 _value
306   )
307     internal
308   {
309     require(_token.transfer(_to, _value));
310   }
311   function safeTransferFrom(
312     ERC20 _token,
313     address _from,
314     address _to,
315     uint256 _value
316   )
317     internal
318   {
319     require(_token.transferFrom(_from, _to, _value));
320   }
321 
322   function safeApprove(
323     ERC20 _token,
324     address _spender,
325     uint256 _value
326   )
327     internal
328   {
329     require(_token.approve(_spender, _value));
330   }
331 }
332 
333 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
334 
335 /**
336  * @title Ownable
337  * @dev The Ownable contract has an owner address, and provides basic authorization control
338  * functions, this simplifies the implementation of "user permissions".
339  */
340 contract Ownable {
341   address public owner;
342 
343 
344   event OwnershipRenounced(address indexed previousOwner);
345   event OwnershipTransferred(
346     address indexed previousOwner,
347     address indexed newOwner
348   );
349 
350  /**
351    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
352    * account.
353    */
354   constructor() public {
355     owner = msg.sender;
356   }
357 
358   /**
359    * @dev Throws if called by any account other than the owner.
360    */
361   modifier onlyOwner() {
362     require(msg.sender == owner);
363     _;
364   }
365 
366   /**
367    * @dev Allows the current owner to relinquish control of the contract.
368    * @notice Renouncing to ownership will leave the contract without an owner.
369    * It will not be possible to call the functions with the `onlyOwner`
370    * modifier anymore.
371    */
372   function renounceOwnership() public onlyOwner {
373     emit OwnershipRenounced(owner);
374     owner = address(0);
375   }
376 
377   /**
378    * @dev Allows the current owner to transfer control of the contract to a newOwner.
379    * @param _newOwner The address to transfer ownership to.
380    */
381   function transferOwnership(address _newOwner) public onlyOwner {
382     _transferOwnership(_newOwner);
383   }
384 
385   /**
386    * @dev Transfers control of the contract to a newOwner.
387    * @param _newOwner The address to transfer ownership to.
388    */
389   function _transferOwnership(address _newOwner) internal {
390     require(_newOwner != address(0));
391     emit OwnershipTransferred(owner, _newOwner);
392     owner = _newOwner;
393   }
394 }
395 
396 // File: contracts/LockerVesting.sol
397 
398 /* solium-disable security/no-block-members */
399 
400 pragma solidity ^0.4.24;
401 
402 
403 
404 
405 
406 
407 /**
408  * @title LockerVesting
409  * @dev A token holder contract that can release its token balance gradually like a
410  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
411  * owner.
412  */
413 contract LockerVesting is Ownable {
414   using SafeMath for uint256;
415   using SafeERC20 for ERC20Basic;
416 
417   event Released(uint256 amount);
418   event Revoked();
419 
420   // beneficiary of tokens after they are released
421   address public beneficiary;
422 
423   uint256 public start;
424   uint256 public period;
425   uint256 public chunks;
426 
427   bool public revocable;
428 
429   mapping (address => uint256) public released;
430   mapping (address => bool) public revoked;
431 
432   /**
433    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
434    * _beneficiary, using chunk every period time. By period*chunks then all
435    * of the balance will have vested.
436    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
437    * @param _start the time (as Unix time) at which point vesting starts
438    * @param _period duration in seconds of the period of vesting (1 month = 2630000 seconds)
439    * @param _chunks number of chunk for vesting and period*chunks gives duration (capped to 100 max)
440    * @param _revocable whether the vesting is revocable or not
441    */
442   constructor(
443     address _beneficiary,
444     uint256 _start,
445     uint256 _period,
446     uint256 _chunks,
447     bool _revocable
448   )
449     public
450   {
451     require(_beneficiary != address(0));
452 
453     beneficiary = _beneficiary;
454     revocable = _revocable;
455     period = _period;
456     chunks = _chunks;
457     start = _start;
458   }
459 
460   /**
461    * @notice Transfers vested tokens to beneficiary.
462    * @param _token ERC20 token which is being vested
463    */
464   function release(ERC20Basic _token) public {
465     uint256 unreleased = releasableAmount(_token);
466 
467     require(unreleased > 0);
468 
469     released[_token] = released[_token].add(unreleased);
470 
471     _token.safeTransfer(beneficiary, unreleased);
472 
473     emit Released(unreleased);
474   }
475 
476   /**
477    * @notice Allows the owner to revoke the vesting. Tokens already vested
478    * remain in the contract, the rest are returned to the owner.
479    * @param _token ERC20 token which is being vested
480    */
481   function revoke(ERC20Basic _token) public onlyOwner {
482     require(revocable);
483     require(!revoked[_token]);
484 
485     uint256 balance = _token.balanceOf(address(this));
486 
487     uint256 unreleased = releasableAmount(_token);
488     uint256 refund = balance.sub(unreleased);
489 
490     revoked[_token] = true;
491 
492     _token.safeTransfer(owner, refund);
493 
494     emit Revoked();
495   }
496 
497   /**
498    * @dev Calculates the amount that has already vested but hasn't been released yet.
499    * @param _token ERC20 token which is being vested
500    */
501   function releasableAmount(ERC20Basic _token) public view returns (uint256) {
502     return vestedAmount(_token).sub(released[_token]);
503   }
504 
505   /**
506    * @dev Calculates the amount that has already vested.
507    * @param _token ERC20 token which is being vested
508    */
509   function vestedAmount(ERC20Basic _token) public view returns (uint256) {
510     uint256 currentBalance = _token.balanceOf(address(this));
511     uint256 totalBalance = currentBalance.add(released[_token]);
512 
513     require(chunks < 100);
514     // be sure it can't loop forever
515     if (block.timestamp < start) {
516       return 0;
517     } 
518     for (uint i=0; i<chunks; i++) {
519       if (block.timestamp > start.add(period.mul(i)) && block.timestamp <= start.add(period.mul(i+1))) {
520         // send totalbalance dividev in chunk, then multiply by i+1
521         return totalBalance.div(chunks).mul(i+1);
522       } 
523     }
524     return 0;
525   }
526 }
527 
528 // File: contracts/Smartcop_Locker.sol
529 
530 // Copyright ©2018 Mangrovia Blockchain Solutions – All Right Reserved
531 
532 pragma solidity ^0.4.24;
533 
534 
535 
536 
537 contract Smartcop_Locker 
538 {
539     using SafeMath for uint;
540 
541     address tokOwner;
542     uint startTime;
543     Smartcop AWN;
544 
545     mapping (address => address) TTLaddress;
546 
547     event LockInvestor( address indexed purchaser, uint tokens);
548     event LockAdvisor( address indexed purchaser, uint tokens);
549     event LockCompanyReserve( address indexed purchaser, uint tokens);
550     event LockCashBack( address indexed purchaser, uint tokens);
551     event LockAffiliateMarketing( address indexed purchaser, uint tokens);
552     event LockStrategicPartners( address indexed purchaser, uint tokens);
553  
554     // we shall hardcode all variables, it will cost less eth to deploy
555     constructor(address _token) public
556     { 
557         AWN = Smartcop(_token);
558         startTime = now;
559         tokOwner = AWN.owner();
560     }
561 
562     function totalTokens() public view returns(uint) {
563         return AWN.totalSupply();
564     }
565 
566     function getMyLocker() public view returns(address) {
567         return TTLaddress[msg.sender]; 
568     }
569 
570     function PrivateSale(address buyerAddress, uint amount) public returns(bool) {
571         // PrivateSale receive directly the tokens
572         AWN.transferFrom(tokOwner, buyerAddress, amount);
573         emit LockInvestor( buyerAddress, amount);
574     }
575 
576     function AdvisorsAndFounders(address buyerAddress, uint amount) public returns(bool) {
577         // it receive 30% immediately, and 70 vested in  14 months (5% per month)
578         uint tamount = amount.mul(30);
579         tamount = tamount.div(100);
580         AWN.transferFrom(tokOwner, buyerAddress, tamount );
581         assignTokens(buyerAddress, amount.sub(tamount), startTime, 2630000, 14);
582         emit LockAdvisor(buyerAddress, amount);
583         return true;
584     }
585     function CompanyReserve(address buyerAddress, uint amount) public returns(bool) {
586         // it receive the token  after 6 months, then 20% and then in 15 months the remaining
587         assignTokens(buyerAddress, amount ,startTime.add(15780000), 7890000, 5);
588         emit LockCompanyReserve(buyerAddress, amount);
589         return true;
590     }
591 
592     function AffiliateMarketing(address buyerAddress, uint amount) public returns(bool) {
593         // it receive the tokens 10% immediatly and then 10% each month
594         assignTokens(buyerAddress, amount, startTime,2630000, 10);
595         emit LockAffiliateMarketing(buyerAddress, amount);
596         return true;
597     }
598 
599     function Cashback(address buyerAddress, uint amount) public returns(bool) {
600         // monthly (2630000) 10 months
601         assignTokens(buyerAddress, amount, startTime,2630000, 10 );
602         emit LockCashBack(buyerAddress, amount);
603         return true;
604     }
605 
606     function StrategicPartners(address buyerAddress, uint amount) public returns(bool) {
607         // monthly (2630000) 10 months
608         assignTokens(buyerAddress, amount, startTime, 2630000, 10);
609         emit LockStrategicPartners(buyerAddress, amount);
610         return true;
611     }
612 
613     function ArbitraryLocker(address buyerAddress, uint amount, uint start, uint period, uint chunks) public returns(bool) {
614         assignTokens(buyerAddress, amount, start, period, chunks);
615         return true;
616     }
617 
618     function assignTokens(address buyerAddress, uint amount, 
619                                     uint start, uint period, uint chunks ) internal returns(address) {
620         require(amount <= AWN.allowance(tokOwner, address(this)) ,"Type 1 Not enough Tokens to transfer");
621         address ttl1 = getMyLocker();
622 
623         if (ttl1 == 0x0) {
624         // this is Private Sale and Advisors/Founders TTL (30% at the end of ICO and then 5% per month)
625             ttl1 = new LockerVesting(buyerAddress, start, period, chunks, false);
626         }
627             
628         AWN.transferFrom(tokOwner, ttl1, amount);
629         TTLaddress[buyerAddress] = ttl1;
630 
631         return ttl1;
632     }
633 
634 
635 }