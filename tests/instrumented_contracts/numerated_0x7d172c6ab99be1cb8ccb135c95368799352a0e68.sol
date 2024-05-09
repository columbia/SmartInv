1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Contract that will work with ERC223 tokens.
5  */
6 
7 contract ERC223ReceivingContract { 
8     /**
9      * @dev Standard ERC223 function that will handle incoming token transfers.
10      *
11      * @param _from  Token sender address.
12      * @param _value Amount of tokens.
13      * @param _data  Transaction metadata.
14      */
15     function tokenFallback(address _from, uint _value, bytes _data) public;
16 }
17 /**
18  * @title ERC20Basic
19  * @dev Simpler version of ERC20 interface
20  * See https://github.com/ethereum/EIPs/issues/179
21  */
22 contract ERC20Basic {
23   function totalSupply() public view returns (uint256);
24   function balanceOf(address who) public view returns (uint256);
25   function transfer(address to, uint256 value) public returns (bool);
26   event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35 
36   /**
37   * @dev Multiplies two numbers, throws on overflow.
38   */
39   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
41     // benefit is lost if 'b' is also tested.
42     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43     if (a == 0) {
44       return 0;
45     }
46 
47     c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     // uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return a / b;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   uint256 totalSupply_;
91 
92   /**
93   * @dev Total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev Transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender)
132     public view returns (uint256);
133 
134   function transferFrom(address from, address to, uint256 value)
135     public returns (bool);
136 
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(
139     address indexed owner,
140     address indexed spender,
141     uint256 value
142   );
143 }
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * https://github.com/ethereum/EIPs/issues/20
150  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(
164     address _from,
165     address _to,
166     uint256 _value
167   )
168     public
169     returns (bool)
170   {
171     require(_to != address(0));
172     require(_value <= balances[_from]);
173     require(_value <= allowed[_from][msg.sender]);
174 
175     balances[_from] = balances[_from].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
178     emit Transfer(_from, _to, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184    * Beware that changing an allowance with this method brings the risk that someone may use both the old
185    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188    * @param _spender The address which will spend the funds.
189    * @param _value The amount of tokens to be spent.
190    */
191   function approve(address _spender, uint256 _value) public returns (bool) {
192     allowed[msg.sender][_spender] = _value;
193     emit Approval(msg.sender, _spender, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifying the amount of tokens still available for the spender.
202    */
203   function allowance(
204     address _owner,
205     address _spender
206    )
207     public
208     view
209     returns (uint256)
210   {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * @dev Increase the amount of tokens that an owner allowed to a spender.
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(
224     address _spender,
225     uint256 _addedValue
226   )
227     public
228     returns (bool)
229   {
230     allowed[msg.sender][_spender] = (
231       allowed[msg.sender][_spender].add(_addedValue));
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    * approve should be called when allowed[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(
246     address _spender,
247     uint256 _subtractedValue
248   )
249     public
250     returns (bool)
251   {
252     uint256 oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 
265 /**
266  * @title Ownable
267  * @dev The Ownable contract has an owner address, and provides basic authorization control
268  * functions, this simplifies the implementation of "user permissions".
269  */
270 contract Ownable {
271   address public owner;
272 
273 
274   event OwnershipRenounced(address indexed previousOwner);
275   event OwnershipTransferred(
276     address indexed previousOwner,
277     address indexed newOwner
278   );
279 
280 
281   /**
282    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
283    * account.
284    */
285   constructor() public {
286     owner = msg.sender;
287   }
288 
289   /**
290    * @dev Throws if called by any account other than the owner.
291    */
292   modifier onlyOwner() {
293     require(msg.sender == owner);
294     _;
295   }
296 
297   /**
298    * @dev Allows the current owner to relinquish control of the contract.
299    * @notice Renouncing to ownership will leave the contract without an owner.
300    * It will not be possible to call the functions with the `onlyOwner`
301    * modifier anymore.
302    */
303   function renounceOwnership() public onlyOwner {
304     emit OwnershipRenounced(owner);
305     owner = address(0);
306   }
307 
308   /**
309    * @dev Allows the current owner to transfer control of the contract to a newOwner.
310    * @param _newOwner The address to transfer ownership to.
311    */
312   function transferOwnership(address _newOwner) public onlyOwner {
313     _transferOwnership(_newOwner);
314   }
315 
316   /**
317    * @dev Transfers control of the contract to a newOwner.
318    * @param _newOwner The address to transfer ownership to.
319    */
320   function _transferOwnership(address _newOwner) internal {
321     require(_newOwner != address(0));
322     emit OwnershipTransferred(owner, _newOwner);
323     owner = _newOwner;
324   }
325 }
326 
327 
328 /**
329  * @title Pausable
330  * @dev Base contract which allows children to implement an emergency stop mechanism.
331  */
332 contract Pausable is Ownable {
333   event Pause();
334   event Unpause();
335 
336   bool public paused = false;
337 
338 
339   /**
340    * @dev Modifier to make a function callable only when the contract is not paused.
341    */
342   modifier whenNotPaused() {
343     require(!paused);
344     _;
345   }
346 
347   /**
348    * @dev Modifier to make a function callable only when the contract is paused.
349    */
350   modifier whenPaused() {
351     require(paused);
352     _;
353   }
354 
355   /**
356    * @dev called by the owner to pause, triggers stopped state
357    */
358   function pause() onlyOwner whenNotPaused public {
359     paused = true;
360     emit Pause();
361   }
362 
363   /**
364    * @dev called by the owner to unpause, returns to normal state
365    */
366   function unpause() onlyOwner whenPaused public {
367     paused = false;
368     emit Unpause();
369   }
370 }
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
435 contract Trader {
436     function buy(address _from, uint256 _tokenId, uint256 _count) public;
437 }
438 
439 // 不支持自定义参数，只允许用指定的trader进行购买操作
440 contract Cake is PausableToken {
441 
442     string public name;
443     string public symbol;
444     uint8 public decimals = 18;
445 
446     mapping(address => bool) public traders;
447 
448     constructor() public {
449         name = "Card Alchemists' Knowldege Energy (CardMaker Cash)";
450         symbol = "CAKE";
451 
452         uint256 _totalSupply = 100000000000; // 一千亿
453         totalSupply_ = _totalSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
454         balances[msg.sender] = totalSupply_;                // Give the creator all tokens
455 
456         tokenURI_ = "http://cardmaker.io/cake/tokenURI";
457     }
458 
459     function addTrader(address _trader) public onlyOwner {
460         traders[_trader] = true;
461     }
462     function removeTrader(address _trader) public onlyOwner {
463         delete traders[_trader];
464     }
465 
466     /**
467      * @dev Transfer the specified amount of tokens to the specified address.
468      *      This function doesn't contain `_data` param.
469      *      due to backwards compatibility reasons.
470      *
471      * @param _to    Receiver address.
472      * @param _value Amount of tokens that will be transferred.
473      */
474     function transfer(address _to, uint _value) public returns (bool) {
475         uint codeLength;
476         bytes memory empty;
477 
478         // solium-disable-next-line security/no-inline-assembly
479         assembly {
480         // Retrieve the size of the code on target address, this needs assembly .
481             codeLength := extcodesize(_to)
482         }
483 
484         super.transfer(_to, _value);
485 
486         if(codeLength>0) {
487             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
488             receiver.tokenFallback(msg.sender, _value, empty);
489         }
490 
491         return true;
492     }
493 
494     function transferAndBuy(address _trader, uint256 _value, uint256 _tokenId, uint256 _count) public {
495         require(traders[_trader], "");
496         transfer(_trader, _value);
497         Trader(_trader).buy(msg.sender, _tokenId, _count);
498     }
499 
500     function transferFrom(
501         address _from,
502         address _to,
503         uint256 _value
504     )
505     public
506     returns (bool)
507     {
508         uint codeLength;
509         bytes memory empty;
510 
511         // solium-disable-next-line security/no-inline-assembly
512         assembly {
513         // Retrieve the size of the code on target address, this needs assembly .
514             codeLength := extcodesize(_to)
515         }
516 
517         super.transferFrom(_from, _to, _value);
518 
519         if(codeLength>0) {
520             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
521             receiver.tokenFallback(_from, _value, empty);
522         }
523 
524         return true;
525     }
526 
527     // EIP1046/1047
528     string private tokenURI_ = "";
529     function tokenURI() external view returns (string) {
530         return tokenURI_;
531     }
532 }