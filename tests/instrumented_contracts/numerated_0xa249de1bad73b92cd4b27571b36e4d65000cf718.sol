1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79  // solium-disable linebreak-style
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 
90 
91 /**
92  * @title SafeMath
93  * @dev Math operations with safety checks that throw on error
94  */
95 library SafeMath {
96 
97   /**
98   * @dev Multiplies two numbers, throws on overflow.
99   */
100   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
101     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
102     // benefit is lost if 'b' is also tested.
103     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
104     if (_a == 0) {
105       return 0;
106     }
107 
108     c = _a * _b;
109     assert(c / _a == _b);
110     return c;
111   }
112 
113   /**
114   * @dev Integer division of two numbers, truncating the quotient.
115   */
116   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
117     // assert(_b > 0); // Solidity automatically throws when dividing by 0
118     // uint256 c = _a / _b;
119     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
120     return _a / _b;
121   }
122 
123   /**
124   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
125   */
126   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
127     assert(_b <= _a);
128     return _a - _b;
129   }
130 
131   /**
132   * @dev Adds two numbers, throws on overflow.
133   */
134   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
135     c = _a + _b;
136     assert(c >= _a);
137     return c;
138   }
139 }
140 
141 
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   mapping(address => uint256) internal balances;
151 
152   uint256 internal totalSupply_;
153 
154   /**
155   * @dev Total number of tokens in existence
156   */
157   function totalSupply() public view returns (uint256) {
158     return totalSupply_;
159   }
160 
161   /**
162   * @dev Transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     require(_value <= balances[msg.sender]);
168     require(_to != address(0));
169 
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     emit Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public view returns (uint256) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 
188 
189 
190 
191 
192 /**
193  * @title ERC20 interface
194  * @dev see https://github.com/ethereum/EIPs/issues/20
195  */
196 contract ERC20 is ERC20Basic {
197   function allowance(address _owner, address _spender)
198     public view returns (uint256);
199 
200   function transferFrom(address _from, address _to, uint256 _value)
201     public returns (bool);
202 
203   function approve(address _spender, uint256 _value) public returns (bool);
204   event Approval(
205     address indexed owner,
206     address indexed spender,
207     uint256 value
208   );
209 }
210 
211 
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * https://github.com/ethereum/EIPs/issues/20
218  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract StandardToken is ERC20, BasicToken {
221 
222   mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232     require(_value <= balances[_from]);
233     require(_value <= allowed[_from][msg.sender]);
234     require(_to != address(0));
235 
236     balances[_from] = balances[_from].sub(_value);
237     balances[_to] = balances[_to].add(_value);
238     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239     emit Transfer(_from, _to, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
245    * Beware that changing an allowance with this method brings the risk that someone may use both the old
246    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
247    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
248    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249    * @param _spender The address which will spend the funds.
250    * @param _value The amount of tokens to be spent.
251    */
252   function approve(address _spender, uint256 _value) public returns (bool) {
253     allowed[msg.sender][_spender] = _value;
254     emit Approval(msg.sender, _spender, _value);
255     return true;
256   }
257 
258   /**
259    * @dev Function to check the amount of tokens that an owner allowed to a spender.
260    * @param _owner address The address which owns the funds.
261    * @param _spender address The address which will spend the funds.
262    * @return A uint256 specifying the amount of tokens still available for the spender.
263    */
264   function allowance(
265     address _owner,
266     address _spender
267    )
268     public
269     view
270     returns (uint256)
271   {
272     return allowed[_owner][_spender];
273   }
274 
275   /**
276    * @dev Increase the amount of tokens that an owner allowed to a spender.
277    * approve should be called when allowed[_spender] == 0. To increment
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    * @param _spender The address which will spend the funds.
282    * @param _addedValue The amount of tokens to increase the allowance by.
283    */
284   function increaseApproval(
285     address _spender,
286     uint256 _addedValue
287   )
288     public
289     returns (bool)
290   {
291     allowed[msg.sender][_spender] = (
292       allowed[msg.sender][_spender].add(_addedValue));
293     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294     return true;
295   }
296 
297   /**
298    * @dev Decrease the amount of tokens that an owner allowed to a spender.
299    * approve should be called when allowed[_spender] == 0. To decrement
300    * allowed value is better to use this function to avoid 2 calls (and wait until
301    * the first transaction is mined)
302    * From MonolithDAO Token.sol
303    * @param _spender The address which will spend the funds.
304    * @param _subtractedValue The amount of tokens to decrease the allowance by.
305    */
306   function decreaseApproval(
307     address _spender,
308     uint256 _subtractedValue
309   )
310     public
311     returns (bool)
312   {
313     uint256 oldValue = allowed[msg.sender][_spender];
314     if (_subtractedValue >= oldValue) {
315       allowed[msg.sender][_spender] = 0;
316     } else {
317       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
318     }
319     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320     return true;
321   }
322 
323 }
324 
325 
326 
327 
328 
329 
330 
331 
332 
333 
334 /**
335  * @title Pausable
336  * @dev Base contract which allows children to implement an emergency stop mechanism.
337  */
338 contract Pausable is Ownable {
339   event Pause();
340   event Unpause();
341 
342   bool public paused = false;
343 
344 
345   /**
346    * @dev Modifier to make a function callable only when the contract is not paused.
347    */
348   modifier whenNotPaused() {
349     require(!paused);
350     _;
351   }
352 
353   /**
354    * @dev Modifier to make a function callable only when the contract is paused.
355    */
356   modifier whenPaused() {
357     require(paused);
358     _;
359   }
360 
361   /**
362    * @dev called by the owner to pause, triggers stopped state
363    */
364   function pause() public onlyOwner whenNotPaused {
365     paused = true;
366     emit Pause();
367   }
368 
369   /**
370    * @dev called by the owner to unpause, returns to normal state
371    */
372   function unpause() public onlyOwner whenPaused {
373     paused = false;
374     emit Unpause();
375   }
376 }
377 
378 
379 
380 /**
381  * @title Pausable token
382  * @dev StandardToken modified with pausable transfers.
383  **/
384 contract PausableToken is StandardToken, Pausable {
385 
386   function transfer(
387     address _to,
388     uint256 _value
389   )
390     public
391     whenNotPaused
392     returns (bool)
393   {
394     return super.transfer(_to, _value);
395   }
396 
397   function transferFrom(
398     address _from,
399     address _to,
400     uint256 _value
401   )
402     public
403     whenNotPaused
404     returns (bool)
405   {
406     return super.transferFrom(_from, _to, _value);
407   }
408 
409   function approve(
410     address _spender,
411     uint256 _value
412   )
413     public
414     whenNotPaused
415     returns (bool)
416   {
417     return super.approve(_spender, _value);
418   }
419 
420   function increaseApproval(
421     address _spender,
422     uint _addedValue
423   )
424     public
425     whenNotPaused
426     returns (bool success)
427   {
428     return super.increaseApproval(_spender, _addedValue);
429   }
430 
431   function decreaseApproval(
432     address _spender,
433     uint _subtractedValue
434   )
435     public
436     whenNotPaused
437     returns (bool success)
438   {
439     return super.decreaseApproval(_spender, _subtractedValue);
440   }
441 }
442 
443 
444 
445 
446 
447 
448 /**
449  * @title Burnable Token
450  * @dev Token that can be irreversibly burned (destroyed).
451  */
452 contract BurnableToken is BasicToken {
453 
454   event Burn(address indexed burner, uint256 value);
455 
456   /**
457    * @dev Burns a specific amount of tokens.
458    * @param _value The amount of token to be burned.
459    */
460   function burn(uint256 _value) public {
461     _burn(msg.sender, _value);
462   }
463 
464   function _burn(address _who, uint256 _value) internal {
465     require(_value <= balances[_who]);
466     // no need to require value <= totalSupply, since that would imply the
467     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
468 
469     balances[_who] = balances[_who].sub(_value);
470     totalSupply_ = totalSupply_.sub(_value);
471     emit Burn(_who, _value);
472     emit Transfer(_who, address(0), _value);
473   }
474 }
475 
476 
477 
478 contract CollegeToken is StandardToken, PausableToken, BurnableToken {
479 
480     using SafeMath for uint256;
481 
482     string public constant name =  "College Token";
483     string public constant symbol = "CT";
484     uint256 public constant decimals = 18;
485     uint256 public totalSupply = 1000000000 * 1 ether;
486 
487     constructor() {
488         totalSupply_ = totalSupply;
489         balances[msg.sender] = totalSupply_;
490     }
491 
492     function transferFunds(address[] _to, uint256[] _value) public onlyOwner {
493 
494         for (uint i = 0; i < _to.length; i++) {
495             
496             _value[i] = SafeMath.mul(_value[i], 1 ether);
497           
498             require(_value[i] <= balances[msg.sender]);
499             require(_to[i] != address(0));
500 
501             balances[msg.sender] = balances[msg.sender].sub(_value[i]);
502             balances[_to[i]] = balances[_to[i]].add(_value[i]);
503             emit Transfer(msg.sender, _to[i], _value[i]);
504         }
505     }
506 }