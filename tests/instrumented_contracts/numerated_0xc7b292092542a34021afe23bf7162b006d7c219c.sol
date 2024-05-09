1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * See https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address _who) public view returns (uint256);
61   function transfer(address _to, uint256 _value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) internal balances;
73 
74   uint256 internal totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_value <= balances[msg.sender]);
90     require(_to != address(0));
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address _owner, address _spender)
115     public view returns (uint256);
116 
117   function transferFrom(address _from, address _to, uint256 _value)
118     public returns (bool);
119 
120   function approve(address _spender, uint256 _value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156     require(_to != address(0));
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue >= oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title SafeERC20
249  * @dev Wrappers around ERC20 operations that throw on failure.
250  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
251  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
252  */
253 library SafeERC20 {
254   function safeTransfer(
255     ERC20Basic _token,
256     address _to,
257     uint256 _value
258   )
259     internal
260   {
261     require(_token.transfer(_to, _value));
262   }
263 
264   function safeTransferFrom(
265     ERC20 _token,
266     address _from,
267     address _to,
268     uint256 _value
269   )
270     internal
271   {
272     require(_token.transferFrom(_from, _to, _value));
273   }
274 
275   function safeApprove(
276     ERC20 _token,
277     address _spender,
278     uint256 _value
279   )
280     internal
281   {
282     require(_token.approve(_spender, _value));
283   }
284 }
285 
286 /**
287  * @title TokenTimelock
288  * @dev TokenTimelock is a token holder contract that will allow a
289  * beneficiary to extract the tokens after a given release time
290  */
291 contract TokenTimelock {
292   using SafeERC20 for ERC20Basic;
293 
294   // ERC20 basic token contract being held
295   ERC20Basic public token;
296 
297   // beneficiary of tokens after they are released
298   address public beneficiary;
299 
300   // timestamp when token release is enabled
301   uint256 public releaseTime;
302 
303   constructor(
304     ERC20Basic _token,
305     address _beneficiary,
306     uint256 _releaseTime
307   )
308     public
309   {
310     // solium-disable-next-line security/no-block-members
311     require(_releaseTime > block.timestamp);
312     token = _token;
313     beneficiary = _beneficiary;
314     releaseTime = _releaseTime;
315   }
316 
317   /**
318    * @notice Transfers tokens held by timelock to beneficiary.
319    */
320   function release() public {
321     // solium-disable-next-line security/no-block-members
322     require(block.timestamp >= releaseTime);
323 
324     uint256 amount = token.balanceOf(address(this));
325     require(amount > 0);
326 
327     token.safeTransfer(beneficiary, amount);
328   }
329 }
330 
331 /**
332  * @title Ownable
333  * @dev The Ownable contract has an owner address, and provides basic authorization control
334  * functions, this simplifies the implementation of "user permissions".
335  */
336 contract Ownable {
337   address public owner;
338 
339 
340   event OwnershipRenounced(address indexed previousOwner);
341   event OwnershipTransferred(
342     address indexed previousOwner,
343     address indexed newOwner
344   );
345 
346 
347   /**
348    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
349    * account.
350    */
351   constructor() public {
352     owner = msg.sender;
353   }
354 
355   /**
356    * @dev Throws if called by any account other than the owner.
357    */
358   modifier onlyOwner() {
359     require(msg.sender == owner);
360     _;
361   }
362 
363   /**
364    * @dev Allows the current owner to relinquish control of the contract.
365    * @notice Renouncing to ownership will leave the contract without an owner.
366    * It will not be possible to call the functions with the `onlyOwner`
367    * modifier anymore.
368    */
369   function renounceOwnership() public onlyOwner {
370     emit OwnershipRenounced(owner);
371     owner = address(0);
372   }
373 
374   /**
375    * @dev Allows the current owner to transfer control of the contract to a newOwner.
376    * @param _newOwner The address to transfer ownership to.
377    */
378   function transferOwnership(address _newOwner) public onlyOwner {
379     _transferOwnership(_newOwner);
380   }
381 
382   /**
383    * @dev Transfers control of the contract to a newOwner.
384    * @param _newOwner The address to transfer ownership to.
385    */
386   function _transferOwnership(address _newOwner) internal {
387     require(_newOwner != address(0));
388     emit OwnershipTransferred(owner, _newOwner);
389     owner = _newOwner;
390   }
391 }
392 
393 /**
394  * @title DiscoperiTokenVesting
395  * @dev DiscoperiTokenVesting mixin that gives possibility for token holders to have vested amounts of tokens on their balances. 
396  * Token should check a balance spot for transfer and transferFrom functions to use this feature.
397  */
398 contract DiscoperiTokenVesting {
399     using SafeMath for uint256;  
400 
401     // vesting parts count
402     uint256 public constant VESTING_PARTS = 4;
403 
404     // vesting releases timestamps
405     uint256[VESTING_PARTS] public vestingReleases;
406 
407     // list of vested amounts by beneficiary
408     mapping (address => uint256) public vestedAmount;
409     
410     // vesting event logging
411     event Vesting(address indexed to, uint256 amount);    
412 
413     /**
414      * @dev Find out if the address has vested amounts
415      * @param _who address Address checked for vested amounts
416      * @return bool Returns true if address has vested amounts     
417      */  
418     function hasVested(address _who) public view returns (bool) {
419         return balanceVested(_who) > 0;
420     }
421 
422     /**
423      * @dev Get balance vested to the current moment of time
424      * @param _who address Address owns vested amounts
425      * @return uint256 Balance vested to the current moment of time     
426      */       
427     function balanceVested(address _who) public view returns (uint256) {
428         for (uint256 i = 0; i < VESTING_PARTS; i++) {
429             if (now < vestingReleases[i]) // solium-disable-line security/no-block-members
430                return vestedAmount[_who].mul(VESTING_PARTS - i).div(VESTING_PARTS);
431         }
432     } 
433  
434     /**
435      * @dev Make vesting for the amount using contract with vesting rules
436      * @param _who address Address gets the vested amount
437      * @param _amount uint256 Amount to vest
438      */ 
439     function _vest(address _who, uint256 _amount) internal {
440         require(_who != address(0), "Vesting target address can't be zero.");
441         require(_amount > 0, "Vesting amount should be > 0.");
442         vestedAmount[_who] = vestedAmount[_who].add(_amount);
443         emit Vesting(_who, _amount);
444     }        
445 }
446 
447 /**
448  * @title DiscoperiTokenLockup
449  * @dev This contract gives possibility for token holders to have locked up (till release time) amounts of tokens on their balances. 
450  */
451 contract DiscoperiTokenLockup {
452     using SafeMath for uint256;  
453 
454     // LockedUp struct
455     struct LockedUp {
456         uint256 amount; // lockedup amount
457         uint256 release; // release timestamp
458     }
459 
460     // list of lockedup amounts and release timestamps
461     mapping (address => LockedUp[]) public lockedup;
462 
463     // lockup event logging
464     event Lockup(address indexed to, uint256 amount, uint256 release);
465 
466     /**
467      * @dev Find out if the address has locked up amounts
468      * @param _who address Address checked for lockedup amounts
469      * @return bool Returns true if address has lockedup amounts     
470      */    
471     function hasLockedUp(address _who) public view returns (bool) {
472         return balanceLockedUp(_who) > 0;
473     }    
474 
475     /**
476      * @dev Get balance locked up to the current moment of time
477      * @param _who address Address owns lockedup amounts
478      * @return uint256 Balance locked up to the current moment of time     
479      */       
480     function balanceLockedUp(address _who) public view returns (uint256) {
481         uint256 _balanceLockedUp = 0;
482         for (uint256 i = 0; i < lockedup[_who].length; i++) {
483             if (lockedup[_who][i].release > block.timestamp) // solium-disable-line security/no-block-members
484                 _balanceLockedUp = _balanceLockedUp.add(lockedup[_who][i].amount);
485         }
486         return _balanceLockedUp;
487     }    
488     
489     /**
490      * @dev Lockup amount till release time
491      * @param _who address Address gets the lockedup amount
492      * @param _amount uint256 Amount to lockup
493      * @param _release uint256 Release timestamp     
494      */     
495     function _lockup(address _who, uint256 _amount, uint256 _release) internal {
496         if (_release != 0) {
497             require(_who != address(0), "Lockup target address can't be zero.");
498             require(_amount > 0, "Lockup amount should be > 0.");   
499             require(_release > block.timestamp, "Lockup release time should be > now."); // solium-disable-line security/no-block-members 
500             lockedup[_who].push(LockedUp(_amount, _release));
501             emit Lockup(_who, _amount, _release);
502         }
503     }      
504 
505 }
506 
507 /**
508  * @title IDiscoperiSale
509  * @dev IDiscoperiSale is a ..
510  */
511 contract IDiscoperiSale {
512     
513     /**
514      * @dev Order tokens for beneficiary
515      * @param _collector  collector id
516      * @param _tx hash of the transaction
517      * @param _beneficiary beneficiary who has paid coins for tokens
518      * @param _funds amount of coins beneficiary has paid 
519      */
520     function acquireTokens(uint256 _collector, uint256 _tx, address _beneficiary, uint256 _funds) external payable;
521 
522 }
523 
524 /**
525  * @title IDiscoperiToken
526  * @dev IDiscoperiToken is a ..
527  */
528 contract IDiscoperiToken {
529 
530     /**
531      * @dev Burn tokens from sale contract
532      */
533     function burnSaleTokens() external;
534 
535      /**
536      * @dev Transfer tokens from one address to another with westing
537      * @param _to address which you want to transfer to
538      * @param _value the amount of tokens to be transferred
539      * @return true if the transfer was succeeded
540      */
541     function transferWithVesting(address _to, uint256 _value) external returns (bool); 
542 
543 }
544 
545 /**
546  * @title DiscoperiToken
547  * @dev Discoperi Token contract
548  */
549 contract DiscoperiToken is  
550     IDiscoperiToken,
551     StandardToken, 
552     Ownable,
553     DiscoperiTokenLockup,
554     DiscoperiTokenVesting
555 {
556     using SafeMath for uint256;
557 
558     // token constants
559     string public constant name = "Discoperi Token"; // solium-disable-line uppercase
560     string public constant symbol = "DISC"; // solium-disable-line uppercase
561     uint8 public constant decimals = 18; // solium-disable-line uppercase
562 
563     // total tokens supply
564     uint256 public constant TOTAL_SUPPLY = 200000000000 * (10 ** uint256(decimals)); // 200,000,000,000 DISCs
565 
566     // TOTAL_SUPPLY is distributed as follows
567     uint256 public constant SALES_SUPPLY = 50000000000 * (10 ** uint256(decimals)); // 50,000,000,000 DISCs - 25%
568     uint256 public constant INVESTORS_SUPPLY = 50000000000 * (10 ** uint256(decimals)); // 50,000,000,000 DISCs - 25%
569     uint256 public constant TEAM_SUPPLY = 30000000000 * (10 ** uint256(decimals)); // 30,000,000,000 DISCs - 15%
570     uint256 public constant RESERVE_SUPPLY = 22000000000 * (10 ** uint256(decimals)); // 22,000,000,000 DISCs - 11%
571     uint256 public constant MARKET_DEV_SUPPLY = 20000000000 * (10 ** uint256(decimals)); // 20,000,000,000 DISCs - 10%    
572     uint256 public constant PR_ADVERSTISING_SUPPLY = 15000000000 * (10 ** uint256(decimals)); // 15,000,000,000 DISCs - 7.5%
573     uint256 public constant REFERRAL_SUPPLY = 8000000000 * (10 ** uint256(decimals)); // 8,000,000,000 DISCs - 4%
574     uint256 public constant ANGEL_INVESTORS_SUPPLY = 5000000000 * (10 ** uint256(decimals)); // 5,000,000,000 DISCs - 2.5%
575     
576     // fund wallets
577     address public constant MARKET_DEV_ADDRESS = 0x3f272f26C2322cB38781D0C6C42B1c2531Ec79Be;
578     address public constant TEAM_ADDRESS = 0xD8069C8c24D10023DBC5823156994aC2A638dBBd;
579     address public constant RESERVE_ADDRESS = 0x7656Cee371A812775A5E0Fb98a565Cc731aCC44B;
580     address public constant INVESTORS_ADDRESS= 0x25230591492198b6DD4363d03a7dAa5aD7590D2d;
581     address public constant PR_ADVERSTISING_ADDRESS = 0xC36d70AE6ddBE87F973bf4248Df52d0370FBb7E7;
582 
583     // sale address
584     address public sale;
585 
586     // restrict execution only for sale address
587     modifier onlySale() {
588         require(msg.sender == sale, "Attemp to execute by not sale address");
589         _;
590     }
591 
592     // restrict execution only for authorized address
593     modifier onlyLockupAuthorized() {
594         require(msg.sender == INVESTORS_ADDRESS, "Attemp to lockup tokens by not authorized address");
595         _;
596     }
597 
598     // check balance spot on transfer
599     modifier spotTransfer(address _from, uint256 _value) {
600         require(_value <= balanceSpot(_from), "Attempt to transfer more than balance spot");
601         _;
602     }
603 
604     // burn event
605     event Burn(address indexed burner, uint256 value);
606 
607     /**
608      * CONSTRUCTOR
609      * @dev Allocate investors tokens supply
610      */
611     constructor() public { 
612         balances[INVESTORS_ADDRESS] = balances[INVESTORS_ADDRESS].add(INVESTORS_SUPPLY);
613         totalSupply_ = totalSupply_.add(INVESTORS_SUPPLY);
614         emit Transfer(address(0), INVESTORS_ADDRESS, INVESTORS_SUPPLY);
615 
616         balances[INVESTORS_ADDRESS] = balances[INVESTORS_ADDRESS].add(ANGEL_INVESTORS_SUPPLY);
617         totalSupply_ = totalSupply_.add(ANGEL_INVESTORS_SUPPLY);
618         emit Transfer(address(0), INVESTORS_ADDRESS, ANGEL_INVESTORS_SUPPLY);
619     }
620 
621     /**
622      * @dev Initialize token contract and allocate tokens supply
623      * @param _sale address of the sale contract
624      * @param _teamRelease team tokens release timestamp
625      * @param _vestingFirstRelease first release timestamp of tokens vesting
626      * @param _vestingSecondRelease second release timestamp of tokens vesting
627      * @param _vestingThirdRelease third release timestamp of tokens vesting
628      * @param _vestingFourthRelease fourth release timestamp of tokens vesting
629      */
630     function init(
631         address _sale, 
632         uint256 _teamRelease, 
633         uint256 _vestingFirstRelease,
634         uint256 _vestingSecondRelease,
635         uint256 _vestingThirdRelease,
636         uint256 _vestingFourthRelease
637     ) 
638         external 
639         onlyOwner 
640     {
641         require(sale == address(0), "cannot execute init function twice");
642         require(_sale != address(0), "cannot set zero address as sale");
643         require(_teamRelease > now, "team tokens release date should be > now"); // solium-disable-line security/no-block-members
644         require(_vestingFirstRelease > now, "vesting first release date should be > now"); // solium-disable-line security/no-block-members
645         require(_vestingSecondRelease > now, "vesting second release date should be > now"); // solium-disable-line security/no-block-members
646         require(_vestingThirdRelease > now, "vesting third release date should be > now"); // solium-disable-line security/no-block-members
647         require(_vestingFourthRelease > now, "vesting fourth release date should be > now"); // solium-disable-line security/no-block-members
648 
649         sale = _sale;
650 
651         balances[sale] = balances[sale].add(SALES_SUPPLY);
652         totalSupply_ = totalSupply_.add(SALES_SUPPLY);
653         emit Transfer(address(0), sale, SALES_SUPPLY);
654 
655         balances[sale] = balances[sale].add(REFERRAL_SUPPLY);
656         totalSupply_ = totalSupply_.add(REFERRAL_SUPPLY);
657         emit Transfer(address(0), sale, REFERRAL_SUPPLY);
658 
659         TokenTimelock teamTimelock = new TokenTimelock(this, TEAM_ADDRESS, _teamRelease);
660         balances[teamTimelock] = balances[teamTimelock].add(TEAM_SUPPLY);
661         totalSupply_ = totalSupply_.add(TEAM_SUPPLY);
662         emit Transfer(address(0), teamTimelock, TEAM_SUPPLY);
663          
664         balances[MARKET_DEV_ADDRESS] = balances[MARKET_DEV_ADDRESS].add(MARKET_DEV_SUPPLY);
665         totalSupply_ = totalSupply_.add(MARKET_DEV_SUPPLY);
666         emit Transfer(address(0), MARKET_DEV_ADDRESS, MARKET_DEV_SUPPLY);
667 
668         balances[RESERVE_ADDRESS] = balances[RESERVE_ADDRESS].add(RESERVE_SUPPLY);
669         totalSupply_ = totalSupply_.add(RESERVE_SUPPLY);
670         emit Transfer(address(0), RESERVE_ADDRESS, RESERVE_SUPPLY);
671        
672         balances[PR_ADVERSTISING_ADDRESS] = balances[PR_ADVERSTISING_ADDRESS].add(PR_ADVERSTISING_SUPPLY);
673         totalSupply_ = totalSupply_.add(PR_ADVERSTISING_SUPPLY);
674         emit Transfer(address(0), PR_ADVERSTISING_ADDRESS, PR_ADVERSTISING_SUPPLY);
675 
676         vestingReleases[0] = _vestingFirstRelease;
677         vestingReleases[1] = _vestingSecondRelease;
678         vestingReleases[2] = _vestingThirdRelease;
679         vestingReleases[3] = _vestingFourthRelease;
680     }
681 
682     /**
683      * @dev Transfer tokens from one address to another with vesting
684      * @param _to address which you want to transfer to
685      * @param _value the amount of tokens to be transferred
686      * @return true if the transfer was succeeded
687      */
688     function transferWithVesting(address _to, uint256 _value) external onlySale returns (bool) {    
689         _vest(_to, _value);
690         return super.transfer(_to, _value);
691     }
692 
693     /**
694      * @dev Transfer  tokens from one address to another with locking up
695      * @param _to address which you want to transfer to
696      * @param _value the amount of tokens to be transferred
697      * @param _release the amount of tokens to be transferred
698      * @return true if the transfer was succeeded
699      */
700     function transferWithLockup(address _to, uint256 _value, uint256 _release) external onlyLockupAuthorized returns (bool) {    
701         _lockup(_to, _value, _release);
702         return super.transfer(_to, _value);
703     }
704 
705     /**
706      * @dev Burn all tokens, remaining on sale contract
707      */
708     function burnSaleTokens() external onlySale {
709         uint256 _amount = balances[sale];
710         balances[sale] = 0;
711         totalSupply_ = totalSupply_.sub(_amount);
712         emit Burn(sale, _amount);
713         emit Transfer(sale, address(0), _amount);        
714     }
715 
716     /**
717      * @dev Transfer tokens from one address to another
718      * @param _to address which you want to transfer to
719      * @param _value the amount of tokens to be transferred
720      * @return true if the transfer was succeeded
721      */
722     function transfer(address _to, uint256 _value) public spotTransfer(msg.sender, _value) returns (bool) {
723         return super.transfer(_to, _value);
724     }
725 
726     /**
727      * @dev Transfer tokens from one address to another
728      * @param _from the address which you want to send tokens from
729      * @param _to the address which you want to transfer to
730      * @param _value the amount of tokens to be transferred
731      * @return true if the transfer was succeeded
732      */
733     function transferFrom(address _from, address _to, uint256 _value) public spotTransfer(_from, _value) returns (bool) {    
734         return super.transferFrom(_from, _to, _value);
735     }
736 
737     /**
738      * @dev Get balance spot for the current moment of time
739      * @param _who address owns balance spot
740      * @return balance spot for the current moment of time     
741      */   
742     function balanceSpot(address _who) public view returns (uint256) {
743         return balanceOf(_who).sub(balanceVested(_who)).sub(balanceLockedUp(_who));
744     }     
745 
746 }