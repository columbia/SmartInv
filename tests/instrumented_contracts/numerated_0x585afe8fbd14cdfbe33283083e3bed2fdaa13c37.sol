1 pragma solidity ^0.4.23;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
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
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     emit Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     emit Unpause();
130   }
131 }
132 
133 /**
134  * @title ERC20Basic
135  * @dev Simpler version of ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/179
137  */
138 contract ERC20Basic {
139   function totalSupply() public view returns (uint256);
140   function balanceOf(address who) public view returns (uint256);
141   function transfer(address to, uint256 value) public returns (bool);
142   event Transfer(address indexed from, address indexed to, uint256 value);
143 }
144 
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender)
152     public view returns (uint256);
153 
154   function transferFrom(address from, address to, uint256 value)
155     public returns (bool);
156 
157   function approve(address spender, uint256 value) public returns (bool);
158   event Approval(
159     address indexed owner,
160     address indexed spender,
161     uint256 value
162   );
163 }
164 
165 
166 /**
167  * @title Basic token
168  * @dev Basic version of StandardToken, with no allowances.
169  */
170 contract BasicToken is ERC20Basic {
171   using SafeMath for uint256;
172 
173   mapping(address => uint256) balances;
174 
175   uint256 totalSupply_;
176 
177   /**
178   * @dev total number of tokens in existence
179   */
180   function totalSupply() public view returns (uint256) {
181     return totalSupply_;
182   }
183 
184   /**
185   * @dev transfer token for a specified address
186   * @param _to The address to transfer to.
187   * @param _value The amount to be transferred.
188   */
189   function transfer(address _to, uint256 _value) public returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[msg.sender]);
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
208 }
209 
210 
211 /**
212  * @title Standard ERC20 token
213  *
214  * @dev Implementation of the basic standard token.
215  * @dev https://github.com/ethereum/EIPs/issues/20
216  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
217  */
218 contract StandardToken is ERC20, BasicToken {
219 
220   mapping (address => mapping (address => uint256)) internal allowed;
221 
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param _from address The address which you want to send tokens from
226    * @param _to address The address which you want to transfer to
227    * @param _value uint256 the amount of tokens to be transferred
228    */
229   function transferFrom(
230     address _from,
231     address _to,
232     uint256 _value
233   )
234     public
235     returns (bool)
236   {
237     require(_to != address(0));
238     require(_value <= balances[_from]);
239     require(_value <= allowed[_from][msg.sender]);
240 
241     balances[_from] = balances[_from].sub(_value);
242     balances[_to] = balances[_to].add(_value);
243     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
244     emit Transfer(_from, _to, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
250    *
251    * Beware that changing an allowance with this method brings the risk that someone may use both the old
252    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    * @param _spender The address which will spend the funds.
256    * @param _value The amount of tokens to be spent.
257    */
258   function approve(address _spender, uint256 _value) public returns (bool) {
259     allowed[msg.sender][_spender] = _value;
260     emit Approval(msg.sender, _spender, _value);
261     return true;
262   }
263 
264   /**
265    * @dev Function to check the amount of tokens that an owner allowed to a spender.
266    * @param _owner address The address which owns the funds.
267    * @param _spender address The address which will spend the funds.
268    * @return A uint256 specifying the amount of tokens still available for the spender.
269    */
270   function allowance(
271     address _owner,
272     address _spender
273    )
274     public
275     view
276     returns (uint256)
277   {
278     return allowed[_owner][_spender];
279   }
280 
281   /**
282    * @dev Increase the amount of tokens that an owner allowed to a spender.
283    *
284    * approve should be called when allowed[_spender] == 0. To increment
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _addedValue The amount of tokens to increase the allowance by.
290    */
291   function increaseApproval(
292     address _spender,
293     uint _addedValue
294   )
295     public
296     returns (bool)
297   {
298     allowed[msg.sender][_spender] = (
299       allowed[msg.sender][_spender].add(_addedValue));
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Decrease the amount of tokens that an owner allowed to a spender.
306    *
307    * approve should be called when allowed[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseApproval(
315     address _spender,
316     uint _subtractedValue
317   )
318     public
319     returns (bool)
320   {
321     uint oldValue = allowed[msg.sender][_spender];
322     if (_subtractedValue > oldValue) {
323       allowed[msg.sender][_spender] = 0;
324     } else {
325       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
326     }
327     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328     return true;
329   }
330 
331 }
332 
333 /**
334  * @title Pausable token
335  * @dev StandardToken modified with pausable transfers.
336  **/
337 contract PausableToken is StandardToken, Pausable {
338 
339   function transfer(
340     address _to,
341     uint256 _value
342   )
343     public
344     whenNotPaused
345     returns (bool)
346   {
347     return super.transfer(_to, _value);
348   }
349 
350   function transferFrom(
351     address _from,
352     address _to,
353     uint256 _value
354   )
355     public
356     whenNotPaused
357     returns (bool)
358   {
359     return super.transferFrom(_from, _to, _value);
360   }
361 
362   function approve(
363     address _spender,
364     uint256 _value
365   )
366     public
367     whenNotPaused
368     returns (bool)
369   {
370     return super.approve(_spender, _value);
371   }
372 
373   function increaseApproval(
374     address _spender,
375     uint _addedValue
376   )
377     public
378     whenNotPaused
379     returns (bool success)
380   {
381     return super.increaseApproval(_spender, _addedValue);
382   }
383 
384   function decreaseApproval(
385     address _spender,
386     uint _subtractedValue
387   )
388     public
389     whenNotPaused
390     returns (bool success)
391   {
392     return super.decreaseApproval(_spender, _subtractedValue);
393   }
394 }
395 
396 /**
397  * @title Mintable token
398  * @dev Simple ERC20 Token example, with mintable token creation
399  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
400  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
401  */
402 contract MintableToken is StandardToken, Ownable {
403   event Mint(address indexed to, uint256 amount);
404   event MintFinished();
405 
406   bool public mintingFinished = false;
407   
408  
409   /** List of agents that are allowed to create new tokens */
410   mapping (address => bool) public saleAgent;
411 
412   modifier canMint() {
413     require(!mintingFinished);
414     _;
415     
416   }
417   
418    modifier onlySaleAgent() {
419  // Only crowdsale contracts are allowed to mint new tokens
420      require(saleAgent[msg.sender]);    
421     _;
422   }
423   
424   function setSaleAgent(address addr, bool state) onlyOwner canMint public {
425     saleAgent[addr] = state;
426   } 
427   
428 
429   /**
430    * @dev Function to mint tokens
431    * @param _to The address that will receive the minted tokens.
432    * @param _amount The amount of tokens to mint.
433    * @return A boolean that indicates if the operation was successful.
434    */
435   function mint(address _to, uint256 _amount) onlySaleAgent canMint public returns (bool) {
436     totalSupply_ = totalSupply_.add(_amount);
437     balances[_to] = balances[_to].add(_amount);
438     emit Mint(_to, _amount);
439     emit Transfer(address(0), _to, _amount);
440     return true;
441   }
442 
443   /**
444    * @dev Function to stop minting new tokens.
445    * @return True if the operation was successful.
446    */
447   function finishMinting() onlyOwner canMint public returns (bool) {
448     mintingFinished = true;
449     emit MintFinished();
450     return true;
451   }
452 }
453 
454 /**
455  * @title Capped token
456  * @dev Mintable token with a token cap.
457  */
458 contract CappedToken is MintableToken {
459 
460   uint256 public cap;
461   
462 
463   function CappedToken(uint256 _cap) public {
464     require(_cap > 0);
465     cap = _cap;
466   }
467   
468 
469 
470   /**
471    * @dev Function to mint tokens
472    * @param _to The address that will receive the minted tokens.
473    * @param _amount The amount of tokens to mint.
474    * @return A boolean that indicates if the operation was successful.
475    */
476   function mint(address _to, uint256 _amount) onlySaleAgent canMint public returns (bool) {
477     require(totalSupply_.add(_amount) <= cap);
478 
479     return super.mint(_to, _amount);
480   }
481 
482 }
483 
484 
485 
486 
487 contract AgroTechFarmToken is PausableToken, CappedToken {
488   string public constant name = "AgroTechFarm";
489   string public constant symbol = "ATF";
490   uint8 public constant decimals = 18;
491   uint256 private constant TOKEN_CAP = 5 * 10**24;
492   
493   
494   function AgroTechFarmToken() public CappedToken(TOKEN_CAP) {
495   paused = true;
496   }
497 }
498 
499 
500 contract AgroTechFarmCrowdsale is Ownable {    
501     using SafeMath for uint;
502     uint8 public decimals = 18;
503     AgroTechFarmToken public token;
504     address public multisig;
505     uint public rate;  
506     uint public start;
507     uint public end;
508    
509     mapping (address => uint256) public balances;
510     function AgroTechFarmCrowdsale(address _multisig,AgroTechFarmToken _token) public { 
511          require(_multisig != address(0));
512          require(_token != address(0));        
513          multisig = _multisig;
514 	 token = _token;
515 	 rate = 83333333333000000000;
516 	 start = 1533038400;
517          end = 1535716800; 
518     }
519        
520  
521    modifier saleIsOn() {
522     	require(_getTime() > start && _getTime() < end);
523     	_;
524     }
525 	
526 
527    function createTokens() public saleIsOn payable {
528      uint tokens = rate.mul(msg.value).div(1 ether);           
529      multisig.transfer(msg.value); 
530      uint bonusTokens = tokens.mul(20).div(100);  
531      tokens += bonusTokens; 
532      balances[msg.sender] = balances[msg.sender].add(msg.value);
533      token.mint(msg.sender, tokens);
534      }
535  
536 
537     function() external payable {
538         createTokens();
539     } 
540     
541     function _getTime() internal view returns (uint256) {
542     return now;
543     }
544 }