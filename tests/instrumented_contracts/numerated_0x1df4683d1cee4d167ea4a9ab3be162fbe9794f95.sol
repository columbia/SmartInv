1 pragma solidity 0.4.24;
2 
3 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
65 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
112 
113 /**
114  * @title Burnable Token
115  * @dev Token that can be irreversibly burned (destroyed).
116  */
117 contract BurnableToken is BasicToken {
118 
119   event Burn(address indexed burner, uint256 value);
120 
121   /**
122    * @dev Burns a specific amount of tokens.
123    * @param _value The amount of token to be burned.
124    */
125   function burn(uint256 _value) public {
126     _burn(msg.sender, _value);
127   }
128 
129   function _burn(address _who, uint256 _value) internal {
130     require(_value <= balances[_who]);
131     // no need to require value <= totalSupply, since that would imply the
132     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
133 
134     balances[_who] = balances[_who].sub(_value);
135     totalSupply_ = totalSupply_.sub(_value);
136     emit Burn(_who, _value);
137     emit Transfer(_who, address(0), _value);
138   }
139 }
140 
141 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
142 
143 /**
144  * @title Ownable
145  * @dev The Ownable contract has an owner address, and provides basic authorization control
146  * functions, this simplifies the implementation of "user permissions".
147  */
148 contract Ownable {
149   address public owner;
150 
151 
152   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154 
155   /**
156    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157    * account.
158    */
159   function Ownable() public {
160     owner = msg.sender;
161   }
162 
163   /**
164    * @dev Throws if called by any account other than the owner.
165    */
166   modifier onlyOwner() {
167     require(msg.sender == owner);
168     _;
169   }
170 
171   /**
172    * @dev Allows the current owner to transfer control of the contract to a newOwner.
173    * @param newOwner The address to transfer ownership to.
174    */
175   function transferOwnership(address newOwner) public onlyOwner {
176     require(newOwner != address(0));
177     emit OwnershipTransferred(owner, newOwner);
178     owner = newOwner;
179   }
180 
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
450     string public name = "VREO Token";
451     string public symbol = "VREO";
452     uint8 public decimals = 18;
453 
454     /// @dev Constructor
455     constructor() public CappedToken(TOTAL_TOKEN_CAP) {
456         pause();
457     }
458 
459 }