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
57 // File: contracts/ownership/Ownable.sol
58 
59 /**
60  * Copyright (c) 2016 Smart Contract Solutions, Inc.
61  * Released under the MIT license.
62  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
63 */
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71   address public owner;
72 
73 
74   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81   constructor() public {
82     owner = msg.sender;
83   }
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address newOwner) public onlyOwner {
98     require(newOwner != address(0));
99     emit OwnershipTransferred(owner, newOwner);
100     owner = newOwner;
101   }
102 
103 }
104 
105 // File: contracts/token/ERC20/ERC20Interface.sol
106 
107 /**
108  * Copyright (c) 2016 Smart Contract Solutions, Inc.
109  * Released under the MIT license.
110  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
111 */
112 
113 /**
114  * @title 
115  * @dev 
116  */
117 contract ERC20Interface {
118   function totalSupply() external view returns (uint256);
119   function balanceOf(address who) external view returns (uint256);
120   function transfer(address to, uint256 value) external returns (bool);
121   function allowance(address owner, address spender) external view returns (uint256);
122   function transferFrom(address from, address to, uint256 value) external returns (bool);
123   function approve(address spender, uint256 value) external returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 // File: contracts/token/ERC20/ERC20Standard.sol
129 
130 /**
131  * Copyright (c) 2016 Smart Contract Solutions, Inc.
132  * Released under the MIT license.
133  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
134 */
135 
136 
137 
138 /**
139  * @title 
140  * @dev 
141  */
142 contract ERC20Standard is ERC20Interface {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) balances;
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148   uint256 totalSupply_;
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) external returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     // SafeMath.sub will throw if there is not enough balance.
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     emit Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Transfer tokens from one address to another
168    * @param _from address The address which you want to send tokens from
169    * @param _to address The address which you want to transfer to
170    * @param _value uint256 the amount of tokens to be transferred
171    */
172   function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[_from]);
175     require(_value <= allowed[_from][msg.sender]);
176 
177     balances[_from] = balances[_from].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180     emit Transfer(_from, _to, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    *
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * 
192    * To avoid this issue, allowances are only allowed to be changed between zero and non-zero.
193    *
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) external returns (bool) {
198     require(allowed[msg.sender][_spender] == 0 || _value == 0);
199     allowed[msg.sender][_spender] = _value;
200     emit Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205   * @dev total number of tokens in existence
206   */
207   function totalSupply() external view returns (uint256) {
208     return totalSupply_;
209   }
210 
211   /**
212   * @dev Gets the balance of the specified address.
213   * @param _owner The address to query the the balance of.
214   * @return An uint256 representing the amount owned by the passed address.
215   */
216   function balanceOf(address _owner) external view returns (uint256 balance) {
217     return balances[_owner];
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(address _owner, address _spender) external view returns (uint256) {
227     return allowed[_owner][_spender];
228   }
229 
230   /**
231    * @dev Increase the amount of tokens that an owner allowed to a spender.
232    *
233    * approve should be called when allowed[_spender] == 0. To increment
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _addedValue The amount of tokens to increase the allowance by.
239    */
240   function increaseApproval(address _spender, uint _addedValue) external returns (bool) {
241     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246   /**
247    * @dev Decrease the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {
257     uint oldValue = allowed[msg.sender][_spender];
258     if (_subtractedValue > oldValue) {
259       allowed[msg.sender][_spender] = 0;
260     } else {
261       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
262     }
263     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267 }
268 
269 // File: contracts/token/ERC223/ERC223Interface.sol
270 
271 /**
272  * Released under the MIT license.
273  * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE
274 */
275 
276 contract ERC223Interface {
277     function totalSupply() external view returns (uint256);
278     function balanceOf(address who) external view returns (uint256);
279     function transfer(address to, uint256 value) external returns (bool);
280     function transfer(address to, uint256 value, bytes data) external returns (bool);
281     event Transfer(address indexed from, address indexed to, uint256 value);
282 }
283 
284 // File: contracts/token/ERC223/ERC223ReceivingContract.sol
285 
286 /**
287  * Released under the MIT license.
288  * https://github.com/Dexaran/ERC223-token-standard/blob/master/LICENSE
289 */
290 
291 
292 /**
293  * @title Contract that will work with ERC223 tokens.
294  */
295  
296 contract ERC223ReceivingContract { 
297 /**
298  * @dev Standard ERC223 function that will handle incoming token transfers.
299  *
300  * @param _from  Token sender address.
301  * @param _value Amount of tokens.
302  * @param _data  Transaction metadata.
303  */
304     function tokenFallback(address _from, uint _value, bytes _data) public;
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
438 // File: contracts/DAICOVO/TokenController.sol
439 
440 /// @title A controller that manages permissions to mint specific ERC20/ERC223 token.
441 /// @author ICOVO AG
442 /// @dev The target must be a mintable ERC20/ERC223 and also be set its ownership
443 ///      to this controller. It changes permissions in each 3 phases - before the
444 ///      token-sale, during the token-sale and after the token-sale.
445 ///     
446 ///      Before the token-sale (State = Init):
447 ///       Only the owner of this contract has a permission to mint tokens.
448 ///      During the token-sale (State = Tokensale):
449 ///       Only the token-sale contract has a permission to mint tokens.
450 ///      After the token-sale (State = Public):
451 ///       Nobody has any permissions. Will be expand in the future:
452 contract TokenController is Ownable {
453     using SafeMath for uint256;
454 
455     MintableToken public targetToken;
456     address public votingAddr;
457     address public tokensaleManagerAddr;
458 
459     State public state;
460 
461     enum State {
462         Init,
463         Tokensale,
464         Public
465     }
466 
467     /// @dev The deployer must change the ownership of the target token to this contract.
468     /// @param _targetToken : The target token this contract manage the rights to mint.
469     /// @return 
470     constructor (
471         MintableToken _targetToken
472     ) public {
473         targetToken = MintableToken(_targetToken);
474         state = State.Init;
475     }
476 
477     /// @dev Mint and distribute specified amount of tokens to an address.
478     /// @param to An address that receive the minted tokens.
479     /// @param amount Amount to mint.
480     /// @return True if the distribution is successful, revert otherwise.
481     function mint (address to, uint256 amount) external returns (bool) {
482         /*
483           being called from voting contract will be available in the future
484           ex. if (state == State.Public && msg.sender == votingAddr) 
485         */
486 
487         if ((state == State.Init && msg.sender == owner) ||
488             (state == State.Tokensale && msg.sender == tokensaleManagerAddr)) {
489             return targetToken.mint(to, amount);
490         }
491 
492         revert();
493     }
494 
495     /// @dev Change the phase from "Init" to "Tokensale".
496     /// @param _tokensaleManagerAddr A contract address of token-sale.
497     /// @return True if the change of the phase is successful, revert otherwise.
498     function openTokensale (address _tokensaleManagerAddr)
499         external
500         onlyOwner
501         returns (bool)
502     {
503         /* check if the owner of the target token is set to this contract */
504         require(MintableToken(targetToken).owner() == address(this));
505         require(state == State.Init);
506         require(_tokensaleManagerAddr != address(0x0));
507 
508         tokensaleManagerAddr = _tokensaleManagerAddr;
509         state = State.Tokensale;
510         return true;
511     }
512 
513     /// @dev Change the phase from "Tokensale" to "Public". This function will be
514     ///      cahnged in the future to receive an address of voting contract as an
515     ///      argument in order to handle the result of minting proposal.
516     /// @return True if the change of the phase is successful, revert otherwise.
517     function closeTokensale () external returns (bool) {
518         require(state == State.Tokensale && msg.sender == tokensaleManagerAddr);
519 
520         state = State.Public;
521         return true;
522     }
523 
524     /// @dev Check if the state is "Init" or not.
525     /// @return True if the state is "Init", false otherwise.
526     function isStateInit () external view returns (bool) {
527         return (state == State.Init);
528     }
529 
530     /// @dev Check if the state is "Tokensale" or not.
531     /// @return True if the state is "Tokensale", false otherwise.
532     function isStateTokensale () external view returns (bool) {
533         return (state == State.Tokensale);
534     }
535 
536     /// @dev Check if the state is "Public" or not.
537     /// @return True if the state is "Public", false otherwise.
538     function isStatePublic () external view returns (bool) {
539         return (state == State.Public);
540     }
541 }