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
221 // File: contracts/token/ERC223/ERC223Interface.sol
222 
223 /**
224  * Released under the MIT license.
225  * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE
226 */
227 
228 contract ERC223Interface {
229     function totalSupply() external view returns (uint256);
230     function balanceOf(address who) external view returns (uint256);
231     function transfer(address to, uint256 value) external returns (bool);
232     function transfer(address to, uint256 value, bytes data) external returns (bool);
233     event Transfer(address indexed from, address indexed to, uint256 value);
234 }
235 
236 // File: contracts/token/ERC223/ERC223ReceivingContract.sol
237 
238 /**
239  * Released under the MIT license.
240  * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE
241 */
242 
243 
244 /**
245  * @title Contract that will work with ERC223 tokens.
246  */
247  
248 contract ERC223ReceivingContract { 
249 /**
250  * @dev Standard ERC223 function that will handle incoming token transfers.
251  *
252  * @param _from  Token sender address.
253  * @param _value Amount of tokens.
254  * @param _data  Transaction metadata.
255  */
256     function tokenFallback(address _from, uint _value, bytes _data) public;
257 }
258 
259 // File: contracts/ownership/Ownable.sol
260 
261 /**
262  * Copyright (c) 2016 Smart Contract Solutions, Inc.
263  * Released under the MIT license.
264  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
265 */
266 
267 /**
268  * @title Ownable
269  * @dev The Ownable contract has an owner address, and provides basic authorization control
270  * functions, this simplifies the implementation of "user permissions".
271  */
272 contract Ownable {
273   address public owner;
274 
275 
276   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278 
279   /**
280    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
281    * account.
282    */
283   constructor() public {
284     owner = msg.sender;
285   }
286 
287   /**
288    * @dev Throws if called by any account other than the owner.
289    */
290   modifier onlyOwner() {
291     require(msg.sender == owner);
292     _;
293   }
294 
295   /**
296    * @dev Allows the current owner to transfer control of the contract to a newOwner.
297    * @param newOwner The address to transfer ownership to.
298    */
299   function transferOwnership(address newOwner) public onlyOwner {
300     require(newOwner != address(0));
301     emit OwnershipTransferred(owner, newOwner);
302     owner = newOwner;
303   }
304 
305 }
306 
307 // File: contracts/token/ERC223/ERC223Standard.sol
308 
309 /**
310  * Released under the MIT license.
311  * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE
312 */
313 
314 
315 
316 
317 
318 /**
319  * @title Reference implementation of the ERC223 standard token.
320  */
321 contract ERC223Standard is ERC223Interface, ERC20Standard {
322     using SafeMath for uint256;
323 
324     /**
325      * @dev Transfer the specified amount of tokens to the specified address.
326      *      Invokes the `tokenFallback` function if the recipient is a contract.
327      *      The token transfer fails if the recipient is a contract
328      *      but does not implement the `tokenFallback` function
329      *      or the fallback function to receive funds.
330      *
331      * @param _to    Receiver address.
332      * @param _value Amount of tokens that will be transferred.
333      * @param _data  Transaction metadata.
334      */
335     function transfer(address _to, uint256 _value, bytes _data) external returns(bool){
336         // Standard function transfer similar to ERC20 transfer with no _data .
337         // Added due to backwards compatibility reasons .
338         uint256 codeLength;
339 
340         assembly {
341             // Retrieve the size of the code on target address, this needs assembly .
342             codeLength := extcodesize(_to)
343         }
344 
345         balances[msg.sender] = balances[msg.sender].sub(_value);
346         balances[_to] = balances[_to].add(_value);
347         if(codeLength>0) {
348             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
349             receiver.tokenFallback(msg.sender, _value, _data);
350         }
351         emit Transfer(msg.sender, _to, _value);
352     }
353     
354     /**
355      * @dev Transfer the specified amount of tokens to the specified address.
356      *      This function works the same with the previous one
357      *      but doesn't contain `_data` param.
358      *      Added due to backwards compatibility reasons.
359      *
360      * @param _to    Receiver address.
361      * @param _value Amount of tokens that will be transferred.
362      */
363     function transfer(address _to, uint256 _value) external returns(bool){
364         uint256 codeLength;
365         bytes memory empty;
366 
367         assembly {
368             // Retrieve the size of the code on target address, this needs assembly .
369             codeLength := extcodesize(_to)
370         }
371 
372         balances[msg.sender] = balances[msg.sender].sub(_value);
373         balances[_to] = balances[_to].add(_value);
374         if(codeLength>0) {
375             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
376             receiver.tokenFallback(msg.sender, _value, empty);
377         }
378         emit Transfer(msg.sender, _to, _value);
379         return true;
380     }
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
395 
396 /**
397  * @title Mintable token
398  * @dev Simple ERC20 Token example, with mintable token creation
399  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
400  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
401  */
402 contract MintableToken is ERC223Standard, Ownable {
403   event Mint(address indexed to, uint256 amount);
404   event MintFinished();
405 
406   bool public mintingFinished = false;
407 
408   modifier canMint() {
409     require(!mintingFinished);
410     _;
411   }
412 
413   /**
414    * @dev Function to mint tokens
415    * @param _to The address that will receive the minted tokens.
416    * @param _amount The amount of tokens to mint.
417    * @return A boolean that indicates if the operation was successful.
418    */
419   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
420     totalSupply_ = totalSupply_.add(_amount);
421     balances[_to] = balances[_to].add(_amount);
422     emit Mint(_to, _amount);
423     emit Transfer(address(0), _to, _amount);
424     return true;
425   }
426 
427   /**
428    * @dev Function to stop minting new tokens.
429    * @return True if the operation was successful.
430    */
431   function finishMinting() onlyOwner canMint public returns (bool) {
432     mintingFinished = true;
433     emit MintFinished();
434     return true;
435   }
436 }
437 
438 // File: contracts/DAICOVO/DaicovoStandardToken.sol
439 
440 /**
441  * @title DAICOVO standard ERC20, ERC223 compliant token
442  * @dev Inherited ERC20 and ERC223 token functionalities.
443  * @dev Extended with forceTransfer() function to support compatibility
444  * @dev with exisiting apps which expects ERC20 token's transfer function berhavior.
445  */
446 contract DaicovoStandardToken is ERC20Standard, ERC223Standard, MintableToken {
447     string public name;
448     string public symbol;
449     uint8 public decimals;
450 
451     constructor(string _name, string _symbol, uint8 _decimals) public {
452         name = _name;
453         symbol = _symbol;
454         decimals = _decimals;
455     }
456 
457     /**
458      * @dev It provides an ERC20 compatible transfer function without checking of
459      * @dev target address whether it's contract or EOA address.
460      * @param _to    Receiver address.
461      * @param _value Amount of tokens that will be transferred.
462      */
463     function forceTransfer(address _to, uint _value) external returns(bool) {
464         require(_to != address(0x0));
465         require(_value <= balances[msg.sender]);
466 
467         balances[msg.sender] = balances[msg.sender].sub(_value);
468         balances[_to] = balances[_to].add(_value);
469         emit Transfer(msg.sender, _to, _value);
470         return true;
471     }
472 }
473 
474 // File: contracts/DAICOVO/OVOToken.sol
475 
476 /**
477  * @title OVO Token
478  * @dev ERC20, ERC223 compliant mintable token.
479  */
480 contract OVOToken is DaicovoStandardToken {
481     constructor () public DaicovoStandardToken("TTEST", "TST", 9) {
482     }
483 }