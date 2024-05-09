1 /**
2  * Source Code first verified at https://etherscan.io on Monday, July 16, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.21;
6 
7 // ----------------- 
8 //begin Ownable.sol
9 
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18 
19   event OwnershipRenounced(address indexed previousOwner);
20   event OwnershipTransferred(
21     address indexed previousOwner,
22     address indexed newOwner
23   );
24 
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   constructor() public {
31     owner = msg.sender;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   /**
43    * @dev Allows the current owner to relinquish control of the contract.
44    * @notice Renouncing to ownership will leave the contract without an owner.
45    * It will not be possible to call the functions with the `onlyOwner`
46    * modifier anymore.
47    */
48   function renounceOwnership() public onlyOwner {
49     emit OwnershipRenounced(owner);
50     owner = address(0);
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address _newOwner) public onlyOwner {
58     _transferOwnership(_newOwner);
59   }
60 
61   /**
62    * @dev Transfers control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function _transferOwnership(address _newOwner) internal {
66     require(_newOwner != address(0));
67     emit OwnershipTransferred(owner, _newOwner);
68     owner = _newOwner;
69   }
70 }
71 
72 //end Ownable.sol
73 // ----------------- 
74 //begin ERC20Basic.sol
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * See https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 //end ERC20Basic.sol
89 // ----------------- 
90 //begin SafeMath.sol
91 
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that throw on error
95  */
96 library SafeMath {
97 
98   /**
99   * @dev Multiplies two numbers, throws on overflow.
100   */
101   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
102     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
103     // benefit is lost if 'b' is also tested.
104     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
105     if (a == 0) {
106       return 0;
107     }
108 
109     c = a * b;
110     assert(c / a == b);
111     return c;
112   }
113 
114   /**
115   * @dev Integer division of two numbers, truncating the quotient.
116   */
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     // uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return a / b;
122   }
123 
124   /**
125   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126   */
127   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128     assert(b <= a);
129     return a - b;
130   }
131 
132   /**
133   * @dev Adds two numbers, throws on overflow.
134   */
135   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
136     c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }
141 
142 //end SafeMath.sol
143 // ----------------- 
144 //begin Pausable.sol
145 
146 
147 
148 /**
149  * @title Pausable
150  * @dev Base contract which allows children to implement an emergency stop mechanism.
151  */
152 contract Pausable is Ownable {
153   event Pause();
154   event Unpause();
155 
156   bool public paused = false;
157 
158 
159   /**
160    * @dev Modifier to make a function callable only when the contract is not paused.
161    */
162   modifier whenNotPaused() {
163     require(!paused);
164     _;
165   }
166 
167   /**
168    * @dev Modifier to make a function callable only when the contract is paused.
169    */
170   modifier whenPaused() {
171     require(paused);
172     _;
173   }
174 
175   /**
176    * @dev called by the owner to pause, triggers stopped state
177    */
178   function pause() onlyOwner whenNotPaused public {
179     paused = true;
180     emit Pause();
181   }
182 
183   /**
184    * @dev called by the owner to unpause, returns to normal state
185    */
186   function unpause() onlyOwner whenPaused public {
187     paused = false;
188     emit Unpause();
189   }
190 }
191 
192 //end Pausable.sol
193 // ----------------- 
194 //begin BasicToken.sol
195 
196 
197 
198 /**
199  * @title Basic token
200  * @dev Basic version of StandardToken, with no allowances.
201  */
202 contract BasicToken is ERC20Basic {
203   using SafeMath for uint256;
204 
205   mapping(address => uint256) balances;
206 
207   uint256 totalSupply_;
208 
209   /**
210   * @dev Total number of tokens in existence
211   */
212   function totalSupply() public view returns (uint256) {
213     return totalSupply_;
214   }
215 
216   /**
217   * @dev Transfer token for a specified address
218   * @param _to The address to transfer to.
219   * @param _value The amount to be transferred.
220   */
221   function transfer(address _to, uint256 _value) public returns (bool) {
222     require(_to != address(0));
223     require(_value <= balances[msg.sender]);
224 
225     balances[msg.sender] = balances[msg.sender].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     emit Transfer(msg.sender, _to, _value);
228     return true;
229   }
230 
231   /**
232   * @dev Gets the balance of the specified address.
233   * @param _owner The address to query the the balance of.
234   * @return An uint256 representing the amount owned by the passed address.
235   */
236   function balanceOf(address _owner) public view returns (uint256) {
237     return balances[_owner];
238   }
239 
240 }
241 
242 //end BasicToken.sol
243 // ----------------- 
244 //begin ERC20.sol
245 
246 
247 /**
248  * @title ERC20 interface
249  * @dev see https://github.com/ethereum/EIPs/issues/20
250  */
251 contract ERC20 is ERC20Basic {
252   function allowance(address owner, address spender)
253     public view returns (uint256);
254 
255   function transferFrom(address from, address to, uint256 value)
256     public returns (bool);
257 
258   function approve(address spender, uint256 value) public returns (bool);
259   event Approval(
260     address indexed owner,
261     address indexed spender,
262     uint256 value
263   );
264 }
265 
266 //end ERC20.sol
267 // ----------------- 
268 //begin StandardToken.sol
269 
270 
271 /**
272  * @title Standard ERC20 token
273  *
274  * @dev Implementation of the basic standard token.
275  * https://github.com/ethereum/EIPs/issues/20
276  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
277  */
278 contract StandardToken is ERC20, BasicToken {
279 
280   mapping (address => mapping (address => uint256)) internal allowed;
281 
282 
283   /**
284    * @dev Transfer tokens from one address to another
285    * @param _from address The address which you want to send tokens from
286    * @param _to address The address which you want to transfer to
287    * @param _value uint256 the amount of tokens to be transferred
288    */
289   function transferFrom(
290     address _from,
291     address _to,
292     uint256 _value
293   )
294     public
295     returns (bool)
296   {
297     require(_to != address(0));
298     require(_value <= balances[_from]);
299     require(_value <= allowed[_from][msg.sender]);
300 
301     balances[_from] = balances[_from].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
304     emit Transfer(_from, _to, _value);
305     return true;
306   }
307 
308   /**
309    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
310    * Beware that changing an allowance with this method brings the risk that someone may use both the old
311    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
312    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
313    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
314    * @param _spender The address which will spend the funds.
315    * @param _value The amount of tokens to be spent.
316    */
317   function approve(address _spender, uint256 _value) public returns (bool) {
318     allowed[msg.sender][_spender] = _value;
319     emit Approval(msg.sender, _spender, _value);
320     return true;
321   }
322 
323   /**
324    * @dev Function to check the amount of tokens that an owner allowed to a spender.
325    * @param _owner address The address which owns the funds.
326    * @param _spender address The address which will spend the funds.
327    * @return A uint256 specifying the amount of tokens still available for the spender.
328    */
329   function allowance(
330     address _owner,
331     address _spender
332    )
333     public
334     view
335     returns (uint256)
336   {
337     return allowed[_owner][_spender];
338   }
339 
340   /**
341    * @dev Increase the amount of tokens that an owner allowed to a spender.
342    * approve should be called when allowed[_spender] == 0. To increment
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param _spender The address which will spend the funds.
347    * @param _addedValue The amount of tokens to increase the allowance by.
348    */
349   function increaseApproval(
350     address _spender,
351     uint256 _addedValue
352   )
353     public
354     returns (bool)
355   {
356     allowed[msg.sender][_spender] = (
357       allowed[msg.sender][_spender].add(_addedValue));
358     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359     return true;
360   }
361 
362   /**
363    * @dev Decrease the amount of tokens that an owner allowed to a spender.
364    * approve should be called when allowed[_spender] == 0. To decrement
365    * allowed value is better to use this function to avoid 2 calls (and wait until
366    * the first transaction is mined)
367    * From MonolithDAO Token.sol
368    * @param _spender The address which will spend the funds.
369    * @param _subtractedValue The amount of tokens to decrease the allowance by.
370    */
371   function decreaseApproval(
372     address _spender,
373     uint256 _subtractedValue
374   )
375     public
376     returns (bool)
377   {
378     uint256 oldValue = allowed[msg.sender][_spender];
379     if (_subtractedValue > oldValue) {
380       allowed[msg.sender][_spender] = 0;
381     } else {
382       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
383     }
384     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
385     return true;
386   }
387 
388 }
389 
390 //end StandardToken.sol
391 // ----------------- 
392 //begin MintableToken.sol
393 
394 
395 /**
396  * @title Mintable token
397  * @dev Simple ERC20 Token example, with mintable token creation
398  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
399  */
400 contract MintableToken is StandardToken, Ownable {
401   event Mint(address indexed to, uint256 amount);
402   event MintFinished();
403 
404   bool public mintingFinished = false;
405 
406 
407   modifier canMint() {
408     require(!mintingFinished);
409     _;
410   }
411 
412   modifier hasMintPermission() {
413     require(msg.sender == owner);
414     _;
415   }
416 
417   /**
418    * @dev Function to mint tokens
419    * @param _to The address that will receive the minted tokens.
420    * @param _amount The amount of tokens to mint.
421    * @return A boolean that indicates if the operation was successful.
422    */
423   function mint(
424     address _to,
425     uint256 _amount
426   )
427     hasMintPermission
428     canMint
429     public
430     returns (bool)
431   {
432     totalSupply_ = totalSupply_.add(_amount);
433     balances[_to] = balances[_to].add(_amount);
434     emit Mint(_to, _amount);
435     emit Transfer(address(0), _to, _amount);
436     return true;
437   }
438 
439   /**
440    * @dev Function to stop minting new tokens.
441    * @return True if the operation was successful.
442    */
443   function finishMinting() onlyOwner canMint public returns (bool) {
444     mintingFinished = true;
445     emit MintFinished();
446     return true;
447   }
448 }
449 
450 //end MintableToken.sol
451 // ----------------- 
452 //begin PausableToken.sol
453 
454 
455 /**
456  * @title Pausable token
457  * @dev StandardToken modified with pausable transfers.
458  **/
459 contract PausableToken is StandardToken, Pausable {
460 
461   function transfer(
462     address _to,
463     uint256 _value
464   )
465     public
466     whenNotPaused
467     returns (bool)
468   {
469     return super.transfer(_to, _value);
470   }
471 
472   function transferFrom(
473     address _from,
474     address _to,
475     uint256 _value
476   )
477     public
478     whenNotPaused
479     returns (bool)
480   {
481     return super.transferFrom(_from, _to, _value);
482   }
483 
484   function approve(
485     address _spender,
486     uint256 _value
487   )
488     public
489     whenNotPaused
490     returns (bool)
491   {
492     return super.approve(_spender, _value);
493   }
494 
495   function increaseApproval(
496     address _spender,
497     uint _addedValue
498   )
499     public
500     whenNotPaused
501     returns (bool success)
502   {
503     return super.increaseApproval(_spender, _addedValue);
504   }
505 
506   function decreaseApproval(
507     address _spender,
508     uint _subtractedValue
509   )
510     public
511     whenNotPaused
512     returns (bool success)
513   {
514     return super.decreaseApproval(_spender, _subtractedValue);
515   }
516 }
517 
518 //end PausableToken.sol
519 // ----------------- 
520 //begin ShFundToken.sol
521 
522 
523 contract ShFundToken is MintableToken, PausableToken {
524     string public name = "SHFUND";
525     string public symbol = "SHFUND";
526     uint256 public decimals = 18;
527 }
528 
529 //end ShFundToken.sol