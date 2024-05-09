1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * See https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address who) public view returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 
70 contract Time {
71     /**
72     * @dev Current time getter
73     * @return Current time in seconds
74     */
75     function _currentTime() internal view returns (uint256) {
76         return block.timestamp;
77     }
78 }
79 
80 
81 /**
82  * @title Ownable
83  * @dev The Ownable contract has an owner address, and provides basic authorization control
84  * functions, this simplifies the implementation of "user permissions".
85  */
86 contract Ownable {
87   address public owner;
88 
89 
90   event OwnershipRenounced(address indexed previousOwner);
91   event OwnershipTransferred(
92     address indexed previousOwner,
93     address indexed newOwner
94   );
95 
96 
97   /**
98    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99    * account.
100    */
101   constructor() public {
102     owner = msg.sender;
103   }
104 
105   /**
106    * @dev Throws if called by any account other than the owner.
107    */
108   modifier onlyOwner() {
109     require(msg.sender == owner);
110     _;
111   }
112 
113   /**
114    * @dev Allows the current owner to relinquish control of the contract.
115    * @notice Renouncing to ownership will leave the contract without an owner.
116    * It will not be possible to call the functions with the `onlyOwner`
117    * modifier anymore.
118    */
119   function renounceOwnership() public onlyOwner {
120     emit OwnershipRenounced(owner);
121     owner = address(0);
122   }
123 
124   /**
125    * @dev Allows the current owner to transfer control of the contract to a newOwner.
126    * @param _newOwner The address to transfer ownership to.
127    */
128   function transferOwnership(address _newOwner) public onlyOwner {
129     _transferOwnership(_newOwner);
130   }
131 
132   /**
133    * @dev Transfers control of the contract to a newOwner.
134    * @param _newOwner The address to transfer ownership to.
135    */
136   function _transferOwnership(address _newOwner) internal {
137     require(_newOwner != address(0));
138     emit OwnershipTransferred(owner, _newOwner);
139     owner = _newOwner;
140   }
141 }
142 
143 
144 
145 
146 
147 
148 
149 
150 
151 
152 /**
153  * @title ERC20 interface
154  * @dev see https://github.com/ethereum/EIPs/issues/20
155  */
156 contract ERC20 is ERC20Basic {
157   function allowance(address owner, address spender)
158     public view returns (uint256);
159 
160   function transferFrom(address from, address to, uint256 value)
161     public returns (bool);
162 
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(
165     address indexed owner,
166     address indexed spender,
167     uint256 value
168   );
169 }
170 
171 
172 
173 /**
174  * @title DetailedERC20 token
175  * @dev The decimals are only for visualization purposes.
176  * All the operations are done using the smallest and indivisible token unit,
177  * just as on Ethereum all the operations are done in wei.
178  */
179 contract DetailedERC20 is ERC20 {
180   string public name;
181   string public symbol;
182   uint8 public decimals;
183 
184   constructor(string _name, string _symbol, uint8 _decimals) public {
185     name = _name;
186     symbol = _symbol;
187     decimals = _decimals;
188   }
189 }
190 
191 
192 
193 
194 
195 
196 
197 
198 
199 
200 /**
201  * @title Basic token
202  * @dev Basic version of StandardToken, with no allowances.
203  */
204 contract BasicToken is ERC20Basic {
205   using SafeMath for uint256;
206 
207   mapping(address => uint256) balances;
208 
209   uint256 totalSupply_;
210 
211   /**
212   * @dev Total number of tokens in existence
213   */
214   function totalSupply() public view returns (uint256) {
215     return totalSupply_;
216   }
217 
218   /**
219   * @dev Transfer token for a specified address
220   * @param _to The address to transfer to.
221   * @param _value The amount to be transferred.
222   */
223   function transfer(address _to, uint256 _value) public returns (bool) {
224     require(_to != address(0));
225     require(_value <= balances[msg.sender]);
226 
227     balances[msg.sender] = balances[msg.sender].sub(_value);
228     balances[_to] = balances[_to].add(_value);
229     emit Transfer(msg.sender, _to, _value);
230     return true;
231   }
232 
233   /**
234   * @dev Gets the balance of the specified address.
235   * @param _owner The address to query the the balance of.
236   * @return An uint256 representing the amount owned by the passed address.
237   */
238   function balanceOf(address _owner) public view returns (uint256) {
239     return balances[_owner];
240   }
241 
242 }
243 
244 
245 
246 
247 /**
248  * @title Standard ERC20 token
249  *
250  * @dev Implementation of the basic standard token.
251  * https://github.com/ethereum/EIPs/issues/20
252  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
253  */
254 contract StandardToken is ERC20, BasicToken {
255 
256   mapping (address => mapping (address => uint256)) internal allowed;
257 
258 
259   /**
260    * @dev Transfer tokens from one address to another
261    * @param _from address The address which you want to send tokens from
262    * @param _to address The address which you want to transfer to
263    * @param _value uint256 the amount of tokens to be transferred
264    */
265   function transferFrom(
266     address _from,
267     address _to,
268     uint256 _value
269   )
270     public
271     returns (bool)
272   {
273     require(_to != address(0));
274     require(_value <= balances[_from]);
275     require(_value <= allowed[_from][msg.sender]);
276 
277     balances[_from] = balances[_from].sub(_value);
278     balances[_to] = balances[_to].add(_value);
279     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
280     emit Transfer(_from, _to, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
286    * Beware that changing an allowance with this method brings the risk that someone may use both the old
287    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
288    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
289    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290    * @param _spender The address which will spend the funds.
291    * @param _value The amount of tokens to be spent.
292    */
293   function approve(address _spender, uint256 _value) public returns (bool) {
294     allowed[msg.sender][_spender] = _value;
295     emit Approval(msg.sender, _spender, _value);
296     return true;
297   }
298 
299   /**
300    * @dev Function to check the amount of tokens that an owner allowed to a spender.
301    * @param _owner address The address which owns the funds.
302    * @param _spender address The address which will spend the funds.
303    * @return A uint256 specifying the amount of tokens still available for the spender.
304    */
305   function allowance(
306     address _owner,
307     address _spender
308    )
309     public
310     view
311     returns (uint256)
312   {
313     return allowed[_owner][_spender];
314   }
315 
316   /**
317    * @dev Increase the amount of tokens that an owner allowed to a spender.
318    * approve should be called when allowed[_spender] == 0. To increment
319    * allowed value is better to use this function to avoid 2 calls (and wait until
320    * the first transaction is mined)
321    * From MonolithDAO Token.sol
322    * @param _spender The address which will spend the funds.
323    * @param _addedValue The amount of tokens to increase the allowance by.
324    */
325   function increaseApproval(
326     address _spender,
327     uint256 _addedValue
328   )
329     public
330     returns (bool)
331   {
332     allowed[msg.sender][_spender] = (
333       allowed[msg.sender][_spender].add(_addedValue));
334     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338   /**
339    * @dev Decrease the amount of tokens that an owner allowed to a spender.
340    * approve should be called when allowed[_spender] == 0. To decrement
341    * allowed value is better to use this function to avoid 2 calls (and wait until
342    * the first transaction is mined)
343    * From MonolithDAO Token.sol
344    * @param _spender The address which will spend the funds.
345    * @param _subtractedValue The amount of tokens to decrease the allowance by.
346    */
347   function decreaseApproval(
348     address _spender,
349     uint256 _subtractedValue
350   )
351     public
352     returns (bool)
353   {
354     uint256 oldValue = allowed[msg.sender][_spender];
355     if (_subtractedValue > oldValue) {
356       allowed[msg.sender][_spender] = 0;
357     } else {
358       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
359     }
360     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 
364 }
365 
366 
367 
368 
369 
370 
371 contract CosquareToken is Time, StandardToken, DetailedERC20, Ownable {
372     using SafeMath for uint256;
373 
374     /**
375     * Describes locked balance
376     * @param expires Time when tokens will be unlocked
377     * @param value Amount of the tokens is locked
378     */
379     struct LockedBalance {
380         uint256 expires;
381         uint256 value;
382     }
383 
384     // locked balances specified be the address
385     mapping(address => LockedBalance[]) public lockedBalances;
386 
387     // sale wallet (65%)
388     address public saleWallet;
389     // reserve wallet (15%)
390     address public reserveWallet;
391     // team wallet (15%)
392     address public teamWallet;
393     // strategic wallet (5%)
394     address public strategicWallet;
395 
396     // end point, after which all tokens will be unlocked
397     uint256 public lockEndpoint;
398 
399     /**
400     * Event for lock logging
401     * @param who The address on which part of the tokens is locked
402     * @param value Amount of the tokens is locked
403     * @param expires Time when tokens will be unlocked
404     */
405     event LockLog(address indexed who, uint256 value, uint256 expires);
406 
407     /**
408     * @param _saleWallet Sale wallet
409     * @param _reserveWallet Reserve wallet
410     * @param _teamWallet Team wallet
411     * @param _strategicWallet Strategic wallet
412     * @param _lockEndpoint End point, after which all tokens will be unlocked
413     */
414     constructor(address _saleWallet, address _reserveWallet, address _teamWallet, address _strategicWallet, uint256 _lockEndpoint) 
415       DetailedERC20("cosquare", "CSQ", 18) public {
416         require(_lockEndpoint > 0, "Invalid global lock end date.");
417         lockEndpoint = _lockEndpoint;
418 
419         _configureWallet(_saleWallet, 65000000000000000000000000000); // 6.5e+28
420         saleWallet = _saleWallet;
421         _configureWallet(_reserveWallet, 15000000000000000000000000000); // 1.5e+28
422         reserveWallet = _reserveWallet;
423         _configureWallet(_teamWallet, 15000000000000000000000000000); // 1.5e+28
424         teamWallet = _teamWallet;
425         _configureWallet(_strategicWallet, 5000000000000000000000000000); // 0.5e+28
426         strategicWallet = _strategicWallet;
427     }
428 
429     /**
430     * @dev Setting the initial value of the tokens to the wallet
431     * @param _wallet Address to be set up
432     * @param _amount The number of tokens to be assigned to this address
433     */
434     function _configureWallet(address _wallet, uint256 _amount) private {
435         require(_wallet != address(0), "Invalid wallet address.");
436 
437         totalSupply_ = totalSupply_.add(_amount);
438         balances[_wallet] = _amount;
439         emit Transfer(address(0), _wallet, _amount);
440     }
441 
442     /**
443     * @dev Throws if the address does not have enough not locked balance
444     * @param _who The address to transfer from
445     * @param _value The amount to be transferred
446     */
447     modifier notLocked(address _who, uint256 _value) {
448         uint256 time = _currentTime();
449 
450         if (lockEndpoint > time) {
451             uint256 index = 0;
452             uint256 locked = 0;
453             while (index < lockedBalances[_who].length) {
454                 if (lockedBalances[_who][index].expires > time) {
455                     locked = locked.add(lockedBalances[_who][index].value);
456                 }
457 
458                 index++;
459             }
460 
461             require(_value <= balances[_who].sub(locked), "Not enough unlocked tokens");
462         }        
463         _;
464     }
465 
466     /**
467     * @dev Overridden to check whether enough not locked balance
468     * @param _from The address which you want to send tokens from
469     * @param _to The address which you want to transfer to
470     * @param _value The amount of tokens to be transferred
471     */
472     function transferFrom(address _from, address _to, uint256 _value) public notLocked(_from, _value) returns (bool) {
473         return super.transferFrom(_from, _to, _value);
474     }
475 
476     /**
477     * @dev Overridden to check whether enough not locked balance
478     * @param _to The address to transfer to
479     * @param _value The amount to be transferred
480     */
481     function transfer(address _to, uint256 _value) public notLocked(msg.sender, _value) returns (bool) {
482         return super.transfer(_to, _value);
483     }
484 
485     /**
486     * @dev Gets the locked balance of the specified address
487     * @param _owner The address to query the locked balance of
488     * @param _expires Time of expiration of the lock (If equals to 0 - returns all locked tokens at this moment)
489     * @return An uint256 representing the amount of locked balance by the passed address
490     */
491     function lockedBalanceOf(address _owner, uint256 _expires) external view returns (uint256) {
492         uint256 time = _currentTime();
493         uint256 index = 0;
494         uint256 locked = 0;
495 
496         if (lockEndpoint > time) {       
497             while (index < lockedBalances[_owner].length) {
498                 if (_expires > 0) {
499                     if (lockedBalances[_owner][index].expires == _expires) {
500                         locked = locked.add(lockedBalances[_owner][index].value);
501                     }
502                 } else {
503                     if (lockedBalances[_owner][index].expires >= time) {
504                         locked = locked.add(lockedBalances[_owner][index].value);
505                     }
506                 }
507 
508                 index++;
509             }
510         }
511 
512         return locked;
513     }
514 
515     /**
516     * @dev Locks part of the balance for the specified address and for a certain period (3 periods expected)
517     * @param _who The address of which will be locked part of the balance
518     * @param _value The amount of tokens to be locked
519     * @param _expires Time of expiration of the lock
520     */
521     function lock(address _who, uint256 _value, uint256 _expires) public onlyOwner {
522         uint256 time = _currentTime();
523         require(_who != address(0) && _value <= balances[_who] && _expires > time, "Invalid lock configuration.");
524 
525         uint256 index = 0;
526         bool exist = false;
527         while (index < lockedBalances[_who].length) {
528             if (lockedBalances[_who][index].expires == _expires) {
529                 exist = true;
530                 break;
531             }
532 
533             index++;
534         }
535 
536         if (exist) {
537             lockedBalances[_who][index].value = lockedBalances[_who][index].value.add(_value);
538         } else {
539             lockedBalances[_who].push(LockedBalance({
540                 expires: _expires,
541                 value: _value
542             }));
543         }
544 
545         emit LockLog(_who, _value, _expires);
546     }
547 }