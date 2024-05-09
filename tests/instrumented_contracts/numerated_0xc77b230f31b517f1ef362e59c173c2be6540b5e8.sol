1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender)
62     public view returns (uint256);
63 
64   function transferFrom(address from, address to, uint256 value)
65     public returns (bool);
66 
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(
69     address indexed owner,
70     address indexed spender,
71     uint256 value
72   );
73 }
74 
75 /**
76  * @title Ownable
77  * @dev The Ownable contract has an owner address, and provides basic authorization control
78  * functions, this simplifies the implementation of "user permissions".
79  */
80 contract Ownable {
81   address public owner;
82 
83 
84   event OwnershipRenounced(address indexed previousOwner);
85   event OwnershipTransferred(
86     address indexed previousOwner,
87     address indexed newOwner
88   );
89 
90 
91   /**
92    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
93    * account.
94    */
95   constructor() public {
96     owner = msg.sender;
97   }
98 
99   /**
100    * @dev Throws if called by any account other than the owner.
101    */
102   modifier onlyOwner() {
103     require(msg.sender == owner);
104     _;
105   }
106 
107   /**
108    * @dev Allows the current owner to relinquish control of the contract.
109    */
110   function renounceOwnership() public onlyOwner {
111     emit OwnershipRenounced(owner);
112     owner = address(0);
113   }
114 
115   /**
116    * @dev Allows the current owner to transfer control of the contract to a newOwner.
117    * @param _newOwner The address to transfer ownership to.
118    */
119   function transferOwnership(address _newOwner) public onlyOwner {
120     _transferOwnership(_newOwner);
121   }
122 
123   /**
124    * @dev Transfers control of the contract to a newOwner.
125    * @param _newOwner The address to transfer ownership to.
126    */
127   function _transferOwnership(address _newOwner) internal {
128     require(_newOwner != address(0));
129     emit OwnershipTransferred(owner, _newOwner);
130     owner = _newOwner;
131   }
132 }
133 
134 /**
135  * @title Basic token
136  * @dev Basic version of StandardToken, with no allowances.
137  */
138 contract BasicToken is ERC20Basic {
139   using SafeMath for uint256;
140 
141   mapping(address => uint256) balances;
142 
143   uint256 totalSupply_;
144 
145   /**
146   * @dev total number of tokens in existence
147   */
148   function totalSupply() public view returns (uint256) {
149     return totalSupply_;
150   }
151 
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[msg.sender]);
160 
161     balances[msg.sender] = balances[msg.sender].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     emit Transfer(msg.sender, _to, _value);
164     return true;
165   }
166 
167   /**
168   * @dev Gets the balance of the specified address.
169   * @param _owner The address to query the the balance of.
170   * @return An uint256 representing the amount owned by the passed address.
171   */
172   function balanceOf(address _owner) public view returns (uint256) {
173     return balances[_owner];
174   }
175 
176 }
177 
178 /**
179  * @title Burnable Token
180  * @dev Token that can be irreversibly burned (destroyed).
181  */
182 contract BurnableToken is BasicToken {
183 
184   event Burn(address indexed burner, uint256 value);
185 
186   /**
187    * @dev Burns a specific amount of tokens.
188    * @param _value The amount of token to be burned.
189    */
190   function burn(uint256 _value) public {
191     _burn(msg.sender, _value);
192   }
193 
194   function _burn(address _who, uint256 _value) internal {
195     require(_value <= balances[_who]);
196     // no need to require value <= totalSupply, since that would imply the
197     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
198 
199     balances[_who] = balances[_who].sub(_value);
200     totalSupply_ = totalSupply_.sub(_value);
201     emit Burn(_who, _value);
202     emit Transfer(_who, address(0), _value);
203   }
204 }
205 
206 
207 
208 
209 
210 
211 
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * @dev https://github.com/ethereum/EIPs/issues/20
217  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218  */
219 contract StandardToken is ERC20, BasicToken {
220 
221   mapping (address => mapping (address => uint256)) internal allowed;
222 
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(
231     address _from,
232     address _to,
233     uint256 _value
234   )
235     public
236     returns (bool)
237   {
238     require(_to != address(0));
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     emit Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    *
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     emit Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(
272     address _owner,
273     address _spender
274    )
275     public
276     view
277     returns (uint256)
278   {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * @dev Increase the amount of tokens that an owner allowed to a spender.
284    *
285    * approve should be called when allowed[_spender] == 0. To increment
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _addedValue The amount of tokens to increase the allowance by.
291    */
292   function increaseApproval(
293     address _spender,
294     uint _addedValue
295   )
296     public
297     returns (bool)
298   {
299     allowed[msg.sender][_spender] = (
300       allowed[msg.sender][_spender].add(_addedValue));
301     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305   /**
306    * @dev Decrease the amount of tokens that an owner allowed to a spender.
307    *
308    * approve should be called when allowed[_spender] == 0. To decrement
309    * allowed value is better to use this function to avoid 2 calls (and wait until
310    * the first transaction is mined)
311    * From MonolithDAO Token.sol
312    * @param _spender The address which will spend the funds.
313    * @param _subtractedValue The amount of tokens to decrease the allowance by.
314    */
315   function decreaseApproval(
316     address _spender,
317     uint _subtractedValue
318   )
319     public
320     returns (bool)
321   {
322     uint oldValue = allowed[msg.sender][_spender];
323     if (_subtractedValue > oldValue) {
324       allowed[msg.sender][_spender] = 0;
325     } else {
326       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
327     }
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332 }
333 
334 
335 
336 /**
337  * @title Standard Burnable Token
338  * @dev Adds burnFrom method to ERC20 implementations
339  */
340 contract StandardBurnableToken is BurnableToken, StandardToken {
341 
342   /**
343    * @dev Burns a specific amount of tokens from the target address and decrements allowance
344    * @param _from address The address which you want to send tokens from
345    * @param _value uint256 The amount of token to be burned
346    */
347   function burnFrom(address _from, uint256 _value) public {
348     require(_value <= allowed[_from][msg.sender]);
349     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
350     // this function needs to emit an event with the updated approval.
351     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
352     _burn(_from, _value);
353   }
354 }
355 
356 
357 
358 
359 
360 
361 
362 
363 
364 
365 
366 
367 /**
368  * @title DetailedERC20 token
369  * @dev The decimals are only for visualization purposes.
370  * All the operations are done using the smallest and indivisible token unit,
371  * just as on Ethereum all the operations are done in wei.
372  */
373 contract DetailedERC20 is ERC20 {
374   string public name;
375   string public symbol;
376   uint8 public decimals;
377 
378   constructor(string _name, string _symbol, uint8 _decimals) public {
379     name = _name;
380     symbol = _symbol;
381     decimals = _decimals;
382   }
383 }
384 
385 
386 /**
387  * @title Pausable
388  * @dev Base contract which allows children to implement an emergency stop mechanism.
389  */
390 contract Pausable is Ownable {
391   event Pause();
392   event Unpause();
393 
394   bool public paused = false;
395 
396 
397   /**
398    * @dev Modifier to make a function callable only when the contract is not paused.
399    */
400   modifier whenNotPaused() {
401     require(!paused);
402     _;
403   }
404 
405   /**
406    * @dev Modifier to make a function callable only when the contract is paused.
407    */
408   modifier whenPaused() {
409     require(paused);
410     _;
411   }
412 
413   /**
414    * @dev called by the owner to pause, triggers stopped state
415    */
416   function pause() onlyOwner whenNotPaused public {
417     paused = true;
418     emit Pause();
419   }
420 
421   /**
422    * @dev called by the owner to unpause, returns to normal state
423    */
424   function unpause() onlyOwner whenPaused public {
425     paused = false;
426     emit Unpause();
427   }
428 }
429 
430 
431 
432 /**
433  * @title Pausable token
434  * @dev StandardToken modified with pausable transfers.
435  **/
436 contract PausableToken is StandardToken, Pausable {
437 
438   function transfer(
439     address _to,
440     uint256 _value
441   )
442     public
443     whenNotPaused
444     returns (bool)
445   {
446     return super.transfer(_to, _value);
447   }
448 
449   function transferFrom(
450     address _from,
451     address _to,
452     uint256 _value
453   )
454     public
455     whenNotPaused
456     returns (bool)
457   {
458     return super.transferFrom(_from, _to, _value);
459   }
460 
461   function approve(
462     address _spender,
463     uint256 _value
464   )
465     public
466     whenNotPaused
467     returns (bool)
468   {
469     return super.approve(_spender, _value);
470   }
471 
472   function increaseApproval(
473     address _spender,
474     uint _addedValue
475   )
476     public
477     whenNotPaused
478     returns (bool success)
479   {
480     return super.increaseApproval(_spender, _addedValue);
481   }
482 
483   function decreaseApproval(
484     address _spender,
485     uint _subtractedValue
486   )
487     public
488     whenNotPaused
489     returns (bool success)
490   {
491     return super.decreaseApproval(_spender, _subtractedValue);
492   }
493 }
494 
495 
496 /**
497  * A base token for the VidyCoin (or any other coin with similar behavior).
498  * Compatible with contracts and UIs expecting a ERC20 token.
499  * Provides also a convenience method to burn tokens, permanently removing them from the pool;
500  * the intent of this convenience method is for users who wish to burn tokens
501  * (as they always can via a transfer to an unowned address or self-destructing
502  * contract) to do so in a way that is then reflected in the token's total supply.
503  */
504 contract BaseERC20Token is StandardBurnableToken, PausableToken, DetailedERC20 {
505 
506   constructor(
507     uint256 _initialAmount,
508     uint8 _decimalUnits,
509     string _tokenName,
510     string _tokenSymbol
511   ) DetailedERC20(_tokenName, _tokenSymbol, _decimalUnits) public {
512     totalSupply_ = _initialAmount;
513     balances[msg.sender] = totalSupply_;
514   }
515 
516   // override the burnable token's "Burn" function: don't allow tokens to
517   // be burned when paused
518   function _burn(address _from, uint256 _value) internal whenNotPaused {
519     super._burn(_from, _value);
520   }
521 
522 }
523 
524 
525 contract VidyCoin is BaseERC20Token {
526   constructor() BaseERC20Token(10000000000000000000000000000, 18, "VidyCoin", "VIDY") public {
527     // nothing else needed
528   }
529 }