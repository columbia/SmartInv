1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
27     // benefit is lost if 'b' is also tested.
28     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29     if (a == 0) {
30       return 0;
31     }
32 
33     c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     // uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return a / b;
46   }
47 
48   /**
49   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60     c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
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
78   * @dev total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev transfer token for a specified address
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
111  * @title Burnable Token
112  * @dev Token that can be irreversibly burned (destroyed).
113  */
114 contract BurnableToken is BasicToken {
115 
116   event Burn(address indexed burner, uint256 value);
117 
118   /**
119    * @dev Burns a specific amount of tokens.
120    * @param _value The amount of token to be burned.
121    */
122   function burn(uint256 _value) public {
123     _burn(msg.sender, _value);
124   }
125 
126   function _burn(address _who, uint256 _value) internal {
127     require(_value <= balances[_who]);
128     // no need to require value <= totalSupply, since that would imply the
129     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131     balances[_who] = balances[_who].sub(_value);
132     totalSupply_ = totalSupply_.sub(_value);
133     emit Burn(_who, _value);
134     emit Transfer(_who, address(0), _value);
135   }
136 }
137 
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract ERC20 is ERC20Basic {
144   function allowance(address owner, address spender)
145     public view returns (uint256);
146 
147   function transferFrom(address from, address to, uint256 value)
148     public returns (bool);
149 
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(
152     address indexed owner,
153     address indexed spender,
154     uint256 value
155   );
156 }
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public
182     returns (bool)
183   {
184     require(_to != address(0));
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    *
198    * Beware that changing an allowance with this method brings the risk that someone may use both the old
199    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) public returns (bool) {
206     allowed[msg.sender][_spender] = _value;
207     emit Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(
218     address _owner,
219     address _spender
220    )
221     public
222     view
223     returns (uint256)
224   {
225     return allowed[_owner][_spender];
226   }
227 
228   /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _addedValue The amount of tokens to increase the allowance by.
237    */
238   function increaseApproval(
239     address _spender,
240     uint _addedValue
241   )
242     public
243     returns (bool)
244   {
245     allowed[msg.sender][_spender] = (
246       allowed[msg.sender][_spender].add(_addedValue));
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Decrease the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(
262     address _spender,
263     uint _subtractedValue
264   )
265     public
266     returns (bool)
267   {
268     uint oldValue = allowed[msg.sender][_spender];
269     if (_subtractedValue > oldValue) {
270       allowed[msg.sender][_spender] = 0;
271     } else {
272       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273     }
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278 }
279 
280 
281 /**
282  * @title Ownable
283  * @dev The Ownable contract has an owner address, and provides basic authorization control
284  * functions, this simplifies the implementation of "user permissions".
285  */
286 contract Ownable {
287   address public owner;
288 
289 
290   event OwnershipRenounced(address indexed previousOwner);
291   event OwnershipTransferred(
292     address indexed previousOwner,
293     address indexed newOwner
294   );
295 
296 
297   /**
298    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
299    * account.
300    */
301   constructor() public {
302     owner = msg.sender;
303   }
304 
305   /**
306    * @dev Throws if called by any account other than the owner.
307    */
308   modifier onlyOwner() {
309     require(msg.sender == owner);
310     _;
311   }
312 
313   /**
314    * @dev Allows the current owner to relinquish control of the contract.
315    */
316   function renounceOwnership() public onlyOwner {
317     emit OwnershipRenounced(owner);
318     owner = address(0);
319   }
320 
321   /**
322    * @dev Allows the current owner to transfer control of the contract to a newOwner.
323    * @param _newOwner The address to transfer ownership to.
324    */
325   function transferOwnership(address _newOwner) public onlyOwner {
326     _transferOwnership(_newOwner);
327   }
328 
329   /**
330    * @dev Transfers control of the contract to a newOwner.
331    * @param _newOwner The address to transfer ownership to.
332    */
333   function _transferOwnership(address _newOwner) internal {
334     require(_newOwner != address(0));
335     emit OwnershipTransferred(owner, _newOwner);
336     owner = _newOwner;
337   }
338 }
339 
340 
341 
342 /**
343  * @title Pausable
344  * @dev Base contract which allows children to implement an emergency stop mechanism.
345  */
346 contract Pausable is Ownable {
347   event Pause();
348   event Unpause();
349 
350   bool public paused = false;
351 
352 
353   /**
354    * @dev Modifier to make a function callable only when the contract is not paused.
355    */
356   modifier whenNotPaused() {
357     require(!paused);
358     _;
359   }
360 
361   /**
362    * @dev Modifier to make a function callable only when the contract is paused.
363    */
364   modifier whenPaused() {
365     require(paused);
366     _;
367   }
368 
369   /**
370    * @dev called by the owner to pause, triggers stopped state
371    */
372   function pause() onlyOwner whenNotPaused public {
373     paused = true;
374     emit Pause();
375   }
376 
377   /**
378    * @dev called by the owner to unpause, returns to normal state
379    */
380   function unpause() onlyOwner whenPaused public {
381     paused = false;
382     emit Unpause();
383   }
384 }
385 
386 
387 /**
388  * @title Mintable token
389  * @dev Simple ERC20 Token example, with mintable token creation
390  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
391  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
392  */
393 contract MintableToken is StandardToken, Ownable {
394   event Mint(address indexed to, uint256 amount);
395   event MintFinished();
396 
397   bool public mintingFinished = false;
398 
399 
400   modifier canMint() {
401     require(!mintingFinished);
402     _;
403   }
404 
405   modifier hasMintPermission() {
406     require(msg.sender == owner);
407     _;
408   }
409 
410   /**
411    * @dev Function to mint tokens
412    * @param _to The address that will receive the minted tokens.
413    * @param _amount The amount of tokens to mint.
414    * @return A boolean that indicates if the operation was successful.
415    */
416   function mint(
417     address _to,
418     uint256 _amount
419   )
420     hasMintPermission
421     canMint
422     public
423     returns (bool)
424   {
425     totalSupply_ = totalSupply_.add(_amount);
426     balances[_to] = balances[_to].add(_amount);
427     emit Mint(_to, _amount);
428     emit Transfer(address(0), _to, _amount);
429     return true;
430   }
431 
432   /**
433    * @dev Function to stop minting new tokens.
434    * @return True if the operation was successful.
435    */
436   function finishMinting() onlyOwner canMint public returns (bool) {
437     mintingFinished = true;
438     emit MintFinished();
439     return true;
440   }
441 }
442 
443 
444 /**
445  * @title Pausable token
446  * @dev StandardToken modified with pausable transfers.
447  **/
448 contract PausableToken is StandardToken, Pausable {
449 
450   function transfer(
451     address _to,
452     uint256 _value
453   )
454     public
455     whenNotPaused
456     returns (bool)
457   {
458     return super.transfer(_to, _value);
459   }
460 
461   function transferFrom(
462     address _from,
463     address _to,
464     uint256 _value
465   )
466     public
467     whenNotPaused
468     returns (bool)
469   {
470     return super.transferFrom(_from, _to, _value);
471   }
472 
473   function approve(
474     address _spender,
475     uint256 _value
476   )
477     public
478     whenNotPaused
479     returns (bool)
480   {
481     return super.approve(_spender, _value);
482   }
483 
484   function increaseApproval(
485     address _spender,
486     uint _addedValue
487   )
488     public
489     whenNotPaused
490     returns (bool success)
491   {
492     return super.increaseApproval(_spender, _addedValue);
493   }
494 
495   function decreaseApproval(
496     address _spender,
497     uint _subtractedValue
498   )
499     public
500     whenNotPaused
501     returns (bool success)
502   {
503     return super.decreaseApproval(_spender, _subtractedValue);
504   }
505 }
506 
507 contract ZeexToken is MintableToken, BurnableToken, PausableToken {
508   string public constant name = "Zeex Token";
509   string public constant symbol = "ZIX";
510   uint8 public constant decimals = 18;
511 
512   constructor() public {
513     paused = true;
514   }
515 }