1 pragma solidity ^0.4.15;
2 
3 /*
4     ERC20 Standard Token interface
5 */
6 contract IERC20Token {
7     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
8     function name() public constant returns (string) {}
9     function symbol() public constant returns (string) {}
10     function decimals() public constant returns (uint8) {}
11     function totalSupply() public constant returns (uint) {}
12     function transfer(address _to, uint _value) public returns (bool success);
13     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
14     function approve(address _spender, uint _value) public returns (bool success);
15     function balanceOf(address _owner) public constant returns (uint balance);
16     function allowance(address _owner, address _spender) public constant returns (uint remaining);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   /**
50   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 /**
68  * @title Standard ERC20 token
69  *
70  * @dev Implementation of the basic standard token.
71  * @dev https://github.com/ethereum/EIPs/issues/20
72  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
73  */
74 contract StandardToken is IERC20Token {
75   using SafeMath for uint;
76 
77   mapping (address => mapping (address => uint256)) internal allowed;
78   mapping (address => uint) balances;
79   uint256 totalSupply_;
80 
81 
82   /**
83    * @dev Transfer tokens from one address to another
84    * @param _from address The address which you want to send tokens from
85    * @param _to address The address which you want to transfer to
86    * @param _value uint256 the amount of tokens to be transferred
87    */
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[_from]);
91     require(_value <= allowed[_from][msg.sender]);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   /**
101    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    *
103    * Beware that changing an allowance with this method brings the risk that someone may use both the old
104    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
105    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
106    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107    * @param _spender The address which will spend the funds.
108    * @param _value The amount of tokens to be spent.
109    */
110   function approve(address _spender, uint256 _value) public returns (bool) {
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Function to check the amount of tokens that an owner allowed to a spender.
118    * @param _owner address The address which owns the funds.
119    * @param _spender address The address which will spend the funds.
120    * @return A uint256 specifying the amount of tokens still available for the spender.
121    */
122   function allowance(address _owner, address _spender) public view returns (uint256) {
123     return allowed[_owner][_spender];
124   }
125 
126   /**
127    * @dev Increase the amount of tokens that an owner allowed to a spender.
128    *
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    * @param _spender The address which will spend the funds.
134    * @param _addedValue The amount of tokens to increase the allowance by.
135    */
136   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
137     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
138     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141 
142   /**
143    * @dev Decrease the amount of tokens that an owner allowed to a spender.
144    *
145    * approve should be called when allowed[_spender] == 0. To decrement
146    * allowed value is better to use this function to avoid 2 calls (and wait until
147    * the first transaction is mined)
148    * From MonolithDAO Token.sol
149    * @param _spender The address which will spend the funds.
150    * @param _subtractedValue The amount of tokens to decrease the allowance by.
151    */
152   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
153     uint oldValue = allowed[msg.sender][_spender];
154     if (_subtractedValue > oldValue) {
155       allowed[msg.sender][_spender] = 0;
156     } else {
157       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
158     }
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163 }
164 
165 /**
166  * @title Burnable
167  *
168  * @dev Standard ERC20 token
169  */
170 contract Burnable is StandardToken {
171   using SafeMath for uint;
172 
173   /* This notifies clients about the amount burnt */
174   event Burn(address indexed from, uint value);
175 
176   function burn(uint _value) public returns (bool success) {
177     require(_value > 0 && balances[msg.sender] >= _value);
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     totalSupply_ = totalSupply_.sub(_value);
180     Burn(msg.sender, _value);
181     return true;
182   }
183 
184   function burnFrom(address _from, uint _value) public returns (bool success) {
185     require(_from != 0x0 && _value > 0 && balances[_from] >= _value);
186     require(_value <= allowed[_from][msg.sender]);
187     balances[_from] = balances[_from].sub(_value);
188     totalSupply_ = totalSupply_.sub(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     Burn(_from, _value);
191     return true;
192   }
193 
194   function transfer(address _to, uint _value) public returns (bool success) {
195     require(_to != 0x0); //use burn
196 
197     return super.transfer(_to, _value);
198   }
199 
200   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
201     require(_to != 0x0); //use burn
202 
203     return super.transferFrom(_from, _to, _value);
204   }
205 }
206 
207 /*
208     Utilities & Common Modifiers
209 */
210 contract Utils {
211     /**
212         constructor
213     */
214     function Utils() public {
215     }
216 
217     // verifies that an amount is greater than zero
218     modifier greaterThanZero(uint _amount) {
219         require(_amount > 0);
220         _;
221     }
222 
223     // validates an address - currently only checks that it isn't null
224     modifier validAddress(address _address) {
225         require(_address != 0x0);
226         _;
227     }
228 
229     // verifies that the address is different than this contract address
230     modifier notThis(address _address) {
231         require(_address != address(this));
232         _;
233     }
234 
235 
236     function _validAddress(address _address) internal pure returns (bool) {
237       return  _address != 0x0;
238     }
239 
240     // Overflow protected math functions
241 
242     /**
243         @dev returns the sum of _x and _y, asserts if the calculation overflows
244 
245         @param _x   value 1
246         @param _y   value 2
247 
248         @return sum
249     */
250     function safeAdd(uint _x, uint _y) internal pure returns (uint) {
251         uint z = _x + _y;
252         assert(z >= _x);
253         return z;
254     }
255 
256     /**
257         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
258 
259         @param _x   minuend
260         @param _y   subtrahend
261 
262         @return difference
263     */
264     function safeSub(uint _x, uint _y) internal pure returns (uint) {
265         assert(_x >= _y);
266         return _x - _y;
267     }
268 
269     /**
270         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
271 
272         @param _x   factor 1
273         @param _y   factor 2
274 
275         @return product
276     */
277     function safeMul(uint _x, uint _y) internal pure returns (uint) {
278         uint z = _x * _y;
279         assert(_x == 0 || z / _x == _y);
280         return z;
281     }
282 }
283 
284 /*
285     Owned contract interface
286 */
287 contract IOwned {
288     // this function isn't abstract since the compiler emits automatically generated getter functions as external
289     function owner() public constant returns (address) {}
290 
291     function transferOwnership(address _newOwner) public;
292 }
293 
294 /*
295     Token Holder interface
296 */
297 contract ITokenHolder is IOwned {
298     function withdrawTokens(IERC20Token _token, address _to, uint _amount) public;
299 }
300 
301 /**
302  * @title Ownable
303  * @dev The Ownable contract has an owner address, and provides basic authorization control
304  * functions, this simplifies the implementation of "user permissions".
305  */
306 contract Ownable {
307   address public owner;
308 
309 
310   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
311 
312 
313   /**
314    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
315    * account.
316    */
317   function Ownable() public {
318     owner = msg.sender;
319   }
320 
321   /**
322    * @dev Throws if called by any account other than the owner.
323    */
324   modifier onlyOwner() {
325     require(msg.sender == owner);
326     _;
327   }
328 
329   /**
330    * @dev Allows the current owner to transfer control of the contract to a newOwner.
331    * @param newOwner The address to transfer ownership to.
332    */
333   function transferOwnership(address newOwner) public onlyOwner {
334     require(newOwner != address(0));
335     OwnershipTransferred(owner, newOwner);
336     owner = newOwner;
337   }
338 
339 }
340 
341 /*
342     We consider every contract to be a 'token holder' since it's currently not possible
343     for a contract to deny receiving tokens.
344 
345     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
346     the owner to send tokens that were sent to the contract by mistake back to their sender.
347 */
348 contract TokenHolder is ITokenHolder, Ownable, Utils {
349 
350     // @dev constructor
351     function TokenHolder() public {
352     }
353 
354 
355     //  @dev withdraws tokens held by the contract and sends them to an account
356     //  can only be called by the owner
357     // @param _token   ERC20 token contract address
358     // @param _to      account to receive the new amount
359     // @param _amount  amount to withdraw
360     function withdrawTokens(IERC20Token _token, address _to, uint _amount) public
361     onlyOwner
362     validAddress(_to)
363     {
364         require(_to != address(this));
365         assert(_token.transfer(_to, _amount));
366     }
367 }
368 
369 /*
370     Smart Token interface
371 */
372 contract ISmartToken is IOwned, IERC20Token {
373     function disableTransfers(bool _disable) public;
374     function issue(address _to, uint _amount) public;
375     function destroy(address _from, uint _amount) public;
376 }
377 
378 contract SmartToken is ISmartToken, Burnable, TokenHolder {
379     string public version = '0.3';
380 
381     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
382 
383     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
384     event NewSmartToken(address _token);
385     // triggered when the total supply is increased
386     event Issuance(uint _amount);
387     // triggered when the total supply is decreased
388     event Destruction(uint _amount);
389 
390     // allows execution only when transfers aren't disabled
391     modifier transfersAllowed {
392         assert(transfersEnabled);
393         _;
394     }
395 
396     /**
397         @dev disables/enables transfers
398         can only be called by the contract owner
399 
400         @param _disable    true to disable transfers, false to enable them
401     */
402     function disableTransfers(bool _disable) public onlyOwner {
403         transfersEnabled = !_disable;
404     }
405 
406     /**
407         @dev increases the token supply and sends the new tokens to an account
408         can only be called by the contract owner
409 
410         @param _to         account to receive the new amount
411         @param _amount     amount to increase the supply by
412     */
413     function issue(address _to, uint _amount)
414         public
415         onlyOwner
416         validAddress(_to)
417         notThis(_to)
418     {
419         totalSupply_ = safeAdd(totalSupply_, _amount);
420         balances[_to] = safeAdd(balances[_to], _amount);
421 
422         Issuance(_amount);
423         Transfer(this, _to, _amount);
424     }
425 
426     /**
427         @dev removes tokens from an account and decreases the token supply
428         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
429 
430         @param _from       account to remove the amount from
431         @param _amount     amount to decrease the supply by
432     */
433     function destroy(address _from, uint _amount) public {
434         require(msg.sender == _from || msg.sender == owner); // validate input
435 
436         balances[_from] = safeSub(balances[_from], _amount);
437         totalSupply_ = safeSub(totalSupply_, _amount);
438 
439         Transfer(_from, this, _amount);
440         Destruction(_amount);
441     }
442 
443     // ERC20 standard method overrides with some extra functionality
444 
445     /**
446         @dev send coins
447         throws on any error rather then return a false flag to minimize user errors
448         in addition to the standard checks, the function throws if transfers are disabled
449 
450         @param _to      target address
451         @param _value   transfer amount
452 
453         @return true if the transfer was successful, false if it wasn't
454     */
455     function transfer(address _to, uint _value) public transfersAllowed returns (bool success) {
456         assert(super.transfer(_to, _value));
457         return true;
458     }
459 
460     /**
461         @dev an account/contract attempts to get the coins
462         throws on any error rather then return a false flag to minimize user errors
463         in addition to the standard checks, the function throws if transfers are disabled
464 
465         @param _from    source address
466         @param _to      target address
467         @param _value   transfer amount
468 
469         @return true if the transfer was successful, false if it wasn't
470     */
471     function transferFrom(address _from, address _to, uint _value) public transfersAllowed returns (bool success) {
472         assert(super.transferFrom(_from, _to, _value));
473         return true;
474     }
475 }
476 
477 contract ContractReceiver {
478    function tokenFallback(address _from, uint _value, bytes _data) external;
479 }
480 
481 /**
482  * @title FinTabToken
483  *
484  * @dev Burnable Ownable ERC223(and ERC20-compilant) token with support of
485  * Bancor SmartToken protocol
486  */
487 contract FinTabToken is SmartToken {
488 
489   uint public constant INITIAL_SUPPLY = 3079387 * (10 ** 8);
490 
491   uint public releaseTokensBlock; //Approximatly will be at 01.07.2018
492 
493   mapping (address => bool) public teamAddresses;
494   mapping (address => bool) public tokenBurners;
495 
496   event Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);
497 
498   // Limit token transfer for  the team
499   modifier canTransfer(address _sender) {
500     require(block.number >= releaseTokensBlock || !teamAddresses[_sender]);
501     _;
502   }
503 
504   modifier canBurnTokens(address _sender) {
505     require(tokenBurners[_sender] == true || owner == _sender);
506     _;
507   }
508 
509   // Token construcor
510   function FinTabToken(uint _releaseBlock) public {
511     releaseTokensBlock = _releaseBlock;
512     totalSupply_ = INITIAL_SUPPLY;
513     balances[msg.sender] = INITIAL_SUPPLY;
514     NewSmartToken(this);
515   }
516 
517   function name() public constant returns (string) { return "FinTab"; }
518   function symbol() public constant returns (string) { return "FNTB" ;}
519   function decimals() public constant returns (uint8) { return 8; }
520 
521   function totalSupply() public constant returns (uint) {
522     return totalSupply_;
523   }
524   function balanceOf(address _owner) public constant returns (uint balance) {
525     require(_owner != 0x0);
526     return balances[_owner];
527   }
528 
529 
530   // Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
531   function setTeamAddress(address addr, bool state) onlyOwner public {
532     require(addr != 0x0);
533     teamAddresses[addr] = state;
534   }
535 
536   function setBurner(address addr, bool state) onlyOwner public {
537     require(addr != 0x0);
538     tokenBurners[addr] = state;
539   }
540 
541   // Function that is called when a user or another contract wants to transfer funds .
542   function transfer(address _to, uint _value, bytes _data) transfersAllowed canTransfer(msg.sender) public returns (bool success) {
543     if(isContract(_to)) {
544         return transferToContract(_to, _value, _data);
545     }
546     else {
547         return transferToAddress(_to, _value, _data);
548     }
549   }
550 
551   // Standard function transfer similar to ERC20 transfer with no _data .
552   // Added due to backwards compatibility reasons .
553   function transfer(address _to, uint _value) transfersAllowed canTransfer(msg.sender) public returns (bool success) {
554     //standard function transfer similar to ERC20 transfer with no _data
555     //added due to backwards compatibility reasons
556     bytes memory empty;
557     if(isContract(_to)) {
558         return transferToContract(_to, _value, empty);
559     }
560     else {
561         return transferToAddress(_to, _value, empty);
562     }
563   }
564 
565   // Transfer on _from behalf
566   function transferFrom(address _from, address _to, uint _value) transfersAllowed canTransfer(_from) public returns (bool success) {
567     // Call Burnable.transferForm()
568     return super.transferFrom(_from, _to, _value);
569   }
570 
571   // Burn tokens
572   function burn(uint _value) canBurnTokens(msg.sender) public returns (bool success) {
573     return super.burn(_value);
574   }
575 
576   // Burn tokens on _from behalf
577   function burnFrom(address _from, uint _value) onlyOwner  canBurnTokens(msg.sender) public returns (bool success) {
578     return super.burnFrom(_from, _value);
579   }
580 
581 
582   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
583   function isContract(address _addr) private returns (bool is_contract) {
584       uint length;
585       assembly {
586             //retrieve the size of the code on target address, this needs assembly
587             length := extcodesize(_addr)
588       }
589       return (length>0);
590     }
591 
592   //function that is called when transaction target is an address
593   function transferToAddress(address _to, uint _value, bytes _data) private canTransfer(msg.sender) returns (bool success) {
594     require(balanceOf(msg.sender) >= _value);
595     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
596     balances[_to] = safeAdd(balanceOf(_to), _value);
597     Transfer(msg.sender, _to, _value);
598     return true;
599   }
600 
601   //function that is called when transaction target is a contract
602   function transferToContract(address _to, uint _value, bytes _data) private canTransfer(msg.sender) returns (bool success) {
603     require(balanceOf(msg.sender) >= _value);
604     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
605     balances[_to] = safeAdd(balanceOf(_to), _value);
606     ContractReceiver receiver = ContractReceiver(_to);
607     receiver.tokenFallback(msg.sender, _value, _data);
608     Transfer(msg.sender, _to, _value);
609     return true;
610   }
611 }