1 pragma solidity ^0.4.24;
2 
3 // File: contracts\Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param _newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address _newOwner) public onlyOwner {
43     _transferOwnership(_newOwner);
44   }
45 
46   /**
47    * @dev Transfers control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function _transferOwnership(address _newOwner) internal {
51     require(_newOwner != address(0));
52     emit OwnershipTransferred(owner, _newOwner);
53     owner = _newOwner;
54   }
55 }
56 
57 // File: contracts\Pausable.sol
58 
59 /**
60  * @title Pausable
61  * @dev Base contract which allows children to implement an emergency stop mechanism.
62  */
63 contract Pausable is Ownable {
64   event Pause();
65   event Unpause();
66 
67   bool public paused = false;
68 
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is not paused.
72    */
73   modifier whenNotPaused() {
74     require(!paused);
75     _;
76   }
77 
78   /**
79    * @dev Modifier to make a function callable only when the contract is paused.
80    */
81   modifier whenPaused() {
82     require(paused);
83     _;
84   }
85 
86   /**
87    * @dev called by the owner to pause, triggers stopped state
88    */
89   function pause() public onlyOwner whenNotPaused {
90     paused = true;
91     emit Pause();
92   }
93 
94   /**
95    * @dev called by the owner to unpause, returns to normal state
96    */
97   function unpause() public onlyOwner whenPaused {
98     paused = false;
99     emit Unpause();
100   }
101 }
102 
103 // File: contracts\SafeMath.sol
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that throw on error
108  */
109 library SafeMath {
110 
111   /**
112   * @dev Multiplies two numbers, throws on overflow.
113   */
114   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
115     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
116     // benefit is lost if 'b' is also tested.
117     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
118     if (_a == 0) {
119       return 0;
120     }
121 
122     c = _a * _b;
123     assert(c / _a == _b);
124     return c;
125   }
126 
127   /**
128   * @dev Integer division of two numbers, truncating the quotient.
129   */
130   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
131     // assert(_b > 0); // Solidity automatically throws when dividing by 0
132     // uint256 c = _a / _b;
133     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
134     return _a / _b;
135   }
136 
137   /**
138   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
139   */
140   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
141     assert(_b <= _a);
142     return _a - _b;
143   }
144 
145   /**
146   * @dev Adds two numbers, throws on overflow.
147   */
148   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
149     c = _a + _b;
150     assert(c >= _a);
151     return c;
152   }
153 }
154 
155 // File: contracts\StandardToken.sol
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * https://github.com/ethereum/EIPs/issues/20
162  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken  {
165 
166   using SafeMath for uint256;
167   event Transfer(address indexed from, address indexed to, uint256 value);
168   event Approval(address indexed owner,address indexed spender,uint256 value);
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171   mapping(address => uint256) internal balances;
172 
173 
174   uint256 internal totalSupply_;
175 
176   /**
177   * @dev Total number of tokens in existence
178   */
179   function totalSupply() public view returns (uint256) {
180     return totalSupply_;
181   }
182 
183   /**
184   * @dev Transfer token for a specified address
185   * @param _to The address to transfer to.
186   * @param _value The amount to be transferred.
187   */
188   function transfer(address _to, uint256 _value) public returns (bool) {
189     require(_value <= balances[msg.sender]);
190     require(_to != address(0));
191     require(_to != address(this));
192 
193     balances[msg.sender] = balances[msg.sender].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     emit Transfer(msg.sender, _to, _value);
196     return true;
197   }
198 
199   /**
200   * @dev Gets the balance of the specified address.
201   * @param _owner The address to query the the balance of.
202   * @return An uint256 representing the amount owned by the passed address.
203   */
204   function balanceOf(address _owner) public view returns (uint256) {
205     return balances[_owner];
206   }
207 
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(
217     address _from,
218     address _to,
219     uint256 _value
220   )
221     public
222     returns (bool)
223   {
224     require(_value <= balances[_from]);
225     require(_value <= allowed[_from][msg.sender]);
226     require(_to != address(0));
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     emit Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    * Beware that changing an allowance with this method brings the risk that someone may use both the old
238    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) public returns (bool) {
245     allowed[msg.sender][_spender] = _value;
246     emit Approval(msg.sender, _spender, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Function to check the amount of tokens that an owner allowed to a spender.
252    * @param _owner address The address which owns the funds.
253    * @param _spender address The address which will spend the funds.
254    * @return A uint256 specifying the amount of tokens still available for the spender.
255    */
256   function allowance(
257     address _owner,
258     address _spender
259    )
260     public
261     view
262     returns (uint256)
263   {
264     return allowed[_owner][_spender];
265   }
266 
267   /**
268    * @dev Increase the amount of tokens that an owner allowed to a spender.
269    * approve should be called when allowed[_spender] == 0. To increment
270    * allowed value is better to use this function to avoid 2 calls (and wait until
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    * @param _spender The address which will spend the funds.
274    * @param _addedValue The amount of tokens to increase the allowance by.
275    */
276   function increaseApproval(
277     address _spender,
278     uint256 _addedValue
279   )
280     public
281     returns (bool)
282   {
283     allowed[msg.sender][_spender] = (
284       allowed[msg.sender][_spender].add(_addedValue));
285     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289   /**
290    * @dev Decrease the amount of tokens that an owner allowed to a spender.
291    * approve should be called when allowed[_spender] == 0. To decrement
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _subtractedValue The amount of tokens to decrease the allowance by.
297    */
298   function decreaseApproval(
299     address _spender,
300     uint256 _subtractedValue
301   )
302     public
303     returns (bool)
304   {
305     uint256 oldValue = allowed[msg.sender][_spender];
306     if (_subtractedValue >= oldValue) {
307       allowed[msg.sender][_spender] = 0;
308     } else {
309       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
310     }
311     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312     return true;
313   }
314 
315 }
316 
317 contract ERC20 is StandardToken {
318 
319 }
320 
321 // File: contracts\PausableToken.sol
322 
323 /**
324  * @title Pausable token
325  * @dev StandardToken modified with pausable transfers.
326  **/
327 contract PausableToken is StandardToken, Pausable {
328 
329   function transfer(
330     address _to,
331     uint256 _value
332   )
333     public
334     whenNotPaused
335     returns (bool)
336   {
337     return super.transfer(_to, _value);
338   }
339 
340   function transferFrom(
341     address _from,
342     address _to,
343     uint256 _value
344   )
345     public
346     whenNotPaused
347     returns (bool)
348   {
349     return super.transferFrom(_from, _to, _value);
350   }
351 
352   function approve(
353     address _spender,
354     uint256 _value
355   )
356     public
357     whenNotPaused
358     returns (bool)
359   {
360     return super.approve(_spender, _value);
361   }
362 
363   function increaseApproval(
364     address _spender,
365     uint _addedValue
366   )
367     public
368     whenNotPaused
369     returns (bool success)
370   {
371     return super.increaseApproval(_spender, _addedValue);
372   }
373 
374   function decreaseApproval(
375     address _spender,
376     uint _subtractedValue
377   )
378     public
379     whenNotPaused
380     returns (bool success)
381   {
382     return super.decreaseApproval(_spender, _subtractedValue);
383   }
384 }
385 
386 // File: contracts\TXTToken.sol
387 
388 contract TXTToken is PausableToken {
389 
390 using SafeMath for uint256;
391 
392 
393 string public name;
394 string public symbol;
395 uint8 public decimals;
396 
397 // 200 millions tokens are vested. Every 150 days (5 months)  tokens release 50 millions
398 address private foundersWallet;
399 uint256 private tokenStartTime;
400 uint256 private constant  phasePeriod  = 30 days;
401 uint256 private constant phaseTokens  = 20 * 10 ** 24;
402 uint256 private lastPhase = 0;
403 
404 event TokensReleased(uint256 amount, address to, uint256 phase);
405 ///@notice Constructor set total supply and set owner of this contract as _fondersWallet. Founders wallet also receives 50 millions tokens.
406 
407 constructor (address _foundersWallet) public{
408   require(_foundersWallet != address(0x0));
409   name = "Tune Trade Token";
410   symbol = "TXT";
411   decimals = 18;
412   foundersWallet = _foundersWallet;
413   totalSupply_ = 500 * 10 ** 24;
414   balances[foundersWallet] = 30 * 10 ** 24;
415   balances[owner] = 250 * 10 **24; //owner gets 250 000 000 tokens to transfer to crowdsale.
416   transferOwnership(foundersWallet);
417   tokenStartTime = now;
418   releaseTokens();
419 }
420 
421 
422 function _phasesToRelease() internal view returns (uint256)
423 {
424   if (lastPhase == 11) return 0;
425   uint256 timeFromStart = now.sub(tokenStartTime);
426   uint256 phases = timeFromStart.div(phasePeriod).add(1);
427   if (phases > 11) phases = 11;
428   return phases.sub(lastPhase);
429 }
430 
431 function _readyToRelease() internal view returns(bool) {
432 
433   if(_phasesToRelease()> 0) return true;
434   return false;
435 
436 }
437 
438 function releaseTokens () public returns(bool) {
439 
440   require(_readyToRelease());
441   uint256 toRelease = _phasesToRelease();
442 
443   balances[foundersWallet] = balances[foundersWallet].add(phaseTokens.mul(toRelease));
444   lastPhase = lastPhase.add(toRelease);
445   emit TokensReleased(phaseTokens*toRelease,foundersWallet,lastPhase);
446 
447   return true;
448 }
449 
450 function transfer(address _to, uint256 _value) public returns (bool)
451 {
452   if(msg.sender == foundersWallet) {
453     if(_readyToRelease()) releaseTokens();
454   }
455   return super.transfer(_to,_value);
456 
457 }
458 
459 function balanceOf(address _owner) public view returns (uint256) {
460   if(_owner == foundersWallet)
461   {
462     return balances[_owner].add( _phasesToRelease().mul(phaseTokens));
463   }
464   else {
465   return balances[_owner];
466   }
467 
468 }
469 
470 }