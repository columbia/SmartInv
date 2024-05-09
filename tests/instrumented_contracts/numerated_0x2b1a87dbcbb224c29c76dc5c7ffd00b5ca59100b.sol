1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev Total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev Transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender)
116     public view returns (uint256);
117 
118   function transferFrom(address from, address to, uint256 value)
119     public returns (bool);
120 
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(
123     address indexed owner,
124     address indexed spender,
125     uint256 value
126   );
127 }
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * https://github.com/ethereum/EIPs/issues/20
135  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amount of tokens to be transferred
147    */
148   function transferFrom(
149     address _from,
150     address _to,
151     uint256 _value
152   )
153     public
154     returns (bool)
155   {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     emit Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     emit Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(
189     address _owner,
190     address _spender
191    )
192     public
193     view
194     returns (uint256)
195   {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint256 _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseApproval(
231     address _spender,
232     uint256 _subtractedValue
233   )
234     public
235     returns (bool)
236   {
237     uint256 oldValue = allowed[msg.sender][_spender];
238     if (_subtractedValue > oldValue) {
239       allowed[msg.sender][_spender] = 0;
240     } else {
241       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242     }
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247 }
248 
249 /**
250  * @title Ownable
251  * @dev The Ownable contract has an owner address, and provides basic authorization control
252  * functions, this simplifies the implementation of "user permissions".
253  */
254 contract Ownable {
255   address public owner;
256 
257 
258   event OwnershipRenounced(address indexed previousOwner);
259   event OwnershipTransferred(
260     address indexed previousOwner,
261     address indexed newOwner
262   );
263 
264 
265   /**
266    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
267    * account.
268    */
269   constructor() public {
270     owner = msg.sender;
271   }
272 
273   /**
274    * @dev Throws if called by any account other than the owner.
275    */
276   modifier onlyOwner() {
277     require(msg.sender == owner);
278     _;
279   }
280 
281   /**
282    * @dev Allows the current owner to relinquish control of the contract.
283    * @notice Renouncing to ownership will leave the contract without an owner.
284    * It will not be possible to call the functions with the `onlyOwner`
285    * modifier anymore.
286    */
287   function renounceOwnership() public onlyOwner {
288     emit OwnershipRenounced(owner);
289     owner = address(0);
290   }
291 
292   /**
293    * @dev Allows the current owner to transfer control of the contract to a newOwner.
294    * @param _newOwner The address to transfer ownership to.
295    */
296   function transferOwnership(address _newOwner) public onlyOwner {
297     _transferOwnership(_newOwner);
298   }
299 
300   /**
301    * @dev Transfers control of the contract to a newOwner.
302    * @param _newOwner The address to transfer ownership to.
303    */
304   function _transferOwnership(address _newOwner) internal {
305     require(_newOwner != address(0));
306     emit OwnershipTransferred(owner, _newOwner);
307     owner = _newOwner;
308   }
309 }
310 
311 /**
312  * @title Pausable
313  * @dev Base contract which allows children to implement an emergency stop mechanism.
314  */
315 contract Pausable is Ownable {
316   event Pause();
317   event Unpause();
318 
319   bool public paused = false;
320 
321 
322   /**
323    * @dev Modifier to make a function callable only when the contract is not paused.
324    */
325   modifier whenNotPaused() {
326     require(!paused);
327     _;
328   }
329 
330   /**
331    * @dev Modifier to make a function callable only when the contract is paused.
332    */
333   modifier whenPaused() {
334     require(paused);
335     _;
336   }
337 
338   /**
339    * @dev called by the owner to pause, triggers stopped state
340    */
341   function pause() onlyOwner whenNotPaused public {
342     paused = true;
343     emit Pause();
344   }
345 
346   /**
347    * @dev called by the owner to unpause, returns to normal state
348    */
349   function unpause() onlyOwner whenPaused public {
350     paused = false;
351     emit Unpause();
352   }
353 }
354 
355 /**
356  * @title Pausable token
357  * @dev StandardToken modified with pausable transfers.
358  **/
359 contract PausableToken is StandardToken, Pausable {
360 
361   function transfer(
362     address _to,
363     uint256 _value
364   )
365     public
366     whenNotPaused
367     returns (bool)
368   {
369     return super.transfer(_to, _value);
370   }
371 
372   function transferFrom(
373     address _from,
374     address _to,
375     uint256 _value
376   )
377     public
378     whenNotPaused
379     returns (bool)
380   {
381     return super.transferFrom(_from, _to, _value);
382   }
383 
384   function approve(
385     address _spender,
386     uint256 _value
387   )
388     public
389     whenNotPaused
390     returns (bool)
391   {
392     return super.approve(_spender, _value);
393   }
394 
395   function increaseApproval(
396     address _spender,
397     uint _addedValue
398   )
399     public
400     whenNotPaused
401     returns (bool success)
402   {
403     return super.increaseApproval(_spender, _addedValue);
404   }
405 
406   function decreaseApproval(
407     address _spender,
408     uint _subtractedValue
409   )
410     public
411     whenNotPaused
412     returns (bool success)
413   {
414     return super.decreaseApproval(_spender, _subtractedValue);
415   }
416 }
417 
418 
419 
420 
421 /**
422  * @title Mintable token
423  * @dev Simple ERC20 Token example, with mintable token creation
424  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
425  */
426 contract MintableToken is PausableToken {
427   event Mint(address indexed to, uint256 amount);
428   event MintFinished();
429 
430   bool public mintingFinished = false;
431 
432 
433   modifier canMint() {
434     require(!mintingFinished);
435     _;
436   }
437 
438   modifier hasMintPermission() {
439     require(msg.sender == owner);
440     _;
441   }
442 
443   /**
444    * @dev Function to mint tokens
445    * @param _to The address that will receive the minted tokens.
446    * @param _amount The amount of tokens to mint.
447    * @return A boolean that indicates if the operation was successful.
448    */
449   function mint(
450     address _to,
451     uint256 _amount
452   )
453     hasMintPermission
454     canMint
455     public
456     returns (bool)
457   {
458     totalSupply_ = totalSupply_.add(_amount);
459     balances[_to] = balances[_to].add(_amount);
460     emit Mint(_to, _amount);
461     emit Transfer(address(0), _to, _amount);
462     return true;
463   }
464 
465   /**
466    * @dev Function to stop minting new tokens.
467    * @return True if the operation was successful.
468    */
469   function finishMinting() onlyOwner canMint public returns (bool) {
470     mintingFinished = true;
471     emit MintFinished();
472     return true;
473   }
474 }
475 
476 /**
477  * @title Burnable Token
478  * @dev Token that can be irreversibly burned (destroyed).
479  */
480 contract BurnableToken is MintableToken {
481 
482   event Burn(address indexed burner, uint256 value);
483 
484   /**
485    * @dev Burns a specific amount of tokens.
486    * @param _value The amount of token to be burned.
487    */
488   function burn(uint256 _value) public {
489     _burn(msg.sender, _value);
490   }
491 
492   function _burn(address _who, uint256 _value) internal {
493     require(_value <= balances[_who]);
494     // no need to require value <= totalSupply, since that would imply the
495     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
496 
497     balances[_who] = balances[_who].sub(_value);
498     totalSupply_ = totalSupply_.sub(_value);
499     emit Burn(_who, _value);
500     emit Transfer(_who, address(0), _value);
501   }
502 }
503 
504 contract VitaToken is BurnableToken {
505   string public name = "VITA Token";
506   string public symbol = "VITA";
507   uint256 public decimals = 18;
508 }