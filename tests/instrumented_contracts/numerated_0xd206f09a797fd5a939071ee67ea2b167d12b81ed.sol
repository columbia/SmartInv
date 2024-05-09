1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: zeppelin-solidity/contracts/math/SafeMath.sol
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (a == 0) {
80       return 0;
81     }
82 
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return a / b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
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
206 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
207 
208 /**
209  * @title ERC20 interface
210  * @dev see https://github.com/ethereum/EIPs/issues/20
211  */
212 contract ERC20 is ERC20Basic {
213   function allowance(address owner, address spender)
214     public view returns (uint256);
215 
216   function transferFrom(address from, address to, uint256 value)
217     public returns (bool);
218 
219   function approve(address spender, uint256 value) public returns (bool);
220   event Approval(
221     address indexed owner,
222     address indexed spender,
223     uint256 value
224   );
225 }
226 
227 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
228 
229 /**
230  * @title Pausable
231  * @dev Base contract which allows children to implement an emergency stop mechanism.
232  */
233 contract Pausable is Ownable {
234   event Pause();
235   event Unpause();
236 
237   bool public paused = false;
238 
239 
240   /**
241    * @dev Modifier to make a function callable only when the contract is not paused.
242    */
243   modifier whenNotPaused() {
244     require(!paused);
245     _;
246   }
247 
248   /**
249    * @dev Modifier to make a function callable only when the contract is paused.
250    */
251   modifier whenPaused() {
252     require(paused);
253     _;
254   }
255 
256   /**
257    * @dev called by the owner to pause, triggers stopped state
258    */
259   function pause() onlyOwner whenNotPaused public {
260     paused = true;
261     emit Pause();
262   }
263 
264   /**
265    * @dev called by the owner to unpause, returns to normal state
266    */
267   function unpause() onlyOwner whenPaused public {
268     paused = false;
269     emit Unpause();
270   }
271 }
272 
273 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
274 
275 /**
276  * @title Standard ERC20 token
277  *
278  * @dev Implementation of the basic standard token.
279  * @dev https://github.com/ethereum/EIPs/issues/20
280  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
281  */
282 contract StandardToken is ERC20, BasicToken {
283 
284   mapping (address => mapping (address => uint256)) internal allowed;
285 
286 
287   /**
288    * @dev Transfer tokens from one address to another
289    * @param _from address The address which you want to send tokens from
290    * @param _to address The address which you want to transfer to
291    * @param _value uint256 the amount of tokens to be transferred
292    */
293   function transferFrom(
294     address _from,
295     address _to,
296     uint256 _value
297   )
298     public
299     returns (bool)
300   {
301     require(_to != address(0));
302     require(_value <= balances[_from]);
303     require(_value <= allowed[_from][msg.sender]);
304 
305     balances[_from] = balances[_from].sub(_value);
306     balances[_to] = balances[_to].add(_value);
307     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
308     emit Transfer(_from, _to, _value);
309     return true;
310   }
311 
312   /**
313    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
314    *
315    * Beware that changing an allowance with this method brings the risk that someone may use both the old
316    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
317    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
318    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
319    * @param _spender The address which will spend the funds.
320    * @param _value The amount of tokens to be spent.
321    */
322   function approve(address _spender, uint256 _value) public returns (bool) {
323     allowed[msg.sender][_spender] = _value;
324     emit Approval(msg.sender, _spender, _value);
325     return true;
326   }
327 
328   /**
329    * @dev Function to check the amount of tokens that an owner allowed to a spender.
330    * @param _owner address The address which owns the funds.
331    * @param _spender address The address which will spend the funds.
332    * @return A uint256 specifying the amount of tokens still available for the spender.
333    */
334   function allowance(
335     address _owner,
336     address _spender
337    )
338     public
339     view
340     returns (uint256)
341   {
342     return allowed[_owner][_spender];
343   }
344 
345   /**
346    * @dev Increase the amount of tokens that an owner allowed to a spender.
347    *
348    * approve should be called when allowed[_spender] == 0. To increment
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _addedValue The amount of tokens to increase the allowance by.
354    */
355   function increaseApproval(
356     address _spender,
357     uint _addedValue
358   )
359     public
360     returns (bool)
361   {
362     allowed[msg.sender][_spender] = (
363       allowed[msg.sender][_spender].add(_addedValue));
364     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365     return true;
366   }
367 
368   /**
369    * @dev Decrease the amount of tokens that an owner allowed to a spender.
370    *
371    * approve should be called when allowed[_spender] == 0. To decrement
372    * allowed value is better to use this function to avoid 2 calls (and wait until
373    * the first transaction is mined)
374    * From MonolithDAO Token.sol
375    * @param _spender The address which will spend the funds.
376    * @param _subtractedValue The amount of tokens to decrease the allowance by.
377    */
378   function decreaseApproval(
379     address _spender,
380     uint _subtractedValue
381   )
382     public
383     returns (bool)
384   {
385     uint oldValue = allowed[msg.sender][_spender];
386     if (_subtractedValue > oldValue) {
387       allowed[msg.sender][_spender] = 0;
388     } else {
389       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
390     }
391     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
392     return true;
393   }
394 
395 }
396 
397 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
398 
399 /**
400  * @title Pausable token
401  * @dev StandardToken modified with pausable transfers.
402  **/
403 contract PausableToken is StandardToken, Pausable {
404 
405   function transfer(
406     address _to,
407     uint256 _value
408   )
409     public
410     whenNotPaused
411     returns (bool)
412   {
413     return super.transfer(_to, _value);
414   }
415 
416   function transferFrom(
417     address _from,
418     address _to,
419     uint256 _value
420   )
421     public
422     whenNotPaused
423     returns (bool)
424   {
425     return super.transferFrom(_from, _to, _value);
426   }
427 
428   function approve(
429     address _spender,
430     uint256 _value
431   )
432     public
433     whenNotPaused
434     returns (bool)
435   {
436     return super.approve(_spender, _value);
437   }
438 
439   function increaseApproval(
440     address _spender,
441     uint _addedValue
442   )
443     public
444     whenNotPaused
445     returns (bool success)
446   {
447     return super.increaseApproval(_spender, _addedValue);
448   }
449 
450   function decreaseApproval(
451     address _spender,
452     uint _subtractedValue
453   )
454     public
455     whenNotPaused
456     returns (bool success)
457   {
458     return super.decreaseApproval(_spender, _subtractedValue);
459   }
460 }
461 
462 // File: contracts/CppToken.sol
463 
464 contract CppToken is Ownable, BurnableToken, PausableToken {
465 
466     string public constant name = "CoinPinPinToken";
467     string public constant symbol = "CPP";
468     uint8 public constant decimals = 18;
469     string public version = '1.0.0';
470 
471 
472     uint256 public constant INITIAL_SUPPLY = 200 * 100000000 * (10 ** uint256(decimals));
473 
474 
475     /* init CppToken CPP token  */
476 
477     constructor() public {
478         totalSupply_ = INITIAL_SUPPLY;
479         balances[msg.sender] = INITIAL_SUPPLY;
480         emit Transfer(this, msg.sender, INITIAL_SUPPLY);
481     }
482 
483     function() payable public {
484     }
485 
486 
487     function withdrawEth(uint256 _value) public onlyOwner {
488         owner.transfer(_value);
489     }
490 
491 
492 
493     /* Transfer out any accidentally sent ERC20 tokens */
494 
495     function transferAnyERC20Token(address _token_address, uint _amount) public onlyOwner returns (bool success) {
496         return ERC20(_token_address).transfer(owner, _amount);
497     }
498 
499 
500     /* Multiple token transfers from one address to save gas and time  */
501 
502     function transferMultiple(address[] _addresses, uint[] _amounts) external {
503         for (uint i; i < _addresses.length; i++) {
504             super.transfer(_addresses[i], _amounts[i]);
505         }
506     }
507 
508     function transferMultipleSame(address[] _addresses, uint _amount) external {
509         for (uint i; i < _addresses.length; i++) {
510             super.transfer(_addresses[i], _amount);
511         }
512     }
513 }