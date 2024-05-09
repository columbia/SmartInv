1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity\contracts\ownership\Ownable.sol
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
67 // File: zeppelin-solidity\contracts\lifecycle\Pausable.sol
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
113 // File: zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 // File: zeppelin-solidity\contracts\token\ERC20\ERC20.sol
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender)
135     public view returns (uint256);
136 
137   function transferFrom(address from, address to, uint256 value)
138     public returns (bool);
139 
140   function approve(address spender, uint256 value) public returns (bool);
141   event Approval(
142     address indexed owner,
143     address indexed spender,
144     uint256 value
145   );
146 }
147 
148 // File: zeppelin-solidity\contracts\math\SafeMath.sol
149 
150 /**
151  * @title SafeMath
152  * @dev Math operations with safety checks that throw on error
153  */
154 library SafeMath {
155 
156   /**
157   * @dev Multiplies two numbers, throws on overflow.
158   */
159   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
160     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
161     // benefit is lost if 'b' is also tested.
162     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
163     if (a == 0) {
164       return 0;
165     }
166 
167     c = a * b;
168     assert(c / a == b);
169     return c;
170   }
171 
172   /**
173   * @dev Integer division of two numbers, truncating the quotient.
174   */
175   function div(uint256 a, uint256 b) internal pure returns (uint256) {
176     // assert(b > 0); // Solidity automatically throws when dividing by 0
177     // uint256 c = a / b;
178     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
179     return a / b;
180   }
181 
182   /**
183   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
184   */
185   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186     assert(b <= a);
187     return a - b;
188   }
189 
190   /**
191   * @dev Adds two numbers, throws on overflow.
192   */
193   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
194     c = a + b;
195     assert(c >= a);
196     return c;
197   }
198 }
199 
200 // File: zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
201 
202 /**
203  * @title Basic token
204  * @dev Basic version of StandardToken, with no allowances.
205  */
206 contract BasicToken is ERC20Basic {
207   using SafeMath for uint256;
208 
209   mapping(address => uint256) balances;
210 
211   uint256 totalSupply_;
212 
213   /**
214   * @dev Total number of tokens in existence
215   */
216   function totalSupply() public view returns (uint256) {
217     return totalSupply_;
218   }
219 
220   /**
221   * @dev Transfer token for a specified address
222   * @param _to The address to transfer to.
223   * @param _value The amount to be transferred.
224   */
225   function transfer(address _to, uint256 _value) public returns (bool) {
226     require(_to != address(0));
227     require(_value <= balances[msg.sender]);
228 
229     balances[msg.sender] = balances[msg.sender].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     emit Transfer(msg.sender, _to, _value);
232     return true;
233   }
234 
235   /**
236   * @dev Gets the balance of the specified address.
237   * @param _owner The address to query the the balance of.
238   * @return An uint256 representing the amount owned by the passed address.
239   */
240   function balanceOf(address _owner) public view returns (uint256) {
241     return balances[_owner];
242   }
243 
244 }
245 
246 // File: zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
247 
248 /**
249  * @title Standard ERC20 token
250  *
251  * @dev Implementation of the basic standard token.
252  * https://github.com/ethereum/EIPs/issues/20
253  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
287    * Beware that changing an allowance with this method brings the risk that someone may use both the old
288    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291    * @param _spender The address which will spend the funds.
292    * @param _value The amount of tokens to be spent.
293    */
294   function approve(address _spender, uint256 _value) public returns (bool) {
295     allowed[msg.sender][_spender] = _value;
296     emit Approval(msg.sender, _spender, _value);
297     return true;
298   }
299 
300   /**
301    * @dev Function to check the amount of tokens that an owner allowed to a spender.
302    * @param _owner address The address which owns the funds.
303    * @param _spender address The address which will spend the funds.
304    * @return A uint256 specifying the amount of tokens still available for the spender.
305    */
306   function allowance(
307     address _owner,
308     address _spender
309    )
310     public
311     view
312     returns (uint256)
313   {
314     return allowed[_owner][_spender];
315   }
316 
317   /**
318    * @dev Increase the amount of tokens that an owner allowed to a spender.
319    * approve should be called when allowed[_spender] == 0. To increment
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _addedValue The amount of tokens to increase the allowance by.
325    */
326   function increaseApproval(
327     address _spender,
328     uint256 _addedValue
329   )
330     public
331     returns (bool)
332   {
333     allowed[msg.sender][_spender] = (
334       allowed[msg.sender][_spender].add(_addedValue));
335     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339   /**
340    * @dev Decrease the amount of tokens that an owner allowed to a spender.
341    * approve should be called when allowed[_spender] == 0. To decrement
342    * allowed value is better to use this function to avoid 2 calls (and wait until
343    * the first transaction is mined)
344    * From MonolithDAO Token.sol
345    * @param _spender The address which will spend the funds.
346    * @param _subtractedValue The amount of tokens to decrease the allowance by.
347    */
348   function decreaseApproval(
349     address _spender,
350     uint256 _subtractedValue
351   )
352     public
353     returns (bool)
354   {
355     uint256 oldValue = allowed[msg.sender][_spender];
356     if (_subtractedValue > oldValue) {
357       allowed[msg.sender][_spender] = 0;
358     } else {
359       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
360     }
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365 }
366 
367 // File: zeppelin-solidity\contracts\token\ERC20\MintableToken.sol
368 
369 /**
370  * @title Mintable token
371  * @dev Simple ERC20 Token example, with mintable token creation
372  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
373  */
374 contract MintableToken is StandardToken, Ownable {
375   event Mint(address indexed to, uint256 amount);
376   event MintFinished();
377 
378   bool public mintingFinished = false;
379 
380 
381   modifier canMint() {
382     require(!mintingFinished);
383     _;
384   }
385 
386   modifier hasMintPermission() {
387     require(msg.sender == owner);
388     _;
389   }
390 
391   /**
392    * @dev Function to mint tokens
393    * @param _to The address that will receive the minted tokens.
394    * @param _amount The amount of tokens to mint.
395    * @return A boolean that indicates if the operation was successful.
396    */
397   function mint(
398     address _to,
399     uint256 _amount
400   )
401     hasMintPermission
402     canMint
403     public
404     returns (bool)
405   {
406     totalSupply_ = totalSupply_.add(_amount);
407     balances[_to] = balances[_to].add(_amount);
408     emit Mint(_to, _amount);
409     emit Transfer(address(0), _to, _amount);
410     return true;
411   }
412 
413   /**
414    * @dev Function to stop minting new tokens.
415    * @return True if the operation was successful.
416    */
417   function finishMinting() onlyOwner canMint public returns (bool) {
418     mintingFinished = true;
419     emit MintFinished();
420     return true;
421   }
422 }
423 
424 // File: contracts\lib\ApprovalAndCallFallBack.sol
425 
426 contract ApprovalAndCallFallBack {
427   function receiveApproval(address _owner, uint256 _amount, address _token, bytes _data) public returns (bool);
428 }
429 
430 // File: contracts\token\MuzikaCoin.sol
431 
432 contract MuzikaCoin is MintableToken, Pausable {
433   string public name = 'Muzika';
434   string public symbol = 'MZK';
435   uint8 public decimals = 18;
436 
437   event Burn(address indexed burner, uint256 value);
438 
439   constructor(uint256 initialSupply) public {
440     totalSupply_ = initialSupply;
441     balances[msg.sender] = initialSupply;
442     emit Transfer(address(0), msg.sender, initialSupply);
443   }
444 
445   /**
446    * @dev Burns a specific amount of tokens.
447    * @param _value The amount of token to be burned.
448    */
449   function burn(uint256 _value) public onlyOwner {
450     _burn(msg.sender, _value);
451   }
452 
453   function _burn(address _who, uint256 _value) internal {
454     require(_value <= balances[_who]);
455     // no need to require value <= totalSupply, since that would imply the
456     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
457 
458     balances[_who] = balances[_who].sub(_value);
459     totalSupply_ = totalSupply_.sub(_value);
460     emit Burn(_who, _value);
461     emit Transfer(_who, address(0), _value);
462   }
463 
464   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
465     return super.transfer(_to, _value);
466   }
467 
468   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
469     return super.transferFrom(_from, _to, _value);
470   }
471 
472   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public returns (bool) {
473     require(_spender != address(this));
474 
475     increaseApproval(_spender, _addedValue);
476 
477     require(
478       ApprovalAndCallFallBack(_spender).receiveApproval(
479         msg.sender,
480         allowed[msg.sender][_spender],
481         address(this),
482         _data
483       )
484     );
485 
486     return true;
487   }
488 
489   function tokenDrain(ERC20 _token, uint256 _amount) public onlyOwner {
490     _token.transfer(owner, _amount);
491   }
492 }