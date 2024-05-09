1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164     uint oldValue = allowed[msg.sender][_spender];
165     if (_subtractedValue > oldValue) {
166       allowed[msg.sender][_spender] = 0;
167     } else {
168       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169     }
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174 }
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182   address public owner;
183 
184 
185   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187 
188   /**
189    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190    * account.
191    */
192   function Ownable() public {
193     owner = msg.sender;
194   }
195 
196 
197   /**
198    * @dev Throws if called by any account other than the owner.
199    */
200   modifier onlyOwner() {
201     require(msg.sender == owner);
202     _;
203   }
204 
205 
206   /**
207    * @dev Allows the current owner to transfer control of the contract to a newOwner.
208    * @param newOwner The address to transfer ownership to.
209    */
210   function transferOwnership(address newOwner) public onlyOwner {
211     require(newOwner != address(0));
212     OwnershipTransferred(owner, newOwner);
213     owner = newOwner;
214   }
215 
216 }
217 
218 /**
219  * @title Mintable token
220  * @dev Simple ERC20 Token example, with mintable token creation
221  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
222  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
223  */
224 
225 contract MintableToken is StandardToken, Ownable {
226   event Mint(address indexed to, uint256 amount);
227   event MintFinished();
228 
229   bool public mintingFinished = false;
230 
231 
232   modifier canMint() {
233     require(!mintingFinished);
234     _;
235   }
236 
237   /**
238    * @dev Function to mint tokens
239    * @param _to The address that will receive the minted tokens.
240    * @param _amount The amount of tokens to mint.
241    * @return A boolean that indicates if the operation was successful.
242    */
243   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
244     totalSupply = totalSupply.add(_amount);
245     balances[_to] = balances[_to].add(_amount);
246     Mint(_to, _amount);
247     Transfer(address(0), _to, _amount);
248     return true;
249   }
250 
251   /**
252    * @dev Function to stop minting new tokens.
253    * @return True if the operation was successful.
254    */
255   function finishMinting() onlyOwner canMint public returns (bool) {
256     mintingFinished = true;
257     MintFinished();
258     return true;
259   }
260 }
261 
262 /**
263  * @title Capped token
264  * @dev Mintable token with a token cap.
265  */
266 
267 contract CappedToken is MintableToken {
268 
269   uint256 public cap;
270 
271   function CappedToken(uint256 _cap) public {
272     require(_cap > 0);
273     cap = _cap;
274   }
275 
276   /**
277    * @dev Function to mint tokens
278    * @param _to The address that will receive the minted tokens.
279    * @param _amount The amount of tokens to mint.
280    * @return A boolean that indicates if the operation was successful.
281    */
282   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
283     require(totalSupply.add(_amount) <= cap);
284 
285     return super.mint(_to, _amount);
286   }
287 
288 }
289 
290 /**
291  * @title SafeERC20
292  * @dev Wrappers around ERC20 operations that throw on failure.
293  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
294  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
295  */
296 library SafeERC20 {
297   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
298     assert(token.transfer(to, value));
299   }
300 
301   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
302     assert(token.transferFrom(from, to, value));
303   }
304 
305   function safeApprove(ERC20 token, address spender, uint256 value) internal {
306     assert(token.approve(spender, value));
307   }
308 }
309 
310 /**
311  * @title TokenVesting
312  * @dev A token holder contract that can release its token balance gradually like a
313  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
314  * owner.
315  */
316 contract TokenVesting is Ownable {
317   using SafeMath for uint256;
318   using SafeERC20 for ERC20Basic;
319 
320   event Released(uint256 amount);
321   event Revoked();
322 
323   // beneficiary of tokens after they are released
324   address public beneficiary;
325 
326   uint256 public cliff;
327   uint256 public start;
328   uint256 public duration;
329 
330   bool public revocable;
331 
332   mapping (address => uint256) public released;
333   mapping (address => bool) public revoked;
334 
335   /**
336    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
337    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
338    * of the balance will have vested.
339    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
340    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
341    * @param _duration duration in seconds of the period in which the tokens will vest
342    * @param _revocable whether the vesting is revocable or not
343    */
344   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
345     require(_beneficiary != address(0));
346     require(_cliff <= _duration);
347 
348     beneficiary = _beneficiary;
349     revocable = _revocable;
350     duration = _duration;
351     cliff = _start.add(_cliff);
352     start = _start;
353   }
354 
355   /**
356    * @notice Transfers vested tokens to beneficiary.
357    * @param token ERC20 token which is being vested
358    */
359   function release(ERC20Basic token) public {
360     uint256 unreleased = releasableAmount(token);
361 
362     require(unreleased > 0);
363 
364     released[token] = released[token].add(unreleased);
365 
366     token.safeTransfer(beneficiary, unreleased);
367 
368     Released(unreleased);
369   }
370 
371   /**
372    * @notice Allows the owner to revoke the vesting. Tokens already vested
373    * remain in the contract, the rest are returned to the owner.
374    * @param token ERC20 token which is being vested
375    */
376   function revoke(ERC20Basic token) public onlyOwner {
377     require(revocable);
378     require(!revoked[token]);
379 
380     uint256 balance = token.balanceOf(this);
381 
382     uint256 unreleased = releasableAmount(token);
383     uint256 refund = balance.sub(unreleased);
384 
385     revoked[token] = true;
386 
387     token.safeTransfer(owner, refund);
388 
389     Revoked();
390   }
391 
392   /**
393    * @dev Calculates the amount that has already vested but hasn't been released yet.
394    * @param token ERC20 token which is being vested
395    */
396   function releasableAmount(ERC20Basic token) public view returns (uint256) {
397     return vestedAmount(token).sub(released[token]);
398   }
399 
400   /**
401    * @dev Calculates the amount that has already vested.
402    * @param token ERC20 token which is being vested
403    */
404   function vestedAmount(ERC20Basic token) public view returns (uint256) {
405     uint256 currentBalance = token.balanceOf(this);
406     uint256 totalBalance = currentBalance.add(released[token]);
407 
408     if (now < cliff) {
409       return 0;
410     } else if (now >= start.add(duration) || revoked[token]) {
411       return totalBalance;
412     } else {
413       return totalBalance.mul(now.sub(start)).div(duration);
414     }
415   }
416 }
417 
418 contract MonthlyTokenVesting is TokenVesting {
419 
420     uint256 public previousTokenVesting = 0;
421 
422     function MonthlyTokenVesting(
423         address _beneficiary,
424         uint256 _start,
425         uint256 _cliff,
426         uint256 _duration,
427         bool _revocable
428     ) public
429     TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable)
430     { }
431 
432 
433     function release(ERC20Basic token) public onlyOwner {
434         require(now >= previousTokenVesting + 30 days);
435         super.release(token);
436         previousTokenVesting = now;
437     }
438 }
439 
440 contract CREDToken is CappedToken {
441     using SafeMath for uint256;
442 
443     /**
444      * Constant fields
445      */
446 
447     string public constant name = "Verify Token";
448     uint8 public constant decimals = 18;
449     string public constant symbol = "CRED";
450 
451     /**
452      * Immutable state variables
453      */
454 
455     // Time when team and reserved tokens are unlocked
456     uint256 public reserveUnlockTime;
457 
458     address public teamWallet;
459     address public reserveWallet;
460     address public advisorsWallet;
461 
462     /**
463      * State variables
464      */
465 
466     uint256 teamLocked;
467     uint256 reserveLocked;
468     uint256 advisorsLocked;
469 
470     // Are the tokens non-transferrable?
471     bool public locked = true;
472 
473     // When tokens can be unfreezed.
474     uint256 public unfreezeTime = 0;
475 
476     bool public unlockedReserveAndTeamFunds = false;
477 
478     MonthlyTokenVesting public advisorsVesting = MonthlyTokenVesting(address(0));
479 
480     /**
481      * Events
482      */
483 
484     event MintLocked(address indexed to, uint256 amount);
485 
486     event Unlocked(address indexed to, uint256 amount);
487 
488     /**
489      * Modifiers
490      */
491 
492     // Tokens must not be locked.
493     modifier whenLiquid {
494         require(!locked);
495         _;
496     }
497 
498     modifier afterReserveUnlockTime {
499         require(now >= reserveUnlockTime);
500         _;
501     }
502 
503     modifier unlockReserveAndTeamOnce {
504         require(!unlockedReserveAndTeamFunds);
505         _;
506     }
507 
508     /**
509      * Constructor
510      */
511     function CREDToken(
512         uint256 _cap,
513         uint256 _yearLockEndTime,
514         address _teamWallet,
515         address _reserveWallet,
516         address _advisorsWallet
517     )
518     CappedToken(_cap)
519     public
520     {
521         require(_yearLockEndTime != 0);
522         require(_teamWallet != address(0));
523         require(_reserveWallet != address(0));
524         require(_advisorsWallet != address(0));
525 
526         reserveUnlockTime = _yearLockEndTime;
527         teamWallet = _teamWallet;
528         reserveWallet = _reserveWallet;
529         advisorsWallet = _advisorsWallet;
530     }
531 
532     // Mint a certain number of tokens that are locked up.
533     // _value has to be bounded not to overflow.
534     function mintAdvisorsTokens(uint256 _value) public onlyOwner canMint {
535         require(advisorsLocked == 0);
536         require(_value.add(totalSupply) <= cap);
537         advisorsLocked = _value;
538         MintLocked(advisorsWallet, _value);
539     }
540 
541     function mintTeamTokens(uint256 _value) public onlyOwner canMint {
542         require(teamLocked == 0);
543         require(_value.add(totalSupply) <= cap);
544         teamLocked = _value;
545         MintLocked(teamWallet, _value);
546     }
547 
548     function mintReserveTokens(uint256 _value) public onlyOwner canMint {
549         require(reserveLocked == 0);
550         require(_value.add(totalSupply) <= cap);
551         reserveLocked = _value;
552         MintLocked(reserveWallet, _value);
553     }
554 
555 
556     /// Finalise any minting operations. Resets the owner and causes normal tokens
557     /// to be frozen. Also begins the countdown for locked-up tokens.
558     function finalise() public onlyOwner {
559         require(reserveLocked > 0);
560         require(teamLocked > 0);
561         require(advisorsLocked > 0);
562 
563         advisorsVesting = new MonthlyTokenVesting(advisorsWallet, now, 92 days, 2 years, false);
564         mint(advisorsVesting, advisorsLocked);
565         finishMinting();
566 
567         owner = 0;
568         unfreezeTime = now + 1 weeks;
569     }
570 
571 
572     // Causes tokens to be liquid 1 week after the tokensale is completed
573     function unfreeze() public {
574         require(unfreezeTime > 0);
575         require(now >= unfreezeTime);
576         locked = false;
577     }
578 
579 
580     /// Unlock any now freeable tokens that are locked up for team and reserve accounts .
581     function unlockTeamAndReserveTokens() public whenLiquid afterReserveUnlockTime unlockReserveAndTeamOnce {
582         require(totalSupply.add(teamLocked).add(reserveLocked) <= cap);
583 
584         totalSupply = totalSupply.add(teamLocked).add(reserveLocked);
585         balances[teamWallet] = balances[teamWallet].add(teamLocked);
586         balances[reserveWallet] = balances[reserveWallet].add(reserveLocked);
587         teamLocked = 0;
588         reserveLocked = 0;
589         unlockedReserveAndTeamFunds = true;
590 
591         Transfer(address(0), teamWallet, teamLocked);
592         Transfer(address(0), reserveWallet, reserveLocked);
593         Unlocked(teamWallet, teamLocked);
594         Unlocked(reserveWallet, reserveLocked);
595     }
596 
597     function unlockAdvisorTokens() public whenLiquid {
598         advisorsVesting.release(this);
599     }
600 
601 
602     /**
603      * Methods overriding some OpenZeppelin functions to prevent calling them when token is not liquid.
604      */
605 
606     function transfer(address _to, uint256 _value) public whenLiquid returns (bool) {
607         return super.transfer(_to, _value);
608     }
609 
610     function transferFrom(address _from, address _to, uint256 _value) public whenLiquid returns (bool) {
611         return super.transferFrom(_from, _to, _value);
612     }
613 
614     function approve(address _spender, uint256 _value) public whenLiquid returns (bool) {
615         return super.approve(_spender, _value);
616     }
617 
618     function increaseApproval(address _spender, uint256 _addedValue) public whenLiquid returns (bool) {
619         return super.increaseApproval(_spender, _addedValue);
620     }
621 
622     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenLiquid returns (bool) {
623         return super.decreaseApproval(_spender, _subtractedValue);
624     }
625 
626 }