1 pragma solidity 0.4.23;
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
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     if (a == 0) {
58       return 0;
59     }
60     c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     // uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return a / b;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     emit Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
264 
265 /**
266  * @title Mintable token
267  * @dev Simple ERC20 Token example, with mintable token creation
268  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
269  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
270  */
271 contract MintableToken is StandardToken, Ownable {
272   event Mint(address indexed to, uint256 amount);
273   event MintFinished();
274 
275   bool public mintingFinished = false;
276 
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   /**
284    * @dev Function to mint tokens
285    * @param _to The address that will receive the minted tokens.
286    * @param _amount The amount of tokens to mint.
287    * @return A boolean that indicates if the operation was successful.
288    */
289   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
290     totalSupply_ = totalSupply_.add(_amount);
291     balances[_to] = balances[_to].add(_amount);
292     emit Mint(_to, _amount);
293     emit Transfer(address(0), _to, _amount);
294     return true;
295   }
296 
297   /**
298    * @dev Function to stop minting new tokens.
299    * @return True if the operation was successful.
300    */
301   function finishMinting() onlyOwner canMint public returns (bool) {
302     mintingFinished = true;
303     emit MintFinished();
304     return true;
305   }
306 }
307 
308 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
309 
310 /**
311  * @title Capped token
312  * @dev Mintable token with a token cap.
313  */
314 contract CappedToken is MintableToken {
315 
316   uint256 public cap;
317 
318   function CappedToken(uint256 _cap) public {
319     require(_cap > 0);
320     cap = _cap;
321   }
322 
323   /**
324    * @dev Function to mint tokens
325    * @param _to The address that will receive the minted tokens.
326    * @param _amount The amount of tokens to mint.
327    * @return A boolean that indicates if the operation was successful.
328    */
329   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
330     require(totalSupply_.add(_amount) <= cap);
331 
332     return super.mint(_to, _amount);
333   }
334 
335 }
336 
337 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
338 
339 /**
340  * @title Pausable
341  * @dev Base contract which allows children to implement an emergency stop mechanism.
342  */
343 contract Pausable is Ownable {
344   event Pause();
345   event Unpause();
346 
347   bool public paused = false;
348 
349 
350   /**
351    * @dev Modifier to make a function callable only when the contract is not paused.
352    */
353   modifier whenNotPaused() {
354     require(!paused);
355     _;
356   }
357 
358   /**
359    * @dev Modifier to make a function callable only when the contract is paused.
360    */
361   modifier whenPaused() {
362     require(paused);
363     _;
364   }
365 
366   /**
367    * @dev called by the owner to pause, triggers stopped state
368    */
369   function pause() onlyOwner whenNotPaused public {
370     paused = true;
371     emit Pause();
372   }
373 
374   /**
375    * @dev called by the owner to unpause, returns to normal state
376    */
377   function unpause() onlyOwner whenPaused public {
378     paused = false;
379     emit Unpause();
380   }
381 }
382 
383 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
384 
385 /**
386  * @title Pausable token
387  * @dev StandardToken modified with pausable transfers.
388  **/
389 contract PausableToken is StandardToken, Pausable {
390 
391   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
392     return super.transfer(_to, _value);
393   }
394 
395   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
396     return super.transferFrom(_from, _to, _value);
397   }
398 
399   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
400     return super.approve(_spender, _value);
401   }
402 
403   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
404     return super.increaseApproval(_spender, _addedValue);
405   }
406 
407   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
408     return super.decreaseApproval(_spender, _subtractedValue);
409   }
410 }
411 
412 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
413 
414 /**
415  * @title Burnable Token
416  * @dev Token that can be irreversibly burned (destroyed).
417  */
418 contract BurnableToken is BasicToken {
419 
420   event Burn(address indexed burner, uint256 value);
421 
422   /**
423    * @dev Burns a specific amount of tokens.
424    * @param _value The amount of token to be burned.
425    */
426   function burn(uint256 _value) public {
427     _burn(msg.sender, _value);
428   }
429 
430   function _burn(address _who, uint256 _value) internal {
431     require(_value <= balances[_who]);
432     // no need to require value <= totalSupply, since that would imply the
433     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
434 
435     balances[_who] = balances[_who].sub(_value);
436     totalSupply_ = totalSupply_.sub(_value);
437     emit Burn(_who, _value);
438     emit Transfer(_who, address(0), _value);
439   }
440 }
441 
442 // File: zeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
443 
444 /**
445  * @title Standard Burnable Token
446  * @dev Adds burnFrom method to ERC20 implementations
447  */
448 contract StandardBurnableToken is BurnableToken, StandardToken {
449 
450   /**
451    * @dev Burns a specific amount of tokens from the target address and decrements allowance
452    * @param _from address The address which you want to send tokens from
453    * @param _value uint256 The amount of token to be burned
454    */
455   function burnFrom(address _from, uint256 _value) public {
456     require(_value <= allowed[_from][msg.sender]);
457     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
458     // this function needs to emit an event with the updated approval.
459     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
460     _burn(_from, _value);
461   }
462 }
463 
464 // File: contracts/ORSToken.sol
465 
466 /// @title ORSToken
467 /// @author Sicos et al.
468 contract ORSToken is CappedToken, StandardBurnableToken, PausableToken {
469 
470     string public name = "ORS Token";
471     string public symbol = "ORS";
472     uint8 public decimals = 18;
473 
474     /// @dev Constructor
475     /// @param _cap Maximum number of integral token units; total supply must never exceed this limit
476     constructor(uint _cap) public CappedToken(_cap) {
477         pause();  // Disable token trade
478     }
479 
480 }