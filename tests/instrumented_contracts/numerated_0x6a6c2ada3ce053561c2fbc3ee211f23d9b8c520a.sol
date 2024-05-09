1 /**
2  *Submitted for verification at Etherscan.io on 2018-10-04
3 */
4 
5 pragma solidity ^0.4.24;
6 // produced by the Solididy File Flattener (c) David Appleton 2018
7 // contact : dave@akomba.com
8 // released under Apache 2.0 licence
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipRenounced(address indexed previousOwner);
21   event OwnershipTransferred(
22     address indexed previousOwner,
23     address indexed newOwner
24   );
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   constructor() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    */
46   function renounceOwnership() public onlyOwner {
47     emit OwnershipRenounced(owner);
48     owner = address(0);
49   }
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address _newOwner) public onlyOwner {
56     _transferOwnership(_newOwner);
57   }
58 
59   /**
60    * @dev Transfers control of the contract to a newOwner.
61    * @param _newOwner The address to transfer ownership to.
62    */
63   function _transferOwnership(address _newOwner) internal {
64     require(_newOwner != address(0));
65     emit OwnershipTransferred(owner, _newOwner);
66     owner = _newOwner;
67   }
68 }
69 
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (a == 0) {
80       return 0;
81     }
82 
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return a / b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender)
118     public view returns (uint256);
119 
120   function transferFrom(address from, address to, uint256 value)
121     public returns (bool);
122 
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(
125     address indexed owner,
126     address indexed spender,
127     uint256 value
128   );
129 }
130 
131 contract Pausable is Ownable {
132   event Pause();
133   event Unpause();
134 
135   bool public paused = false;
136 
137 
138   /**
139    * @dev Modifier to make a function callable only when the contract is not paused.
140    */
141   modifier whenNotPaused() {
142     require(!paused);
143     _;
144   }
145 
146   /**
147    * @dev Modifier to make a function callable only when the contract is paused.
148    */
149   modifier whenPaused() {
150     require(paused);
151     _;
152   }
153 
154   /**
155    * @dev called by the owner to pause, triggers stopped state
156    */
157   function pause() onlyOwner whenNotPaused public {
158     paused = true;
159     emit Pause();
160   }
161 
162   /**
163    * @dev called by the owner to unpause, returns to normal state
164    */
165   function unpause() onlyOwner whenPaused public {
166     paused = false;
167     emit Unpause();
168   }
169 }
170 
171 contract DetailedERC20 is ERC20 {
172   string public name;
173   string public symbol;
174   uint8 public decimals;
175 
176   constructor(string _name, string _symbol, uint8 _decimals) public {
177     name = _name;
178     symbol = _symbol;
179     decimals = _decimals;
180   }
181 }
182 
183 contract BasicToken is ERC20Basic {
184   using SafeMath for uint256;
185 
186   mapping(address => uint256) balances;
187 
188   uint256 totalSupply_;
189 
190   /**
191   * @dev total number of tokens in existence
192   */
193   function totalSupply() public view returns (uint256) {
194     return totalSupply_;
195   }
196 
197   /**
198   * @dev transfer token for a specified address
199   * @param _to The address to transfer to.
200   * @param _value The amount to be transferred.
201   */
202   function transfer(address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[msg.sender]);
205 
206     balances[msg.sender] = balances[msg.sender].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     emit Transfer(msg.sender, _to, _value);
209     return true;
210   }
211 
212   /**
213   * @dev Gets the balance of the specified address.
214   * @param _owner The address to query the the balance of.
215   * @return An uint256 representing the amount owned by the passed address.
216   */
217   function balanceOf(address _owner) public view returns (uint256) {
218     return balances[_owner];
219   }
220 
221 }
222 
223 contract BurnableToken is BasicToken {
224 
225   event Burn(address indexed burner, uint256 value);
226 
227   /**
228    * @dev Burns a specific amount of tokens.
229    * @param _value The amount of token to be burned.
230    */
231   function burn(uint256 _value) public {
232     _burn(msg.sender, _value);
233   }
234 
235   function _burn(address _who, uint256 _value) internal {
236     require(_value <= balances[_who]);
237     // no need to require value <= totalSupply, since that would imply the
238     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
239 
240     balances[_who] = balances[_who].sub(_value);
241     totalSupply_ = totalSupply_.sub(_value);
242     emit Burn(_who, _value);
243     emit Transfer(_who, address(0), _value);
244   }
245 }
246 
247 contract StandardToken is ERC20, BasicToken {
248 
249   mapping (address => mapping (address => uint256)) internal allowed;
250 
251 
252   /**
253    * @dev Transfer tokens from one address to another
254    * @param _from address The address which you want to send tokens from
255    * @param _to address The address which you want to transfer to
256    * @param _value uint256 the amount of tokens to be transferred
257    */
258   function transferFrom(
259     address _from,
260     address _to,
261     uint256 _value
262   )
263     public
264     returns (bool)
265   {
266     require(_to != address(0));
267     require(_value <= balances[_from]);
268     require(_value <= allowed[_from][msg.sender]);
269 
270     balances[_from] = balances[_from].sub(_value);
271     balances[_to] = balances[_to].add(_value);
272     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
273     emit Transfer(_from, _to, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
279    *
280    * Beware that changing an allowance with this method brings the risk that someone may use both the old
281    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
282    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
283    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284    * @param _spender The address which will spend the funds.
285    * @param _value The amount of tokens to be spent.
286    */
287   function approve(address _spender, uint256 _value) public returns (bool) {
288     allowed[msg.sender][_spender] = _value;
289     emit Approval(msg.sender, _spender, _value);
290     return true;
291   }
292 
293   /**
294    * @dev Function to check the amount of tokens that an owner allowed to a spender.
295    * @param _owner address The address which owns the funds.
296    * @param _spender address The address which will spend the funds.
297    * @return A uint256 specifying the amount of tokens still available for the spender.
298    */
299   function allowance(
300     address _owner,
301     address _spender
302    )
303     public
304     view
305     returns (uint256)
306   {
307     return allowed[_owner][_spender];
308   }
309 
310   /**
311    * @dev Increase the amount of tokens that an owner allowed to a spender.
312    *
313    * approve should be called when allowed[_spender] == 0. To increment
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _addedValue The amount of tokens to increase the allowance by.
319    */
320   function increaseApproval(
321     address _spender,
322     uint _addedValue
323   )
324     public
325     returns (bool)
326   {
327     allowed[msg.sender][_spender] = (
328       allowed[msg.sender][_spender].add(_addedValue));
329     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333   /**
334    * @dev Decrease the amount of tokens that an owner allowed to a spender.
335    *
336    * approve should be called when allowed[_spender] == 0. To decrement
337    * allowed value is better to use this function to avoid 2 calls (and wait until
338    * the first transaction is mined)
339    * From MonolithDAO Token.sol
340    * @param _spender The address which will spend the funds.
341    * @param _subtractedValue The amount of tokens to decrease the allowance by.
342    */
343   function decreaseApproval(
344     address _spender,
345     uint _subtractedValue
346   )
347     public
348     returns (bool)
349   {
350     uint oldValue = allowed[msg.sender][_spender];
351     if (_subtractedValue > oldValue) {
352       allowed[msg.sender][_spender] = 0;
353     } else {
354       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
355     }
356     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
357     return true;
358   }
359 
360 }
361 
362 contract PausableToken is StandardToken, Pausable {
363 
364   function transfer(
365     address _to,
366     uint256 _value
367   )
368     public
369     whenNotPaused
370     returns (bool)
371   {
372     return super.transfer(_to, _value);
373   }
374 
375   function transferFrom(
376     address _from,
377     address _to,
378     uint256 _value
379   )
380     public
381     whenNotPaused
382     returns (bool)
383   {
384     return super.transferFrom(_from, _to, _value);
385   }
386 
387   function approve(
388     address _spender,
389     uint256 _value
390   )
391     public
392     whenNotPaused
393     returns (bool)
394   {
395     return super.approve(_spender, _value);
396   }
397 
398   function increaseApproval(
399     address _spender,
400     uint _addedValue
401   )
402     public
403     whenNotPaused
404     returns (bool success)
405   {
406     return super.increaseApproval(_spender, _addedValue);
407   }
408 
409   function decreaseApproval(
410     address _spender,
411     uint _subtractedValue
412   )
413     public
414     whenNotPaused
415     returns (bool success)
416   {
417     return super.decreaseApproval(_spender, _subtractedValue);
418   }
419 }
420 
421 contract MintableToken is StandardToken, Ownable {
422   event Mint(address indexed to, uint256 amount);
423   event MintFinished();
424 
425   bool public mintingFinished = false;
426 
427 
428   modifier canMint() {
429     require(!mintingFinished);
430     _;
431   }
432 
433   modifier hasMintPermission() {
434     require(msg.sender == owner);
435     _;
436   }
437 
438   /**
439    * @dev Function to mint tokens
440    * @param _to The address that will receive the minted tokens.
441    * @param _amount The amount of tokens to mint.
442    * @return A boolean that indicates if the operation was successful.
443    */
444   function mint(
445     address _to,
446     uint256 _amount
447   )
448     hasMintPermission
449     canMint
450     public
451     returns (bool)
452   {
453     totalSupply_ = totalSupply_.add(_amount);
454     balances[_to] = balances[_to].add(_amount);
455     emit Mint(_to, _amount);
456     emit Transfer(address(0), _to, _amount);
457     return true;
458   }
459 
460   /**
461    * @dev Function to stop minting new tokens.
462    * @return True if the operation was successful.
463    */
464   function finishMinting() onlyOwner canMint public returns (bool) {
465     mintingFinished = true;
466     emit MintFinished();
467     return true;
468   }
469 }
470 
471 contract WhitelistedPausableToken is PausableToken {
472     // UNIX timestamp (in seconds) after which this whitelist no longer applies
473     uint256 public whitelistExpiration;
474     // While the whitelist is active, either the sender or recipient must be
475     // in allowedTransactors.
476     mapping (address => bool) public allowedTransactors;
477 
478     event SetWhitelistExpiration(uint256 expiration);
479     event AllowedTransactorAdded(address sender);
480     event AllowedTransactorRemoved(address sender);
481 
482     //
483     // Functions for maintaining whitelist
484     //
485 
486     modifier allowedTransfer(address _from, address _to) {
487         require(
488             // solium-disable-next-line operator-whitespace
489             !whitelistActive() ||
490             allowedTransactors[_from] ||
491             allowedTransactors[_to],
492             "neither sender nor recipient are allowed"
493         );
494         _;
495     }
496 
497     function whitelistActive() public view returns (bool) {
498         return block.timestamp < whitelistExpiration;
499     }
500 
501     function addAllowedTransactor(address _transactor) public onlyOwner {
502         emit AllowedTransactorAdded(_transactor);
503         allowedTransactors[_transactor] = true;
504     }
505 
506     function removeAllowedTransactor(address _transactor) public onlyOwner {
507         emit AllowedTransactorRemoved(_transactor);
508         delete allowedTransactors[_transactor];
509     }
510 
511     /**
512     * @dev Set the whitelist expiration, after which the whitelist no longer
513     * applies.
514     */
515     function setWhitelistExpiration(uint256 _expiration) public onlyOwner {
516         // allow only if whitelist expiration hasn't yet been set, or if the
517         // whitelist expiration hasn't passed yet
518         //        require(
519         //            whitelistExpiration == 0 || whitelistActive(),
520         //            "an expired whitelist cannot be extended"
521         //        );
522         // prevent possible mistakes in calling this function
523         require(
524             _expiration >= block.timestamp,
525             "whitelist expiration not far enough into the future"
526         );
527         emit SetWhitelistExpiration(_expiration);
528         whitelistExpiration = _expiration;
529     }
530 
531     //
532     // ERC20 transfer functions that have been overridden to enforce the
533     // whitelist.
534     //
535 
536     function transfer(
537         address _to,
538         uint256 _value
539     )
540         public
541         allowedTransfer(msg.sender, _to)
542         returns (bool)
543     {
544         return super.transfer(_to, _value);
545     }
546 
547     function transferFrom(
548         address _from,
549         address _to,
550         uint256 _value
551     )
552     public
553         allowedTransfer(_from, _to)
554     returns (bool)
555     {
556         return super.transferFrom(_from, _to, _value);
557     }
558 }
559 
560 contract TONToken is BurnableToken, MintableToken, WhitelistedPausableToken, DetailedERC20 {
561     event AddCallSpenderWhitelist(address enabler, address spender);
562     event RemoveCallSpenderWhitelist(address disabler, address spender);
563 
564     mapping (address => bool) public callSpenderWhitelist;
565 
566     // @dev Constructor that gives msg.sender all initial tokens.
567     constructor() DetailedERC20("TONToken", "TON", 18) public {
568         owner = msg.sender;
569         mint(owner, 400000000*10**18);
570     }
571 
572     //
573     // Burn methods
574     //
575 
576     // @dev Burns tokens belonging to the sender
577     // @param _value Amount of token to be burned
578     function burn(uint256 _value) public onlyOwner {
579         // TODO: add a function & modifier to enable for all accounts without doing
580         // a contract migration?
581         super.burn(_value);
582     }
583 
584     // @dev Burns tokens belonging to the specified address
585     // @param _who The account whose tokens we're burning
586     // @param _value Amount of token to be burned
587     function burn(address _who, uint256 _value) public onlyOwner {
588         _burn(_who, _value);
589     }
590 
591     //
592     // approveAndCall methods
593     //
594 
595     // @dev Add spender to whitelist of spenders for approveAndCall
596     // @param _spender Address to add
597     function addCallSpenderWhitelist(address _spender) public onlyOwner {
598         callSpenderWhitelist[_spender] = true;
599         emit AddCallSpenderWhitelist(msg.sender, _spender);
600     }
601 
602     // @dev Remove spender from whitelist of spenders for approveAndCall
603     // @param _spender Address to remove
604     function removeCallSpenderWhitelist(address _spender) public onlyOwner {
605         delete callSpenderWhitelist[_spender];
606         emit RemoveCallSpenderWhitelist(msg.sender, _spender);
607     }
608 
609     // @dev Approve transfer of tokens and make a contract call in a single
610     // @dev transaction. This allows a DApp to avoid requiring two MetaMask
611     // @dev approvals for a single logical action, such as creating a listing,
612     // @dev which requires the seller to approve a token transfer and the
613     // @dev marketplace contract to transfer tokens from the seller.
614     //
615     // @dev This is based on the ERC827 function approveAndCall and avoids
616     // @dev security issues by only working with a whitelisted set of _spender
617     // @dev addresses. The other difference is that the combination of this
618     // @dev function ensures that the proxied function call receives the
619     // @dev msg.sender for this function as its first parameter.
620     //
621     // @param _spender The address that will spend the funds.
622     // @param _value The amount of tokens to be spent.
623     // @param _selector Function selector for function to be called.
624     // @param _callParams Packed, encoded parameters, omitting the first parameter which is always msg.sender
625     function approveAndCallWithSender(
626         address _spender,
627         uint256 _value,
628         bytes4 _selector,
629         bytes _callParams
630     )
631         public
632         payable
633         returns (bool)
634     {
635         require(_spender != address(this), "token contract can't be approved");
636         require(callSpenderWhitelist[_spender], "spender not in whitelist");
637 
638         require(super.approve(_spender, _value), "approve failed");
639 
640         bytes memory callData = abi.encodePacked(_selector, uint256(msg.sender), _callParams);
641         // solium-disable-next-line security/no-call-value
642         require(_spender.call.value(msg.value)(callData), "proxied call failed");
643         return true;
644     }
645 }