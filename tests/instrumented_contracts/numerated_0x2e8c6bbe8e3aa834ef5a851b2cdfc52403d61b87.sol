1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
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
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * See https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender)
71     public view returns (uint256);
72 
73   function transferFrom(address from, address to, uint256 value)
74     public returns (bool);
75 
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
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
93   uint256 totalSupply_;
94 
95   /**
96   * @dev Total number of tokens in existence
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   /**
103   * @dev Transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_value <= balances[msg.sender]);
109     require(_to != address(0));
110 
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     emit Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 /**
129  * @title Burnable Token
130  * @dev Token that can be irreversibly burned (destroyed).
131  */
132 contract BurnableToken is BasicToken {
133 
134   event Burn(address indexed burner, uint256 value);
135 
136   /**
137    * @dev Burns a specific amount of tokens.
138    * @param _value The amount of token to be burned.
139    */
140   function burn(uint256 _value) public {
141     _burn(msg.sender, _value);
142   }
143 
144   function _burn(address _who, uint256 _value) internal {
145     require(_value <= balances[_who]);
146     // no need to require value <= totalSupply, since that would imply the
147     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
148 
149     balances[_who] = balances[_who].sub(_value);
150     totalSupply_ = totalSupply_.sub(_value);
151     emit Burn(_who, _value);
152     emit Transfer(_who, address(0), _value);
153   }
154 }
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/issues/20
161  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BurnableToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184     require(_to != address(0));
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint256 _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(
257     address _spender,
258     uint256 _subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     uint256 oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue >= oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273 }
274 
275 /**
276  * @title Standard Burnable Token
277  * @dev Adds burnFrom method to ERC20 implementations
278  */
279 contract StandardBurnableToken is StandardToken {
280 
281   /**
282    * @dev Burns a specific amount of tokens from the target address and decrements allowance
283    * @param _from address The address which you want to send tokens from
284    * @param _value uint256 The amount of token to be burned
285    */
286   function burnFrom(address _from, uint256 _value) public {
287     require(_value <= allowed[_from][msg.sender]);
288     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
289     // this function needs to emit an event with the updated approval.
290     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
291     _burn(_from, _value);
292   }
293 }
294 
295 /**
296  * @title Ownable
297  * @dev The Ownable contract has an owner address, and provides basic authorization control
298  * functions, this simplifies the implementation of "user permissions".
299  */
300 contract Ownable {
301   address public owner;
302 
303 
304   event OwnershipRenounced(address indexed previousOwner);
305   event OwnershipTransferred(
306     address indexed previousOwner,
307     address indexed newOwner
308   );
309 
310 
311   /**
312    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
313    * account.
314    */
315   constructor() public {
316     owner = msg.sender;
317   }
318 
319   /**
320    * @dev Throws if called by any account other than the owner.
321    */
322   modifier onlyOwner() {
323     require(msg.sender == owner);
324     _;
325   }
326 
327   /**
328    * @dev Allows the current owner to relinquish control of the contract.
329    * @notice Renouncing to ownership will leave the contract without an owner.
330    * It will not be possible to call the functions with the `onlyOwner`
331    * modifier anymore.
332    */
333   function renounceOwnership() public onlyOwner {
334     emit OwnershipRenounced(owner);
335     owner = address(0);
336   }
337 
338   /**
339    * @dev Allows the current owner to transfer control of the contract to a newOwner.
340    * @param _newOwner The address to transfer ownership to.
341    */
342   function transferOwnership(address _newOwner) public onlyOwner {
343     _transferOwnership(_newOwner);
344   }
345 
346   /**
347    * @dev Transfers control of the contract to a newOwner.
348    * @param _newOwner The address to transfer ownership to.
349    */
350   function _transferOwnership(address _newOwner) internal {
351     require(_newOwner != address(0));
352     emit OwnershipTransferred(owner, _newOwner);
353     owner = _newOwner;
354   }
355 }
356 
357 /**
358  * @title Pausable
359  * @dev Base contract which allows children to implement an emergency stop mechanism.
360  */
361 contract Pausable is Ownable {
362   event Pause();
363   event Unpause();
364 
365   bool public paused = false;
366 
367 
368   /**
369    * @dev Modifier to make a function callable only when the contract is not paused.
370    */
371   modifier whenNotPaused() {
372     require(!paused);
373     _;
374   }
375 
376   /**
377    * @dev Modifier to make a function callable only when the contract is paused.
378    */
379   modifier whenPaused() {
380     require(paused);
381     _;
382   }
383 
384   /**
385    * @dev called by the owner to pause, triggers stopped state
386    */
387   function pause() onlyOwner whenNotPaused public {
388     paused = true;
389     emit Pause();
390   }
391 
392   /**
393    * @dev called by the owner to unpause, returns to normal state
394    */
395   function unpause() onlyOwner whenPaused public {
396     paused = false;
397     emit Unpause();
398   }
399 }
400 
401 /**
402  * @title Pausable token
403  * @dev StandardToken modified with pausable transfers.
404  **/
405 contract PausableToken is StandardBurnableToken, Pausable {
406 
407   function transfer(
408     address _to,
409     uint256 _value
410   )
411     public
412     whenNotPaused
413     returns (bool)
414   {
415     return super.transfer(_to, _value);
416   }
417 
418   function transferFrom(
419     address _from,
420     address _to,
421     uint256 _value
422   )
423     public
424     whenNotPaused
425     returns (bool)
426   {
427     return super.transferFrom(_from, _to, _value);
428   }
429 
430   function approve(
431     address _spender,
432     uint256 _value
433   )
434     public
435     whenNotPaused
436     returns (bool)
437   {
438     return super.approve(_spender, _value);
439   }
440 
441   function increaseApproval(
442     address _spender,
443     uint _addedValue
444   )
445     public
446     whenNotPaused
447     returns (bool success)
448   {
449     return super.increaseApproval(_spender, _addedValue);
450   }
451 
452   function decreaseApproval(
453     address _spender,
454     uint _subtractedValue
455   )
456     public
457     whenNotPaused
458     returns (bool success)
459   {
460     return super.decreaseApproval(_spender, _subtractedValue);
461   }
462 }
463 
464 contract Streamity is PausableToken {
465     
466     string public constant name = "Streamity";
467     string public constant symbol = "STM";
468     uint8 public constant decimals = 18;
469 
470     uint256 public constant INITIAL_SUPPLY = 180000000 * (10 ** uint256(decimals));
471 
472 
473     address public tokenOwner = 0x464398aC8B96DdAd7e22AC37147822E1c69293Cb;
474     
475     address public reserveFund = 0x84726199Ac1579684d58F4A47C4c85f2C45B5a11;
476     address public advisersPartners = 0xa2C2f149e4b3EC671a61EAc9F12eAF2489e0Fb10; 
477     
478     address public teamWallet1 = 0xbBB9E0605f0BC7Af1B7238bAC2807a3A8DCb54b5; 
479     
480     address public teamWallet2 = 0xd69824B62D26E7f2316812b8c59F36328196Ca13; 
481     
482     
483     
484     constructor () public {
485         totalSupply_ = INITIAL_SUPPLY;
486         
487         balances[tokenOwner] = 129780000 ether;
488         balances[address(this)] = 50220000 ether;
489         
490         emit Transfer(address(0), tokenOwner, 129780000 ether);
491         emit Transfer(address(0), address(this), 50220000 ether);
492     }
493     
494     uint teamObligationPart1 = 4650000 ether;
495     uint advisersPartnersObligation = 3720000 ether;
496     
497     function ReleaseTokenForReserveFund () public onlyOwner {
498         // 25 september 2018 y.
499         require(now >= 1537833600);
500         if (transfer(advisersPartners, advisersPartnersObligation)) {
501             advisersPartnersObligation = 0;
502         }
503         
504         if (transfer(teamWallet1, teamObligationPart1)) {
505             teamObligationPart1 = 0;
506         }
507     }
508     
509     uint teamObligationPart2 = 23250000 ether;
510     uint reserveFundObligation = 18600000 ether;
511     
512     function ReleaseTokenForTeamAdvisersPartners () public onlyOwner {
513         // 12 march 2019
514         require(now >= 1552348800);
515         
516         if (transfer(reserveFund, reserveFundObligation)) {
517             reserveFundObligation = 0;
518         }
519         
520         if (transfer(teamWallet2, teamObligationPart2)) {
521             teamObligationPart2 = 0;
522         }
523     }
524     
525     function sendTokens(address _to, uint _value) public onlyOwner {
526         require(_to != address(0));
527         require(_value <= balances[tokenOwner]);
528         balances[tokenOwner] = balances[tokenOwner].sub(_value);
529         balances[_to] = balances[_to].add(_value);
530         Transfer(tokenOwner, _to, _value);
531     }
532 }