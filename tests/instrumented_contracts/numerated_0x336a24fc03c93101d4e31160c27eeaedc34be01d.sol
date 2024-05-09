1 pragma solidity >=0.4.24  <0.6.0;
2 /**
3  * @title ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/20
5  */
6 contract IERC20Token{
7 // these functions aren't abstract since the compiler emits automatically generated getter functions as external
8 function name() public view returns(string memory);
9 function symbol() public view returns(string memory);
10 function decimals() public view returns(uint256);
11 function totalSupply() public view returns (uint256);
12 function balanceOf(address _owner) public view returns (uint256);
13 function allowance(address _owner, address _spender) public view returns (uint256);
14 
15 function transfer(address _to, uint256 _value) public returns (bool success);
16 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17 function approve(address _spender, uint256 _value) public returns (bool success);
18  event Transfer(
19     address indexed from,
20     address indexed to,
21     uint256 value
22   );
23 
24   event Approval(
25     address indexed owner,
26     address indexed spender,
27     uint256 value
28   );
29 
30 }
31 
32 
33 /*
34     Library for basic math operations with overflow/underflow protection
35 */
36 library SafeMath {
37     /**
38         @dev returns the sum of _x and _y, reverts if the calculation overflows
39 
40         @param _x   value 1
41         @param _y   value 2
42 
43         @return sum
44     */
45     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
46         uint256 z = _x + _y;
47         require(z >= _x,"SafeMath->mul got a exception");
48         return z;
49     }
50 
51     /**
52         @dev returns the difference of _x minus _y, reverts if the calculation underflows
53 
54         @param _x   minuend
55         @param _y   subtrahend
56 
57         @return difference
58     */
59     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
60         require(_x >= _y,"SafeMath->sub got a exception");
61         return _x - _y;
62     }
63 
64     /**
65         @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
66 
67         @param _x   factor 1
68         @param _y   factor 2
69 
70         @return product
71     */
72     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
73         // gas optimization
74         if (_x == 0)
75             return 0;
76 
77         uint256 z = _x * _y;
78         require(z / _x == _y,"SafeMath->mul got a exception");
79         return z;
80     }
81 
82       /**
83         @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
84 
85         @param _x   dividend
86         @param _y   divisor
87 
88         @return quotient
89     */
90     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
91         require(_y > 0,"SafeMath->div got a exception");
92         uint256 c = _x / _y;
93 
94         return c;
95     }
96 
97     /**
98      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
99      * reverts when dividing by zero.
100      */
101     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b != 0, "SafeMath: modulo by zero");
103         return a % b;
104     }
105 }
106 
107 library ConvertLib {
108     function convert(uint amount,uint conversionRate) public pure returns (uint convertedAmount) {
109         return amount * conversionRate;
110     }
111 }
112 
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
119  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract ERC20Token is IERC20Token {
122   using SafeMath for uint256;
123 
124   mapping (address => uint256) _balances;
125 
126   mapping (address => mapping (address => uint256)) _allowed;
127 
128   uint256 _totalSupply;
129   string private _name;
130   string private _symbol;
131   uint256 private _decimals;
132 
133    event Transfer(
134     address indexed from,
135     address indexed to,
136     uint256 value
137   );
138 
139   event Approval(
140     address indexed owner,
141     address indexed spender,
142     uint256 value
143   );
144 
145   constructor(string memory name, string memory symbol,uint256 total, uint256 decimals) public {
146     _name = name;
147     _symbol = symbol;
148     _decimals = decimals;
149     _totalSupply = total.mul(10**decimals);
150     _balances[msg.sender] = _totalSupply;
151   }
152 
153   /**
154    * @return the name of the token.
155    */
156   function name() public view returns(string memory) {
157     return _name;
158   }
159 
160   /**
161    * @return the symbol of the token.
162    */
163   function symbol() public view returns(string memory) {
164     return _symbol;
165   }
166 
167   /**
168    * @return the number of decimals of the token.
169    */
170   function decimals() public view returns(uint) {
171     return _decimals;
172   }
173 
174   /**
175   * @dev Total number of tokens in existence
176   */
177   function totalSupply() public view returns (uint256) {
178     return _totalSupply;
179   }
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param owner The address to query the balance of.
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address owner) public view returns (uint256) {
186     return _balances[owner];
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param owner address The address which owns the funds.
192    * @param spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(
196     address owner,
197     address spender
198    )
199     public
200     view
201     returns (uint256)
202   {
203     return _allowed[owner][spender];
204   }
205 
206   /**
207   * @dev Transfer token for a specified address
208   * @param to The address to transfer to.
209   * @param value The amount to be transferred.
210   */
211   function transfer(address to, uint256 value) public returns (bool) {
212     require(value <= _balances[msg.sender],"not enough balance!!");
213     require(to != address(0),"params can't be empty(0)");
214 
215     _balances[msg.sender] = _balances[msg.sender].sub(value);
216     _balances[to] = _balances[to].add(value);
217     emit Transfer(msg.sender, to, value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param spender The address which will spend the funds.
228    * @param value The amount of tokens to be spent.
229    */
230   function approve(address spender, uint256 value) public returns (bool) {
231     require(spender != address(0),"approve address can't be empty(0)!!!");
232 
233     _allowed[msg.sender][spender] = value;
234     emit Approval(msg.sender, spender, value);
235     return true;
236   }
237 
238   /**
239    * @dev Transfer tokens from one address to another
240    * @param from address The address which you want to send tokens from
241    * @param to address The address which you want to transfer to
242    * @param value uint256 the amount of tokens to be transferred
243    */
244   function transferFrom(
245     address from,
246     address to,
247     uint256 value
248   )
249     public
250     returns (bool)
251   {
252     require(value <= _balances[from],"balance not enough!!");
253     require(value <= _allowed[from][msg.sender],"allow not enough");
254     require(to != address(0),"target address can't be empty(0)");
255 
256     _balances[from] = _balances[from].sub(value);
257     _balances[to] = _balances[to].add(value);
258     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
259     emit Transfer(from, to, value);
260     return true;
261   }
262 }
263 
264 /*
265 *lock/unlock tokens
266 */
267 contract LockXL{
268     using SafeMath for uint256;
269     uint256 constant UNLOCK_DURATION = 100 * 24 * 60 * 60; //100 days, 100 * 24 * 60 * 60
270     uint256 constant DAY_UINT = 1*24*60*60;//1day,24 * 60 * 60;
271     uint256 private _unlockStartTime;
272 
273     struct LockBody{
274         address account;
275         uint256 lockXLs;
276         uint256 unlockXLs; //remainXLs = lockXLs - unlockXLs
277         bool unlockDone; //remainXLs == 0
278     }
279 
280     mapping (address=>LockBody) _lockBodies;
281 
282     event LockBodyInputLog(address indexed account,uint256 indexed lockXLs);
283 
284     constructor(uint256 unlockDurationTime) public {
285         _unlockStartTime = now.add(unlockDurationTime);
286     }
287 
288     function transferable(uint256 amount,uint256 balance) internal  returns(bool){
289         if(_lockBodies[msg.sender].account == address(0)) return true; //it is not lock sender
290         LockBody storage lb = _lockBodies[msg.sender];
291         //current unlock progress
292         uint256 curProgress = now.sub(_unlockStartTime);
293         uint256 timeStamp = curProgress.div(DAY_UINT); //turn to day
294         lb.unlockDone = timeStamp >= UNLOCK_DURATION;
295         if(lb.unlockDone) return true; //unlock finished
296 
297         uint256 unlockXLsPart = lb.lockXLs.mul(timeStamp).div(UNLOCK_DURATION);
298         lb.unlockXLs = unlockXLsPart;
299         if(balance.add(unlockXLsPart).sub(lb.lockXLs) > amount) return true;
300         return false;
301     }
302 
303     /**
304      *get the current
305      */
306      function LockInfo(address _acc) public view returns(address account,uint256 unlockStartTime,
307       uint256 curUnlockProgess,uint256 unlockDuration,
308       uint256 lockXLs,uint256 unlockXLs,uint256 remainlockXLs){
309         account = _acc;
310         unlockStartTime = _unlockStartTime;
311         LockBody memory lb = _lockBodies[_acc];
312         //current unlock progress
313         uint256 curProgress = now.sub(_unlockStartTime);
314         curUnlockProgess = curProgress.div(DAY_UINT);
315         lockXLs = lb.lockXLs;
316         if(curUnlockProgess >= UNLOCK_DURATION){
317             curUnlockProgess = UNLOCK_DURATION;
318         }
319         unlockXLs = lb.lockXLs.mul(curUnlockProgess).div(UNLOCK_DURATION);
320         remainlockXLs = lb.lockXLs.sub(unlockXLs);
321         unlockDuration = UNLOCK_DURATION;
322      }
323 
324 
325     /*
326     *
327     *
328     */
329     function inputLockBody(uint256 _XLs) public {
330         require(_XLs > 0,"xl amount == 0");
331         address _account = address(tx.origin); //origin
332         LockBody storage lb = _lockBodies[_account];
333         if(lb.account != address(0)){
334             lb.lockXLs = lb.lockXLs.add(_XLs);
335         }else{
336             _lockBodies[_account] = LockBody({account:_account,lockXLs:_XLs,unlockXLs:0,unlockDone:false});
337         }
338         emit LockBodyInputLog(_account,_XLs);
339     }
340 
341 }
342 
343 contract Ownable{
344     address private _owner;
345     event OwnershipTransferred(address indexed prevOwner,address indexed newOwner);
346     event WithdrawEtherEvent(address indexed receiver,uint256 indexed amount,uint256 indexed atime);
347     //modifier
348     modifier onlyOwner{
349         require(msg.sender == _owner, "sender not eq owner");
350         _;
351     }
352     constructor() internal{
353         _owner = msg.sender;
354     }
355 
356     function transferOwnership(address newOwner) public onlyOwner {
357         require(newOwner != address(0), "newOwner can't be empty!");
358         address prevOwner = _owner;
359         _owner = newOwner;
360         emit OwnershipTransferred(prevOwner,newOwner);
361     }
362 
363     /**
364      * @dev Rescue compatible ERC20 Token
365      *
366      * @param tokenAddr ERC20 The address of the ERC20 token contract
367      * @param receiver The address of the receiver
368      * @param amount uint256
369      */
370     function rescueTokens(IERC20Token tokenAddr, address receiver, uint256 amount) external onlyOwner {
371         IERC20Token _token = IERC20Token(tokenAddr);
372         require(receiver != address(0),"receiver can't be empty!");
373         uint256 balance = _token.balanceOf(address(this));
374         require(balance >= amount,"balance is not enough!");
375         require(_token.transfer(receiver, amount),"transfer failed!!");
376     }
377 
378     /**
379      * @dev Withdraw ether
380      */
381     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
382         require(to != address(0),"address can't be empty");
383         uint256 balance = address(this).balance;
384         require(balance >= amount,"this balance is not enough!");
385         to.transfer(amount);
386        emit WithdrawEtherEvent(to,amount,now);
387     }
388 
389 
390 }
391 
392 /*
393 *紧急情况下暂停转账
394 *
395 */
396 
397 contract UrgencyPause is Ownable{
398     bool private _paused;
399     mapping (address=>bool) private _manager;
400     event Paused(address indexed account,bool indexed state);
401     event ChangeManagerState(address indexed account,bool indexed state);
402     //modifer
403     modifier isManager(){
404         require(_manager[msg.sender]==true,"not manager!!");
405         _;
406     }
407     
408     modifier notPaused(){
409         require(!_paused,"the state is paused!");
410         _;
411     }
412     constructor() public{
413         _paused = false;
414         _manager[msg.sender] = true;
415     }
416 
417     function changeManagerState(address account,bool state) public onlyOwner {
418         require(account != address(0),"null address!!");
419         _manager[account] = state;
420         emit ChangeManagerState(account,state);
421     }
422 
423     function paused() public view returns(bool) {
424         return _paused;
425     }
426 
427     function setPaused(bool state) public isManager {
428             _paused = state;
429             emit Paused(msg.sender,_paused);
430     }
431 
432 }
433 
434 contract XLand is ERC20Token,UrgencyPause,LockXL{
435     using SafeMath for uint256;
436     mapping(address=>bool) private _freezes;  //accounts were freezed
437     //events
438     event FreezeAccountStateChange(address indexed account, bool indexed isFreeze);
439     //modifier
440     modifier notFreeze(){
441       require(_freezes[msg.sender]==false,"The account was freezed!!");
442       _;
443     }
444 
445     modifier transferableXLs(uint256 amount){
446       require(super.transferable(amount,_balances[msg.sender]),"lock,can't be transfer!!");
447       _;
448     }
449     
450     constructor(string memory name, string memory symbol,uint256 total, uint8 decimals,uint256 unLockStatTime)
451     public
452     ERC20Token(name,symbol,total,decimals)
453     LockXL(unLockStatTime){
454 
455     }
456 
457     function transfer(address to, uint256 value) public notPaused notFreeze transferableXLs(value) returns (bool){
458         return super.transfer(to,value);
459     }
460 
461     function approve(address spender, uint256 value) public notPaused notFreeze transferableXLs(value) returns (bool){
462         return super.approve(spender,value);
463     }
464 
465     function transferFrom(
466     address from,
467     address to,
468     uint256 value
469   )
470     public notPaused notFreeze
471     returns (bool){
472         return super.transferFrom(from,to,value);
473     }
474 
475     function inputLockBody(uint256 amount) public {
476         super.inputLockBody(amount);
477     }
478     /**
479    * @dev Increase the amount of tokens that an owner allowed to a spender.
480    * approve should be called when allowed_[_spender] == 0. To increment
481    * allowed value is better to use this function to avoid 2 calls (and wait until
482    * the first transaction is mined)
483    * From MonolithDAO Token.sol
484    * @param spender The address which will spend the funds.
485    * @param addedValue The amount of tokens to increase the allowance by.
486    */
487   function increaseAllowance(
488     address spender,
489     uint256 addedValue
490   )
491     public notPaused notFreeze
492     returns (bool)
493   {
494     require(spender != address(0),"spender can't be empty(0)!!!");
495 
496     _allowed[msg.sender][spender] = (
497       _allowed[msg.sender][spender].add(addedValue));
498     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
499     return true;
500   }
501 
502   /**
503    * @dev Decrease the amount of tokens that an owner allowed to a spender.
504    * approve should be called when allowed_[_spender] == 0. To decrement
505    * allowed value is better to use this function to avoid 2 calls (and wait until
506    * the first transaction is mined)
507    * From MonolithDAO Token.sol
508    * @param spender The address which will spend the funds.
509    * @param subtractedValue The amount of tokens to decrease the allowance by.
510    */
511   function decreaseAllowance(
512     address spender,
513     uint256 subtractedValue
514   )
515     public notPaused notFreeze
516     returns (bool)
517   {
518     require(spender != address(0),"spender can't be empty(0)!!!");
519 
520     _allowed[msg.sender][spender] = (
521       _allowed[msg.sender][spender].sub(subtractedValue));
522     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
523     return true;
524   }
525 
526   /**
527    * @dev Internal function that mints an amount of the token and assigns it to
528    * an account. This encapsulates the modification of balances such that the
529    * proper events are emitted.
530    * @param amount The amount that will be created.
531    */
532    //can't mint
533   // function mint(uint256 amount) public onlyOwner {
534   //   _totalSupply = _totalSupply.add(amount);
535   //   _balances[msg.sender] = _balances[msg.sender].add(amount);
536   //   emit Transfer(address(0), msg.sender, amount);
537   // }
538 
539   /**
540    * @dev Internal function that burns an amount of the token of a given
541    *
542    * @param amount The amount that will be burnt.
543    */
544   function burn(uint256 amount) public onlyOwner {
545     require(amount <= _balances[msg.sender],"balance not enough!!!");
546     _totalSupply = _totalSupply.sub(amount);
547     _balances[msg.sender] = _balances[msg.sender].sub(amount);
548     emit Transfer(msg.sender, address(0), amount);
549   }
550 
551   /**
552   *add  freeze/unfreeze account
553   *account
554   */
555   function changeFreezeAccountState(address account,bool isFreeze) public onlyOwner{
556     require(account != address(0),"account can't be empty!!");
557     _freezes[account] = isFreeze;
558     emit FreezeAccountStateChange(account,isFreeze);
559   }
560 
561 }