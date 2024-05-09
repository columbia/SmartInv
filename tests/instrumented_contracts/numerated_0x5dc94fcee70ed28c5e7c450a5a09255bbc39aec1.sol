1 pragma solidity ^0.4.24;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 /**
6  * Copyright (c) 2016 Smart Contract Solutions, Inc.
7  * Released under the MIT license.
8  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
9 */
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, throws on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     // uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return a / b;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 // File: contracts/token/ERC20/ERC20Interface.sol
58 
59 /**
60  * Copyright (c) 2016 Smart Contract Solutions, Inc.
61  * Released under the MIT license.
62  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
63 */
64 
65 /**
66  * @title 
67  * @dev 
68  */
69 contract ERC20Interface {
70   function totalSupply() external view returns (uint256);
71   function balanceOf(address who) external view returns (uint256);
72   function transfer(address to, uint256 value) external returns (bool);
73   function allowance(address owner, address spender) external view returns (uint256);
74   function transferFrom(address from, address to, uint256 value) external returns (bool);
75   function approve(address spender, uint256 value) external returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/token/ERC20/ERC20Standard.sol
81 
82 /**
83  * Copyright (c) 2016 Smart Contract Solutions, Inc.
84  * Released under the MIT license.
85  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
86 */
87 
88 
89 
90 /**
91  * @title 
92  * @dev 
93  */
94 contract ERC20Standard is ERC20Interface {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98   mapping (address => mapping (address => uint256)) internal allowed;
99 
100   uint256 totalSupply_;
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) external returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[msg.sender]);
110 
111     // SafeMath.sub will throw if there is not enough balance.
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     emit Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Transfer tokens from one address to another
120    * @param _from address The address which you want to send tokens from
121    * @param _to address The address which you want to transfer to
122    * @param _value uint256 the amount of tokens to be transferred
123    */
124   function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[_from]);
127     require(_value <= allowed[_from][msg.sender]);
128 
129     balances[_from] = balances[_from].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132     emit Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    *
139    * Beware that changing an allowance with this method brings the risk that someone may use both the old
140    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143    * 
144    * To avoid this issue, allowances are only allowed to be changed between zero and non-zero.
145    *
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149   function approve(address _spender, uint256 _value) external returns (bool) {
150     require(allowed[msg.sender][_spender] == 0 || _value == 0);
151     allowed[msg.sender][_spender] = _value;
152     emit Approval(msg.sender, _spender, _value);
153     return true;
154   }
155 
156   /**
157   * @dev total number of tokens in existence
158   */
159   function totalSupply() external view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) external view returns (uint256 balance) {
169     return balances[_owner];
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) external view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) external returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 // File: contracts/token/ERC223/ERC223ReceivingContract.sol
222 
223 /**
224  * Released under the MIT license.
225  * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE
226 */
227 
228 
229 /**
230  * @title Contract that will work with ERC223 tokens.
231  */
232  
233 contract ERC223ReceivingContract { 
234 /**
235  * @dev Standard ERC223 function that will handle incoming token transfers.
236  *
237  * @param _from  Token sender address.
238  * @param _value Amount of tokens.
239  * @param _data  Transaction metadata.
240  */
241     function tokenFallback(address _from, uint _value, bytes _data) public;
242 }
243 
244 // File: contracts/token/ERC223/ERC223Interface.sol
245 
246 /**
247  * Released under the MIT license.
248  * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE
249 */
250 
251 contract ERC223Interface {
252     function totalSupply() external view returns (uint256);
253     function balanceOf(address who) external view returns (uint256);
254     function transfer(address to, uint256 value) external returns (bool);
255     function transfer(address to, uint256 value, bytes data) external returns (bool);
256     event Transfer(address indexed from, address indexed to, uint256 value);
257 }
258 
259 // File: contracts/token/ERC223/ERC223Standard.sol
260 
261 /**
262  * Released under the MIT license.
263  * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE
264 */
265 
266 
267 
268 
269 
270 /**
271  * @title Reference implementation of the ERC223 standard token.
272  */
273 contract ERC223Standard is ERC223Interface, ERC20Standard {
274     using SafeMath for uint256;
275 
276     /**
277      * @dev Transfer the specified amount of tokens to the specified address.
278      *      Invokes the `tokenFallback` function if the recipient is a contract.
279      *      The token transfer fails if the recipient is a contract
280      *      but does not implement the `tokenFallback` function
281      *      or the fallback function to receive funds.
282      *
283      * @param _to    Receiver address.
284      * @param _value Amount of tokens that will be transferred.
285      * @param _data  Transaction metadata.
286      */
287     function transfer(address _to, uint256 _value, bytes _data) external returns(bool){
288         // Standard function transfer similar to ERC20 transfer with no _data .
289         // Added due to backwards compatibility reasons .
290         uint256 codeLength;
291 
292         assembly {
293             // Retrieve the size of the code on target address, this needs assembly .
294             codeLength := extcodesize(_to)
295         }
296 
297         balances[msg.sender] = balances[msg.sender].sub(_value);
298         balances[_to] = balances[_to].add(_value);
299         if(codeLength>0) {
300             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
301             receiver.tokenFallback(msg.sender, _value, _data);
302         }
303         emit Transfer(msg.sender, _to, _value);
304     }
305     
306     /**
307      * @dev Transfer the specified amount of tokens to the specified address.
308      *      This function works the same with the previous one
309      *      but doesn't contain `_data` param.
310      *      Added due to backwards compatibility reasons.
311      *
312      * @param _to    Receiver address.
313      * @param _value Amount of tokens that will be transferred.
314      */
315     function transfer(address _to, uint256 _value) external returns(bool){
316         uint256 codeLength;
317         bytes memory empty;
318 
319         assembly {
320             // Retrieve the size of the code on target address, this needs assembly .
321             codeLength := extcodesize(_to)
322         }
323 
324         balances[msg.sender] = balances[msg.sender].sub(_value);
325         balances[_to] = balances[_to].add(_value);
326         if(codeLength>0) {
327             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
328             receiver.tokenFallback(msg.sender, _value, empty);
329         }
330         emit Transfer(msg.sender, _to, _value);
331         return true;
332     }
333  
334 }
335 
336 // File: contracts/ownership/Ownable.sol
337 
338 /**
339  * Copyright (c) 2016 Smart Contract Solutions, Inc.
340  * Released under the MIT license.
341  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
342 */
343 
344 /**
345  * @title Ownable
346  * @dev The Ownable contract has an owner address, and provides basic authorization control
347  * functions, this simplifies the implementation of "user permissions".
348  */
349 contract Ownable {
350   address public owner;
351 
352 
353   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
354 
355 
356   /**
357    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
358    * account.
359    */
360   constructor() public {
361     owner = msg.sender;
362   }
363 
364   /**
365    * @dev Throws if called by any account other than the owner.
366    */
367   modifier onlyOwner() {
368     require(msg.sender == owner);
369     _;
370   }
371 
372   /**
373    * @dev Allows the current owner to transfer control of the contract to a newOwner.
374    * @param newOwner The address to transfer ownership to.
375    */
376   function transferOwnership(address newOwner) public onlyOwner {
377     require(newOwner != address(0));
378     emit OwnershipTransferred(owner, newOwner);
379     owner = newOwner;
380   }
381 
382 }
383 
384 // File: contracts/token/extentions/MintableToken.sol
385 
386 /**
387  * Copyright (c) 2016 Smart Contract Solutions, Inc.
388  * Released under the MIT license.
389  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
390 */
391 
392 
393 
394 
395 /**
396  * @title Mintable token
397  * @dev Simple ERC20 Token example, with mintable token creation
398  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
399  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
400  */
401 contract MintableToken is ERC223Standard, Ownable {
402   event Mint(address indexed to, uint256 amount);
403   event MintFinished();
404 
405   bool public mintingFinished = false;
406 
407   modifier canMint() {
408     require(!mintingFinished);
409     _;
410   }
411 
412   /**
413    * @dev Function to mint tokens
414    * @param _to The address that will receive the minted tokens.
415    * @param _amount The amount of tokens to mint.
416    * @return A boolean that indicates if the operation was successful.
417    */
418   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
419     totalSupply_ = totalSupply_.add(_amount);
420     balances[_to] = balances[_to].add(_amount);
421     emit Mint(_to, _amount);
422     emit Transfer(address(0), _to, _amount);
423     return true;
424   }
425 
426   /**
427    * @dev Function to stop minting new tokens.
428    * @return True if the operation was successful.
429    */
430   function finishMinting() onlyOwner canMint public returns (bool) {
431     mintingFinished = true;
432     emit MintFinished();
433     return true;
434   }
435 }
436 
437 // File: contracts/DAICOVO/DaicovoStandardToken.sol
438 
439 /**
440  * @title DAICOVO standard ERC20, ERC223 compliant token
441  * @dev Inherited ERC20 and ERC223 token functionalities.
442  * @dev Extended with forceTransfer() function to support compatibility
443  * @dev with exisiting apps which expects ERC20 token's transfer function berhavior.
444  */
445 contract DaicovoStandardToken is ERC20Standard, ERC223Standard, MintableToken {
446     string public name;
447     string public symbol;
448     uint8 public decimals;
449 
450     constructor(string _name, string _symbol, uint8 _decimals) public {
451         name = _name;
452         symbol = _symbol;
453         decimals = _decimals;
454     }
455 
456     /**
457      * @dev It provides an ERC20 compatible transfer function without checking of
458      * @dev target address whether it's contract or EOA address.
459      * @param _to    Receiver address.
460      * @param _value Amount of tokens that will be transferred.
461      */
462     function forceTransfer(address _to, uint _value) external returns(bool) {
463         require(_to != address(0x0));
464         require(_value <= balances[msg.sender]);
465 
466         balances[msg.sender] = balances[msg.sender].sub(_value);
467         balances[_to] = balances[_to].add(_value);
468         emit Transfer(msg.sender, _to, _value);
469         return true;
470     }
471 }
472 
473 // File: contracts/token/extentions/BurnableToken.sol
474 
475 /**
476  * Copyright (c) 2016 Smart Contract Solutions, Inc.
477  * Released under the MIT license.
478  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
479 */
480 
481 
482 
483 /**
484  * @title Burnable Token
485  * @dev Token that can be irreversibly burned (destroyed).
486  */
487 contract BurnableToken is ERC223Standard {
488 
489   event Burn(address indexed burner, uint256 value);
490 
491   /**
492    * @dev Burns a specific amount of tokens.
493    * @param _value The amount of token to be burned.
494    */
495   function burn(uint256 _value) public {
496     _burn(msg.sender, _value);
497   }
498 
499   function _burn(address _who, uint256 _value) internal {
500     require(_value <= balances[_who]);
501     // no need to require value <= totalSupply, since that would imply the
502     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
503 
504     balances[_who] = balances[_who].sub(_value);
505     totalSupply_ = totalSupply_.sub(_value);
506     emit Burn(_who, _value);
507     emit Transfer(_who, address(0), _value);
508   }
509 }
510 
511 /**
512  * @title Capped token
513  * @dev Mintable token with a token cap.
514  */
515 contract CappedToken is MintableToken {
516 
517   uint256 public cap;
518 
519   constructor(uint256 _cap) public {
520     require(_cap > 0);
521     cap = _cap;
522   }
523 
524   /**
525    * @dev Function to mint tokens
526    * @param _to The address that will receive the minted tokens.
527    * @param _amount The amount of tokens to mint.
528    * @return A boolean that indicates if the operation was successful.
529    */
530   function mint(address _to, uint256 _amount) public returns (bool) {
531     require(totalSupply_.add(_amount) <= cap);
532     return super.mint(_to, _amount);
533   }
534 
535 }
536 
537 /**
538  * @title HWG Revolution Token
539  * @dev ERC20, ERC223 compliant mintable, burnable token.
540  */
541 contract HWGR is DaicovoStandardToken, BurnableToken, CappedToken {
542     constructor () public DaicovoStandardToken("HWG Revolution", "REV", 8) CappedToken(10000000000000000) {
543     }
544 }