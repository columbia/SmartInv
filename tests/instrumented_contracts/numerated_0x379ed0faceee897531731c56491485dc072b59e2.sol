1 pragma solidity 0.4.21;
2 
3 /*
4 The MIT License (MIT)
5 
6 Copyright (c) 2016 Smart Contract Solutions, Inc.
7 
8 Permission is hereby granted, free of charge, to any person obtaining
9 a copy of this software and associated documentation files (the
10 "Software"), to deal in the Software without restriction, including
11 without limitation the rights to use, copy, modify, merge, publish,
12 distribute, sublicense, and/or sell copies of the Software, and to
13 permit persons to whom the Software is furnished to do so, subject to
14 the following conditions:
15 
16 The above copyright notice and this permission notice shall be included
17 in all copies or substantial portions of the Software.
18 
19 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
20 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
21 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
22 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
23 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
24 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
25 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
26 */
27  
28 // zeppelin-solidity: 1.9.0
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
40     if (a == 0) {
41       return 0;
42     }
43     c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers, truncating the quotient.
50   */
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     // uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return a / b;
56   }
57 
58   /**
59   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60   */
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   /**
67   * @dev Adds two numbers, throws on overflow.
68   */
69   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @title Basic token
101  * @dev Basic version of StandardToken, with no allowances.
102  */
103 contract BasicToken is ERC20Basic {
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107 
108   uint256 totalSupply_;
109 
110   /**
111   * @dev total number of tokens in existence
112   */
113   function totalSupply() public view returns (uint256) {
114     return totalSupply_;
115   }
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[msg.sender]);
125 
126     balances[msg.sender] = balances[msg.sender].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     emit Transfer(msg.sender, _to, _value);
129     return true;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address _owner) public view returns (uint256) {
138     return balances[_owner];
139   }
140 
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  */
150 contract StandardToken is ERC20, BasicToken {
151 
152   mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169     emit Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     emit Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(address _owner, address _spender) public view returns (uint256) {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To increment
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _addedValue The amount of tokens to increase the allowance by.
208    */
209   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
210     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
211     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   /**
216    * @dev Decrease the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To decrement
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _subtractedValue The amount of tokens to decrease the allowance by.
224    */
225   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
226     uint oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236 }
237 
238 /**
239  * @title Burnable Token
240  * @dev Token that can be irreversibly burned (destroyed).
241  */
242 contract BurnableToken is BasicToken {
243 
244   event Burn(address indexed burner, uint256 value);
245 
246   /**
247    * @dev Burns a specific amount of tokens.
248    * @param _value The amount of token to be burned.
249    */
250   function burn(uint256 _value) public {
251     _burn(msg.sender, _value);
252   }
253 
254   function _burn(address _who, uint256 _value) internal {
255     require(_value <= balances[_who]);
256     // no need to require value <= totalSupply, since that would imply the
257     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
258 
259     balances[_who] = balances[_who].sub(_value);
260     totalSupply_ = totalSupply_.sub(_value);
261     emit Burn(_who, _value);
262     emit Transfer(_who, address(0), _value);
263   }
264 }
265 
266 /**
267  * @title Standard Burnable Token
268  * @dev Adds burnFrom method to ERC20 implementations
269  */
270 contract StandardBurnableToken is BurnableToken, StandardToken {
271 
272   /**
273    * @dev Burns a specific amount of tokens from the target address and decrements allowance
274    * @param _from address The address which you want to send tokens from
275    * @param _value uint256 The amount of token to be burned
276    */
277   function burnFrom(address _from, uint256 _value) public {
278     require(_value <= allowed[_from][msg.sender]);
279     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
280     // this function needs to emit an event with the updated approval.
281     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
282     _burn(_from, _value);
283   }
284 }
285 
286 /**
287     * @title Safe Approve
288     * @dev  `msg.sender` approves `_spender` to spend `_amount` tokens on
289     *  its behalf. This is a modified version of the ERC20 approve function
290     *  to be a little bit safer
291     */
292 contract SafeApprove is StandardBurnableToken {
293 
294    /**
295     *  @param _spender The address of the account able to transfer the tokens
296     *  @param _value The value of tokens to be approved for transfer
297     *  @return True if the approval was successful
298     **/
299   function approve(address _spender, uint256 _value) public  returns (bool) {
300     //  To change the approve amount you first have to reduce the addresses`
301     //  allowance to zero by calling `approve(_spender,0)` if it is not
302     //  already 0 to mitigate the race condition described here:
303     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
304     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
305     return super.approve(_spender, _value);
306   }
307 }
308 
309 /**
310  * @title Ownable
311  * @dev The Ownable contract has an owner address, and provides basic authorization control
312  * functions, this simplifies the implementation of "user permissions".
313  */
314 contract Ownable {
315   address public owner;
316 
317 
318   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
319 
320 
321   /**
322    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
323    * account.
324    */
325   function Ownable() public {
326     owner = msg.sender;
327   }
328 
329   /**
330    * @dev Throws if called by any account other than the owner.
331    */
332   modifier onlyOwner() {
333     require(msg.sender == owner);
334     _;
335   }
336 
337   /**
338    * @dev Allows the current owner to transfer control of the contract to a newOwner.
339    * @param newOwner The address to transfer ownership to.
340    */
341   function transferOwnership(address newOwner) public onlyOwner {
342     require(newOwner != address(0));
343     emit OwnershipTransferred(owner, newOwner);
344     owner = newOwner;
345   }
346 
347 }
348 
349 /**
350  * @title AdvancedOwnable
351  * @dev The AdvancedOwnable contract provides advanced authorization control
352  * functions, this simplifies the implementation of "user permissions".
353  */
354 contract AdvancedOwnable is Ownable {
355 
356   address public saleAgent;
357   address internal managerAgent;
358 
359   /**
360    * @dev The AdvancedOwnable constructor sets saleAgent and managerAgent.
361    * @dev Until the owner has been given a new address, the address will be assigned to the owner.
362    */
363   function AdvancedOwnable() public {
364     saleAgent=owner;
365     managerAgent=owner;
366   }
367   modifier onlyOwnerOrManagerAgent {
368     require(owner == msg.sender || managerAgent == msg.sender);
369     _;
370   }
371   modifier onlyOwnerOrSaleAgent {
372     require(owner == msg.sender || saleAgent == msg.sender);
373     _;
374   }
375   function setSaleAgent(address newSaleAgent) public onlyOwner {
376     require(newSaleAgent != address(0));
377     saleAgent = newSaleAgent;
378   }
379   function setManagerAgent(address newManagerAgent) public onlyOwner {
380     require(newManagerAgent != address(0));
381     managerAgent = newManagerAgent;
382   }
383 
384 }
385 
386 /**
387    * @title blacklist
388    * @dev The blacklist contract has a blacklist of addresses, and provides basic authorization control functions.
389    * @dev This simplifies the implementation of "user permissions".
390    */
391 contract BlackList is AdvancedOwnable {
392 
393     mapping (address => bool) internal blacklist;
394     event BlacklistedAddressAdded(address indexed _address);
395     event BlacklistedAddressRemoved(address indexed _address);
396 
397    /**
398     * @dev Modifier to make a function callable only when the address is not in black list.
399     */
400    modifier notInBlackList() {
401      require(!blacklist[msg.sender]);
402      _;
403    }
404 
405    /**
406     * @dev Modifier to make a function callable only when the address is not in black list.
407     */
408    modifier onlyIfNotInBlackList(address _address) {
409      require(!blacklist[_address]);
410      _;
411    }
412    /**
413     * @dev Modifier to make a function callable only when the address is in black list.
414     */
415    modifier onlyIfInBlackList(address _address) {
416      require(blacklist[_address]);
417      _;
418    }
419  /**
420    * @dev add an address to the blacklist
421    * @param _address address
422    * @return true if the address was added to the blacklist,
423    * false if the address was already in the blacklist
424    */
425    function addAddressToBlacklist(address _address) public onlyOwnerOrManagerAgent onlyIfNotInBlackList(_address) returns(bool) {
426      blacklist[_address] = true;
427      emit BlacklistedAddressAdded(_address);
428      return true;
429    }
430  /**
431    * @dev remove addresses from the blacklist
432    * @param _address address
433    * @return true if  address was removed from the blacklist,
434    * false if address weren't in the blacklist in the first place
435    */
436   function removeAddressFromBlacklist(address _address) public onlyOwnerOrManagerAgent onlyIfInBlackList(_address) returns(bool) {
437     blacklist[_address] = false;
438     emit BlacklistedAddressRemoved(_address);
439     return true;
440   }
441 }
442 
443 /**
444    * @title BlackList Token
445    * @dev Throws if called by any account that's in blackList.
446    */
447 contract BlackListToken is BlackList,SafeApprove {
448 
449   function transfer(address _to, uint256 _value) public notInBlackList returns (bool) {
450     return super.transfer(_to, _value);
451   }
452 
453   function transferFrom(address _from, address _to, uint256 _value) public notInBlackList returns (bool) {
454     return super.transferFrom(_from, _to, _value);
455   }
456 
457   function approve(address _spender, uint256 _value) public notInBlackList returns (bool) {
458     return super.approve(_spender, _value);
459   }
460 
461   function increaseApproval(address _spender, uint _addedValue) public notInBlackList returns (bool) {
462     return super.increaseApproval(_spender, _addedValue);
463   }
464 
465   function decreaseApproval(address _spender, uint _subtractedValue) public notInBlackList returns (bool) {
466     return super.decreaseApproval(_spender, _subtractedValue);
467   }
468 
469   function burn(uint256 _value) public notInBlackList {
470    super.burn( _value);
471   }
472 
473   function burnFrom(address _from, uint256 _value) public notInBlackList {
474    super.burnFrom( _from, _value);
475   }
476 
477 }
478 
479 /**
480  * @title Pausable
481  * @dev Base contract which allows children to implement an emergency stop mechanism.
482  */
483 contract Pausable is AdvancedOwnable {
484   event Pause();
485   event Unpause();
486 
487   bool public paused = false;
488 
489   /**
490    * @dev Modifier to make a function callable only when the contract is not paused.
491    */
492   modifier whenNotPaused() {
493     require(!paused);
494     _;
495   }
496 
497   /**
498    * @dev Modifier to make a function callable only when the contract is paused.
499    */
500   modifier whenPaused() {
501     require(paused);
502     _;
503   }
504 
505   /**
506    * @dev Modifier to make a function callable only for owner and saleAgent when the contract is paused.
507    */
508    modifier onlyWhenNotPaused() {
509      if(owner != msg.sender && saleAgent != msg.sender) {
510        require (!paused);
511      }
512     _;
513    }
514 
515   /**
516    * @dev called by the owner to pause, triggers stopped state
517    */
518   function pause() onlyOwnerOrSaleAgent whenNotPaused public {
519     paused = true;
520     emit Pause();
521   }
522 
523   /**
524    * @dev called by the owner to unpause, returns to normal state
525    */
526   function unpause() onlyOwnerOrSaleAgent whenPaused public {
527     paused = false;
528     emit Unpause();
529   }
530 }
531 
532 /**
533  * @title Pausable token
534  * @dev BlackListToken modified with pausable transfers.
535  **/
536 contract PausableToken is Pausable,BlackListToken {
537 
538   function transfer(address _to, uint256 _value) public onlyWhenNotPaused returns (bool) {
539     return super.transfer(_to, _value);
540   }
541 
542   function transferFrom(address _from, address _to, uint256 _value) public onlyWhenNotPaused returns (bool) {
543     return super.transferFrom(_from, _to, _value);
544   }
545 
546   function approve(address _spender, uint256 _value) public onlyWhenNotPaused returns (bool) {
547     return super.approve(_spender, _value);
548   }
549 
550   function increaseApproval(address _spender, uint _addedValue) public onlyWhenNotPaused returns (bool) {
551     return super.increaseApproval(_spender, _addedValue);
552   }
553 
554   function decreaseApproval(address _spender, uint _subtractedValue) public onlyWhenNotPaused returns (bool) {
555     return super.decreaseApproval(_spender, _subtractedValue);
556   }
557 
558   function burn(uint256 _value) public onlyWhenNotPaused {
559    super.burn( _value);
560   }
561 
562   function burnFrom(address _from, uint256 _value) public onlyWhenNotPaused {
563    super.burnFrom( _from, _value);
564   }
565 
566 }
567 
568 /**
569  * @title SafeCheckToken
570  * @dev More secure functionality.
571  */
572 contract SafeCheckToken is PausableToken {
573 
574 
575     function transfer(address _to, uint256 _value) public returns (bool) {
576       // Do not send tokens to this contract
577       require(_to != address(this));
578       // Check  Short Address
579       require(msg.data.length >= 68);
580       // Check Value is not zero
581       require(_value != 0);
582 
583       return super.transfer(_to, _value);
584     }
585 
586     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
587       // Do not send tokens to this contract
588       require(_to != address(this));
589       // Check  Short Address
590       require(msg.data.length >= 68);
591       // Check  Address from is not zero
592       require(_from != address(0));
593       // Check Value is not zero
594       require(_value != 0);
595 
596       return super.transferFrom(_from, _to, _value);
597     }
598 
599     function approve(address _spender, uint256 _value) public returns (bool) {
600       // Check  Short Address
601       require(msg.data.length >= 68);
602       return super.approve(_spender, _value);
603     }
604 
605     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
606       // Check  Short Address
607       require(msg.data.length >= 68);
608       return super.increaseApproval(_spender, _addedValue);
609     }
610 
611     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
612       // Check  Short Address
613       require(msg.data.length >= 68);
614       return super.decreaseApproval(_spender, _subtractedValue);
615     }
616 
617     function burn(uint256 _value) public {
618       // Check Value is not zero
619       require(_value != 0);
620       super.burn( _value);
621     }
622 
623     function burnFrom(address _from, uint256 _value) public {
624       // Check  Short Address
625       require(msg.data.length >= 68);
626       // Check Value is not zero
627       require(_value != 0);
628       super.burnFrom( _from, _value);
629     }
630 
631 }
632 
633 //Interface for accidentally send ERC20 tokens
634 interface accidentallyERC20 {
635     function transfer(address _to, uint256 _value) external returns (bool);
636 }
637 
638 /**
639  * @title AccidentallyTokens
640  * @dev Owner can transfer out any accidentally sent ERC20 tokens.
641  */
642 contract AccidentallyTokens is Ownable {
643 
644     function transferAnyERC20Token(address tokenAddress,address _to, uint _value) public onlyOwner returns (bool) {
645       require(_to != address(this));
646       require(tokenAddress != address(0));
647       require(_to != address(0));
648       return accidentallyERC20(tokenAddress).transfer(_to,_value);
649     }
650 }
651 
652 /**
653  * @title MainToken
654  * @dev  ERC20 Token contract, where all tokens are send to the Token Wallet Holder.
655  */
656 contract MainToken is SafeCheckToken,AccidentallyTokens {
657 
658   address public TokenWalletHolder;
659 
660   string public constant name = "EQI Token";
661   string public constant symbol = "EQI";
662   uint8 public constant decimals = 18;
663 
664   uint256 public constant INITIAL_SUPPLY = 880000000 * (10 ** uint256(decimals));
665 
666   /**
667    * @dev Constructor that gives TokenWalletHolder all of existing tokens.
668    */
669   function MainToken(address _TokenWalletHolder) public {
670     require(_TokenWalletHolder != address(0));
671     TokenWalletHolder = _TokenWalletHolder;
672     totalSupply_ = INITIAL_SUPPLY;
673     balances[TokenWalletHolder] = INITIAL_SUPPLY;
674     emit Transfer(address(this), msg.sender, INITIAL_SUPPLY);
675   }
676 
677   /**
678    * @dev  Don't accept ETH.
679    */
680   function () public payable {
681     revert();
682   }
683 
684 }