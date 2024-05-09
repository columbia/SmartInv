1 pragma solidity ^0.4.21;
2 
3 // ----------------- 
4 //begin Ownable.sol
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 //end Ownable.sol
69 // ----------------- 
70 //begin ERC20Basic.sol
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * See https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   function totalSupply() public view returns (uint256);
79   function balanceOf(address who) public view returns (uint256);
80   function transfer(address to, uint256 value) public returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 //end ERC20Basic.sol
85 // ----------------- 
86 //begin SafeMath.sol
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
99     // benefit is lost if 'b' is also tested.
100     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
101     if (a == 0) {
102       return 0;
103     }
104 
105     c = a * b;
106     assert(c / a == b);
107     return c;
108   }
109 
110   /**
111   * @dev Integer division of two numbers, truncating the quotient.
112   */
113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
114     // assert(b > 0); // Solidity automatically throws when dividing by 0
115     // uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117     return a / b;
118   }
119 
120   /**
121   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
122   */
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     assert(b <= a);
125     return a - b;
126   }
127 
128   /**
129   * @dev Adds two numbers, throws on overflow.
130   */
131   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
132     c = a + b;
133     assert(c >= a);
134     return c;
135   }
136 }
137 
138 //end SafeMath.sol
139 // ----------------- 
140 //begin Pausable.sol
141 
142 
143 
144 /**
145  * @title Pausable
146  * @dev Base contract which allows children to implement an emergency stop mechanism.
147  */
148 contract Pausable is Ownable {
149   event Pause();
150   event Unpause();
151 
152   bool public paused = false;
153 
154 
155   /**
156    * @dev Modifier to make a function callable only when the contract is not paused.
157    */
158   modifier whenNotPaused() {
159     require(!paused);
160     _;
161   }
162 
163   /**
164    * @dev Modifier to make a function callable only when the contract is paused.
165    */
166   modifier whenPaused() {
167     require(paused);
168     _;
169   }
170 
171   /**
172    * @dev called by the owner to pause, triggers stopped state
173    */
174   function pause() onlyOwner whenNotPaused public {
175     paused = true;
176     emit Pause();
177   }
178 
179   /**
180    * @dev called by the owner to unpause, returns to normal state
181    */
182   function unpause() onlyOwner whenPaused public {
183     paused = false;
184     emit Unpause();
185   }
186 }
187 
188 //end Pausable.sol
189 // ----------------- 
190 //begin BasicToken.sol
191 
192 
193 
194 /**
195  * @title Basic token
196  * @dev Basic version of StandardToken, with no allowances.
197  */
198 contract BasicToken is ERC20Basic {
199   using SafeMath for uint256;
200 
201   mapping(address => uint256) balances;
202 
203   uint256 totalSupply_;
204 
205   /**
206   * @dev Total number of tokens in existence
207   */
208   function totalSupply() public view returns (uint256) {
209     return totalSupply_;
210   }
211 
212   /**
213   * @dev Transfer token for a specified address
214   * @param _to The address to transfer to.
215   * @param _value The amount to be transferred.
216   */
217   function transfer(address _to, uint256 _value) public returns (bool) {
218     require(_to != address(0));
219     require(_value <= balances[msg.sender]);
220 
221     balances[msg.sender] = balances[msg.sender].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     emit Transfer(msg.sender, _to, _value);
224     return true;
225   }
226 
227   /**
228   * @dev Gets the balance of the specified address.
229   * @param _owner The address to query the the balance of.
230   * @return An uint256 representing the amount owned by the passed address.
231   */
232   function balanceOf(address _owner) public view returns (uint256) {
233     return balances[_owner];
234   }
235 
236 }
237 
238 //end BasicToken.sol
239 // ----------------- 
240 //begin ERC20.sol
241 
242 
243 /**
244  * @title ERC20 interface
245  * @dev see https://github.com/ethereum/EIPs/issues/20
246  */
247 contract ERC20 is ERC20Basic {
248   function allowance(address owner, address spender)
249     public view returns (uint256);
250 
251   function transferFrom(address from, address to, uint256 value)
252     public returns (bool);
253 
254   function approve(address spender, uint256 value) public returns (bool);
255   event Approval(
256     address indexed owner,
257     address indexed spender,
258     uint256 value
259   );
260 }
261 
262 //end ERC20.sol
263 // ----------------- 
264 //begin StandardToken.sol
265 
266 
267 /**
268  * @title Standard ERC20 token
269  *
270  * @dev Implementation of the basic standard token.
271  * https://github.com/ethereum/EIPs/issues/20
272  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
273  */
274 contract StandardToken is ERC20, BasicToken {
275 
276   mapping (address => mapping (address => uint256)) internal allowed;
277 
278 
279   /**
280    * @dev Transfer tokens from one address to another
281    * @param _from address The address which you want to send tokens from
282    * @param _to address The address which you want to transfer to
283    * @param _value uint256 the amount of tokens to be transferred
284    */
285   function transferFrom(
286     address _from,
287     address _to,
288     uint256 _value
289   )
290     public
291     returns (bool)
292   {
293     require(_to != address(0));
294     require(_value <= balances[_from]);
295     require(_value <= allowed[_from][msg.sender]);
296 
297     balances[_from] = balances[_from].sub(_value);
298     balances[_to] = balances[_to].add(_value);
299     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
300     emit Transfer(_from, _to, _value);
301     return true;
302   }
303 
304   /**
305    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
306    * Beware that changing an allowance with this method brings the risk that someone may use both the old
307    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
308    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
309    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310    * @param _spender The address which will spend the funds.
311    * @param _value The amount of tokens to be spent.
312    */
313   function approve(address _spender, uint256 _value) public returns (bool) {
314     allowed[msg.sender][_spender] = _value;
315     emit Approval(msg.sender, _spender, _value);
316     return true;
317   }
318 
319   /**
320    * @dev Function to check the amount of tokens that an owner allowed to a spender.
321    * @param _owner address The address which owns the funds.
322    * @param _spender address The address which will spend the funds.
323    * @return A uint256 specifying the amount of tokens still available for the spender.
324    */
325   function allowance(
326     address _owner,
327     address _spender
328    )
329     public
330     view
331     returns (uint256)
332   {
333     return allowed[_owner][_spender];
334   }
335 
336   /**
337    * @dev Increase the amount of tokens that an owner allowed to a spender.
338    * approve should be called when allowed[_spender] == 0. To increment
339    * allowed value is better to use this function to avoid 2 calls (and wait until
340    * the first transaction is mined)
341    * From MonolithDAO Token.sol
342    * @param _spender The address which will spend the funds.
343    * @param _addedValue The amount of tokens to increase the allowance by.
344    */
345   function increaseApproval(
346     address _spender,
347     uint256 _addedValue
348   )
349     public
350     returns (bool)
351   {
352     allowed[msg.sender][_spender] = (
353       allowed[msg.sender][_spender].add(_addedValue));
354     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
355     return true;
356   }
357 
358   /**
359    * @dev Decrease the amount of tokens that an owner allowed to a spender.
360    * approve should be called when allowed[_spender] == 0. To decrement
361    * allowed value is better to use this function to avoid 2 calls (and wait until
362    * the first transaction is mined)
363    * From MonolithDAO Token.sol
364    * @param _spender The address which will spend the funds.
365    * @param _subtractedValue The amount of tokens to decrease the allowance by.
366    */
367   function decreaseApproval(
368     address _spender,
369     uint256 _subtractedValue
370   )
371     public
372     returns (bool)
373   {
374     uint256 oldValue = allowed[msg.sender][_spender];
375     if (_subtractedValue > oldValue) {
376       allowed[msg.sender][_spender] = 0;
377     } else {
378       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
379     }
380     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
381     return true;
382   }
383 
384 }
385 
386 //end StandardToken.sol
387 // ----------------- 
388 //begin MintableToken.sol
389 
390 
391 /**
392  * @title Mintable token
393  * @dev Simple ERC20 Token example, with mintable token creation
394  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
395  */
396 contract MintableToken is StandardToken, Ownable {
397   event Mint(address indexed to, uint256 amount);
398   event MintFinished();
399 
400   bool public mintingFinished = false;
401 
402 
403   modifier canMint() {
404     require(!mintingFinished);
405     _;
406   }
407 
408   modifier hasMintPermission() {
409     require(msg.sender == owner);
410     _;
411   }
412 
413   /**
414    * @dev Function to mint tokens
415    * @param _to The address that will receive the minted tokens.
416    * @param _amount The amount of tokens to mint.
417    * @return A boolean that indicates if the operation was successful.
418    */
419   function mint(
420     address _to,
421     uint256 _amount
422   )
423     hasMintPermission
424     canMint
425     public
426     returns (bool)
427   {
428     totalSupply_ = totalSupply_.add(_amount);
429     balances[_to] = balances[_to].add(_amount);
430     emit Mint(_to, _amount);
431     emit Transfer(address(0), _to, _amount);
432     return true;
433   }
434 
435   /**
436    * @dev Function to stop minting new tokens.
437    * @return True if the operation was successful.
438    */
439   function finishMinting() onlyOwner canMint public returns (bool) {
440     mintingFinished = true;
441     emit MintFinished();
442     return true;
443   }
444 }
445 
446 //end MintableToken.sol
447 // ----------------- 
448 //begin PausableToken.sol
449 
450 
451 /**
452  * @title Pausable token
453  * @dev StandardToken modified with pausable transfers.
454  **/
455 contract PausableToken is StandardToken, Pausable {
456 
457   function transfer(
458     address _to,
459     uint256 _value
460   )
461     public
462     whenNotPaused
463     returns (bool)
464   {
465     return super.transfer(_to, _value);
466   }
467 
468   function transferFrom(
469     address _from,
470     address _to,
471     uint256 _value
472   )
473     public
474     whenNotPaused
475     returns (bool)
476   {
477     return super.transferFrom(_from, _to, _value);
478   }
479 
480   function approve(
481     address _spender,
482     uint256 _value
483   )
484     public
485     whenNotPaused
486     returns (bool)
487   {
488     return super.approve(_spender, _value);
489   }
490 
491   function increaseApproval(
492     address _spender,
493     uint _addedValue
494   )
495     public
496     whenNotPaused
497     returns (bool success)
498   {
499     return super.increaseApproval(_spender, _addedValue);
500   }
501 
502   function decreaseApproval(
503     address _spender,
504     uint _subtractedValue
505   )
506     public
507     whenNotPaused
508     returns (bool success)
509   {
510     return super.decreaseApproval(_spender, _subtractedValue);
511   }
512 }
513 
514 //end PausableToken.sol
515 // ----------------- 
516 //begin OpiriaToken.sol
517 
518 
519 contract OpiriaToken is MintableToken, PausableToken {
520     string public name = "PDATA";
521     string public symbol = "PDATA";
522     uint256 public decimals = 18;
523 }
524 
525 //end OpiriaToken.sol