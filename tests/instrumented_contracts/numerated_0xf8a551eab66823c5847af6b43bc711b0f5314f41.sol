1 pragma solidity ^0.4.18;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   uint256 totalSupply_;
89 
90   /**
91   * @dev total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 
222 /**
223  * @title Ownable
224  * @dev The Ownable contract has an owner address, and provides basic authorization control
225  * functions, this simplifies the implementation of "user permissions".
226  */
227 contract Ownable {
228   address public owner;
229 
230 
231   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233 
234   /**
235    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
236    * account.
237    */
238   function Ownable() public {
239     owner = msg.sender;
240   }
241 
242   /**
243    * @dev Throws if called by any account other than the owner.
244    */
245   modifier onlyOwner() {
246     require(msg.sender == owner);
247     _;
248   }
249 
250   /**
251    * @dev Allows the current owner to transfer control of the contract to a newOwner.
252    * @param newOwner The address to transfer ownership to.
253    */
254   function transferOwnership(address newOwner) public onlyOwner {
255     require(newOwner != address(0));
256     OwnershipTransferred(owner, newOwner);
257     owner = newOwner;
258   }
259 
260 }
261 
262 
263 
264 /**
265  * @title Mintable token
266  * @dev Simple ERC20 Token example, with mintable token creation
267  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
268  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
269  */
270 contract MintableToken is StandardToken, Ownable {
271   event Mint(address indexed to, uint256 amount);
272   event MintFinished();
273 
274   bool public mintingFinished = false;
275 
276 
277   modifier canMint() {
278     require(!mintingFinished);
279     _;
280   }
281 
282   /**
283    * @dev Function to mint tokens
284    * @param _to The address that will receive the minted tokens.
285    * @param _amount The amount of tokens to mint.
286    * @return A boolean that indicates if the operation was successful.
287    */
288   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
289     totalSupply_ = totalSupply_.add(_amount);
290     balances[_to] = balances[_to].add(_amount);
291     Mint(_to, _amount);
292     Transfer(address(0), _to, _amount);
293     return true;
294   }
295 
296   /**
297    * @dev Function to stop minting new tokens.
298    * @return True if the operation was successful.
299    */
300   function finishMinting() onlyOwner canMint public returns (bool) {
301     mintingFinished = true;
302     MintFinished();
303     return true;
304   }
305 }
306 
307 
308 
309 /**
310  * @title Capped token
311  * @dev Mintable token with a token cap.
312  */
313 contract CappedToken is MintableToken {
314 
315   uint256 public cap;
316 
317   function CappedToken(uint256 _cap) public {
318     require(_cap > 0);
319     cap = _cap;
320   }
321 
322   /**
323    * @dev Function to mint tokens
324    * @param _to The address that will receive the minted tokens.
325    * @param _amount The amount of tokens to mint.
326    * @return A boolean that indicates if the operation was successful.
327    */
328   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
329     require(totalSupply_.add(_amount) <= cap);
330 
331     return super.mint(_to, _amount);
332   }
333 
334 }
335 
336 
337 /**
338  * @title Heritable
339  * @dev The Heritable contract provides ownership transfer capabilities, in the
340  * case that the current owner stops "heartbeating". Only the heir can pronounce the
341  * owner's death.
342  */
343 contract Heritable is Ownable {
344   address private heir_;
345 
346   // Time window the owner has to notify they are alive.
347   uint256 private heartbeatTimeout_;
348 
349   // Timestamp of the owner's death, as pronounced by the heir.
350   uint256 private timeOfDeath_;
351 
352   event HeirChanged(address indexed owner, address indexed newHeir);
353   event OwnerHeartbeated(address indexed owner);
354   event OwnerProclaimedDead(address indexed owner, address indexed heir, uint256 timeOfDeath);
355   event HeirOwnershipClaimed(address indexed previousOwner, address indexed newOwner);
356 
357 
358   /**
359    * @dev Throw an exception if called by any account other than the heir's.
360    */
361   modifier onlyHeir() {
362     require(msg.sender == heir_);
363     _;
364   }
365 
366 
367   /**
368    * @notice Create a new Heritable Contract with heir address 0x0.
369    * @param _heartbeatTimeout time available for the owner to notify they are alive,
370    * before the heir can take ownership.
371    */
372   function Heritable(uint256 _heartbeatTimeout) public {
373     setHeartbeatTimeout(_heartbeatTimeout);
374   }
375 
376   function setHeir(address newHeir) public onlyOwner {
377     require(newHeir != owner);
378     heartbeat();
379     HeirChanged(owner, newHeir);
380     heir_ = newHeir;
381   }
382 
383   /**
384    * @dev Use these getter functions to access the internal variables in
385    * an inherited contract.
386    */
387   function heir() public view returns(address) {
388     return heir_;
389   }
390 
391   function heartbeatTimeout() public view returns(uint256) {
392     return heartbeatTimeout_;
393   }
394 
395   function timeOfDeath() public view returns(uint256) {
396     return timeOfDeath_;
397   }
398 
399   /**
400    * @dev set heir = 0x0
401    */
402   function removeHeir() public onlyOwner {
403     heartbeat();
404     heir_ = 0;
405   }
406 
407   /**
408    * @dev Heir can pronounce the owners death. To claim the ownership, they will
409    * have to wait for `heartbeatTimeout` seconds.
410    */
411   function proclaimDeath() public onlyHeir {
412     require(ownerLives());
413     OwnerProclaimedDead(owner, heir_, timeOfDeath_);
414     timeOfDeath_ = block.timestamp;
415   }
416 
417   /**
418    * @dev Owner can send a heartbeat if they were mistakenly pronounced dead.
419    */
420   function heartbeat() public onlyOwner {
421     OwnerHeartbeated(owner);
422     timeOfDeath_ = 0;
423   }
424 
425   /**
426    * @dev Allows heir to transfer ownership only if heartbeat has timed out.
427    */
428   function claimHeirOwnership() public onlyHeir {
429     require(!ownerLives());
430     require(block.timestamp >= timeOfDeath_ + heartbeatTimeout_);
431     OwnershipTransferred(owner, heir_);
432     HeirOwnershipClaimed(owner, heir_);
433     owner = heir_;
434     timeOfDeath_ = 0;
435   }
436 
437   function setHeartbeatTimeout(uint256 newHeartbeatTimeout) internal onlyOwner {
438     require(ownerLives());
439     heartbeatTimeout_ = newHeartbeatTimeout;
440   }
441 
442   function ownerLives() internal view returns (bool) {
443     return timeOfDeath_ == 0;
444   }
445 }
446 
447 
448 contract HawkToken is Heritable, CappedToken {
449     string public name = "HWK";
450     string public symbol = "HWK";
451     uint8 public decimals = 18;
452     function HawkToken
453     (
454 	uint256 _cap,
455 	uint256 _hbTimeout
456     )
457     public
458     Heritable(_hbTimeout)
459     CappedToken(_cap)
460     {}
461 
462     // Allow owner to change heartbeat's timeout
463     function setHBT(uint256 newHeartbeatTimeout) public onlyOwner {
464 	setHeartbeatTimeout(newHeartbeatTimeout);
465     }
466 
467 }