1 pragma solidity ^0.4.19;
2 
3 // File: contracts/zeppelin/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts/zeppelin/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: contracts/zeppelin/token/ERC20/BasicToken.sol
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
112 // File: contracts/zeppelin/token/ERC20/ERC20.sol
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
125 // File: contracts/zeppelin/token/ERC20/StandardToken.sol
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
222 // File: contracts/zeppelin/ownership/Ownable.sol
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
264 // File: contracts/ico/Recoverable.sol
265 
266 /**
267  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
268  *
269  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
270  */
271 
272 pragma solidity ^0.4.12;
273 
274 
275 
276 contract Recoverable is Ownable {
277 
278   /// @dev Empty constructor (for now)
279   function Recoverable() public {
280   }
281 
282   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
283   /// @param token Token which will we rescue to the owner from the contract
284   function recoverTokens(ERC20Basic token) onlyOwner public {
285     token.transfer(owner, tokensToBeReturned(token));
286   }
287 
288   /// @dev Interface function, can be overwritten by the superclass
289   /// @param token Token which balance we will check and return
290   /// @return The amount of tokens (in smallest denominator) the contract owns
291   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
292     return token.balanceOf(this);
293   }
294 }
295 
296 // File: contracts/ico/StandardTokenExt.sol
297 
298 /**
299  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
300  *
301  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
302  */
303 
304 pragma solidity ^0.4.14;
305 
306 
307 
308 
309 /**
310  * Standard EIP-20 token with an interface marker.
311  *
312  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
313  *
314  */
315 contract StandardTokenExt is Recoverable, StandardToken {
316 
317   /* Interface declaration */
318   function isToken() public constant returns (bool weAre) {
319     return true;
320   }
321 }
322 
323 // File: contracts/ico/ReleasableToken.sol
324 
325 /**
326  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
327  *
328  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
329  */
330 
331 pragma solidity ^0.4.8;
332 
333 
334 
335 /**
336  * Define interface for releasing the token transfer after a successful crowdsale.
337  */
338 contract ReleasableToken is StandardTokenExt {
339 
340   /* The finalizer contract that allows unlift the transfer limits on this token */
341   address public releaseAgent;
342 
343   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
344   bool public released = false;
345 
346   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
347   mapping (address => bool) public transferAgents;
348 
349   /**
350    * Limit token transfer until the crowdsale is over.
351    *
352    */
353   modifier canTransfer(address _sender) {
354 
355     if(!released) {
356         if(!transferAgents[_sender]) {
357             throw;
358         }
359     }
360 
361     _;
362   }
363 
364   /**
365    * Set the contract that can call release and make the token transferable.
366    *
367    * Design choice. Allow reset the release agent to fix fat finger mistakes.
368    */
369   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
370 
371     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
372     releaseAgent = addr;
373   }
374 
375   /**
376    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
377    */
378   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
379     transferAgents[addr] = state;
380   }
381 
382   /**
383    * One way function to release the tokens to the wild.
384    *
385    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
386    */
387   function releaseTokenTransfer() public onlyReleaseAgent {
388     released = true;
389   }
390 
391   /** The function can be called only before or after the tokens have been releasesd */
392   modifier inReleaseState(bool releaseState) {
393     if(releaseState != released) {
394         throw;
395     }
396     _;
397   }
398 
399   /** The function can be called only by a whitelisted release agent. */
400   modifier onlyReleaseAgent() {
401     if(msg.sender != releaseAgent) {
402         throw;
403     }
404     _;
405   }
406 
407   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
408     // Call StandardToken.transfer()
409     return super.transfer(_to, _value);
410   }
411 
412   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
413     // Call StandardToken.transferForm()
414     return super.transferFrom(_from, _to, _value);
415   }
416 
417 }
418 
419 // File: contracts/WhitelistableToken.sol
420 
421 contract WhitelistableToken is ReleasableToken {
422   /**
423    * A pre-release list of investors
424    */
425   struct WhitelistedInvestor {
426     uint idx;
427     bool whitelisted;
428   }
429 
430   mapping(address => WhitelistedInvestor) whitelist;
431 
432   mapping(uint => address) indexedWhitelist;
433   uint whitelistTotal;
434   address public whitelistAgent; // Address responsible for adding investors to the whitelist.
435 
436 
437   modifier isWhitelisted(address _destination) {
438     if(!released) {
439       if(!whitelist[_destination].whitelisted) {
440         revert();
441       }
442     }
443     _;
444   }
445 
446   modifier onlyWhitelistAgent(address _sender) {
447     if(_sender != whitelistAgent) {
448       revert();
449     }
450 
451     _;
452   }
453 
454   function isOnWhitelist(address _investor) public view returns (bool whitelisted) {
455     return whitelist[_investor].whitelisted;
456   }
457 
458   function addToWhitelist(address _investor) public onlyWhitelistAgent(msg.sender) {
459     if (!whitelist[_investor].whitelisted) { // Should be idempotent to keep duplicates out
460       whitelist[_investor].whitelisted = true;
461       whitelist[_investor].idx = whitelistTotal;
462       indexedWhitelist[whitelistTotal] = _investor;
463       whitelistTotal += 1;
464     }
465   }
466 
467   function removeFromWhitelist(address _investor) public onlyWhitelistAgent(msg.sender) {
468     if (!whitelist[_investor].whitelisted) {
469       revert();
470     }
471     whitelist[_investor].whitelisted = false;
472     uint idx = whitelist[_investor].idx;
473     indexedWhitelist[idx] = address(0);
474   }
475 
476   function setWhitelistAgent(address agent) public onlyOwner {
477     whitelistAgent = agent;
478   }
479 
480   /**
481    * Used for iteration.
482    */
483   function getWhitelistTotal() public view returns (uint total) {
484     return whitelistTotal;
485   }
486 
487   function getWhitelistAt(uint idx) public view returns (address investor) {
488     return indexedWhitelist[idx];
489   }
490 
491   function transfer(address _to, uint _value) isWhitelisted(_to) public returns (bool success) {
492     return super.transfer(_to, _value);
493   }
494 
495   function transferFrom(address _from, address _to, uint256 _value) isWhitelisted(_from) isWhitelisted(_to) public returns (bool) {
496     return super.transferFrom(_from, _to, _value);
497   }
498 }
499 
500 // File: contracts/SDAToken.sol
501 
502 // See the example here:
503 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/examples/SimpleToken.sol
504 contract SDAToken is WhitelistableToken {
505   /**
506    * For Releasable tokens, a "transfer agent" can be assigned who is allowed to
507    * transfer tokens between users. This effectively functions as an investor whitelist.
508    *
509    */
510 
511   string public constant name = "Safe Digital Advertising";  // solium-disable-line uppercase
512   string public constant symbol = "SDA";  // solium-disable-line uppercase
513   uint8 public constant decimals = 8;  // solium-disable-line uppercase
514 
515   uint256 public constant INITIAL_SUPPLY = 400000000 * (10 ** uint256(decimals));
516 
517   function SDAToken() public {
518     totalSupply_ = INITIAL_SUPPLY;
519     balances[msg.sender] = INITIAL_SUPPLY;
520     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
521   }
522 }