1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
51 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
52 
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 // File: zeppelin-solidity/contracts/token/BasicToken.sol
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78 
79   /**
80   * @dev total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
113 
114 /**
115  * @title Burnable Token
116  * @dev Token that can be irreversibly burned (destroyed).
117  */
118 contract BurnableToken is BasicToken {
119 
120   event Burn(address indexed burner, uint256 value);
121 
122   /**
123    * @dev Burns a specific amount of tokens.
124    * @param _value The amount of token to be burned.
125    */
126   function burn(uint256 _value) public {
127     _burn(msg.sender, _value);
128   }
129 
130   function _burn(address _who, uint256 _value) internal {
131     require(_value <= balances[_who]);
132     // no need to require value <= totalSupply, since that would imply the
133     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
134 
135     balances[_who] = balances[_who].sub(_value);
136     totalSupply_ = totalSupply_.sub(_value);
137     emit Burn(_who, _value);
138     emit Transfer(_who, address(0), _value);
139   }
140 }
141 
142 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   function Ownable() public {
161     owner = msg.sender;
162   }
163 
164   /**
165    * @dev Throws if called by any account other than the owner.
166    */
167   modifier onlyOwner() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172   /**
173    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174    * @param newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address newOwner) public onlyOwner {
177     require(newOwner != address(0));
178     emit OwnershipTransferred(owner, newOwner);
179     owner = newOwner;
180   }
181 
182 }
183 
184 // File: zeppelin-solidity/contracts/token/ERC20.sol
185 
186 /**
187  * @title ERC20 interface
188  * @dev see https://github.com/ethereum/EIPs/issues/20
189  */
190 contract ERC20 is ERC20Basic {
191   function allowance(address owner, address spender) public view returns (uint256);
192   function transferFrom(address from, address to, uint256 value) public returns (bool);
193   function approve(address spender, uint256 value) public returns (bool);
194   event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 // File: zeppelin-solidity/contracts/token/StandardToken.sol
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
218     require(_to != address(0));
219     require(_value <= balances[_from]);
220     require(_value <= allowed[_from][msg.sender]);
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     emit Transfer(_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231    *
232    * Beware that changing an allowance with this method brings the risk that someone may use both the old
233    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     emit Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(address _owner, address _spender) public view returns (uint256) {
252     return allowed[_owner][_spender];
253   }
254 
255   /**
256    * @dev Increase the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _addedValue The amount of tokens to increase the allowance by.
264    */
265   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
266     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271   /**
272    * @dev Decrease the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To decrement
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _subtractedValue The amount of tokens to decrease the allowance by.
280    */
281   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
282     uint oldValue = allowed[msg.sender][_spender];
283     if (_subtractedValue > oldValue) {
284       allowed[msg.sender][_spender] = 0;
285     } else {
286       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
287     }
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292 }
293 
294 // File: zeppelin-solidity/contracts/token/MintableToken.sol
295 
296 /**
297  * @title Mintable token
298  * @dev Simple ERC20 Token example, with mintable token creation
299  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
300  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
301  */
302 contract MintableToken is StandardToken, Ownable {
303   event Mint(address indexed to, uint256 amount);
304   event MintFinished();
305 
306   bool public mintingFinished = false;
307 
308 
309   modifier canMint() {
310     require(!mintingFinished);
311     _;
312   }
313 
314   /**
315    * @dev Function to mint tokens
316    * @param _to The address that will receive the minted tokens.
317    * @param _amount The amount of tokens to mint.
318    * @return A boolean that indicates if the operation was successful.
319    */
320   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
321     totalSupply_ = totalSupply_.add(_amount);
322     balances[_to] = balances[_to].add(_amount);
323     emit Mint(_to, _amount);
324     emit Transfer(address(0), _to, _amount);
325     return true;
326   }
327 
328   /**
329    * @dev Function to stop minting new tokens.
330    * @return True if the operation was successful.
331    */
332   function finishMinting() onlyOwner canMint public returns (bool) {
333     mintingFinished = true;
334     emit MintFinished();
335     return true;
336   }
337 }
338 
339 
340 // File: zeppelin-solidity/contracts/token/CappedToken.sol
341 
342 /**
343  * @title Capped token
344  * @dev Mintable token with a token cap.
345  */
346 
347 contract CappedToken is MintableToken {
348 
349   uint256 public cap;
350 
351   function CappedToken(uint256 _cap) public {
352     require(_cap > 0);
353     cap = _cap;
354   }
355 
356   /**
357    * @dev Function to mint tokens
358    * @param _to The address that will receive the minted tokens.
359    * @param _amount The amount of tokens to mint.
360    * @return A boolean that indicates if the operation was successful.
361    */
362   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
363     require(totalSupply().add(_amount) <= cap);
364 
365     return super.mint(_to, _amount);
366   }
367 
368 }
369 
370 // File: zeppelin-solidity/contracts/token/DetailedERC20.sol
371 
372 contract DetailedERC20 is ERC20 {
373   string public name;
374   string public symbol;
375   uint8 public decimals;
376 
377   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
378     name = _name;
379     symbol = _symbol;
380     decimals = _decimals;
381   }
382 }
383 
384 
385 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
386 
387 /**
388  * @title Pausable
389  * @dev Base contract which allows children to implement an emergency stop mechanism.
390  */
391 contract Pausable is Ownable {
392   event Pause();
393   event Unpause();
394 
395   bool public paused = false;
396 
397 
398   /**
399    * @dev Modifier to make a function callable only when the contract is not paused.
400    */
401   modifier whenNotPaused() {
402     require(!paused);
403     _;
404   }
405 
406   /**
407    * @dev Modifier to make a function callable only when the contract is paused.
408    */
409   modifier whenPaused() {
410     require(paused);
411     _;
412   }
413 
414   /**
415    * @dev called by the owner to pause, triggers stopped state
416    */
417   function pause() onlyOwner whenNotPaused public {
418     paused = true;
419     emit Pause();
420   }
421 
422   /**
423    * @dev called by the owner to unpause, returns to normal state
424    */
425   function unpause() onlyOwner whenPaused public {
426     paused = false;
427     emit Unpause();
428   }
429 }
430 
431 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
432 
433 /**
434  * @title Pausable token
435  * @dev StandardToken modified with pausable transfers.
436  **/
437 contract PausableToken is StandardToken, Pausable {
438 
439   function transfer(
440     address _to,
441     uint256 _value
442   )
443     public
444     whenNotPaused
445     returns (bool)
446   {
447     return super.transfer(_to, _value);
448   }
449 
450   function transferFrom(
451     address _from,
452     address _to,
453     uint256 _value
454   )
455     public
456     whenNotPaused
457     returns (bool)
458   {
459     return super.transferFrom(_from, _to, _value);
460   }
461 
462   function approve(
463     address _spender,
464     uint256 _value
465   )
466     public
467     whenNotPaused
468     returns (bool)
469   {
470     return super.approve(_spender, _value);
471   }
472 
473   function increaseApproval(
474     address _spender,
475     uint _addedValue
476   )
477     public
478     whenNotPaused
479     returns (bool success)
480   {
481     return super.increaseApproval(_spender, _addedValue);
482   }
483 
484   function decreaseApproval(
485     address _spender,
486     uint _subtractedValue
487   )
488     public
489     whenNotPaused
490     returns (bool success)
491   {
492     return super.decreaseApproval(_spender, _subtractedValue);
493   }
494 }
495 
496 // File: contracts/ERC20Template.sol
497 
498 /**
499  * Use OpenZeppelin Libraries
500  * @author developer@fbee.one
501  */
502 contract ERC20Template is DetailedERC20, PausableToken, BurnableToken, CappedToken {
503   /**
504    * @dev Set the maximum issuance cap and token details.
505    */
506   function ERC20Template(string _name, string _symbol, uint8 _decimals, uint256 initialSupply, address initHold) public
507     DetailedERC20(_name, _symbol, _decimals)
508     CappedToken( initialSupply )
509    {
510     mint(initHold, initialSupply);
511     transferOwnership(initHold);
512   }
513 }