1 pragma solidity 0.4.24;
2 
3 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
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
45 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
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
93 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
107 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
153 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
154 
155 /**
156  * @title Burnable Token
157  * @dev Token that can be irreversibly burned (destroyed).
158  */
159 contract BurnableToken is BasicToken {
160 
161   event Burn(address indexed burner, uint256 value);
162 
163   /**
164    * @dev Burns a specific amount of tokens.
165    * @param _value The amount of token to be burned.
166    */
167   function burn(uint256 _value) public {
168     _burn(msg.sender, _value);
169   }
170 
171   function _burn(address _who, uint256 _value) internal {
172     require(_value <= balances[_who]);
173     // no need to require value <= totalSupply, since that would imply the
174     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
175 
176     balances[_who] = balances[_who].sub(_value);
177     totalSupply_ = totalSupply_.sub(_value);
178     emit Burn(_who, _value);
179     emit Transfer(_who, address(0), _value);
180   }
181 }
182 
183 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
184 
185 /**
186  * @title ERC20 interface
187  * @dev see https://github.com/ethereum/EIPs/issues/20
188  */
189 contract ERC20 is ERC20Basic {
190   function allowance(address owner, address spender) public view returns (uint256);
191   function transferFrom(address from, address to, uint256 value) public returns (bool);
192   function approve(address spender, uint256 value) public returns (bool);
193   event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * @dev https://github.com/ethereum/EIPs/issues/20
203  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  */
205 contract StandardToken is ERC20, BasicToken {
206 
207   mapping (address => mapping (address => uint256)) internal allowed;
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
217     require(_to != address(0));
218     require(_value <= balances[_from]);
219     require(_value <= allowed[_from][msg.sender]);
220 
221     balances[_from] = balances[_from].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224     emit Transfer(_from, _to, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230    *
231    * Beware that changing an allowance with this method brings the risk that someone may use both the old
232    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     emit Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param _owner address The address which owns the funds.
247    * @param _spender address The address which will spend the funds.
248    * @return A uint256 specifying the amount of tokens still available for the spender.
249    */
250   function allowance(address _owner, address _spender) public view returns (uint256) {
251     return allowed[_owner][_spender];
252   }
253 
254   /**
255    * @dev Increase the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To increment
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _addedValue The amount of tokens to increase the allowance by.
263    */
264   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
265     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270   /**
271    * @dev Decrease the amount of tokens that an owner allowed to a spender.
272    *
273    * approve should be called when allowed[_spender] == 0. To decrement
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _subtractedValue The amount of tokens to decrease the allowance by.
279    */
280   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
281     uint oldValue = allowed[msg.sender][_spender];
282     if (_subtractedValue > oldValue) {
283       allowed[msg.sender][_spender] = 0;
284     } else {
285       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
286     }
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291 }
292 
293 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
294 
295 /**
296  * @title Mintable token
297  * @dev Simple ERC20 Token example, with mintable token creation
298  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
299  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
300  */
301 contract MintableToken is StandardToken, Ownable {
302   event Mint(address indexed to, uint256 amount);
303   event MintFinished();
304 
305   bool public mintingFinished = false;
306 
307 
308   modifier canMint() {
309     require(!mintingFinished);
310     _;
311   }
312 
313   /**
314    * @dev Function to mint tokens
315    * @param _to The address that will receive the minted tokens.
316    * @param _amount The amount of tokens to mint.
317    * @return A boolean that indicates if the operation was successful.
318    */
319   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
320     totalSupply_ = totalSupply_.add(_amount);
321     balances[_to] = balances[_to].add(_amount);
322     emit Mint(_to, _amount);
323     emit Transfer(address(0), _to, _amount);
324     return true;
325   }
326 
327   /**
328    * @dev Function to stop minting new tokens.
329    * @return True if the operation was successful.
330    */
331   function finishMinting() onlyOwner canMint public returns (bool) {
332     mintingFinished = true;
333     emit MintFinished();
334     return true;
335   }
336 }
337 
338 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
339 
340 /**
341  * @title Capped token
342  * @dev Mintable token with a token cap.
343  */
344 contract CappedToken is MintableToken {
345 
346   uint256 public cap;
347 
348   function CappedToken(uint256 _cap) public {
349     require(_cap > 0);
350     cap = _cap;
351   }
352 
353   /**
354    * @dev Function to mint tokens
355    * @param _to The address that will receive the minted tokens.
356    * @param _amount The amount of tokens to mint.
357    * @return A boolean that indicates if the operation was successful.
358    */
359   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
360     require(totalSupply_.add(_amount) <= cap);
361 
362     return super.mint(_to, _amount);
363   }
364 
365 }
366 
367 // File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
368 
369 /**
370  * @title Pausable
371  * @dev Base contract which allows children to implement an emergency stop mechanism.
372  */
373 contract Pausable is Ownable {
374   event Pause();
375   event Unpause();
376 
377   bool public paused = false;
378 
379 
380   /**
381    * @dev Modifier to make a function callable only when the contract is not paused.
382    */
383   modifier whenNotPaused() {
384     require(!paused);
385     _;
386   }
387 
388   /**
389    * @dev Modifier to make a function callable only when the contract is paused.
390    */
391   modifier whenPaused() {
392     require(paused);
393     _;
394   }
395 
396   /**
397    * @dev called by the owner to pause, triggers stopped state
398    */
399   function pause() onlyOwner whenNotPaused public {
400     paused = true;
401     emit Pause();
402   }
403 
404   /**
405    * @dev called by the owner to unpause, returns to normal state
406    */
407   function unpause() onlyOwner whenPaused public {
408     paused = false;
409     emit Unpause();
410   }
411 }
412 
413 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
414 
415 /**
416  * @title Pausable token
417  * @dev StandardToken modified with pausable transfers.
418  **/
419 contract PausableToken is StandardToken, Pausable {
420 
421   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
422     return super.transfer(_to, _value);
423   }
424 
425   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
426     return super.transferFrom(_from, _to, _value);
427   }
428 
429   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
430     return super.approve(_spender, _value);
431   }
432 
433   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
434     return super.increaseApproval(_spender, _addedValue);
435   }
436 
437   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
438     return super.decreaseApproval(_spender, _subtractedValue);
439   }
440 }
441 
442 // File: contracts/VreoToken.sol
443 
444 /// @title VreoToken
445 /// @author Sicos et al.
446 contract VreoToken is CappedToken, PausableToken, BurnableToken {
447 
448     uint public constant TOTAL_TOKEN_CAP = 700000000e18;  // = 700.000.000 e18
449 
450     string public name = "MERO Token";
451     string public symbol = "MERO";
452     uint8 public decimals = 18;
453 
454     /// @dev Constructor
455     constructor() public CappedToken(TOTAL_TOKEN_CAP) {
456         pause();
457     }
458 
459 }
460 
461 // File: contracts/VreoTokenBounty.sol
462 
463 /// @title VreoTokenBounty
464 /// @author Sicos et al.
465 contract VreoTokenBounty is Ownable {
466 
467     VreoToken public token;
468 
469     /// @dev Constructor
470     /// @param _token A VreoToken
471     constructor(VreoToken _token) public {
472         require(address(_token) != address(0));
473 
474         token = _token;
475     }
476 
477     /// @dev Distribute tokens
478     /// @param _recipients A list of addresses of bounty recipients
479     /// @param _amounts A list of bounty amounts 
480     function distributeTokens(address[] _recipients, uint[] _amounts) public onlyOwner {
481         require(_recipients.length == _amounts.length);
482 
483         for (uint i = 0; i < _recipients.length; ++i) {
484             token.transfer(_recipients[i], _amounts[i]);
485         }
486     }
487 
488 }