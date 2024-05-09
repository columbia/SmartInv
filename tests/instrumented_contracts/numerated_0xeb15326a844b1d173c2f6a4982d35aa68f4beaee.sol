1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.18;
7 
8 /*************************************************************************
9  * import "zeppelin-solidity/contracts/token/MintableToken.sol" : start
10  *************************************************************************/
11 
12 
13 /*************************************************************************
14  * import "./StandardToken.sol" : start
15  *************************************************************************/
16 
17 
18 /*************************************************************************
19  * import "./BasicToken.sol" : start
20  *************************************************************************/
21 
22 
23 /*************************************************************************
24  * import "./ERC20Basic.sol" : start
25  *************************************************************************/
26 
27 
28 /**
29  * @title ERC20Basic
30  * @dev Simpler version of ERC20 interface
31  * @dev see https://github.com/ethereum/EIPs/issues/179
32  */
33 contract ERC20Basic {
34   uint256 public totalSupply;
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 /*************************************************************************
40  * import "./ERC20Basic.sol" : end
41  *************************************************************************/
42 /*************************************************************************
43  * import "../math/SafeMath.sol" : start
44  *************************************************************************/
45 
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66   }
67 
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 /*************************************************************************
80  * import "../math/SafeMath.sol" : end
81  *************************************************************************/
82 
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 /*************************************************************************
120  * import "./BasicToken.sol" : end
121  *************************************************************************/
122 /*************************************************************************
123  * import "./ERC20.sol" : start
124  *************************************************************************/
125 
126 
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public view returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 /*************************************************************************
141  * import "./ERC20.sol" : end
142  *************************************************************************/
143 
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(address _owner, address _spender) public view returns (uint256) {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   /**
218    * @dev Decrease the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To decrement
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _subtractedValue The amount of tokens to decrease the allowance by.
226    */
227   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
228     uint oldValue = allowed[msg.sender][_spender];
229     if (_subtractedValue > oldValue) {
230       allowed[msg.sender][_spender] = 0;
231     } else {
232       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233     }
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238 }
239 /*************************************************************************
240  * import "./StandardToken.sol" : end
241  *************************************************************************/
242 /*************************************************************************
243  * import "../ownership/Ownable.sol" : start
244  *************************************************************************/
245 
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258 
259   /**
260    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
261    * account.
262    */
263   function Ownable() public {
264     owner = msg.sender;
265   }
266 
267 
268   /**
269    * @dev Throws if called by any account other than the owner.
270    */
271   modifier onlyOwner() {
272     require(msg.sender == owner);
273     _;
274   }
275 
276 
277   /**
278    * @dev Allows the current owner to transfer control of the contract to a newOwner.
279    * @param newOwner The address to transfer ownership to.
280    */
281   function transferOwnership(address newOwner) public onlyOwner {
282     require(newOwner != address(0));
283     OwnershipTransferred(owner, newOwner);
284     owner = newOwner;
285   }
286 
287 }
288 /*************************************************************************
289  * import "../ownership/Ownable.sol" : end
290  *************************************************************************/
291 
292 
293 
294 /**
295  * @title Mintable token
296  * @dev Simple ERC20 Token example, with mintable token creation
297  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
298  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
299  */
300 
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
320     totalSupply = totalSupply.add(_amount);
321     balances[_to] = balances[_to].add(_amount);
322     Mint(_to, _amount);
323     Transfer(address(0), _to, _amount);
324     return true;
325   }
326 
327   /**
328    * @dev Function to stop minting new tokens.
329    * @return True if the operation was successful.
330    */
331   function finishMinting() onlyOwner canMint public returns (bool) {
332     mintingFinished = true;
333     MintFinished();
334     return true;
335   }
336 }
337 /*************************************************************************
338  * import "zeppelin-solidity/contracts/token/MintableToken.sol" : end
339  *************************************************************************/
340 /*************************************************************************
341  * import "zeppelin-solidity/contracts/token/BurnableToken.sol" : start
342  *************************************************************************/
343 
344 
345 
346 /**
347  * @title Burnable Token
348  * @dev Token that can be irreversibly burned (destroyed).
349  */
350 contract BurnableToken is BasicToken {
351 
352     event Burn(address indexed burner, uint256 value);
353 
354     /**
355      * @dev Burns a specific amount of tokens.
356      * @param _value The amount of token to be burned.
357      */
358     function burn(uint256 _value) public {
359         require(_value <= balances[msg.sender]);
360         // no need to require value <= totalSupply, since that would imply the
361         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
362 
363         address burner = msg.sender;
364         balances[burner] = balances[burner].sub(_value);
365         totalSupply = totalSupply.sub(_value);
366         Burn(burner, _value);
367     }
368 }
369 /*************************************************************************
370  * import "zeppelin-solidity/contracts/token/BurnableToken.sol" : end
371  *************************************************************************/
372 /*************************************************************************
373  * import "zeppelin-solidity/contracts/token/PausableToken.sol" : start
374  *************************************************************************/
375 
376 
377 /*************************************************************************
378  * import "../lifecycle/Pausable.sol" : start
379  *************************************************************************/
380 
381 
382 
383 
384 
385 /**
386  * @title Pausable
387  * @dev Base contract which allows children to implement an emergency stop mechanism.
388  */
389 contract Pausable is Ownable {
390   event Pause();
391   event Unpause();
392 
393   bool public paused = false;
394 
395 
396   /**
397    * @dev Modifier to make a function callable only when the contract is not paused.
398    */
399   modifier whenNotPaused() {
400     require(!paused);
401     _;
402   }
403 
404   /**
405    * @dev Modifier to make a function callable only when the contract is paused.
406    */
407   modifier whenPaused() {
408     require(paused);
409     _;
410   }
411 
412   /**
413    * @dev called by the owner to pause, triggers stopped state
414    */
415   function pause() onlyOwner whenNotPaused public {
416     paused = true;
417     Pause();
418   }
419 
420   /**
421    * @dev called by the owner to unpause, returns to normal state
422    */
423   function unpause() onlyOwner whenPaused public {
424     paused = false;
425     Unpause();
426   }
427 }
428 /*************************************************************************
429  * import "../lifecycle/Pausable.sol" : end
430  *************************************************************************/
431 
432 /**
433  * @title Pausable token
434  *
435  * @dev StandardToken modified with pausable transfers.
436  **/
437 
438 contract PausableToken is StandardToken, Pausable {
439 
440   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
441     return super.transfer(_to, _value);
442   }
443 
444   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
445     return super.transferFrom(_from, _to, _value);
446   }
447 
448   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
449     return super.approve(_spender, _value);
450   }
451 
452   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
453     return super.increaseApproval(_spender, _addedValue);
454   }
455 
456   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
457     return super.decreaseApproval(_spender, _subtractedValue);
458   }
459 }
460 /*************************************************************************
461  * import "zeppelin-solidity/contracts/token/PausableToken.sol" : end
462  *************************************************************************/
463 
464 /**
465    @title FNTToken, the Friend token
466 
467    Implementation of FRND, the ERC20 token for Friend, with extra methods
468    to transfer value and data to execute a call on transfer.
469    Uses OpenZeppelin BurnableToken, MintableToken and PausableToken.
470  */
471 contract FNTToken is BurnableToken, MintableToken, PausableToken {
472   // Token Name
473   string public constant NAME = "Friend Network Token";
474 
475   // Token Symbol
476   string public constant SYMBOL = "FRND";
477 
478   // Token decimals
479   uint8 public constant DECIMALS = 18;
480 
481 }