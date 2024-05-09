1 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
2 pragma solidity ^0.4.23;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 //File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
18 pragma solidity ^0.4.23;
19 
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
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
32     // benefit is lost if 'b' is also tested.
33     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34     if (a == 0) {
35       return 0;
36     }
37 
38     c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     // uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return a / b;
51   }
52 
53   /**
54   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
72 pragma solidity ^0.4.23;
73 
74 
75 
76 
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   uint256 totalSupply_;
89 
90   /**
91   * @dev total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105 
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
124 pragma solidity ^0.4.23;
125 
126 
127 
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
148 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
149 pragma solidity ^0.4.23;
150 
151 
152 
153 
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(
174     address _from,
175     address _to,
176     uint256 _value
177   )
178     public
179     returns (bool)
180   {
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     emit Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    *
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(
236     address _spender,
237     uint _addedValue
238   )
239     public
240     returns (bool)
241   {
242     allowed[msg.sender][_spender] = (
243       allowed[msg.sender][_spender].add(_addedValue));
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248   /**
249    * @dev Decrease the amount of tokens that an owner allowed to a spender.
250    *
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(
259     address _spender,
260     uint _subtractedValue
261   )
262     public
263     returns (bool)
264   {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 //File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
278 pragma solidity ^0.4.23;
279 
280 
281 /**
282  * @title Ownable
283  * @dev The Ownable contract has an owner address, and provides basic authorization control
284  * functions, this simplifies the implementation of "user permissions".
285  */
286 contract Ownable {
287   address public owner;
288 
289 
290   event OwnershipRenounced(address indexed previousOwner);
291   event OwnershipTransferred(
292     address indexed previousOwner,
293     address indexed newOwner
294   );
295 
296 
297   /**
298    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
299    * account.
300    */
301   constructor() public {
302     owner = msg.sender;
303   }
304 
305   /**
306    * @dev Throws if called by any account other than the owner.
307    */
308   modifier onlyOwner() {
309     require(msg.sender == owner);
310     _;
311   }
312 
313   /**
314    * @dev Allows the current owner to relinquish control of the contract.
315    */
316   function renounceOwnership() public onlyOwner {
317     emit OwnershipRenounced(owner);
318     owner = address(0);
319   }
320 
321   /**
322    * @dev Allows the current owner to transfer control of the contract to a newOwner.
323    * @param _newOwner The address to transfer ownership to.
324    */
325   function transferOwnership(address _newOwner) public onlyOwner {
326     _transferOwnership(_newOwner);
327   }
328 
329   /**
330    * @dev Transfers control of the contract to a newOwner.
331    * @param _newOwner The address to transfer ownership to.
332    */
333   function _transferOwnership(address _newOwner) internal {
334     require(_newOwner != address(0));
335     emit OwnershipTransferred(owner, _newOwner);
336     owner = _newOwner;
337   }
338 }
339 
340 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\MintableToken.sol
341 pragma solidity ^0.4.23;
342 
343 
344 
345 
346 
347 /**
348  * @title Mintable token
349  * @dev Simple ERC20 Token example, with mintable token creation
350  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
351  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
352  */
353 contract MintableToken is StandardToken, Ownable {
354   event Mint(address indexed to, uint256 amount);
355   event MintFinished();
356 
357   bool public mintingFinished = false;
358 
359 
360   modifier canMint() {
361     require(!mintingFinished);
362     _;
363   }
364 
365   modifier hasMintPermission() {
366     require(msg.sender == owner);
367     _;
368   }
369 
370   /**
371    * @dev Function to mint tokens
372    * @param _to The address that will receive the minted tokens.
373    * @param _amount The amount of tokens to mint.
374    * @return A boolean that indicates if the operation was successful.
375    */
376   function mint(
377     address _to,
378     uint256 _amount
379   )
380     hasMintPermission
381     canMint
382     public
383     returns (bool)
384   {
385     totalSupply_ = totalSupply_.add(_amount);
386     balances[_to] = balances[_to].add(_amount);
387     emit Mint(_to, _amount);
388     emit Transfer(address(0), _to, _amount);
389     return true;
390   }
391 
392   /**
393    * @dev Function to stop minting new tokens.
394    * @return True if the operation was successful.
395    */
396   function finishMinting() onlyOwner canMint public returns (bool) {
397     mintingFinished = true;
398     emit MintFinished();
399     return true;
400   }
401 }
402 
403 //File: node_modules\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
404 pragma solidity ^0.4.23;
405 
406 
407 
408 
409 
410 /**
411  * @title Pausable
412  * @dev Base contract which allows children to implement an emergency stop mechanism.
413  */
414 contract Pausable is Ownable {
415   event Pause();
416   event Unpause();
417 
418   bool public paused = false;
419 
420 
421   /**
422    * @dev Modifier to make a function callable only when the contract is not paused.
423    */
424   modifier whenNotPaused() {
425     require(!paused);
426     _;
427   }
428 
429   /**
430    * @dev Modifier to make a function callable only when the contract is paused.
431    */
432   modifier whenPaused() {
433     require(paused);
434     _;
435   }
436 
437   /**
438    * @dev called by the owner to pause, triggers stopped state
439    */
440   function pause() onlyOwner whenNotPaused public {
441     paused = true;
442     emit Pause();
443   }
444 
445   /**
446    * @dev called by the owner to unpause, returns to normal state
447    */
448   function unpause() onlyOwner whenPaused public {
449     paused = false;
450     emit Unpause();
451   }
452 }
453 
454 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\PausableToken.sol
455 pragma solidity ^0.4.23;
456 
457 
458 
459 
460 
461 /**
462  * @title Pausable token
463  * @dev StandardToken modified with pausable transfers.
464  **/
465 contract PausableToken is StandardToken, Pausable {
466 
467   function transfer(
468     address _to,
469     uint256 _value
470   )
471     public
472     whenNotPaused
473     returns (bool)
474   {
475     return super.transfer(_to, _value);
476   }
477 
478   function transferFrom(
479     address _from,
480     address _to,
481     uint256 _value
482   )
483     public
484     whenNotPaused
485     returns (bool)
486   {
487     return super.transferFrom(_from, _to, _value);
488   }
489 
490   function approve(
491     address _spender,
492     uint256 _value
493   )
494     public
495     whenNotPaused
496     returns (bool)
497   {
498     return super.approve(_spender, _value);
499   }
500 
501   function increaseApproval(
502     address _spender,
503     uint _addedValue
504   )
505     public
506     whenNotPaused
507     returns (bool success)
508   {
509     return super.increaseApproval(_spender, _addedValue);
510   }
511 
512   function decreaseApproval(
513     address _spender,
514     uint _subtractedValue
515   )
516     public
517     whenNotPaused
518     returns (bool success)
519   {
520     return super.decreaseApproval(_spender, _subtractedValue);
521   }
522 }
523 
524 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
525 pragma solidity ^0.4.23;
526 
527 
528 
529 
530 /**
531  * @title Burnable Token
532  * @dev Token that can be irreversibly burned (destroyed).
533  */
534 contract BurnableToken is BasicToken {
535 
536   event Burn(address indexed burner, uint256 value);
537 
538   /**
539    * @dev Burns a specific amount of tokens.
540    * @param _value The amount of token to be burned.
541    */
542   function burn(uint256 _value) public {
543     _burn(msg.sender, _value);
544   }
545 
546   function _burn(address _who, uint256 _value) internal {
547     require(_value <= balances[_who]);
548     // no need to require value <= totalSupply, since that would imply the
549     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
550 
551     balances[_who] = balances[_who].sub(_value);
552     totalSupply_ = totalSupply_.sub(_value);
553     emit Burn(_who, _value);
554     emit Transfer(_who, address(0), _value);
555   }
556 }
557 
558 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
559 pragma solidity ^0.4.23;
560 
561 
562 
563 
564 
565 /**
566  * @title SafeERC20
567  * @dev Wrappers around ERC20 operations that throw on failure.
568  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
569  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
570  */
571 library SafeERC20 {
572   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
573     require(token.transfer(to, value));
574   }
575 
576   function safeTransferFrom(
577     ERC20 token,
578     address from,
579     address to,
580     uint256 value
581   )
582     internal
583   {
584     require(token.transferFrom(from, to, value));
585   }
586 
587   function safeApprove(ERC20 token, address spender, uint256 value) internal {
588     require(token.approve(spender, value));
589   }
590 }
591 
592 //File: node_modules\openzeppelin-solidity\contracts\ownership\CanReclaimToken.sol
593 pragma solidity ^0.4.23;
594 
595 
596 
597 
598 
599 
600 /**
601  * @title Contracts that should be able to recover tokens
602  * @author SylTi
603  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
604  * This will prevent any accidental loss of tokens.
605  */
606 contract CanReclaimToken is Ownable {
607   using SafeERC20 for ERC20Basic;
608 
609   /**
610    * @dev Reclaim all ERC20Basic compatible tokens
611    * @param token ERC20Basic The address of the token contract
612    */
613   function reclaimToken(ERC20Basic token) external onlyOwner {
614     uint256 balance = token.balanceOf(this);
615     token.safeTransfer(owner, balance);
616   }
617 
618 }
619 
620 //File: contracts\ico\GotToken.sol
621 /**
622  * @title ParkinGO token
623  *
624  * @version 1.0
625  * @author ParkinGO
626  */
627 pragma solidity ^0.4.24;
628 
629 
630 
631 
632 
633 
634 
635 contract GotToken is CanReclaimToken, MintableToken, PausableToken, BurnableToken {
636     string public constant name = "GOToken";
637     string public constant symbol = "GOT";
638     uint8 public constant decimals = 18;
639 
640     /**
641      * @dev Constructor of GotToken that instantiates a new Mintable Pausable Token
642      */
643     constructor() public {
644         // token should not be transferable until after all tokens have been issued
645         paused = true;
646     }
647 }