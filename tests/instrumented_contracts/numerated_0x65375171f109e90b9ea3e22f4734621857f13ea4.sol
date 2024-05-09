1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72     address private _owner;
73 
74     event OwnershipTransferred(
75         address indexed previousOwner,
76         address indexed newOwner
77     );
78 
79     /**
80      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81      * account.
82      */
83     constructor() internal {
84         _owner = msg.sender;
85         emit OwnershipTransferred(address(0), _owner);
86     }
87 
88     /**
89      * @return the address of the owner.
90      */
91     function owner() public view returns(address) {
92         return _owner;
93     }
94 
95     /**
96      * @dev Throws if called by any account other than the owner.
97      */
98     modifier onlyOwner() {
99         require(isOwner());
100         _;
101     }
102 
103     /**
104      * @return true if `msg.sender` is the owner of the contract.
105      */
106     function isOwner() public view returns(bool) {
107         return msg.sender == _owner;
108     }
109 
110     /**
111      * @dev Allows the current owner to relinquish control of the contract.
112      * @notice Renouncing to ownership will leave the contract without an owner.
113      * It will not be possible to call the functions with the `onlyOwner`
114      * modifier anymore.
115      */
116     function renounceOwnership() public onlyOwner {
117         emit OwnershipTransferred(_owner, address(0));
118         _owner = address(0);
119     }
120 
121     /**
122      * @dev Allows the current owner to transfer control of the contract to a newOwner.
123      * @param newOwner The address to transfer ownership to.
124      */
125     function transferOwnership(address newOwner) public onlyOwner {
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers control of the contract to a newOwner.
131      * @param newOwner The address to transfer ownership to.
132      */
133     function _transferOwnership(address newOwner) internal {
134         require(newOwner != address(0));
135         emit OwnershipTransferred(_owner, newOwner);
136         _owner = newOwner;
137     }
138 }
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 interface IERC20 {
144     function totalSupply() external view returns (uint256);
145 
146     function balanceOf(address who) external view returns (uint256);
147 
148     function allowance(address owner, address spender)
149     external view returns (uint256);
150 
151     function transfer(address to, uint256 value) external returns (bool);
152 
153     function approve(address spender, uint256 value)
154     external returns (bool);
155 
156     function transferFrom(address from, address to, uint256 value)
157     external returns (bool);
158 
159     event Transfer(
160         address indexed from,
161         address indexed to,
162         uint256 value
163     );
164 
165     event Approval(
166         address indexed owner,
167         address indexed spender,
168         uint256 value
169     );
170 }
171 /**
172  * @title Roles
173  * @dev Library for managing addresses assigned to a Role.
174  */
175 library Roles {
176     struct Role {
177         mapping (address => bool) bearer;
178     }
179 
180     /**
181      * @dev give an account access to this role
182      */
183     function add(Role storage role, address account) internal {
184         require(account != address(0));
185         require(!has(role, account));
186 
187         role.bearer[account] = true;
188     }
189 
190     /**
191      * @dev remove an account's access to this role
192      */
193     function remove(Role storage role, address account) internal {
194         require(account != address(0));
195         require(has(role, account));
196 
197         role.bearer[account] = false;
198     }
199 
200     /**
201      * @dev check if an account has this role
202      * @return bool
203      */
204     function has(Role storage role, address account)
205     internal
206     view
207     returns (bool)
208     {
209         require(account != address(0));
210         return role.bearer[account];
211     }
212 }
213 contract MinterRole {
214     using Roles for Roles.Role;
215 
216     event MinterAdded(address indexed account);
217     event MinterRemoved(address indexed account);
218 
219     Roles.Role private minters;
220 
221     constructor() internal {
222         _addMinter(msg.sender);
223     }
224 
225     modifier onlyMinter() {
226         require(isMinter(msg.sender));
227         _;
228     }
229 
230     function isMinter(address account) public view returns (bool) {
231         return minters.has(account);
232     }
233 
234     function addMinter(address account) public onlyMinter {
235         _addMinter(account);
236     }
237 
238     function renounceMinter() public {
239         _removeMinter(msg.sender);
240     }
241 
242     function _addMinter(address account) internal {
243         minters.add(account);
244         emit MinterAdded(account);
245     }
246 
247     function _removeMinter(address account) internal {
248         minters.remove(account);
249         emit MinterRemoved(account);
250     }
251 }
252 
253 contract StandardERC20 is IERC20 {
254     using SafeMath for uint256;
255 
256     mapping (address => uint256) internal _balances;
257 
258     mapping (address => mapping (address => uint256)) private _allowed;
259 
260     uint256 private _totalSupply;
261     string private _name;
262     string private _symbol;
263     uint8 private _decimals;
264 
265     constructor(string name, string symbol, uint8 decimals) public {
266         _name = name;
267         _symbol = symbol;
268         _decimals = decimals;
269     }
270 
271     /**
272      * @return the name of the token.
273      */
274     function name() public view returns(string) {
275         return _name;
276     }
277 
278     /**
279      * @return the symbol of the token.
280      */
281     function symbol() public view returns(string) {
282         return _symbol;
283     }
284 
285     /**
286      * @return the number of decimals of the token.
287      */
288     function decimals() public view returns(uint8) {
289         return _decimals;
290     }
291     /**
292     * @dev Total number of tokens in existence
293     */
294     function totalSupply() public view returns (uint256) {
295         return _totalSupply;
296     }
297 
298     /**
299     * @dev Gets the balance of the specified address.
300     * @param owner The address to query the balance of.
301     * @return An uint256 representing the amount owned by the passed address.
302     */
303     function balanceOf(address owner) public view returns (uint256) {
304         return _balances[owner];
305     }
306 
307     /**
308      * @dev Function to check the amount of tokens that an owner allowed to a spender.
309      * @param owner address The address which owns the funds.
310      * @param spender address The address which will spend the funds.
311      * @return A uint256 specifying the amount of tokens still available for the spender.
312      */
313     function allowance(
314         address owner,
315         address spender
316     )
317     public
318     view
319     returns (uint256)
320     {
321         return _allowed[owner][spender];
322     }
323 
324     /**
325     * @dev Transfer token for a specified address
326     * @param to The address to transfer to.
327     * @param value The amount to be transferred.
328     */
329     function transfer(address to, uint256 value) public returns (bool) {
330         _transfer(msg.sender, to, value);
331         return true;
332     }
333 
334     /**
335      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
336      * Beware that changing an allowance with this method brings the risk that someone may use both the old
337      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
338      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
339      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
340      * @param spender The address which will spend the funds.
341      * @param value The amount of tokens to be spent.
342      */
343     function approve(address spender, uint256 value) public returns (bool) {
344         require(spender != address(0));
345 
346         _allowed[msg.sender][spender] = value;
347         emit Approval(msg.sender, spender, value);
348         return true;
349     }
350 
351     /**
352      * @dev Transfer tokens from one address to another
353      * @param from address The address which you want to send tokens from
354      * @param to address The address which you want to transfer to
355      * @param value uint256 the amount of tokens to be transferred
356      */
357     function transferFrom(
358         address from,
359         address to,
360         uint256 value
361     )
362     public
363     returns (bool)
364     {
365         require(value <= _allowed[from][msg.sender]);
366 
367         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
368         _transfer(from, to, value);
369         return true;
370     }
371 
372     /**
373      * @dev Increase the amount of tokens that an owner allowed to a spender.
374      * approve should be called when allowed_[_spender] == 0. To increment
375      * allowed value is better to use this function to avoid 2 calls (and wait until
376      * the first transaction is mined)
377      * From MonolithDAO Token.sol
378      * @param spender The address which will spend the funds.
379      * @param addedValue The amount of tokens to increase the allowance by.
380      */
381     function increaseAllowance(
382         address spender,
383         uint256 addedValue
384     )
385     public
386     returns (bool)
387     {
388         require(spender != address(0));
389 
390         _allowed[msg.sender][spender] = (
391         _allowed[msg.sender][spender].add(addedValue));
392         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
393         return true;
394     }
395 
396     /**
397      * @dev Decrease the amount of tokens that an owner allowed to a spender.
398      * approve should be called when allowed_[_spender] == 0. To decrement
399      * allowed value is better to use this function to avoid 2 calls (and wait until
400      * the first transaction is mined)
401      * From MonolithDAO Token.sol
402      * @param spender The address which will spend the funds.
403      * @param subtractedValue The amount of tokens to decrease the allowance by.
404      */
405     function decreaseAllowance(
406         address spender,
407         uint256 subtractedValue
408     )
409     public
410     returns (bool)
411     {
412         require(spender != address(0));
413 
414         _allowed[msg.sender][spender] = (
415         _allowed[msg.sender][spender].sub(subtractedValue));
416         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
417         return true;
418     }
419 
420     /**
421     * @dev Transfer token for a specified addresses
422     * @param from The address to transfer from.
423     * @param to The address to transfer to.
424     * @param value The amount to be transferred.
425     */
426     function _transfer(address from, address to, uint256 value) internal {
427         require(value <= _balances[from]);
428         require(to != address(0));
429 
430         _balances[from] = _balances[from].sub(value);
431         _balances[to] = _balances[to].add(value);
432         emit Transfer(from, to, value);
433     }
434 
435     /**
436      * @dev Internal function that mints an amount of the token and assigns it to
437      * an account. This encapsulates the modification of balances such that the
438      * proper events are emitted.
439      * @param account The account that will receive the created tokens.
440      * @param value The amount that will be created.
441      */
442     function _mint(address account, uint256 value) internal {
443         require(account != address(0));
444         _totalSupply = _totalSupply.add(value);
445         _balances[account] = _balances[account].add(value);
446         emit Transfer(address(0), account, value);
447     }
448 
449 }
450 
451 /**
452  * @title ERC20Mintable
453  * @dev ERC20 minting logic
454  */
455 contract ERC20Mintable is StandardERC20, MinterRole {
456 
457     constructor(string name, string symbol, uint8 decimals)
458     public
459     StandardERC20(name,symbol,decimals)
460     {
461     }
462     /**
463      * @dev Function to mint tokens
464      * @param to The address that will receive the minted tokens.
465      * @param value The amount of tokens to mint.
466      * @return A boolean that indicates if the operation was successful.
467      */
468     function mint(
469         address to,
470         uint256 value
471     )
472     public
473     onlyMinter
474     returns (bool)
475     {
476         _mint(to, value);
477         return true;
478     }
479 }
480 
481 /**
482  * @title Capped token
483  * @dev Mintable token with a token cap.
484  */
485 contract ERC20Capped is ERC20Mintable {
486 
487     uint256 private _cap;
488 
489     constructor(string name, string symbol, uint8 decimals,uint256 cap)
490     public
491     ERC20Mintable(name,symbol,decimals)
492     {
493         require(cap > 0);
494         _cap =  cap.mul(uint(10) **decimals);
495     }
496 
497     /**
498      * @return the cap for the token minting.
499      */
500     function cap() public view returns(uint256) {
501         return _cap;
502     }
503 
504     function _mint(address account, uint256 value) internal {
505         require(totalSupply().add(value) <= _cap);
506         super._mint(account, value);
507     }
508 }
509 
510 contract FSTToken is ERC20Capped {
511 
512     constructor(string name, string symbol, uint8 decimals,uint256 cap)
513     public
514     ERC20Capped(name,symbol,decimals,cap)
515     {
516 
517     }
518 
519 }
520 
521 contract FSTTokenAgentHolder is Ownable{
522 
523     using SafeMath for uint256;
524 
525     FSTToken private token ;
526 
527     uint256 public totalLockTokens;
528 
529     uint256 public totalUNLockTokens;
530     uint256 public globalLockPeriod;
531 
532     uint256 public totalUnlockNum=4;
533     mapping (address => HolderSchedule) public holderList;
534     address[] public holderAccountList=[0x0];
535 
536     uint256 private singleNodeTime;
537 
538     event ReleaseTokens(address indexed who,uint256 value);
539     event HolderToken(address indexed who,uint256 value,uint256 totalValue);
540 
541     struct HolderSchedule {
542         uint256 startAt;
543         uint256 lockAmount;
544         uint256 releasedAmount;
545         uint256 totalReleasedAmount;
546         uint256 lastUnlocktime;
547         bool isReleased;
548         bool isInvested;
549         uint256 unlockNumed;
550     }
551 
552     constructor(address _tokenAddress ,uint256 _globalLockPeriod,uint256 _totalUnlockNum) public{
553         token = FSTToken(_tokenAddress);
554         globalLockPeriod=_globalLockPeriod;
555         totalUnlockNum=_totalUnlockNum;
556         singleNodeTime=globalLockPeriod.div(totalUnlockNum);
557     }
558 
559     function addHolderToken(address _adr,uint256 _lockAmount) public onlyOwner {
560         HolderSchedule storage holderSchedule = holderList[_adr];
561         require(_lockAmount > 0);
562         _lockAmount=_lockAmount.mul(uint(10) **token.decimals());
563         if(holderSchedule.isInvested==false||holderSchedule.isReleased==true){
564             holderSchedule.isInvested=true;
565             holderSchedule.startAt = block.timestamp;
566             holderSchedule.lastUnlocktime=holderSchedule.startAt;
567             if(holderSchedule.isReleased==false){
568                 holderSchedule.releasedAmount=0;
569                 if(holderAccountList[0]==0x0){
570                     holderAccountList[0]=_adr;
571                 }else{
572                     holderAccountList.push(_adr);
573                 }
574             }
575         }
576         holderSchedule.isReleased = false;
577         holderSchedule.lockAmount=holderSchedule.lockAmount.add(_lockAmount);
578         totalLockTokens=totalLockTokens.add(_lockAmount);
579         emit HolderToken(_adr,_lockAmount,holderSchedule.lockAmount.add(holderSchedule.releasedAmount));
580     }
581 
582     function subHolderToken(address _adr,uint256 _lockAmount)public onlyOwner{
583         HolderSchedule storage holderSchedule = holderList[_adr];
584         require(_lockAmount > 0);
585         _lockAmount=_lockAmount.mul(uint(10) **token.decimals());
586         require(holderSchedule.lockAmount>=_lockAmount);
587         holderSchedule.lockAmount=holderSchedule.lockAmount.sub(_lockAmount);
588         totalLockTokens=totalLockTokens.sub(_lockAmount);
589         emit HolderToken(_adr,_lockAmount,holderSchedule.lockAmount.add(holderSchedule.releasedAmount));
590     }
591 
592     function accessToken(address rec,uint256 value) private {
593         totalUNLockTokens=totalUNLockTokens.add(value);
594         token.mint(rec,value);
595     }
596     function releaseMyTokens() public{
597         releaseTokens(msg.sender);
598     }
599 
600     function releaseTokens(address _adr) public{
601         require(_adr!=address(0));
602         HolderSchedule storage holderSchedule = holderList[_adr];
603         if(holderSchedule.isReleased==false&&holderSchedule.lockAmount>0){
604             uint256 unlockAmount=lockStrategy(_adr);
605             if(unlockAmount>0&&holderSchedule.lockAmount>=unlockAmount){
606                 holderSchedule.lockAmount=holderSchedule.lockAmount.sub(unlockAmount);
607                 holderSchedule.releasedAmount=holderSchedule.releasedAmount.add(unlockAmount);
608                 holderSchedule.totalReleasedAmount=holderSchedule.totalReleasedAmount.add(unlockAmount);
609                 holderSchedule.lastUnlocktime=block.timestamp;
610                 if(holderSchedule.lockAmount==0){
611                     holderSchedule.isReleased=true;
612                     holderSchedule.releasedAmount=0;
613                     holderSchedule.unlockNumed=0;
614                 }
615                 accessToken(_adr,unlockAmount);
616                 emit ReleaseTokens(_adr,unlockAmount);
617             }
618         }
619     }
620     function releaseEachTokens() public {
621         require(holderAccountList.length>0);
622         for(uint i=0;i<holderAccountList.length;i++){
623             HolderSchedule storage holderSchedule = holderList[holderAccountList[i]];
624             if(holderSchedule.lockAmount>0&&holderSchedule.isReleased==false){
625                 uint256 unlockAmount=lockStrategy(holderAccountList[i]);
626                 if(unlockAmount>0){
627                     holderSchedule.lockAmount=holderSchedule.lockAmount.sub(unlockAmount);
628                     holderSchedule.releasedAmount=holderSchedule.releasedAmount.add(unlockAmount);
629                     holderSchedule.totalReleasedAmount=holderSchedule.totalReleasedAmount.add(unlockAmount);
630                     holderSchedule.lastUnlocktime=block.timestamp;
631                     if(holderSchedule.lockAmount==0){
632                         holderSchedule.isReleased=true;
633                         holderSchedule.releasedAmount=0;
634                         holderSchedule.unlockNumed=0;
635                     }
636                     accessToken(holderAccountList[i],unlockAmount);
637                 }
638             }
639         }
640     }
641     function lockStrategy(address _adr) private returns(uint256){
642         HolderSchedule storage holderSchedule = holderList[_adr];
643         uint256 interval=block.timestamp.sub(holderSchedule.startAt);
644         uint256 unlockAmount=0;
645         if(interval>=singleNodeTime){
646             uint256 unlockNum=interval.div(singleNodeTime);
647             uint256 nextUnlockNum=unlockNum.sub(holderSchedule.unlockNumed);
648             if(nextUnlockNum>0){
649                 holderSchedule.unlockNumed=unlockNum;
650                 uint totalAmount=holderSchedule.lockAmount.add(holderSchedule.releasedAmount);
651                 uint singleAmount=totalAmount.div(totalUnlockNum);
652                 unlockAmount=singleAmount.mul(nextUnlockNum);
653                 if(unlockAmount>holderSchedule.lockAmount){
654                     unlockAmount=holderSchedule.lockAmount;
655                 }
656             }
657         }
658         return unlockAmount;
659     }
660 }