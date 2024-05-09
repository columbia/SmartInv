1 pragma solidity ^0.4.23;
2 
3 // File: contracts/ownership/Ownable.sol
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
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() onlyOwner whenNotPaused public {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() onlyOwner whenPaused public {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: contracts/math/SafeMath.sol
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
125     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
126     // benefit is lost if 'b' is also tested.
127     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
128     if (a == 0) {
129       return 0;
130     }
131 
132     c = a * b;
133     assert(c / a == b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 a, uint256 b) internal pure returns (uint256) {
141     // assert(b > 0); // Solidity automatically throws when dividing by 0
142     // uint256 c = a / b;
143     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144     return a / b;
145   }
146 
147   /**
148   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     assert(b <= a);
152     return a - b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
159     c = a + b;
160     assert(c >= a);
161     return c;
162   }
163 }
164 
165 // File: contracts/ERC20/ERC20Basic.sol
166 
167 /**
168  * @title ERC20Basic
169  * @dev Simpler version of ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/179
171  */
172 contract ERC20Basic {
173   function totalSupply() public view returns (uint256);
174   function balanceOf(address who) public view returns (uint256);
175   function transfer(address to, uint256 value) public returns (bool);
176   event Transfer(address indexed from, address indexed to, uint256 value);
177 }
178 
179 // File: contracts/ERC20/BasicToken.sol
180 
181 /**
182  * @title Basic token
183  * @dev Basic version of StandardToken, with no allowances.
184  */
185 contract BasicToken is ERC20Basic {
186   using SafeMath for uint256;
187 
188   mapping(address => uint256) balances;
189 
190   uint256 totalSupply_;
191 
192   /**
193   * @dev Total number of tokens in existence
194   */
195   function totalSupply() public view returns (uint256) {
196     return totalSupply_;
197   }
198 
199   /**
200   * @dev Transfer token for a specified address
201   * @param _to The address to transfer to.
202   * @param _value The amount to be transferred.
203   */
204   function transfer(address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[msg.sender]);
207 
208     balances[msg.sender] = balances[msg.sender].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     emit Transfer(msg.sender, _to, _value);
211     return true;
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address.
216   * @param _owner The address to query the the balance of.
217   * @return An uint256 representing the amount owned by the passed address.
218   */
219   function balanceOf(address _owner) public view returns (uint256) {
220     return balances[_owner];
221   }
222 
223 }
224 
225 // File: contracts/ERC20/ERC20.sol
226 
227 /**
228  * @title ERC20 interface
229  * @dev see https://github.com/ethereum/EIPs/issues/20
230  */
231 contract ERC20 is ERC20Basic {
232   function allowance(address owner, address spender)
233     public view returns (uint256);
234 
235   function transferFrom(address from, address to, uint256 value)
236     public returns (bool);
237 
238   function approve(address spender, uint256 value) public returns (bool);
239   event Approval(
240     address indexed owner,
241     address indexed spender,
242     uint256 value
243   );
244 }
245 
246 // File: contracts/ERC20/StandardToken.sol
247 
248 /**
249  * @title Standard ERC20 token
250  *
251  * @dev Implementation of the basic standard token.
252  * @dev https://github.com/ethereum/EIPs/issues/20
253  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
254  */
255 contract StandardToken is ERC20, BasicToken {
256 
257   mapping (address => mapping (address => uint256)) internal allowed;
258 
259 
260   /**
261    * @dev Transfer tokens from one address to another
262    * @param _from address The address which you want to send tokens from
263    * @param _to address The address which you want to transfer to
264    * @param _value uint256 the amount of tokens to be transferred
265    */
266   function transferFrom(
267     address _from,
268     address _to,
269     uint256 _value
270   )
271     public
272     returns (bool)
273   {
274     require(_to != address(0));
275     require(_value <= balances[_from]);
276     require(_value <= allowed[_from][msg.sender]);
277 
278     balances[_from] = balances[_from].sub(_value);
279     balances[_to] = balances[_to].add(_value);
280     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
281     emit Transfer(_from, _to, _value);
282     return true;
283   }
284 
285   /**
286    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
287    *
288    * Beware that changing an allowance with this method brings the risk that someone may use both the old
289    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
290    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
291    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292    * @param _spender The address which will spend the funds.
293    * @param _value The amount of tokens to be spent.
294    */
295   function approve(address _spender, uint256 _value) public returns (bool) {
296     allowed[msg.sender][_spender] = _value;
297     emit Approval(msg.sender, _spender, _value);
298     return true;
299   }
300 
301   /**
302    * @dev Function to check the amount of tokens that an owner allowed to a spender.
303    * @param _owner address The address which owns the funds.
304    * @param _spender address The address which will spend the funds.
305    * @return A uint256 specifying the amount of tokens still available for the spender.
306    */
307   function allowance(
308     address _owner,
309     address _spender
310    )
311     public
312     view
313     returns (uint256)
314   {
315     return allowed[_owner][_spender];
316   }
317 
318   /**
319    * @dev Increase the amount of tokens that an owner allowed to a spender.
320    *
321    * approve should be called when allowed[_spender] == 0. To increment
322    * allowed value is better to use this function to avoid 2 calls (and wait until
323    * the first transaction is mined)
324    * From MonolithDAO Token.sol
325    * @param _spender The address which will spend the funds.
326    * @param _addedValue The amount of tokens to increase the allowance by.
327    */
328   function increaseApproval(
329     address _spender,
330     uint _addedValue
331   )
332     public
333     returns (bool)
334   {
335     allowed[msg.sender][_spender] = (
336       allowed[msg.sender][_spender].add(_addedValue));
337     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
338     return true;
339   }
340 
341   /**
342    * @dev Decrease the amount of tokens that an owner allowed to a spender.
343    *
344    * approve should be called when allowed[_spender] == 0. To decrement
345    * allowed value is better to use this function to avoid 2 calls (and wait until
346    * the first transaction is mined)
347    * From MonolithDAO Token.sol
348    * @param _spender The address which will spend the funds.
349    * @param _subtractedValue The amount of tokens to decrease the allowance by.
350    */
351   function decreaseApproval(
352     address _spender,
353     uint _subtractedValue
354   )
355     public
356     returns (bool)
357   {
358     uint oldValue = allowed[msg.sender][_spender];
359     if (_subtractedValue > oldValue) {
360       allowed[msg.sender][_spender] = 0;
361     } else {
362       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
363     }
364     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365     return true;
366   }
367 
368 }
369 
370 // File: contracts/ERC20/PausableToken.sol
371 
372 /**
373  * @title Pausable token
374  * @dev StandardToken modified with pausable transfers.
375  **/
376 contract PausableToken is StandardToken, Pausable {
377 
378   function transfer(
379     address _to,
380     uint256 _value
381   )
382     public
383     whenNotPaused
384     returns (bool)
385   {
386     return super.transfer(_to, _value);
387   }
388 
389   function transferFrom(
390     address _from,
391     address _to,
392     uint256 _value
393   )
394     public
395     whenNotPaused
396     returns (bool)
397   {
398     return super.transferFrom(_from, _to, _value);
399   }
400 
401   function approve(
402     address _spender,
403     uint256 _value
404   )
405     public
406     whenNotPaused
407     returns (bool)
408   {
409     return super.approve(_spender, _value);
410   }
411 
412   function increaseApproval(
413     address _spender,
414     uint _addedValue
415   )
416     public
417     whenNotPaused
418     returns (bool success)
419   {
420     return super.increaseApproval(_spender, _addedValue);
421   }
422 
423   function decreaseApproval(
424     address _spender,
425     uint _subtractedValue
426   )
427     public
428     whenNotPaused
429     returns (bool success)
430   {
431     return super.decreaseApproval(_spender, _subtractedValue);
432   }
433 }
434 
435 // File: contracts/UltrAlphaToken.sol
436 
437 contract UltrAlphaToken is PausableToken {
438     using SafeMath for uint256;
439 
440     string  public  constant name = "UltrAlpha token";
441     string  public  constant symbol = "UAT";
442     uint8   public  constant decimals = 18;
443 
444     event Burn(address indexed burner, uint256 value);
445 
446     modifier validDestination( address to ){
447         require(to != address(0x0));
448         require(to != address(this));
449         _;
450     }
451 
452     constructor()  public   {
453         // assign the total tokens to UAT 500 M
454         totalSupply_ = 5 * 10**8 * 10**18;
455 
456         balances[msg.sender] = totalSupply_;
457         emit Transfer(address(0x0), msg.sender, totalSupply_);
458     }
459 
460     function transfer(address _to, uint _value) validDestination(_to) public returns (bool) {
461         return super.transfer(_to, _value);
462     }
463 
464     function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) {
465         return super.transferFrom(_from, _to, _value);
466     }
467 
468     /**
469     * @dev Burns a specific amount of tokens.
470     * @param _value The amount of token to be burned.
471     */
472     function burn(uint256 _value) public {
473         _burn(msg.sender, _value);
474     }
475 
476     function _burn(address _who, uint256 _value) internal {
477         require(_value <= balances[_who]);
478         // no need to require value <= totalSupply, since that would imply the
479         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
480 
481         balances[_who] = balances[_who].sub(_value);
482         totalSupply_ = totalSupply_.sub(_value);
483         emit Burn(_who, _value);
484         emit Transfer(_who, address(0), _value);
485     }
486 }