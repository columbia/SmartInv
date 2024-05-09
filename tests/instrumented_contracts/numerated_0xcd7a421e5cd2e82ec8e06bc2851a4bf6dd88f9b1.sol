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
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94 
95   /**
96   * @dev Multiplies two numbers, throws on overflow.
97   */
98   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
99     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
100     // benefit is lost if 'b' is also tested.
101     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
102     if (_a == 0) {
103       return 0;
104     }
105 
106     c = _a * _b;
107     assert(c / _a == _b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
115     // assert(_b > 0); // Solidity automatically throws when dividing by 0
116     // uint256 c = _a / _b;
117     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
118     return _a / _b;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
125     assert(_b <= _a);
126     return _a - _b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
133     c = _a + _b;
134     assert(c >= _a);
135     return c;
136   }
137 }
138 
139 
140 
141 /**
142  * @title Basic token
143  * @dev Basic version of StandardToken, with no allowances.
144  */
145 contract BasicToken is ERC20Basic {
146   using SafeMath for uint256;
147 
148   mapping(address => uint256) internal balances;
149 
150   uint256 internal totalSupply_;
151 
152   /**
153   * @dev Total number of tokens in existence
154   */
155   function totalSupply() public view returns (uint256) {
156     return totalSupply_;
157   }
158 
159   /**
160   * @dev Transfer token for a specified address
161   * @param _to The address to transfer to.
162   * @param _value The amount to be transferred.
163   */
164   function transfer(address _to, uint256 _value) public returns (bool) {
165     require(_value <= balances[msg.sender]);
166     require(_to != address(0));
167 
168     balances[msg.sender] = balances[msg.sender].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     emit Transfer(msg.sender, _to, _value);
171     return true;
172   }
173 
174   /**
175   * @dev Gets the balance of the specified address.
176   * @param _owner The address to query the the balance of.
177   * @return An uint256 representing the amount owned by the passed address.
178   */
179   function balanceOf(address _owner) public view returns (uint256) {
180     return balances[_owner];
181   }
182 
183 }
184 
185 
186 
187 /**
188  * @title Burnable Token
189  * @dev Token that can be irreversibly burned (destroyed).
190  */
191 contract BurnableToken is BasicToken {
192 
193   event Burn(address indexed burner, uint256 value);
194 
195   /**
196    * @dev Burns a specific amount of tokens.
197    * @param _value The amount of token to be burned.
198    */
199   function burn(uint256 _value) public {
200     _burn(msg.sender, _value);
201   }
202 
203   function _burn(address _who, uint256 _value) internal {
204     require(_value <= balances[_who]);
205     // no need to require value <= totalSupply, since that would imply the
206     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
207 
208     balances[_who] = balances[_who].sub(_value);
209     totalSupply_ = totalSupply_.sub(_value);
210     emit Burn(_who, _value);
211     emit Transfer(_who, address(0), _value);
212   }
213 }
214 
215 
216 
217 
218 
219 
220 
221 
222 
223 
224 
225 /**
226  * @title ERC20 interface
227  * @dev see https://github.com/ethereum/EIPs/issues/20
228  */
229 contract ERC20 is ERC20Basic {
230   function allowance(address _owner, address _spender)
231     public view returns (uint256);
232 
233   function transferFrom(address _from, address _to, uint256 _value)
234     public returns (bool);
235 
236   function approve(address _spender, uint256 _value) public returns (bool);
237   event Approval(
238     address indexed owner,
239     address indexed spender,
240     uint256 value
241   );
242 }
243 
244 
245 
246 /**
247  * @title Standard ERC20 token
248  *
249  * @dev Implementation of the basic standard token.
250  * https://github.com/ethereum/EIPs/issues/20
251  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
252  */
253 contract StandardToken is ERC20, BasicToken {
254 
255   mapping (address => mapping (address => uint256)) internal allowed;
256 
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param _from address The address which you want to send tokens from
261    * @param _to address The address which you want to transfer to
262    * @param _value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(
265     address _from,
266     address _to,
267     uint256 _value
268   )
269     public
270     returns (bool)
271   {
272     require(_value <= balances[_from]);
273     require(_value <= allowed[_from][msg.sender]);
274     require(_to != address(0));
275 
276     balances[_from] = balances[_from].sub(_value);
277     balances[_to] = balances[_to].add(_value);
278     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
279     emit Transfer(_from, _to, _value);
280     return true;
281   }
282 
283   /**
284    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
285    * Beware that changing an allowance with this method brings the risk that someone may use both the old
286    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
287    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
288    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289    * @param _spender The address which will spend the funds.
290    * @param _value The amount of tokens to be spent.
291    */
292   function approve(address _spender, uint256 _value) public returns (bool) {
293     allowed[msg.sender][_spender] = _value;
294     emit Approval(msg.sender, _spender, _value);
295     return true;
296   }
297 
298   /**
299    * @dev Function to check the amount of tokens that an owner allowed to a spender.
300    * @param _owner address The address which owns the funds.
301    * @param _spender address The address which will spend the funds.
302    * @return A uint256 specifying the amount of tokens still available for the spender.
303    */
304   function allowance(
305     address _owner,
306     address _spender
307    )
308     public
309     view
310     returns (uint256)
311   {
312     return allowed[_owner][_spender];
313   }
314 
315   /**
316    * @dev Increase the amount of tokens that an owner allowed to a spender.
317    * approve should be called when allowed[_spender] == 0. To increment
318    * allowed value is better to use this function to avoid 2 calls (and wait until
319    * the first transaction is mined)
320    * From MonolithDAO Token.sol
321    * @param _spender The address which will spend the funds.
322    * @param _addedValue The amount of tokens to increase the allowance by.
323    */
324   function increaseApproval(
325     address _spender,
326     uint256 _addedValue
327   )
328     public
329     returns (bool)
330   {
331     allowed[msg.sender][_spender] = (
332       allowed[msg.sender][_spender].add(_addedValue));
333     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334     return true;
335   }
336 
337   /**
338    * @dev Decrease the amount of tokens that an owner allowed to a spender.
339    * approve should be called when allowed[_spender] == 0. To decrement
340    * allowed value is better to use this function to avoid 2 calls (and wait until
341    * the first transaction is mined)
342    * From MonolithDAO Token.sol
343    * @param _spender The address which will spend the funds.
344    * @param _subtractedValue The amount of tokens to decrease the allowance by.
345    */
346   function decreaseApproval(
347     address _spender,
348     uint256 _subtractedValue
349   )
350     public
351     returns (bool)
352   {
353     uint256 oldValue = allowed[msg.sender][_spender];
354     if (_subtractedValue >= oldValue) {
355       allowed[msg.sender][_spender] = 0;
356     } else {
357       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
358     }
359     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
360     return true;
361   }
362 
363 }
364 
365 
366 
367 
368 
369 
370 
371 /**
372  * @title Pausable
373  * @dev Base contract which allows children to implement an emergency stop mechanism.
374  */
375 contract Pausable is Ownable {
376   event Pause();
377   event Unpause();
378 
379   bool public paused = false;
380 
381 
382   /**
383    * @dev Modifier to make a function callable only when the contract is not paused.
384    */
385   modifier whenNotPaused() {
386     require(!paused);
387     _;
388   }
389 
390   /**
391    * @dev Modifier to make a function callable only when the contract is paused.
392    */
393   modifier whenPaused() {
394     require(paused);
395     _;
396   }
397 
398   /**
399    * @dev called by the owner to pause, triggers stopped state
400    */
401   function pause() public onlyOwner whenNotPaused {
402     paused = true;
403     emit Pause();
404   }
405 
406   /**
407    * @dev called by the owner to unpause, returns to normal state
408    */
409   function unpause() public onlyOwner whenPaused {
410     paused = false;
411     emit Unpause();
412   }
413 }
414 
415 
416 
417 /**
418  * @title Pausable token
419  * @dev StandardToken modified with pausable transfers.
420  **/
421 contract PausableToken is StandardToken, Pausable {
422 
423   function transfer(
424     address _to,
425     uint256 _value
426   )
427     public
428     whenNotPaused
429     returns (bool)
430   {
431     return super.transfer(_to, _value);
432   }
433 
434   function transferFrom(
435     address _from,
436     address _to,
437     uint256 _value
438   )
439     public
440     whenNotPaused
441     returns (bool)
442   {
443     return super.transferFrom(_from, _to, _value);
444   }
445 
446   function approve(
447     address _spender,
448     uint256 _value
449   )
450     public
451     whenNotPaused
452     returns (bool)
453   {
454     return super.approve(_spender, _value);
455   }
456 
457   function increaseApproval(
458     address _spender,
459     uint _addedValue
460   )
461     public
462     whenNotPaused
463     returns (bool success)
464   {
465     return super.increaseApproval(_spender, _addedValue);
466   }
467 
468   function decreaseApproval(
469     address _spender,
470     uint _subtractedValue
471   )
472     public
473     whenNotPaused
474     returns (bool success)
475   {
476     return super.decreaseApproval(_spender, _subtractedValue);
477   }
478 }
479 
480 
481 contract TSCCoin is PausableToken, BurnableToken {
482 
483     string public name = 'TrustShore Coin';
484     string public symbol = 'TSC';
485     uint8 public decimals = 18;
486     uint256 public INITIAL_SUPPLY = 21000000000;
487 
488     constructor() public {
489         totalSupply_ = INITIAL_SUPPLY*10**18;
490         balances[msg.sender] = totalSupply_;
491     }
492 
493     function burn(uint256 _value) public whenNotPaused {
494         super.burn(_value);
495     }
496 }