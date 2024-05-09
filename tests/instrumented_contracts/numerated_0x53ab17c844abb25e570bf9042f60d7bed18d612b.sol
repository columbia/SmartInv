1 pragma solidity ^0.4.24;
2 
3 /*
4     @title Provides support and utilities for contract ownership
5 */
6 contract Ownable {
7   address public owner;
8   address public newOwnerCandidate;
9 
10   event OwnerUpdate(address prevOwner, address newOwner);
11 
12   /*
13     @dev constructor
14   */
15   constructor() public {
16     owner = msg.sender;
17   }
18 
19   /*
20     @dev allows execution by the owner only
21   */
22   modifier ownerOnly {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /*
28     @dev allows transferring the contract ownership
29     the new owner still needs to accept the transfer
30     can only be called by the contract owner
31 
32     @param _newOwnerCandidate    new contract owner
33   */
34   function transferOwnership(address _newOwnerCandidate) public ownerOnly {
35     require(_newOwnerCandidate != address(0));
36     require(_newOwnerCandidate != owner);
37     newOwnerCandidate = _newOwnerCandidate;
38   }
39 
40   /*
41     @dev used by a new owner to accept an ownership transfer
42   */
43   function acceptOwnership() public {
44     require(msg.sender == newOwnerCandidate);
45     emit OwnerUpdate(owner, newOwnerCandidate);
46     owner = newOwnerCandidate;
47     newOwnerCandidate = address(0);
48   }
49 }
50 
51 /**
52  * @title SafeMath
53  * @dev Math operations with safety checks that revert on error
54  */
55 library SafeMath {
56 
57   /**
58   * @dev Multiplies two numbers, reverts on overflow.
59   */
60   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62     // benefit is lost if 'b' is also tested.
63     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64     if (a == 0) {
65       return 0;
66     }
67 
68     uint256 c = a * b;
69     require(c / a == b);
70 
71     return c;
72   }
73 
74   /**
75   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
76   */
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b > 0); // Solidity only automatically asserts when dividing by 0
79     uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81 
82     return c;
83   }
84 
85   /**
86   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
87   */
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     require(b <= a);
90     uint256 c = a - b;
91 
92     return c;
93   }
94 
95   /**
96   * @dev Adds two numbers, reverts on overflow.
97   */
98   function add(uint256 a, uint256 b) internal pure returns (uint256) {
99     uint256 c = a + b;
100     require(c >= a);
101 
102     return c;
103   }
104 
105   /**
106   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
107   * reverts when dividing by zero.
108   */
109   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
110     require(b != 0);
111     return a % b;
112   }
113 }
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 interface IERC20 {
120   function totalSupply() external view returns (uint256);
121 
122   function balanceOf(address who) external view returns (uint256);
123 
124   function allowance(address owner, address spender)
125     external view returns (uint256);
126 
127   function transfer(address to, uint256 value) external returns (bool);
128 
129   function approve(address spender, uint256 value)
130     external returns (bool);
131 
132   function transferFrom(address from, address to, uint256 value)
133     external returns (bool);
134 
135   event Transfer(
136     address indexed from,
137     address indexed to,
138     uint256 value
139   );
140 
141   event Approval(
142     address indexed owner,
143     address indexed spender,
144     uint256 value
145   );
146 }
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
153  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract ERC20 is IERC20 {
156   using SafeMath for uint256;
157 
158   mapping (address => uint256) internal _balances;
159 
160   mapping (address => mapping (address => uint256)) private _allowed;
161 
162   uint256 internal _totalSupply;
163 
164   /**
165   * @dev Total number of tokens in existence
166   */
167   function totalSupply() public view returns (uint256) {
168     return _totalSupply;
169   }
170 
171   /**
172   * @dev Gets the balance of the specified address.
173   * @param owner The address to query the balance of.
174   * @return An uint256 representing the amount owned by the passed address.
175   */
176   function balanceOf(address owner) public view returns (uint256) {
177     return _balances[owner];
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param owner address The address which owns the funds.
183    * @param spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address owner,
188     address spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return _allowed[owner][spender];
195   }
196 
197   /**
198   * @dev Transfer token for a specified address
199   * @param to The address to transfer to.
200   * @param value The amount to be transferred.
201   */
202   function transfer(address to, uint256 value) public returns (bool) {
203     _transfer(msg.sender, to, value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    * Beware that changing an allowance with this method brings the risk that someone may use both the old
210    * and the new allowance by unfortunate transaction ordering. In order to mitigate this
211    * race condition is we first check the spender's allowance to 0 and set the desired value afterwards:
212    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213    * @param spender The address which will spend the funds.
214    * @param value The amount of tokens to be spent.
215    */
216   function approve(address spender, uint256 value) public returns (bool) {
217     require(spender != address(0));
218 
219     // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
220     require(value == 0 || _allowed[msg.sender][spender] == 0);
221 
222     _allowed[msg.sender][spender] = value;
223     emit Approval(msg.sender, spender, value);
224     return true;
225   }
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param from address The address which you want to send tokens from
230    * @param to address The address which you want to transfer to
231    * @param value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(
234     address from,
235     address to,
236     uint256 value
237   )
238     public
239     returns (bool)
240   {
241     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
242     _transfer(from, to, value);
243     return true;
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    * approve should be called when allowed_[_spender] == 0. To increment
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param spender The address which will spend the funds.
253    * @param addedValue The amount of tokens to increase the allowance by.
254    */
255   function increaseAllowance(
256     address spender,
257     uint256 addedValue
258   )
259     public
260     returns (bool)
261   {
262     require(spender != address(0));
263 
264     _allowed[msg.sender][spender] = (
265       _allowed[msg.sender][spender].add(addedValue));
266     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
267     return true;
268   }
269 
270   /**
271    * @dev Decrease the amount of tokens that an owner allowed to a spender.
272    * approve should be called when allowed_[_spender] == 0. To decrement
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param spender The address which will spend the funds.
277    * @param subtractedValue The amount of tokens to decrease the allowance by.
278    */
279   function decreaseAllowance(
280     address spender,
281     uint256 subtractedValue
282   )
283     public
284     returns (bool)
285   {
286     require(spender != address(0));
287 
288     _allowed[msg.sender][spender] = (
289       _allowed[msg.sender][spender].sub(subtractedValue));
290     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
291     return true;
292   }
293 
294   /**
295   * @dev Transfer token for a specified addresses
296   * @param from The address to transfer from.
297   * @param to The address to transfer to.
298   * @param value The amount to be transferred.
299   */
300   function _transfer(address from, address to, uint256 value) internal {
301     require(to != address(0));
302 
303     _balances[from] = _balances[from].sub(value);
304     _balances[to] = _balances[to].add(value);
305     emit Transfer(from, to, value);
306   }
307 }
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
313  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
314  */
315 
316 contract MintableToken is ERC20, Ownable {
317   event Mint(address indexed to, uint256 amount);
318   event MintFinished();
319   event Burn(address indexed from, uint256 amount);
320 
321   bool public mintingFinished = false;
322 
323 
324   modifier canMint() {
325     require(!mintingFinished);
326     _;
327   }
328 
329   /**
330    * @dev Function to mint tokens
331    * @param to The address that will receive the minted tokens.
332    * @param amount The amount of tokens to mint.
333    * @return A boolean that indicates if the operation was successful.
334    */
335   function mint(address to, uint256 amount) public ownerOnly canMint returns (bool) {
336     require(to != address(0));
337     
338     _totalSupply = _totalSupply.add(amount);
339     _balances[to] = _balances[to].add(amount);
340     emit Mint(to, amount);
341     emit Transfer(address(0), to, amount);
342     return true;
343   }
344 
345     /**
346    * @dev Function to burn tokens
347    * @param from The address whose tokens will be burnt.
348    * @param amount The amount of tokens to burn.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function burn(address from, uint256 amount) public ownerOnly canMint returns (bool) {
352     require(from != address(0));
353 
354     _totalSupply = _totalSupply.sub(amount);
355     _balances[from] = _balances[from].sub(amount);
356     emit Burn(from, amount);
357     emit Transfer(from, address(0), amount);
358   }
359 
360   /**
361    * @dev Function to stop minting new tokens.
362    * @return True if the operation was successful.
363    */
364   function finishMinting() public ownerOnly canMint returns (bool) {
365     mintingFinished = true;
366     emit MintFinished();
367     return true;
368   }
369 }
370 
371 /**
372  * @title FreezableToken
373  * @dev LimitedTransferToken transfers start as disabled untill enabled by the contract owner
374  */
375 
376 contract FreezableToken is ERC20, Ownable {
377 
378   event TransfersEnabled();
379 
380   bool public allowTransfers = false;
381 
382   /**
383    * @dev Checks whether it can transfer or otherwise throws.
384    */
385   modifier canTransfer() {
386     require(allowTransfers || msg.sender == owner);
387     _;
388   }
389 
390   /**
391    * @dev Checks modifier and allows transfer if tokens are not locked.
392 
393    */
394   function enableTransfers() public ownerOnly {
395     allowTransfers = true;
396     emit TransfersEnabled();
397   }
398 
399   /**
400    * @dev Checks modifier and allows transfer if tokens are not locked.
401    * @param to The address that will receive the tokens.
402    * @param value The amount of tokens to be transferred.
403    */
404   function transfer(address to, uint256 value) public canTransfer returns (bool) {
405     return super.transfer(to, value);
406   }
407 
408   /**
409   * @dev Checks modifier and allows transfer if tokens are not locked.
410   * @param from The address that will send the tokens.
411   * @param to The address that will receive the tokens.
412   * @param value The amount of tokens to be transferred.
413   */
414   function transferFrom(address from, address to, uint256 value) public canTransfer returns (bool) {
415     return super.transferFrom(from, to, value);
416   }
417 }
418 
419 /**
420  * @title Capped token
421  * @dev Mintable token with a token cap.
422  */
423 contract CappedToken is MintableToken {
424 
425   uint256 public constant cap = 1000000000000000000000000000;
426 
427   /**
428    * @dev Function to mint tokens
429    * @param to The address that will receive the minted tokens.
430    * @param amount The amount of tokens to mint.
431    * @return A boolean that indicates if the operation was successful.
432    */
433   function mint(
434     address to,
435     uint256 amount
436   )
437     public
438     returns (bool)
439   {
440     require(_totalSupply.add(amount) <= cap);
441 
442     return super.mint(to, amount);
443   }
444 
445 }
446 
447 /**
448  * @title VeganCoin
449  * @dev Based on openzeppelin ERC20 token
450  */
451 contract VeganCoin is CappedToken, FreezableToken {
452 
453   string public name = "VeganCoin"; 
454   string public symbol = "VCN";
455   uint8 public decimals = 18;
456 }
457 
458 /// @title Vesting contract
459 contract VestingTrustee is Ownable {
460     using SafeMath for uint256;
461 
462     // The address of the VCN ERC20 token.
463     VeganCoin public veganCoin;
464 
465     struct Grant {
466         uint256 value;
467         uint256 start;
468         uint256 cliff;
469         uint256 end;
470         uint256 transferred;
471         bool revokable;
472     }
473 
474     // Grants holder.
475     mapping (address => Grant) public grants;
476 
477     // Total tokens available for vesting.
478     uint256 public totalVesting;
479 
480     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
481     event UnlockGrant(address indexed _holder, uint256 _value);
482     event RevokeGrant(address indexed _holder, uint256 _refund);
483 
484     /// @dev Constructor that initializes the address of the VeganCoin contract.
485     /// @param _veganCoin The address of the previously deployed VeganCoin smart contract.
486     constructor(VeganCoin _veganCoin) public {
487         require(_veganCoin != address(0));
488 
489         veganCoin = _veganCoin;
490     }
491 
492     /// @dev Grant tokens to a specified address.
493     /// @param _to address The address to grant tokens to.
494     /// @param _value uint256 The amount of tokens to be granted.
495     /// @param _start uint256 The beginning of the vesting period.
496     /// @param _cliff uint256 Duration of the cliff period.
497     /// @param _end uint256 The end of the vesting period.
498     /// @param _revokable bool Whether the grant is revokable or not.
499     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end, bool _revokable)
500         public ownerOnly {
501         require(_to != address(0));
502         require(_value > 0);
503 
504         // Make sure that a single address can be granted tokens only once.
505         require(grants[_to].value == 0);
506 
507         // Check for date inconsistencies that may cause unexpected behavior.
508         require(_start <= _cliff && _cliff <= _end);
509 
510         // Check that this grant doesn't exceed the total amount of tokens currently available for vesting.
511         require(totalVesting.add(_value) <= veganCoin.balanceOf(address(this)));
512 
513         // Assign a new grant.
514         grants[_to] = Grant({
515             value: _value,
516             start: _start,
517             cliff: _cliff,
518             end: _end,
519             transferred: 0,
520             revokable: _revokable
521         });
522 
523         // Tokens granted, reduce the total amount available for vesting.
524         totalVesting = totalVesting.add(_value);
525 
526         emit NewGrant(msg.sender, _to, _value);
527     }
528 
529     /// @dev Revoke the grant of tokens of a specifed address.
530     /// @param _holder The address which will have its tokens revoked.
531     function revoke(address _holder) public ownerOnly {
532         Grant storage grant = grants[_holder];
533 
534         require(grant.revokable);
535 
536         // Revoke the remaining VCN.
537         uint256 refund = grant.value.sub(grant.transferred);
538 
539         // Remove the grant.
540         delete grants[_holder];
541 
542         totalVesting = totalVesting.sub(refund);
543 
544         emit RevokeGrant(_holder, refund);
545     }
546 
547     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
548     /// @param _holder address The address of the holder.
549     /// @param _time uint256 The specific time.
550     /// @return a uint256 representing a holder's total amount of vested tokens.
551     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
552         Grant storage grant = grants[_holder];
553         if (grant.value == 0) {
554             return 0;
555         }
556 
557         return calculateVestedTokens(grant, _time);
558     }
559 
560     /// @dev Calculate amount of vested tokens at a specifc time.
561     /// @param _grant Grant The vesting grant.
562     /// @param _time uint256 The time to be checked
563     /// @return An uint256 representing the amount of vested tokens of a specific grant.
564     ///   |                         _/--------   vestedTokens rect
565     ///   |                       _/
566     ///   |                     _/
567     ///   |                   _/
568     ///   |                 _/
569     ///   |                /
570     ///   |              .|
571     ///   |            .  |
572     ///   |          .    |
573     ///   |        .      |
574     ///   |      .        |
575     ///   |    .          |
576     ///   +===+===========+---------+----------> time
577     ///     Start       Cliff      End
578     function calculateVestedTokens(Grant _grant, uint256 _time) private pure returns (uint256) {
579         // If we're before the cliff, then nothing is vested.
580         if (_time < _grant.cliff) {
581             return 0;
582         }
583 
584         // If we're after the end of the vesting period - everything is vested;
585         if (_time >= _grant.end) {
586             return _grant.value;
587         }
588 
589         // Interpolate all vested tokens: vestedTokens = tokens/// (time - start) / (end - start)
590          return _grant.value.mul(_time.sub(_grant.start)).div(_grant.end.sub(_grant.start));
591     }
592 
593     /// @dev Unlock vested tokens and transfer them to their holder.
594     /// @return a uint256 representing the amount of vested tokens transferred to their holder.
595     function unlockVestedTokens() public {
596         Grant storage grant = grants[msg.sender];
597         require(grant.value != 0);
598 
599         // Get the total amount of vested tokens, acccording to grant.
600         uint256 vested = calculateVestedTokens(grant, now);
601         if (vested == 0) {
602             return;
603         }
604 
605         // Make sure the holder doesn't transfer more than what he already has.
606         uint256 transferable = vested.sub(grant.transferred);
607         if (transferable == 0) {
608             return;
609         }
610 
611         grant.transferred = grant.transferred.add(transferable);
612         totalVesting = totalVesting.sub(transferable);
613         veganCoin.transfer(msg.sender, transferable);
614 
615         emit UnlockGrant(msg.sender, transferable);
616     }
617 }