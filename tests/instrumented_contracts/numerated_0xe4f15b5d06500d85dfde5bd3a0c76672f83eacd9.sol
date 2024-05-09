1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/SafeMath.sol
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
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   /**
48   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: contracts/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: contracts/ERC20.sol
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 // File: contracts/StandardToken.sol
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 // File: contracts/Ownable.sol
223 
224 /**
225  * @title Ownable
226  * @dev The Ownable contract has an owner address, and provides basic authorization control
227  * functions, this simplifies the implementation of "user permissions".
228  */
229 contract Ownable {
230   address public owner;
231 
232 
233   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
234 
235 
236   /**
237    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
238    * account.
239    */
240   function Ownable() public {
241     owner = msg.sender;
242   }
243 
244   /**
245    * @dev Throws if called by any account other than the owner.
246    */
247   modifier onlyOwner() {
248     require(msg.sender == owner);
249     _;
250   }
251 
252   /**
253    * @dev Allows the current owner to transfer control of the contract to a newOwner.
254    * @param newOwner The address to transfer ownership to.
255    */
256   function transferOwnership(address newOwner) public onlyOwner {
257     require(newOwner != address(0));
258     OwnershipTransferred(owner, newOwner);
259     owner = newOwner;
260   }
261 
262 }
263 
264 // File: contracts/MintableToken.sol
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 contract MintableToken is StandardToken, Ownable {
273   event Mint(address indexed to, uint256 amount);
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply_ = totalSupply_.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     Mint(_to, _amount);
294     Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   /**
299    * @dev Function to stop minting new tokens.
300    * @return True if the operation was successful.
301    */
302   function finishMinting() onlyOwner canMint public returns (bool) {
303     mintingFinished = true;
304     MintFinished();
305     return true;
306   }
307 }
308 
309 // File: contracts/SafeERC20.sol
310 
311 /**
312  * @title SafeERC20
313  * @dev Wrappers around ERC20 operations that throw on failure.
314  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
315  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
316  */
317 library SafeERC20 {
318   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
319     assert(token.transfer(to, value));
320   }
321 
322   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
323     assert(token.transferFrom(from, to, value));
324   }
325 
326   function safeApprove(ERC20 token, address spender, uint256 value) internal {
327     assert(token.approve(spender, value));
328   }
329 }
330 
331 // File: contracts/CanReclaimToken.sol
332 
333 /**
334  * @title Contracts that should be able to recover tokens
335  * @author SylTi
336  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
337  * This will prevent any accidental loss of tokens.
338  */
339 contract CanReclaimToken is Ownable {
340   using SafeERC20 for ERC20Basic;
341 
342   /**
343    * @dev Reclaim all ERC20Basic compatible tokens
344    * @param token ERC20Basic The address of the token contract
345    */
346   function reclaimToken(ERC20Basic token) external onlyOwner {
347     uint256 balance = token.balanceOf(this);
348     token.safeTransfer(owner, balance);
349   }
350 
351 }
352 
353 // File: contracts/HasNoTokens.sol
354 
355 /**
356  * @title Contracts that should not own Tokens
357  * @author Remco Bloemen <remco@2π.com>
358  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
359  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
360  * owner to reclaim the tokens.
361  */
362 contract HasNoTokens is CanReclaimToken {
363 
364  /**
365   * @dev Reject all ERC223 compatible tokens
366   * @param from_ address The address that is transferring the tokens
367   * @param value_ uint256 the amount of the specified token
368   * @param data_ Bytes The data passed from the caller.
369   */
370   function tokenFallback(address from_, uint256 value_, bytes data_) external pure {
371     from_;
372     value_;
373     data_;
374     revert();
375   }
376 
377 }
378 
379 // File: contracts/Vesting.sol
380 
381 /**
382  * @title Standalone Vesting  logic to be added in token
383  * @dev Beneficiary can have at most one VestingGrant only, we do not support adding two vesting grants of vesting grant to same address.
384  *      Token transfer related logic is not handled in this class for simplicity and modularity purpose
385  */
386 contract Vesting {
387   using SafeMath for uint256;
388 
389   struct VestingGrant {
390     uint256 grantedAmount;       // 32 bytes
391     uint64 start;
392     uint64 cliff;
393     uint64 vesting;             // 3 * 8 = 24 bytes
394   } // total 56 bytes = 2 sstore per operation (32 per sstore)
395 
396   mapping (address => VestingGrant) public grants;
397 
398   event VestingGrantSet(address indexed to, uint256 grantedAmount, uint64 vesting);
399 
400   function getVestingGrantAmount(address _to) public view returns (uint256) {
401     return grants[_to].grantedAmount;
402   }
403 
404   /**
405    * @dev Set vesting grant to a specified address
406    * @param _to address The address which the vesting amount will be granted to.
407    * @param _grantedAmount uint256 The amount to be granted.
408    * @param _start uint64 Time of the beginning of the grant.
409    * @param _cliff uint64 Time of the cliff period.
410    * @param _vesting uint64 The vesting period.
411    * @param _override bool Must be true if you are overriding vesting grant that has been set before
412    *          this is to prevent accidental overwriting vesting grant
413    */
414   function setVestingGrant(address _to, uint256 _grantedAmount, uint64 _start, uint64 _cliff, uint64 _vesting, bool _override) public {
415 
416     // Check for date inconsistencies that may cause unexpected behavior
417     require(_cliff >= _start && _vesting >= _cliff);
418     // only one vesting logic per address, and once set to update _override flag is required
419     require(grants[_to].grantedAmount == 0 || _override);
420     grants[_to] = VestingGrant(_grantedAmount, _start, _cliff, _vesting);
421 
422     VestingGrantSet(_to, _grantedAmount, _vesting);
423   }
424 
425   /**
426    * @dev Calculate amount of vested amounts at a specific time (monthly graded)
427    * @param grantedAmount uint256 The amount of amounts granted
428    * @param time uint64 The time to be checked
429    * @param start uint64 The time representing the beginning of the grant
430    * @param cliff uint64  The cliff period, the period before nothing can be paid out
431    * @param vesting uint64 The vesting period
432    * @return An uint256 representing the vested amounts
433    *   |                         _/--------   vestedTokens rect
434    *   |                       _/
435    *   |                     _/
436    *   |                   _/
437    *   |                 _/
438    *   |                /
439    *   |              .|
440    *   |            .  |
441    *   |          .    |
442    *   |        .      |
443    *   |      .        |
444    *   |    .          |
445    *   +===+===========+---------+----------> time
446    *      Start       Cliff    Vesting
447    */
448   function calculateVested (
449     uint256 grantedAmount,
450     uint256 time,
451     uint256 start,
452     uint256 cliff,
453     uint256 vesting) internal pure returns (uint256)
454     {
455       // Shortcuts for before cliff and after vesting cases.
456       if (time < cliff) return 0;
457       if (time >= vesting) return grantedAmount;
458 
459       // Interpolate all vested amounts.
460       // As before cliff the shortcut returns 0, we can use just calculate a value
461       // in the vesting rect (as shown in above's figure)
462 
463       // vestedAmounts = (grantedAmount * (time - start)) / (vesting - start)   <-- this is the original formula
464       // vestedAmounts = (grantedAmount * ( (time - start) / (30 days) ) / ( (vesting - start) / (30 days) )   <-- this is made
465 
466       uint256 vestedAmounts = grantedAmount.mul(time.sub(start).div(30 days)).div(vesting.sub(start).div(30 days));
467 
468       //if (vestedAmounts > grantedAmount) return amounts; // there is no possible case where this is true
469 
470       return vestedAmounts;
471   }
472 
473   function calculateLocked (
474     uint256 grantedAmount,
475     uint256 time,
476     uint256 start,
477     uint256 cliff,
478     uint256 vesting) internal pure returns (uint256)
479     {
480       return grantedAmount.sub(calculateVested(grantedAmount, time, start, cliff, vesting));
481     }
482 
483   /**
484    * @dev Gets the locked amount of a given beneficiary, ie. non vested amount, at a specific time.
485    * @param _to The beneficiary to be checked.
486    * @param _time uint64 The time to be checked
487    * @return An uint256 representing the non vested amounts of a specific grant on the
488    * passed time frame.
489    */
490   function getLockedAmountOf(address _to, uint256 _time) public view returns (uint256) {
491     VestingGrant storage grant = grants[_to];
492     if (grant.grantedAmount == 0) return 0;
493     return calculateLocked(grant.grantedAmount, uint256(_time), uint256(grant.start),
494       uint256(grant.cliff), uint256(grant.vesting));
495   }
496 
497 
498 }
499 
500 // File: contracts/DirectToken.sol
501 
502 contract DirectToken is MintableToken, HasNoTokens, Vesting {
503 
504   string public constant name = "DIREC";
505   string public constant symbol = "DIR";
506   uint8 public constant decimals = 18;
507 
508   bool public tradingStarted = false;   // target is TRADING_START date = 1533081600; // 2018-08-01 00:00:00 UTC
509 
510   /**
511    * @dev Allows the owner to enable the trading.
512    */
513   function setTradingStarted(bool _tradingStarted) public onlyOwner {
514     tradingStarted = _tradingStarted;
515   }
516 
517   /**
518    * @dev Allows anyone to transfer the PAY tokens once trading has started
519    * @param _to the recipient address of the tokens.
520    * @param _value number of tokens to be transfered.
521    */
522   function transfer(address _to, uint256 _value) public returns (bool success) {
523     checkTransferAllowed(msg.sender, _to, _value);
524     return super.transfer(_to, _value);
525   }
526 
527    /**
528    * @dev Allows anyone to transfer the PAY tokens once trading has started
529    * @param _from address The address which you want to send tokens from
530    * @param _to address The address which you want to transfer to
531    * @param _value uint256 the amout of tokens to be transfered
532    */
533   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
534     checkTransferAllowed(msg.sender, _to, _value);
535     return super.transferFrom(_from, _to, _value);
536   }
537 
538   /**
539    * Throws if the transfer not allowed due to minting not finished, trading not started, or vesting
540    *   this should be called at the top of transfer functions and so as to refund unused gas
541    */
542   function checkTransferAllowed(address _sender, address _to, uint256 _value) private view {
543       if (mintingFinished && tradingStarted && isAllowableTransferAmount(_sender, _value)) {
544           // Everybody can transfer once the token is finalized and trading has started and is within allowable vested amount if applicable
545           return;
546       }
547 
548       // Owner is allowed to transfer tokens before the sale is finalized.
549       // This allows the tokens to move from the TokenSale contract to a beneficiary.
550       // We also allow someone to send tokens back to the owner. This is useful among other
551       // cases, reclaimTokens etc.
552       require(_sender == owner || _to == owner);
553   }
554 
555   function setVestingGrant(address _to, uint256 _grantedAmount, uint64 _start, uint64 _cliff, uint64 _vesting, bool _override) public onlyOwner {
556     return super.setVestingGrant(_to, _grantedAmount, _start, _cliff, _vesting, _override);
557   }
558 
559   function isAllowableTransferAmount(address _sender, uint256 _value) private view returns (bool allowed) {
560      if (getVestingGrantAmount(_sender) == 0) {
561         return true;
562      }
563      // the address has vesting grant set, he can transfer up to the amount that vested
564      uint256 transferableAmount = balanceOf(_sender).sub(getLockedAmountOf(_sender, now));
565      return (_value <= transferableAmount);
566   }
567 
568 }