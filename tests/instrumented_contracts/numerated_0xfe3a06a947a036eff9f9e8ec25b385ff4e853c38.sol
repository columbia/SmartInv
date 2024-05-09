1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8   /**
9   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
10   */
11   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12     require(b <= a);
13     uint256 c = a - b;
14 
15     return c;
16   }
17 
18   /**
19   * @dev Adds two numbers, reverts on overflow.
20   */
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     require(c >= a);
24 
25     return c;
26   }
27 }
28 
29 /**
30  * @title ERC20Basic
31  * @dev Simpler version of ERC20 interface
32  * See https://github.com/ethereum/EIPs/issues/179
33  */
34 contract ERC20Basic {
35   function totalSupply() public view returns (uint256);
36   function balanceOf(address _who) public view returns (uint256);
37   function transfer(address _to, uint256 _value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 /**
42  * @title Basic token
43  * @dev Basic version of StandardToken, with no allowances.
44  */
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) internal balances;
49 
50   uint256 internal totalSupply_;
51 
52   /**
53   * @dev Total number of tokens in existence
54   */
55   function totalSupply() public view returns (uint256) {
56     return totalSupply_;
57   }
58 
59   /**
60   * @dev Transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_value <= balances[msg.sender]);
66     require(_to != address(0));
67 
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     emit Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of.
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) public view returns (uint256) {
80     return balances[_owner];
81   }
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address _owner, address _spender)
90     public view returns (uint256);
91 
92   function transferFrom(address _from, address _to, uint256 _value)
93     public returns (bool);
94 
95   function approve(address _spender, uint256 _value) public returns (bool);
96 
97   event Approval(
98     address indexed owner,
99     address indexed spender,
100     uint256 value
101   );
102 }
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * https://github.com/ethereum/EIPs/issues/20
109  */
110 contract StandardToken is ERC20, BasicToken {
111 
112   mapping (address => mapping (address => uint256)) internal allowed;
113 
114   /**
115    * @dev Transfer tokens from one address to another
116    * @param _from address The address which you want to send tokens from
117    * @param _to address The address which you want to transfer to
118    * @param _value uint256 the amount of tokens to be transferred
119    */
120   function transferFrom(
121     address _from,
122     address _to,
123     uint256 _value
124   )
125     public
126     returns (bool)
127   {
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130     require(_to != address(0));
131 
132     balances[_from] = balances[_from].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135     emit Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     emit Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(
161     address _owner,
162     address _spender
163    )
164     public
165     view
166     returns (uint256)
167   {
168     return allowed[_owner][_spender];
169   }
170 }
171 
172 /**
173  * @title Ownable
174  * @dev The Ownable contract has an owner address, and provides basic authorization control
175  * functions, this simplifies the implementation of "user permissions".
176  */
177 contract Ownable {
178   address public owner;
179 
180   event OwnershipTransferred(
181     address indexed previousOwner,
182     address indexed newOwner
183   );
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   constructor() public {
190     owner = msg.sender;
191   }
192 
193   /**
194    * @dev Throws if called by any account other than the owner.
195    */
196   modifier onlyOwner() {
197     require(msg.sender == owner);
198     _;
199   }
200 
201   /**
202    * @dev Allows the current owner to transfer control of the contract to a newOwner.
203    * @param _newOwner The address to transfer ownership to.
204    */
205   function transferOwnership(address _newOwner) public onlyOwner {
206     _transferOwnership(_newOwner);
207   }
208 
209   /**
210    * @dev Transfers control of the contract to a newOwner.
211    * @param _newOwner The address to transfer ownership to.
212    */
213   function _transferOwnership(address _newOwner) internal {
214     require(_newOwner != address(0));
215     emit OwnershipTransferred(owner, _newOwner);
216     owner = _newOwner;
217   }
218 }
219 
220 /**
221  * @title Claimable
222  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
223  * This allows the new owner to accept the transfer.
224  */
225 contract Claimable is Ownable {
226   address public pendingOwner;
227 
228   /**
229    * @dev Modifier throws if called by any account other than the pendingOwner.
230    */
231   modifier onlyPendingOwner() {
232     require(msg.sender == pendingOwner);
233     _;
234   }
235 
236   /**
237    * @dev Allows the current owner to set the pendingOwner address.
238    * @param newOwner The address to transfer ownership to.
239    */
240   function transferOwnership(address newOwner) public onlyOwner {
241     pendingOwner = newOwner;
242   }
243 
244   /**
245    * @dev Allows the pendingOwner address to finalize the transfer.
246    */
247   function claimOwnership() public onlyPendingOwner {
248     emit OwnershipTransferred(owner, pendingOwner);
249     owner = pendingOwner;
250     pendingOwner = address(0);
251   }
252 }
253 
254 /**
255  * @title Pausable
256  * @dev Base contract which allows children to implement an emergency stop mechanism.
257  */
258 contract Pausable is Claimable {
259   event Pause();
260   event Unpause();
261 
262   bool public paused = false;
263 
264   /**
265    * @dev Modifier to make a function callable only when the contract is not paused.
266    */
267   modifier whenNotPaused() {
268     require(!paused);
269     _;
270   }
271 
272   /**
273    * @dev Modifier to make a function callable only when the contract is paused.
274    */
275   modifier whenPaused() {
276     require(paused);
277     _;
278   }
279 
280   /**
281    * @dev called by the owner to pause, triggers stopped state
282    */
283   function pause() public onlyOwner whenNotPaused {
284     paused = true;
285     emit Pause();
286   }
287 
288   /**
289    * @dev called by the owner to unpause, returns to normal state
290    */
291   function unpause() public onlyOwner whenPaused {
292     paused = false;
293     emit Unpause();
294   }
295 }
296 
297 /**
298  * @title Pausable token
299  * @dev StandardToken modified with pausable transfers.
300  **/
301 contract PausableToken is StandardToken, Pausable {
302 
303   function transfer(
304     address _to,
305     uint256 _value
306   )
307     public
308     whenNotPaused
309     returns (bool)
310   {
311     return super.transfer(_to, _value);
312   }
313 
314   function transferFrom(
315     address _from,
316     address _to,
317     uint256 _value
318   )
319     public
320     whenNotPaused
321     returns (bool)
322   {
323     return super.transferFrom(_from, _to, _value);
324   }
325 
326   function approve(
327     address _spender,
328     uint256 _value
329   )
330     public
331     whenNotPaused
332     returns (bool)
333   {
334     return super.approve(_spender, _value);
335   }
336 }
337 
338 /**
339  * @title SafeERC20
340  * @dev Wrappers around ERC20 operations that throw on failure.
341  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
342  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
343  */
344 library SafeERC20 {
345   function safeTransfer(
346     ERC20Basic _token,
347     address _to,
348     uint256 _value
349   )
350     internal
351   {
352     require(_token.transfer(_to, _value));
353   }
354 
355   function safeTransferFrom(
356     ERC20 _token,
357     address _from,
358     address _to,
359     uint256 _value
360   )
361     internal
362   {
363     require(_token.transferFrom(_from, _to, _value));
364   }
365 
366   function safeApprove(
367     ERC20 _token,
368     address _spender,
369     uint256 _value
370   )
371     internal
372   {
373     require(_token.approve(_spender, _value));
374   }
375 }
376 
377 /**
378  * @title JZMLock
379  * @author http://jzm.one
380  * @dev JZMLock is a token holder contract that will allow a
381  * beneficiary to extract the tokens after a given release time
382  */
383 contract JZMLock {
384   using SafeERC20 for ERC20Basic;
385 
386   // ERC20 basic token contract being held
387   ERC20Basic public token;
388 
389   // beneficiary of tokens after they are released
390   address public beneficiary;
391 
392   // timestamp when token release is enabled
393   uint256 public releaseTime;
394 
395   constructor(
396     ERC20Basic _token,
397     address _beneficiary,
398     uint256 _releaseTime
399   )
400     public
401   {
402     // solium-disable-next-line security/no-block-members
403     require(_releaseTime > block.timestamp);
404     token = _token;
405     beneficiary = _beneficiary;
406     releaseTime = _releaseTime;
407   }
408 
409   /**
410    * @notice Transfers tokens held by JZMLock to beneficiary.
411    */
412   function release() public {
413     // solium-disable-next-line security/no-block-members
414     require(block.timestamp >= releaseTime);
415     uint256 amount = token.balanceOf(address(this));
416     require(amount > 0);
417     token.safeTransfer(beneficiary, amount);
418   }
419   
420   function canRelease() public view returns (bool){
421     return block.timestamp >= releaseTime;
422   }
423 }
424 
425 /**
426  * @title JZMToken
427  * @author http://jzm.one
428  * @dev JZMToken is a token that provide lock function
429  */
430 contract JZMToken is PausableToken {
431 
432     event TransferWithLock(address indexed from, address indexed to, address indexed locked, uint256 amount, uint256 releaseTime);
433     
434     mapping (address => address[] ) public balancesLocked;
435 
436     function transferWithLock(address _to, uint256 _amount, uint256 _releaseTime) public returns (bool) {
437         JZMLock lock = new JZMLock(this, _to, _releaseTime);
438         transfer(address(lock), _amount);
439         balancesLocked[_to].push(lock);
440         emit TransferWithLock(msg.sender, _to, address(lock), _amount, _releaseTime);
441         return true;
442     }
443 
444     /**
445      * @dev Gets the locked balance of the specified address.
446      * @param _owner The address to query the locked balance of.
447      * @return An uint256 representing the amount owned by the passed address.
448      */
449     function balanceOfLocked(address _owner) public view returns (uint256) {
450         address[] memory lockTokenAddrs = balancesLocked[_owner];
451 
452         uint256 totalLockedBalance = 0;
453         for (uint i = 0; i < lockTokenAddrs.length; i++) {
454             totalLockedBalance = totalLockedBalance.add(balances[lockTokenAddrs[i]]);
455         }
456         
457         return totalLockedBalance;
458     }
459 
460     function releaseToken(address _owner) public returns (bool) {
461         address[] memory lockTokenAddrs = balancesLocked[_owner];
462         for (uint i = 0; i < lockTokenAddrs.length; i++) {
463             JZMLock lock = JZMLock(lockTokenAddrs[i]);
464             if (lock.canRelease() && balanceOf(lock)>0) {
465                 lock.release();
466             }
467         }
468         return true;
469     }
470 }
471 
472 /**
473  * @title TUToken
474  * @dev Trust Union Token Contract
475  */
476 contract TUToken is JZMToken {
477     using SafeMath for uint256;
478 
479     string public constant name = "Trust Union";
480     string public constant symbol = "TUT";
481     uint8 public constant decimals = 18;
482 
483     uint256 private constant TOKEN_UNIT = 10 ** uint256(decimals);
484     uint256 private constant INITIAL_SUPPLY = (10 ** 9) * TOKEN_UNIT;
485 
486     //init wallet address
487     address private constant ADDR_MARKET          = 0xEd3998AA7F255Ade06236776f9FD429eECc91357;
488     address private constant ADDR_FOUNDTEAM       = 0x1867812567f42e2Da3C572bE597996B1309593A7;
489     address private constant ADDR_ECO             = 0xF7549be7449aA2b7D708d39481fCBB618C9Fb903;
490     address private constant ADDR_PRIVATE_SALE    = 0x252c4f77f1cdCCEBaEBbce393804F4c8f3D5703D;
491     address private constant ADDR_SEED_INVESTOR   = 0x03a59D08980A5327a958860e346d020ec8bb33dC;
492     address private constant ADDR_FOUNDATION      = 0xC138d62b3E34391964852Cf712454492DC7eFF68;
493 
494     //init supply for market = 5%
495     uint256 private constant S_MARKET_TOTAL = INITIAL_SUPPLY * 5 / 100;
496     uint256 private constant S_MARKET_20181030 = 5000000  * TOKEN_UNIT;
497     uint256 private constant S_MARKET_20190130 = 10000000 * TOKEN_UNIT;
498     uint256 private constant S_MARKET_20190430 = 15000000 * TOKEN_UNIT;
499     uint256 private constant S_MARKET_20190730 = 20000000 * TOKEN_UNIT;
500 
501     //init supply for founding team = 15%
502     uint256 private constant S_FOUNDTEAM_TOTAL = INITIAL_SUPPLY * 15 / 100;
503     uint256 private constant S_FOUNDTEAM_20191030 = INITIAL_SUPPLY * 5 / 100;
504     uint256 private constant S_FOUNDTEAM_20200430 = INITIAL_SUPPLY * 5 / 100;
505     uint256 private constant S_FOUNDTEAM_20201030 = INITIAL_SUPPLY * 5 / 100;
506 
507     //init supply for ecological incentive = 40%
508     uint256 private constant S_ECO_TOTAL = INITIAL_SUPPLY * 40 / 100;
509     uint256 private constant S_ECO_20190401 = 45000000 * TOKEN_UNIT;
510     uint256 private constant S_ECO_20191001 = 45000000 * TOKEN_UNIT;
511     uint256 private constant S_ECO_20200401 = 40000000 * TOKEN_UNIT;
512     uint256 private constant S_ECO_20201001 = 40000000 * TOKEN_UNIT;
513     uint256 private constant S_ECO_20210401 = 35000000 * TOKEN_UNIT;
514     uint256 private constant S_ECO_20211001 = 35000000 * TOKEN_UNIT;
515     uint256 private constant S_ECO_20220401 = 30000000 * TOKEN_UNIT;
516     uint256 private constant S_ECO_20221001 = 30000000 * TOKEN_UNIT;
517     uint256 private constant S_ECO_20230401 = 25000000 * TOKEN_UNIT;
518     uint256 private constant S_ECO_20231001 = 25000000 * TOKEN_UNIT;
519     uint256 private constant S_ECO_20240401 = 25000000 * TOKEN_UNIT;
520     uint256 private constant S_ECO_20241001 = 25000000 * TOKEN_UNIT;
521 
522     //init supply for private sale = 10%
523     uint256 private constant S_PRIVATE_SALE = INITIAL_SUPPLY * 10 / 100;
524 
525     //init supply for seed investor = 10%
526     uint256 private constant S_SEED_INVESTOR = INITIAL_SUPPLY * 10 / 100;
527 
528     //init supply for foundation = 20%
529     uint256 private constant S_FOUNDATION = INITIAL_SUPPLY * 20 / 100;
530     
531     constructor() public {
532         totalSupply_ = INITIAL_SUPPLY;
533         balances[owner] = totalSupply_;
534 
535         _initWallet();
536         _invokeLockLogic();
537     }
538 
539     /**
540      * @dev init the wallets
541      */
542     function _initWallet() internal onlyOwner {
543         transfer(ADDR_PRIVATE_SALE, S_PRIVATE_SALE);
544         transfer(ADDR_SEED_INVESTOR, S_SEED_INVESTOR);
545         transfer(ADDR_FOUNDATION, S_FOUNDATION);
546     }
547 
548     /**
549      * @dev invoke lock logic
550      */
551     function _invokeLockLogic() internal onlyOwner {
552         //lock for market
553         //2018/10/30 0:00:00 UTC +8
554         transferWithLock(ADDR_MARKET, S_MARKET_20181030, 1540828800);
555         //2019/01/30 0:00:00 UTC +8
556         transferWithLock(ADDR_MARKET, S_MARKET_20190130, 1548777600); 
557         //2019/04/30 0:00:00 UTC +8     
558         transferWithLock(ADDR_MARKET, S_MARKET_20190430, 1556553600);
559         //2019/07/30 0:00:00 UTC +8
560         transferWithLock(ADDR_MARKET, S_MARKET_20190730, 1564416000);
561         
562         //lock for found team
563         //2019/10/30 0:00:00 UTC +8
564         transferWithLock(ADDR_FOUNDTEAM, S_FOUNDTEAM_20191030, 1572364800);
565         //2020/04/30 0:00:00 UTC +8
566         transferWithLock(ADDR_FOUNDTEAM, S_FOUNDTEAM_20200430, 1588176000);
567         //2020/10/30 0:00:00 UTC +8
568         transferWithLock(ADDR_FOUNDTEAM, S_FOUNDTEAM_20201030, 1603987200);
569         
570         //lock for eco
571         //2019/04/01 0:00:00 UTC +8
572         transferWithLock(ADDR_ECO, S_ECO_20190401, 1554048000);
573         //2019/10/01 0:00:00 UTC +8
574         transferWithLock(ADDR_ECO, S_ECO_20191001, 1569859200);
575         //2020/04/01 0:00:00 UTC +8
576         transferWithLock(ADDR_ECO, S_ECO_20200401, 1585670400);
577         //2020/10/01 0:00:00 UTC +8
578         transferWithLock(ADDR_ECO, S_ECO_20201001, 1601481600);
579         //2021/04/01 0:00:00 UTC +8
580         transferWithLock(ADDR_ECO, S_ECO_20210401, 1617206400);
581         //2021/10/01 0:00:00 UTC +8
582         transferWithLock(ADDR_ECO, S_ECO_20211001, 1633017600);
583         //2022/04/01 0:00:00 UTC +8
584         transferWithLock(ADDR_ECO, S_ECO_20220401, 1648742400);
585         //2022/10/01 0:00:00 UTC +8
586         transferWithLock(ADDR_ECO, S_ECO_20221001, 1664553600);
587         //2023/04/01 0:00:00 UTC +8
588         transferWithLock(ADDR_ECO, S_ECO_20230401, 1680278400);
589         //2023/10/01 0:00:00 UTC +8
590         transferWithLock(ADDR_ECO, S_ECO_20231001, 1696089600);
591         //2024/04/01 0:00:00 UTC +8
592         transferWithLock(ADDR_ECO, S_ECO_20240401, 1711900800);
593         //2024/10/01 0:00:00 UTC +8
594         transferWithLock(ADDR_ECO, S_ECO_20241001, 1727712000);
595     }
596 }