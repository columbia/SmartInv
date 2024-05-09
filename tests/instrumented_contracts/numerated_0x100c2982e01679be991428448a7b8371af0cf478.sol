1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to relinquish control of the contract.
41    * @notice Renouncing to ownership will leave the contract without an owner.
42    * It will not be possible to call the functions with the `onlyOwner`
43    * modifier anymore.
44    */
45   function renounceOwnership() public onlyOwner {
46     emit OwnershipRenounced(owner);
47     owner = address(0);
48   }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param _newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address _newOwner) public onlyOwner {
55     _transferOwnership(_newOwner);
56   }
57 
58   /**
59    * @dev Transfers control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function _transferOwnership(address _newOwner) internal {
63     require(_newOwner != address(0));
64     emit OwnershipTransferred(owner, _newOwner);
65     owner = _newOwner;
66   }
67 }
68 
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (a == 0) {
79       return 0;
80     }
81 
82     c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return a / b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
109     c = a + b;
110     assert(c >= a);
111     return c;
112   }
113 }
114 
115 contract Pausable is Ownable {
116   event Pause();
117   event Unpause();
118 
119   bool public paused = false;
120 
121 
122   /**
123    * @dev Modifier to make a function callable only when the contract is not paused.
124    */
125   modifier whenNotPaused() {
126     require(!paused);
127     _;
128   }
129 
130   /**
131    * @dev Modifier to make a function callable only when the contract is paused.
132    */
133   modifier whenPaused() {
134     require(paused);
135     _;
136   }
137 
138   /**
139    * @dev called by the owner to pause, triggers stopped state
140    */
141   function pause() onlyOwner whenNotPaused public {
142     paused = true;
143     emit Pause();
144   }
145 
146   /**
147    * @dev called by the owner to unpause, returns to normal state
148    */
149   function unpause() onlyOwner whenPaused public {
150     paused = false;
151     emit Unpause();
152   }
153 }
154 
155 contract BasicToken is ERC20Basic {
156   using SafeMath for uint256;
157 
158   mapping(address => uint256) balances;
159 
160   uint256 totalSupply_;
161 
162   /**
163   * @dev Total number of tokens in existence
164   */
165   function totalSupply() public view returns (uint256) {
166     return totalSupply_;
167   }
168 
169   /**
170   * @dev Transfer token for a specified address
171   * @param _to The address to transfer to.
172   * @param _value The amount to be transferred.
173   */
174   function transfer(address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[msg.sender]);
177 
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     emit Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256) {
190     return balances[_owner];
191   }
192 }
193 
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender)
196     public view returns (uint256);
197 
198   function transferFrom(address from, address to, uint256 value)
199     public returns (bool);
200 
201   function approve(address spender, uint256 value) public returns (bool);
202   event Approval(
203     address indexed owner,
204     address indexed spender,
205     uint256 value
206   );
207 }
208 
209 contract DetailedERC20 is ERC20 {
210   string public name;
211   string public symbol;
212   uint8 public decimals;
213 
214   constructor(string _name, string _symbol, uint8 _decimals) public {
215     name = _name;
216     symbol = _symbol;
217     decimals = _decimals;
218   }
219 }
220 
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(
233     address _from,
234     address _to,
235     uint256 _value
236   )
237     public
238     returns (bool)
239   {
240     require(_to != address(0));
241     require(_value <= balances[_from]);
242     require(_value <= allowed[_from][msg.sender]);
243 
244     balances[_from] = balances[_from].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
247     emit Transfer(_from, _to, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253    * Beware that changing an allowance with this method brings the risk that someone may use both the old
254    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257    * @param _spender The address which will spend the funds.
258    * @param _value The amount of tokens to be spent.
259    */
260   function approve(address _spender, uint256 _value) public returns (bool) {
261     allowed[msg.sender][_spender] = _value;
262     emit Approval(msg.sender, _spender, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Function to check the amount of tokens that an owner allowed to a spender.
268    * @param _owner address The address which owns the funds.
269    * @param _spender address The address which will spend the funds.
270    * @return A uint256 specifying the amount of tokens still available for the spender.
271    */
272   function allowance(
273     address _owner,
274     address _spender
275    )
276     public
277     view
278     returns (uint256)
279   {
280     return allowed[_owner][_spender];
281   }
282 
283   /**
284    * @dev Increase the amount of tokens that an owner allowed to a spender.
285    * approve should be called when allowed[_spender] == 0. To increment
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _addedValue The amount of tokens to increase the allowance by.
291    */
292   function increaseApproval(
293     address _spender,
294     uint256 _addedValue
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
307    * approve should be called when allowed[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseApproval(
315     address _spender,
316     uint256 _subtractedValue
317   )
318     public
319     returns (bool)
320   {
321     uint256 oldValue = allowed[msg.sender][_spender];
322     if (_subtractedValue > oldValue) {
323       allowed[msg.sender][_spender] = 0;
324     } else {
325       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
326     }
327     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328     return true;
329   }
330 }
331 
332 contract PausableToken is StandardToken, Pausable {
333 
334   function transfer(
335     address _to,
336     uint256 _value
337   )
338     public
339     whenNotPaused
340     returns (bool)
341   {
342     return super.transfer(_to, _value);
343   }
344 
345   function transferFrom(
346     address _from,
347     address _to,
348     uint256 _value
349   )
350     public
351     whenNotPaused
352     returns (bool)
353   {
354     return super.transferFrom(_from, _to, _value);
355   }
356 
357   function approve(
358     address _spender,
359     uint256 _value
360   )
361     public
362     whenNotPaused
363     returns (bool)
364   {
365     return super.approve(_spender, _value);
366   }
367 
368   function increaseApproval(
369     address _spender,
370     uint _addedValue
371   )
372     public
373     whenNotPaused
374     returns (bool success)
375   {
376     return super.increaseApproval(_spender, _addedValue);
377   }
378 
379   function decreaseApproval(
380     address _spender,
381     uint _subtractedValue
382   )
383     public
384     whenNotPaused
385     returns (bool success)
386   {
387     return super.decreaseApproval(_spender, _subtractedValue);
388   }
389 }
390 
391 contract MintableToken is StandardToken, Ownable {
392   event Mint(address indexed to, uint256 amount);
393   event MintFinished();
394 
395   bool public mintingFinished = false;
396 
397 
398   modifier canMint() {
399     require(!mintingFinished);
400     _;
401   }
402 
403   modifier hasMintPermission() {
404     require(msg.sender == owner);
405     _;
406   }
407 
408   /**
409    * @dev Function to mint tokens
410    * @param _to The address that will receive the minted tokens.
411    * @param _amount The amount of tokens to mint.
412    * @return A boolean that indicates if the operation was successful.
413    */
414   function mint(
415     address _to,
416     uint256 _amount
417   )
418     hasMintPermission
419     canMint
420     public
421     returns (bool)
422   {
423     totalSupply_ = totalSupply_.add(_amount);
424     balances[_to] = balances[_to].add(_amount);
425     emit Mint(_to, _amount);
426     emit Transfer(address(0), _to, _amount);
427     return true;
428   }
429 
430   /**
431    * @dev Function to stop minting new tokens.
432    * @return True if the operation was successful.
433    */
434   function finishMinting() onlyOwner canMint public returns (bool) {
435     mintingFinished = true;
436     emit MintFinished();
437     return true;
438   }
439 }
440 
441 contract CappedToken is MintableToken {
442 
443   uint256 public cap;
444 
445   constructor(uint256 _cap) public {
446     require(_cap > 0);
447     cap = _cap;
448   }
449 
450   /**
451    * @dev Function to mint tokens
452    * @param _to The address that will receive the minted tokens.
453    * @param _amount The amount of tokens to mint.
454    * @return A boolean that indicates if the operation was successful.
455    */
456   function mint(
457     address _to,
458     uint256 _amount
459   )
460     public
461     returns (bool)
462   {
463     require(totalSupply_.add(_amount) <= cap);
464 
465     return super.mint(_to, _amount);
466   }
467 }
468 
469 contract EveryToken is DetailedERC20, PausableToken, CappedToken {
470 
471     string public name = "EVERY Token"; // name of token
472     string public symbol = "EVERY"; // token symbol
473     uint8 public decimals = 18; // decimal places
474     uint256 public cap = 1000000000 ether; // total supply of tokens
475 
476     /**
477     * @dev Constructor for the Every Token contract.
478     *
479     * This contract creates a Pausable, Capped, Mintable token
480     * Pausing freezes all token functions - transfers, allowances, minting
481     * The cap is the max number of tokens that can ever exist.
482     * Minting will stop if the cap is reached or finishMinting() is called
483     * finishMinting() is permanent 
484     */
485     constructor()
486         CappedToken(cap)
487         DetailedERC20(name, symbol, decimals)
488     public {
489     }
490 
491     /**
492     * @dev Special override for the standard mint function
493     *
494     * The mint function is not overridden in the PausableToken so we must
495     * override here to include the whenNotPaused modifier
496     *
497     * @param _to Recepient of new tokens
498     * @param _amount Amount to mint
499     */
500     function mint(address _to, uint256 _amount) whenNotPaused public returns (bool) {
501         return super.mint(_to, _amount); 
502     }
503 
504     /**
505     * @dev Special override for the standard finishMinting function
506     *
507     * The finishMinting function is not overridden in the PausableToken so we must
508     * override here to include the whenNotPaused modifier
509     */
510     function finishMinting() whenNotPaused public returns (bool) {
511         return super.finishMinting();
512     }
513 }