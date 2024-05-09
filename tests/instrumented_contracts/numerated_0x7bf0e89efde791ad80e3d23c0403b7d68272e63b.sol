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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
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
83     emit OwnershipTransferred(owner, newOwner);
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
145 /**
146  * @title ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/20
148  */
149 contract ERC20 is ERC20Basic {
150   function allowance(address owner, address spender) public view returns (uint256);
151   function transferFrom(address from, address to, uint256 value) public returns (bool);
152   function approve(address spender, uint256 value) public returns (bool);
153   event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 /**
157  * @title Basic token
158  * @dev Basic version of StandardToken, with no allowances.
159  */
160 contract BasicToken is ERC20Basic {
161   using SafeMath for uint256;
162 
163   mapping(address => uint256) balances;
164 
165   uint256 totalSupply_;
166 
167   /**
168   * @dev total number of tokens in existence
169   */
170   function totalSupply() public view returns (uint256) {
171     return totalSupply_;
172   }
173 
174   /**
175   * @dev transfer token for a specified address
176   * @param _to The address to transfer to.
177   * @param _value The amount to be transferred.
178   */
179   function transfer(address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[msg.sender]);
182 
183     balances[msg.sender] = balances[msg.sender].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     emit Transfer(msg.sender, _to, _value);
186     return true;
187   }
188 
189   /**
190   * @dev Gets the balance of the specified address.
191   * @param _owner The address to query the the balance of.
192   * @return An uint256 representing the amount owned by the passed address.
193   */
194   function balanceOf(address _owner) public view returns (uint256) {
195     return balances[_owner];
196   }
197 
198 }
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implementation of the basic standard token.
204  * @dev https://github.com/ethereum/EIPs/issues/20
205  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207 contract StandardToken is ERC20, BasicToken {
208 
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
219     require(_to != address(0));
220     require(_value <= balances[_from]);
221     require(_value <= allowed[_from][msg.sender]);
222 
223     balances[_from] = balances[_from].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226     emit Transfer(_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    *
233    * Beware that changing an allowance with this method brings the risk that someone may use both the old
234    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237    * @param _spender The address which will spend the funds.
238    * @param _value The amount of tokens to be spent.
239    */
240   function approve(address _spender, uint256 _value) public returns (bool) {
241     allowed[msg.sender][_spender] = _value;
242     emit Approval(msg.sender, _spender, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Function to check the amount of tokens that an owner allowed to a spender.
248    * @param _owner address The address which owns the funds.
249    * @param _spender address The address which will spend the funds.
250    * @return A uint256 specifying the amount of tokens still available for the spender.
251    */
252   function allowance(address _owner, address _spender) public view returns (uint256) {
253     return allowed[_owner][_spender];
254   }
255 
256   /**
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _addedValue The amount of tokens to increase the allowance by.
265    */
266   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
267     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
268     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272   /**
273    * @dev Decrease the amount of tokens that an owner allowed to a spender.
274    *
275    * approve should be called when allowed[_spender] == 0. To decrement
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _subtractedValue The amount of tokens to decrease the allowance by.
281    */
282   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
283     uint oldValue = allowed[msg.sender][_spender];
284     if (_subtractedValue > oldValue) {
285       allowed[msg.sender][_spender] = 0;
286     } else {
287       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
288     }
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293 }
294 
295 /**
296  * @title Burnable Token
297  * @dev Token that can be irreversibly burned (destroyed).
298  */
299 contract BurnableToken is BasicToken {
300 
301   event Burn(address indexed burner, uint256 value);
302 
303   /**
304    * @dev Burns a specific amount of tokens.
305    * @param _value The amount of token to be burned.
306    */
307   function burn(uint256 _value) public {
308     _burn(msg.sender, _value);
309   }
310 
311   function _burn(address _who, uint256 _value) internal {
312     require(_value <= balances[_who]);
313     // no need to require value <= totalSupply, since that would imply the
314     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
315 
316     balances[_who] = balances[_who].sub(_value);
317     totalSupply_ = totalSupply_.sub(_value);
318     emit Burn(_who, _value);
319     emit Transfer(_who, address(0), _value);
320   }
321 }
322 
323 /**
324  * @title Pausable token
325  * @dev StandardToken modified with pausable transfers.
326  **/
327 contract PausableToken is StandardToken, Pausable {
328 
329   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
330     return super.transfer(_to, _value);
331   }
332 
333   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
334     return super.transferFrom(_from, _to, _value);
335   }
336 
337   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
338     return super.approve(_spender, _value);
339   }
340 
341   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
342     return super.increaseApproval(_spender, _addedValue);
343   }
344 
345   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
346     return super.decreaseApproval(_spender, _subtractedValue);
347   }
348 }
349 
350 /**
351  * @title Mintable token
352  * @dev Simple ERC20 Token example, with mintable token creation
353  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
354  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
355  */
356 contract MintableToken is StandardToken, Ownable {
357   event Mint(address indexed to, uint256 amount);
358   event MintFinished();
359 
360   bool public mintingFinished = false;
361 
362 
363   modifier canMint() {
364     require(!mintingFinished);
365     _;
366   }
367 
368   /**
369    * @dev Function to mint tokens
370    * @param _to The address that will receive the minted tokens.
371    * @param _amount The amount of tokens to mint.
372    * @return A boolean that indicates if the operation was successful.
373    */
374   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
375     totalSupply_ = totalSupply_.add(_amount);
376     balances[_to] = balances[_to].add(_amount);
377     emit Mint(_to, _amount);
378     emit Transfer(address(0), _to, _amount);
379     return true;
380   }
381 
382   /**
383    * @dev Function to stop minting new tokens.
384    * @return True if the operation was successful.
385    */
386   function finishMinting() onlyOwner canMint public returns (bool) {
387     mintingFinished = true;
388     emit MintFinished();
389     return true;
390   }
391 }
392 
393 
394 contract Consumer is Ownable {
395 
396     address public hookableTokenAddress;
397 
398     modifier onlyHookableTokenAddress {
399         require(msg.sender == hookableTokenAddress);
400         _;
401     }
402 
403     function setHookableTokenAddress(address _hookableTokenAddress) onlyOwner {
404         hookableTokenAddress = _hookableTokenAddress;
405     }
406 
407     function onMint(address _sender, address _to, uint256 _amount) onlyHookableTokenAddress {
408     }
409 
410     function onBurn(address _sender, uint256 _value) onlyHookableTokenAddress {
411     }
412 
413     function onTransfer(address _sender, address _to, uint256 _value) onlyHookableTokenAddress {
414     }
415 
416     function onTransferFrom(address _sender, address _from, address _to, uint256 _value) onlyHookableTokenAddress {
417     }
418 
419     function onApprove(address _sender, address _spender, uint256 _value) onlyHookableTokenAddress {
420     }
421 
422     function onIncreaseApproval(address _sender, address _spender, uint _addedValue) onlyHookableTokenAddress {
423     }
424 
425     function onDecreaseApproval(address _sender, address _spender, uint _subtractedValue) onlyHookableTokenAddress {
426     }
427 
428     function onTaxTransfer(address _from, uint _tokensAmount) onlyHookableTokenAddress {
429     }
430 }
431 
432 contract HookableToken is MintableToken, PausableToken, BurnableToken {
433 
434     Consumer public consumerAddress;
435     
436     constructor(address _consumerAddress) public {
437         consumerAddress = Consumer(_consumerAddress);
438     }
439 
440      modifier onlyConsumerAddress(){
441         require(msg.sender == address(consumerAddress));
442         _;
443     }
444 
445     function setConsumerAddress(address _newConsumerAddress) public onlyOwner {
446         require(_newConsumerAddress != address(0));
447         consumerAddress = Consumer(_newConsumerAddress);
448     }
449 
450     function mint(address _to, uint256 _amount) public returns (bool){
451         consumerAddress.onMint(msg.sender,_to, _amount);
452         return super.mint(_to, _amount);
453     }
454 
455     function burn(uint256 _value) public {
456         consumerAddress.onBurn(msg.sender, _value);
457         return super.burn(_value);
458     }
459 
460     function transfer(address _to, uint256 _value) public returns (bool) {
461         consumerAddress.onTransfer(msg.sender, _to, _value);
462         return super.transfer(_to, _value);
463     }
464 
465     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
466         consumerAddress.onTransferFrom(msg.sender, _from, _to, _value);
467         return super.transferFrom(_from, _to, _value);
468     }
469 
470     function approve(address _spender, uint256 _value) public returns (bool) {
471         consumerAddress.onApprove(msg.sender, _spender, _value);
472         return super.approve(_spender, _value);
473     }
474 
475     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
476         consumerAddress.onIncreaseApproval(msg.sender, _spender, _addedValue);
477         return super.increaseApproval(_spender, _addedValue);
478     }
479 
480     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
481         consumerAddress.onDecreaseApproval(msg.sender, _spender, _subtractedValue);
482         return super.decreaseApproval(_spender, _subtractedValue);
483     }
484 
485 }
486 
487 
488 
489 /**
490  * @title ICOToken
491  * @dev Very simple ERC20 Token example.
492  * `StandardToken` functions.
493  */
494 contract ICOToken is MintableToken, PausableToken, HookableToken {
495 
496     string public constant name = "Artificial Intelligence Quotient";
497     string public constant symbol = "AIQ";
498     uint8 public constant decimals = 18;
499 
500 
501     /**
502      * @dev Constructor that gives msg.sender all of existing tokens.
503      */
504     constructor(address _consumerAdr) public 
505     HookableToken(_consumerAdr){
506     }
507 
508     //This function is used for taxation purposes and will be used after specific conditions
509     function taxTransfer(address _from, address _to, uint256 _tokensAmount) public onlyConsumerAddress returns (bool) {
510         require(_from != address(0));
511         require(_to != address(0));
512 
513         balances[_from] = balances[_from].sub(_tokensAmount);
514         balances[_to] = balances[_to].add(_tokensAmount);
515 
516         consumerAddress.onTaxTransfer(_from, _tokensAmount);
517 
518         return true;
519     }
520 }