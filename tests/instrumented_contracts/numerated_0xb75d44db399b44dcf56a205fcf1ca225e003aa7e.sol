1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-16
3 */
4 
5 pragma solidity ^0.4.23;
6 
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender)
66     public view returns (uint256);
67 
68   function transferFrom(address from, address to, uint256 value)
69     public returns (bool);
70 
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(
73     address indexed owner,
74     address indexed spender,
75     uint256 value
76   );
77 }
78 
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract Ownable {
85   address public owner;
86 
87 
88   event OwnershipRenounced(address indexed previousOwner);
89   event OwnershipTransferred(
90     address indexed previousOwner,
91     address indexed newOwner
92   );
93 
94 
95   /**
96    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
97    * account.
98    */
99   constructor() public {
100     owner = msg.sender;
101   }
102 
103   /**
104    * @dev Throws if called by any account other than the owner.
105    */
106   modifier onlyOwner() {
107     require(msg.sender == owner);
108     _;
109   }
110 }
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123   /**
124   * @dev total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 /**
157  * @title Burnable Token
158  * @dev Token that can be irreversibly burned (destroyed).
159  */
160 contract BurnableToken is BasicToken {
161 
162   event Burn(address indexed burner, uint256 value);
163 
164   /**
165    * @dev Burns a specific amount of tokens.
166    * @param _value The amount of token to be burned.
167    */
168   function burn(uint256 _value) public {
169     _burn(msg.sender, _value);
170   }
171 
172   function _burn(address _who, uint256 _value) internal {
173     require(_value <= balances[_who]);
174     // no need to require value <= totalSupply, since that would imply the
175     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
176 
177     balances[_who] = balances[_who].sub(_value);
178     totalSupply_ = totalSupply_.sub(_value);
179     emit Burn(_who, _value);
180     emit Transfer(_who, address(0), _value);
181   }
182 }
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(
203     address _from,
204     address _to,
205     uint256 _value
206   )
207     public
208     returns (bool)
209   {
210     require(_to != address(0));
211     require(_value <= balances[_from]);
212     require(_value <= allowed[_from][msg.sender]);
213 
214     balances[_from] = balances[_from].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217     emit Transfer(_from, _to, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    *
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     emit Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(
244     address _owner,
245     address _spender
246    )
247     public
248     view
249     returns (uint256)
250   {
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
264   function increaseApproval(
265     address _spender,
266     uint _addedValue
267   )
268     public
269     returns (bool)
270   {
271     allowed[msg.sender][_spender] = (
272       allowed[msg.sender][_spender].add(_addedValue));
273     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
287   function decreaseApproval(
288     address _spender,
289     uint _subtractedValue
290   )
291     public
292     returns (bool)
293   {
294     uint oldValue = allowed[msg.sender][_spender];
295     if (_subtractedValue > oldValue) {
296       allowed[msg.sender][_spender] = 0;
297     } else {
298       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299     }
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304 }
305 
306 
307 
308 /**
309  * @title Standard Burnable Token
310  * @dev Adds burnFrom method to ERC20 implementations
311  */
312 contract StandardBurnableToken is BurnableToken, StandardToken {
313 
314   /**
315    * @dev Burns a specific amount of tokens from the target address and decrements allowance
316    * @param _from address The address which you want to send tokens from
317    * @param _value uint256 The amount of token to be burned
318    */
319   function burnFrom(address _from, uint256 _value) public {
320     require(_value <= allowed[_from][msg.sender]);
321     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
322     // this function needs to emit an event with the updated approval.
323     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
324     _burn(_from, _value);
325   }
326 }
327 
328 /**
329  * @title DetailedERC20 token
330  * @dev The decimals are only for visualization purposes.
331  * All the operations are done using the smallest and indivisible token unit,
332  * just as on Ethereum all the operations are done in wei.
333  */
334 contract DetailedERC20 is ERC20 {
335   string public name;
336   string public symbol;
337   uint8 public decimals;
338 
339   constructor(string _name, string _symbol, uint8 _decimals) public {
340     name = _name;
341     symbol = _symbol;
342     decimals = _decimals;
343   }
344 }
345 
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
379     emit Pause();
380   }
381 
382   /**
383    * @dev called by the owner to unpause, returns to normal state
384    */
385   function unpause() onlyOwner whenPaused public {
386     paused = false;
387     emit Unpause();
388   }
389 }
390 
391 
392 
393 /**
394  * @title Pausable token
395  * @dev StandardToken modified with pausable transfers.
396  **/
397 contract PausableToken is StandardToken, Pausable {
398 
399   function transfer(
400     address _to,
401     uint256 _value
402   )
403     public
404     whenNotPaused
405     returns (bool)
406   {
407     return super.transfer(_to, _value);
408   }
409 
410   function transferFrom(
411     address _from,
412     address _to,
413     uint256 _value
414   )
415     public
416     whenNotPaused
417     returns (bool)
418   {
419     return super.transferFrom(_from, _to, _value);
420   }
421 
422   function approve(
423     address _spender,
424     uint256 _value
425   )
426     public
427     whenNotPaused
428     returns (bool)
429   {
430     return super.approve(_spender, _value);
431   }
432 
433   function increaseApproval(
434     address _spender,
435     uint _addedValue
436   )
437     public
438     whenNotPaused
439     returns (bool success)
440   {
441     return super.increaseApproval(_spender, _addedValue);
442   }
443 
444   function decreaseApproval(
445     address _spender,
446     uint _subtractedValue
447   )
448     public
449     whenNotPaused
450     returns (bool success)
451   {
452     return super.decreaseApproval(_spender, _subtractedValue);
453   }
454 }
455 
456 
457 /**
458  * A base token for the Ether Stake Token (or any other coin with similar behavior).
459  * Compatible with contracts and UIs expecting a ERC20 token.
460  * Provides also a convenience method to burn tokens, permanently removing them from the pool;
461  * the intent of this convenience method is for users who wish to burn tokens
462  * (as they always can via a transfer to an unowned address or self-destructing
463  * contract) to do so in a way that is then reflected in the token's total supply.
464  */
465 contract BaseERC20Token is StandardBurnableToken, PausableToken, DetailedERC20 {
466 
467   constructor(
468     uint256 _initialAmount,
469     uint8 _decimalUnits,
470     string _tokenName,
471     string _tokenSymbol
472   ) DetailedERC20(_tokenName, _tokenSymbol, _decimalUnits) public {
473     totalSupply_ = _initialAmount;
474     balances[msg.sender] = totalSupply_;
475   }
476 
477   // override the burnable token's "Burn" function: don't allow tokens to
478   // be burned when paused
479   function _burn(address _from, uint256 _value) internal whenNotPaused {
480     super._burn(_from, _value);
481   }
482 
483 }
484 
485 
486 contract EtherStakeToken is BaseERC20Token {
487   constructor() BaseERC20Token(1000000000000000, 5, "Ether Stake Token", "ETSK") public {
488     // nothing else needed
489   }
490 }