1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
46 
47 /**
48  * @title Claimable
49  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
50  * This allows the new owner to accept the transfer.
51  */
52 contract Claimable is Ownable {
53   address public pendingOwner;
54 
55   /**
56    * @dev Modifier throws if called by any account other than the pendingOwner.
57    */
58   modifier onlyPendingOwner() {
59     require(msg.sender == pendingOwner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to set the pendingOwner address.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     pendingOwner = newOwner;
69   }
70 
71   /**
72    * @dev Allows the pendingOwner address to finalize the transfer.
73    */
74   function claimOwnership() onlyPendingOwner public {
75     OwnershipTransferred(owner, pendingOwner);
76     owner = pendingOwner;
77     pendingOwner = address(0);
78   }
79 }
80 
81 // File: zeppelin-solidity/contracts/math/SafeMath.sol
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     if (a == 0) {
94       return 0;
95     }
96     uint256 c = a * b;
97     assert(c / a == b);
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers, truncating the quotient.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   /**
112   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   /**
120   * @dev Adds two numbers, throws on overflow.
121   */
122   function add(uint256 a, uint256 b) internal pure returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }
128 
129 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
130 
131 /**
132  * @title ERC20Basic
133  * @dev Simpler version of ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/179
135  */
136 contract ERC20Basic {
137   function totalSupply() public view returns (uint256);
138   function balanceOf(address who) public view returns (uint256);
139   function transfer(address to, uint256 value) public returns (bool);
140   event Transfer(address indexed from, address indexed to, uint256 value);
141 }
142 
143 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   uint256 totalSupply_;
155 
156   /**
157   * @dev total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[msg.sender]);
171 
172     // SafeMath.sub will throw if there is not enough balance.
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param _owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address _owner) public view returns (uint256 balance) {
185     return balances[_owner];
186   }
187 
188 }
189 
190 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
191 
192 /**
193  * @title ERC20 interface
194  * @dev see https://github.com/ethereum/EIPs/issues/20
195  */
196 contract ERC20 is ERC20Basic {
197   function allowance(address owner, address spender) public view returns (uint256);
198   function transferFrom(address from, address to, uint256 value) public returns (bool);
199   function approve(address spender, uint256 value) public returns (bool);
200   event Approval(address indexed owner, address indexed spender, uint256 value);
201 }
202 
203 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * @dev https://github.com/ethereum/EIPs/issues/20
210  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  */
212 contract StandardToken is ERC20, BasicToken {
213 
214   mapping (address => mapping (address => uint256)) internal allowed;
215 
216 
217   /**
218    * @dev Transfer tokens from one address to another
219    * @param _from address The address which you want to send tokens from
220    * @param _to address The address which you want to transfer to
221    * @param _value uint256 the amount of tokens to be transferred
222    */
223   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
224     require(_to != address(0));
225     require(_value <= balances[_from]);
226     require(_value <= allowed[_from][msg.sender]);
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    *
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(address _owner, address _spender) public view returns (uint256) {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
272     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
288     uint oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue > oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298 }
299 
300 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
301 
302 /**
303  * @title Mintable token
304  * @dev Simple ERC20 Token example, with mintable token creation
305  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
306  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
307  */
308 contract MintableToken is StandardToken, Ownable {
309   event Mint(address indexed to, uint256 amount);
310   event MintFinished();
311 
312   bool public mintingFinished = false;
313 
314 
315   modifier canMint() {
316     require(!mintingFinished);
317     _;
318   }
319 
320   /**
321    * @dev Function to mint tokens
322    * @param _to The address that will receive the minted tokens.
323    * @param _amount The amount of tokens to mint.
324    * @return A boolean that indicates if the operation was successful.
325    */
326   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
327     totalSupply_ = totalSupply_.add(_amount);
328     balances[_to] = balances[_to].add(_amount);
329     Mint(_to, _amount);
330     Transfer(address(0), _to, _amount);
331     return true;
332   }
333 
334   /**
335    * @dev Function to stop minting new tokens.
336    * @return True if the operation was successful.
337    */
338   function finishMinting() onlyOwner canMint public returns (bool) {
339     mintingFinished = true;
340     MintFinished();
341     return true;
342   }
343 }
344 
345 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
346 
347 /**
348  * @title Pausable
349  * @dev Base contract which allows children to implement an emergency stop mechanism.
350  */
351 contract Pausable is Ownable {
352   event Pause();
353   event Unpause();
354 
355   bool public paused = false;
356 
357 
358   /**
359    * @dev Modifier to make a function callable only when the contract is not paused.
360    */
361   modifier whenNotPaused() {
362     require(!paused);
363     _;
364   }
365 
366   /**
367    * @dev Modifier to make a function callable only when the contract is paused.
368    */
369   modifier whenPaused() {
370     require(paused);
371     _;
372   }
373 
374   /**
375    * @dev called by the owner to pause, triggers stopped state
376    */
377   function pause() onlyOwner whenNotPaused public {
378     paused = true;
379     Pause();
380   }
381 
382   /**
383    * @dev called by the owner to unpause, returns to normal state
384    */
385   function unpause() onlyOwner whenPaused public {
386     paused = false;
387     Unpause();
388   }
389 }
390 
391 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
392 
393 /**
394  * @title Pausable token
395  * @dev StandardToken modified with pausable transfers.
396  **/
397 contract PausableToken is StandardToken, Pausable {
398 
399   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
400     return super.transfer(_to, _value);
401   }
402 
403   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
404     return super.transferFrom(_from, _to, _value);
405   }
406 
407   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
408     return super.approve(_spender, _value);
409   }
410 
411   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
412     return super.increaseApproval(_spender, _addedValue);
413   }
414 
415   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
416     return super.decreaseApproval(_spender, _subtractedValue);
417   }
418 }
419 
420 // File: contracts/WealthE.sol
421 
422 contract WealthE is MintableToken, PausableToken, Claimable {
423 
424     /*----------- ERC20 GLOBALS -----------*/
425 
426     string public constant name = "Wealth-E";
427     string public constant symbol = "WRE";
428     uint8 public constant decimals = 18;
429 
430 
431     /*----------- Ownership Reclaim -----------*/
432 
433     address public reclaimableOwner;
434 
435     /**
436      * @dev Restricts method call to only the address set as `reclaimableOwner`.
437      */
438     modifier onlyReclaimableOwner() {
439         require(msg.sender == reclaimableOwner);
440         _;
441     }
442 
443 
444     /**
445      * @dev Sets the reclaim address to current owner.
446      */
447     function setupReclaim() public onlyOwner {
448         require(reclaimableOwner == address(0));
449 
450         reclaimableOwner = msg.sender;
451     }
452 
453 
454     /**
455      * @dev Resets the reclaim address to address(0).
456      */
457     function resetReclaim() public onlyReclaimableOwner {
458         reclaimableOwner = address(0);
459     }
460 
461 
462     /**
463      * @dev Failsafe to reclaim ownership in the event crowdsale is unable to
464      *      return ownership. Reclaims ownership regardless of
465      *      pending ownership transfer.
466      */
467     function reclaimOwnership() public onlyReclaimableOwner {
468 
469         // Erase any pending transfer.
470         pendingOwner = address(0);
471 
472         // Transfer ownership.
473         OwnershipTransferred(owner, reclaimableOwner);
474         owner = reclaimableOwner;
475 
476         // Reset reclaimableOwner.
477         reclaimableOwner = address(0);
478 
479     }
480 
481 }