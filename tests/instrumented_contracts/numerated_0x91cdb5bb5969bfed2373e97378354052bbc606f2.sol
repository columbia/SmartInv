1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) public view returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) balances;
123 
124   uint256 totalSupply_;
125 
126   /**
127   * @dev total number of tokens in existence
128   */
129   function totalSupply() public view returns (uint256) {
130     return totalSupply_;
131   }
132 
133   /**
134   * @dev transfer token for a specified address
135   * @param _to The address to transfer to.
136   * @param _value The amount to be transferred.
137   */
138   function transfer(address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[msg.sender]);
141 
142     // SafeMath.sub will throw if there is not enough balance.
143     balances[msg.sender] = balances[msg.sender].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     Transfer(msg.sender, _to, _value);
146     return true;
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param _owner The address to query the the balance of.
152   * @return An uint256 representing the amount owned by the passed address.
153   */
154   function balanceOf(address _owner) public view returns (uint256 balance) {
155     return balances[_owner];
156   }
157 
158 }
159 
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    *
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) public view returns (uint256) {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _addedValue The amount of tokens to increase the allowance by.
226    */
227   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To decrement
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _subtractedValue The amount of tokens to decrease the allowance by.
242    */
243   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 /**
257  * @title Burnable Token
258  * @dev Token that can be irreversibly burned (destroyed).
259  */
260 contract BurnableToken is BasicToken {
261 
262   event Burn(address indexed burner, uint256 value);
263 
264   /**
265    * @dev Burns a specific amount of tokens.
266    * @param _value The amount of token to be burned.
267    */
268   function burn(uint256 _value) public {
269     require(_value <= balances[msg.sender]);
270     // no need to require value <= totalSupply, since that would imply the
271     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
272 
273     address burner = msg.sender;
274     balances[burner] = balances[burner].sub(_value);
275     totalSupply_ = totalSupply_.sub(_value);
276     Burn(burner, _value);
277     Transfer(burner, address(0), _value);
278   }
279 }
280 
281 
282 /**
283  * @title Mintable token
284  * @dev Simple ERC20 Token example, with mintable token creation
285  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
286  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
287  */
288 contract MintableToken is StandardToken, Ownable {
289   event Mint(address indexed to, uint256 amount);
290   event MintFinished();
291 
292   bool public mintingFinished = false;
293 
294 
295   modifier canMint() {
296     require(!mintingFinished);
297     _;
298   }
299 
300   /**
301    * @dev Function to mint tokens
302    * @param _to The address that will receive the minted tokens.
303    * @param _amount The amount of tokens to mint.
304    * @return A boolean that indicates if the operation was successful.
305    */
306   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
307     totalSupply_ = totalSupply_.add(_amount);
308     balances[_to] = balances[_to].add(_amount);
309     Mint(_to, _amount);
310     Transfer(address(0), _to, _amount);
311     return true;
312   }
313 
314   /**
315    * @dev Function to stop minting new tokens.
316    * @return True if the operation was successful.
317    */
318   function finishMinting() onlyOwner canMint public returns (bool) {
319     mintingFinished = true;
320     MintFinished();
321     return true;
322   }
323 }
324 
325 /**
326  * @title Pausable
327  * @dev Base contract which allows children to implement an emergency stop mechanism.
328  */
329 contract Pausable is Ownable {
330   event Pause();
331   event Unpause();
332 
333   bool public paused = false;
334 
335 
336   /**
337    * @dev Modifier to make a function callable only when the contract is not paused.
338    */
339   modifier whenNotPaused() {
340     require(!paused);
341     _;
342   }
343 
344   /**
345    * @dev Modifier to make a function callable only when the contract is paused.
346    */
347   modifier whenPaused() {
348     require(paused);
349     _;
350   }
351 
352   /**
353    * @dev called by the owner to pause, triggers stopped state
354    */
355   function pause() onlyOwner whenNotPaused public {
356     paused = true;
357     Pause();
358   }
359 
360   /**
361    * @dev called by the owner to unpause, returns to normal state
362    */
363   function unpause() onlyOwner whenPaused public {
364     paused = false;
365     Unpause();
366   }
367 }
368 
369 /**
370  * @title Pausable token
371  * @dev StandardToken modified with pausable transfers.
372  **/
373 contract PausableToken is StandardToken, Pausable {
374 
375   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
376     return super.transfer(_to, _value);
377   }
378 
379   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
380     return super.transferFrom(_from, _to, _value);
381   }
382 
383   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
384     return super.approve(_spender, _value);
385   }
386 
387   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
388     return super.increaseApproval(_spender, _addedValue);
389   }
390 
391   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
392     return super.decreaseApproval(_spender, _subtractedValue);
393   }
394 }
395 
396 /**
397  * @title Claimable
398  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
399  * This allows the new owner to accept the transfer.
400  */
401 contract Claimable is Ownable {
402   address public pendingOwner;
403 
404   /**
405    * @dev Modifier throws if called by any account other than the pendingOwner.
406    */
407   modifier onlyPendingOwner() {
408     require(msg.sender == pendingOwner);
409     _;
410   }
411 
412   /**
413    * @dev Allows the current owner to set the pendingOwner address.
414    * @param newOwner The address to transfer ownership to.
415    */
416   function transferOwnership(address newOwner) onlyOwner public {
417     pendingOwner = newOwner;
418   }
419 
420   /**
421    * @dev Allows the pendingOwner address to finalize the transfer.
422    */
423   function claimOwnership() onlyPendingOwner public {
424     OwnershipTransferred(owner, pendingOwner);
425     owner = pendingOwner;
426     pendingOwner = address(0);
427   }
428 }
429 
430 /**
431  * @title Autonomy
432  * @dev Simpler version of an Democracy organization contract
433  * @dev the inheritor should implement 'initialCongress' at first
434  */
435 contract Autonomy is Ownable {
436     address public congress;
437 
438     modifier onlyCongress() {
439         require(msg.sender == congress);
440         _;
441     }
442 
443     /**
444      * @dev initialize a Congress contract address for this token 
445      *
446      * @param _congress address the congress contract address
447      */
448     function initialCongress(address _congress) onlyOwner public {
449         require(_congress != address(0));
450         congress = _congress;
451     }
452 
453     /**
454      * @dev set a Congress contract address for this token
455      * must change this address by the last congress contract 
456      *
457      * @param _congress address the congress contract address
458      */
459     function changeCongress(address _congress) onlyCongress public {
460         require(_congress != address(0));
461         congress = _congress;
462     }
463 }
464 
465 
466 interface tokenRecipient { 
467     function receiveApproval(
468         address _from, 
469         uint256 _value,
470         address _token, 
471         bytes _extraData
472     ) external; 
473 }
474 
475 contract DRCToken is BurnableToken, MintableToken, PausableToken, Claimable, Autonomy {    
476     string public name = "DRC Token";
477     string public symbol = "DRCT";
478     uint8 public decimals = 18;
479     uint public INITIAL_SUPPLY = 0;
480 
481     // add map for recording the accounts that will not be allowed to transfer tokens
482     mapping (address => bool) public frozenAccount;
483     // record the amount of tokens that have been frozen
484     mapping (address => uint256) public frozenAmount;
485     event FrozenFunds(address indexed _target, bool _frozen);
486     event FrozenFundsPartialy(address indexed _target, bool _frozen, uint256 _value);
487 
488     event BurnFrom(address from, address burner, uint256 value);
489 
490     /**
491      * contruct the token by total amount 
492      *
493      * initial balance is set. 
494      */
495     function DRCToken() public {
496         totalSupply_ = INITIAL_SUPPLY;
497         balances[msg.sender] = INITIAL_SUPPLY;
498     }
499     
500     /**
501      * @dev freeze the account's balance 
502      *
503      * by default all the accounts will not be frozen until set freeze value as true. 
504      * 
505      * @param _target address the account should be frozen
506      * @param _freeze bool if true, the account will be frozen
507      */
508     function freezeAccount(address _target, bool _freeze) onlyOwner public {
509         require(_target != address(0));
510 
511         frozenAccount[_target] = _freeze;
512         frozenAmount[_target] = balances[_target];
513         FrozenFunds(_target, _freeze);
514     }
515 
516     /**
517      * @dev freeze the account's balance 
518      * 
519      * @param _target address the account should be frozen
520      * @param _value uint256 the amount of tokens that will be frozen
521      */
522     function freezeAccountPartialy(address _target, uint256 _value) onlyOwner public {
523         require(_target != address(0));
524         require(_value <= balances[_target]);
525 
526         frozenAccount[_target] = true;
527         frozenAmount[_target] = _value;
528         FrozenFundsPartialy(_target, true, _value);
529     }
530 
531     /**
532      * @dev transfer token for a specified address with froze status checking
533      * @param _to The address to transfer to.
534      * @param _value The amount to be transferred.
535      */
536     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
537         require(_to != address(0));
538         require(!frozenAccount[msg.sender] || (_value <= balances[msg.sender].sub(frozenAmount[msg.sender])));
539 
540         return super.transfer(_to, _value);
541     }
542   
543     /**
544      * @dev Transfer tokens from one address to another with checking the frozen status
545      * @param _from address The address which you want to send tokens from
546      * @param _to address The address which you want to transfer to
547      * @param _value uint256 the amount of tokens to be transferred
548      */
549     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
550         require(_from != address(0));
551         require(_to != address(0));
552         require(!frozenAccount[_from] || (_value <= balances[_from].sub(frozenAmount[_from])));
553 
554         return super.transferFrom(_from, _to, _value);
555     }
556 
557     /**
558      * @dev transfer token for a specified address with froze status checking
559      * @param _toMulti The addresses to transfer to.
560      * @param _values The array of the amount to be transferred.
561      */
562     // function transferMultiAddress(address[] _toMulti, uint256[] _values) public whenNotPaused returns (bool) {
563     //     require(!frozenAccount[msg.sender]);
564     //     assert(_toMulti.length == _values.length);
565 
566     //     uint256 i = 0;
567     //     while (i < _toMulti.length) {
568     //         require(_toMulti[i] != address(0));
569     //         require(_values[i] <= balances[msg.sender]);
570 
571     //         // SafeMath.sub will throw if there is not enough balance.
572     //         balances[msg.sender] = balances[msg.sender].sub(_values[i]);
573     //         balances[_toMulti[i]] = balances[_toMulti[i]].add(_values[i]);
574     //         Transfer(msg.sender, _toMulti[i], _values[i]);
575 
576     //         i = i.add(1);
577     //     }
578 
579     //     return true;
580     // }
581 
582     /**
583      * @dev Transfer tokens from one address to another with checking the frozen status
584      * @param _from address The address which you want to send tokens from
585      * @param _toMulti address[] The addresses which you want to transfer to in boundle
586      * @param _values uint256[] the array of amount of tokens to be transferred
587      */
588     // function transferMultiAddressFrom(address _from, address[] _toMulti, uint256[] _values) public whenNotPaused returns (bool) {
589     //     require(!frozenAccount[_from]);
590     //     assert(_toMulti.length == _values.length);
591     
592     //     uint256 i = 0;
593     //     while ( i < _toMulti.length) {
594     //         require(_toMulti[i] != address(0));
595     //         require(_values[i] <= balances[_from]);
596     //         require(_values[i] <= allowed[_from][msg.sender]);
597 
598     //         // SafeMath.sub will throw if there is not enough balance.
599     //         balances[_from] = balances[_from].sub(_values[i]);
600     //         balances[_toMulti[i]] = balances[_toMulti[i]].add(_values[i]);
601     //         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_values[i]);
602     //         Transfer(_from, _toMulti[i], _values[i]);
603 
604     //         i = i.add(1);
605     //     }
606 
607     //     return true;
608     // }
609   
610     /**
611      * @dev Burns a specific amount of tokens.
612      * @param _value The amount of token to be burned.
613      */
614     function burn(uint256 _value) whenNotPaused public {
615         super.burn(_value);
616     }
617 
618     /**
619      * @dev Destroy tokens from other account
620      *
621      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
622      *
623      * @param _from the address of the sender
624      * @param _value the amount of money to burn
625      */
626     function burnFrom(address _from, uint256 _value) public whenNotPaused returns (bool success) {
627         require(_from != address(0));
628         require(balances[_from] >= _value);                // Check if the targeted balance is enough
629         require(_value <= allowed[_from][msg.sender]);    // Check allowance
630         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
631         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
632         totalSupply_ = totalSupply_.sub(_value);
633         BurnFrom(msg.sender, _from, _value);
634         return true;
635     }
636 
637     /**
638      * @dev Destroy tokens from other account by force, only a congress contract can call this function
639      *
640      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
641      *
642      * @param _from the address of the sender
643      * @param _value the amount of money to burn
644      */
645     function forceBurnFrom(address _from, uint256 _value) onlyCongress whenNotPaused public returns (bool success) {
646         require(_from != address(0));
647         require(balances[_from] >= _value);                // Check if the targeted balance is enough        
648         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
649         totalSupply_ = totalSupply_.sub(_value);
650         BurnFrom(msg.sender, _from, _value);
651         return true;
652     }
653 
654     /**
655      * @dev Function to mint tokens
656      * @param _to The address that will receive the minted tokens.
657      * @param _amount The amount of tokens to mint.
658      * @return A boolean that indicates if the operation was successful.
659      */
660     function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
661         require(_to != address(0));
662         return super.mint(_to, _amount);
663     }
664 
665     /**
666      * @dev Function to stop minting new tokens.
667      * @return True if the operation was successful.
668      */
669     function finishMinting() onlyOwner canMint whenNotPaused public returns (bool) {
670         return super.finishMinting();
671     }
672 
673     /**
674      * @dev Function to restart minting functionality. Only congress contract can do this. 
675      * @return True if the operation was successful.
676      */
677     function restartMint() onlyCongress whenNotPaused public returns (bool) {
678         mintingFinished = false;
679         return true;
680     }
681     
682     /**
683      * @dev Set allowance for other address and notify
684      *
685      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
686      *
687      * @param _spender The address authorized to spend
688      * @param _value the max amount they can spend
689      * @param _extraData some extra information to send to the approved contract
690      */
691     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public whenNotPaused returns (bool success) {
692         require(_spender != address(0));
693 
694         tokenRecipient spender = tokenRecipient(_spender);
695         if (approve(_spender, _value)) {
696             spender.receiveApproval(msg.sender, _value, this, _extraData);
697             return true;
698         }
699     }
700 }