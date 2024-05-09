1 pragma solidity >=0.5;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title DexStatus
6  * @dev Status for Dex  
7  */ 
8 contract DexStatus {
9     string constant ONLY_RELAYER    = "ONLY_RELAYER";
10     string constant ONLY_AIRDROP    = "ONLY_AIRDROP"; 
11     string constant ONLY_INACTIVITY = "ONLY_INACTIVITY";
12     string constant ONLY_WITHDRAWALAPPROVED = "ONLY_WITHDRAWALAPPROVED";
13 
14     string constant INVALID_NONCE  = "INVALID_NONCE";  
15     string constant INVALID_PERIOD = "INVALID_PERIOD";
16     string constant INVALID_AMOUNT = "INVALID_AMOUNT";
17     string constant INVALID_TIME   = "INVALID_TIME";
18     string constant INVALID_GASTOKEN = "INVALID_GASTOKEN";
19 
20     string constant TRANSFER_FAILED = "TRANSFER_FAILED";
21     string constant ECRECOVER_FAILED  = "ECRECOVER_FAILED";
22 
23     string constant INSUFFICIENT_FOUND = "INSUFFICIENT";  
24     string constant TRADE_EXISTS       = "TRADED";
25     string constant WITHDRAW_EXISTS    = "WITHDRAWN";
26 
27     string constant MAX_VALUE_LIMIT = "MAX_LIMIT";
28 
29     string constant AMOUNT_EXCEEDED = "AMOUNT_EXCEEDED"; 
30 }
31 
32 
33 
34 /**
35  * @title IGasStorage
36  * @dev  GasStorage interface to burn and mint gastoken
37  */
38 interface IGasStorage
39 {
40     function mint(uint256 value) external;
41     function burn(uint256 value) external;
42     function balanceOf() external view returns (uint256 balance);
43 }
44 
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   constructor() public {
63     owner = tx.origin;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     emit OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 
88 /** 
89  * @dev ERC20 interface
90  */
91 interface ERC20 {  
92     function balanceOf(address _owner) external view returns (uint256 balance); 
93     function transfer(address _to, uint256 _value) external returns (bool success) ; 
94     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success); 
95     function approve(address _spender, uint256 _value) external returns (bool success); 
96     function allowance(address _owner, address _spender) view external returns (uint256 remaining); 
97 }
98  
99 /**
100  * @title SafeMath
101  * @dev Math operations with safety checks that revert on error
102  */
103 library SafeMath {
104 
105   /**
106   * @dev Multiplies two numbers, reverts on overflow.
107   */
108   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110     // benefit is lost if 'b' is also tested.
111     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
112     if (a == 0) {
113       return 0;
114     }
115 
116     uint256 c = a * b;
117     require(c / a == b);
118 
119     return c;
120   }
121 
122   /**
123   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
124   */
125   function div(uint256 a, uint256 b) internal pure returns (uint256) {
126     require(b > 0); // Solidity only automatically asserts when dividing by 0
127     uint256 c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129 
130     return c;
131   }
132 
133   /**
134   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
135   */
136   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137     require(b <= a);
138     uint256 c = a - b;
139 
140     return c;
141   }
142 
143   /**
144   * @dev Adds two numbers, reverts on overflow.
145   */
146   function add(uint256 a, uint256 b) internal pure returns (uint256) {
147     uint256 c = a + b;
148     require(c >= a);
149 
150     return c;
151   }
152 
153   /**
154   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
155   * reverts when dividing by zero.
156   */
157   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
158     require(b != 0);
159     return a % b;
160   }
161 }
162   
163  
164 
165  
166 
167 /**
168  * @title Dex
169  * @dev Smart contract for https://www.dex.io
170  */ 
171 contract Dex is Ownable,DexStatus {  
172     using SafeMath for uint256;     
173     
174     struct Order
175     {
176         address token;
177         address baseToken; 
178         address user;  
179         uint256 tokenAmount;
180         uint256 baseTokenAmount;
181         uint    nonce;
182         uint    expireTime;  
183         uint    maxGasFee;  
184         uint    timestamp;
185         address gasToken;  
186         bool    sell;
187         uint8   V;
188         bytes32 R;
189         bytes32 S;  
190         uint    signType;
191     } 
192 
193     struct TradeInfo {
194         uint256 tradeTokenAmount;   
195         uint256 tradeTakerFee;
196         uint256 tradeMakerFee;    
197         uint256 tradeGasFee;
198         uint    tradeNonce; 
199         address tradeGasToken;  
200     }    
201 
202     mapping (address => mapping (address => uint256)) public _balances;  
203 
204     mapping (address => uint)     public _invalidOrderNonce;     
205 
206     mapping (bytes32 => uint256)  public _orderFills;
207 
208     mapping (address => bool)     public _relayers;
209 
210     mapping (bytes32 => bool)     public _traded;
211     mapping (bytes32 => bool)     public _withdrawn;   
212      
213     mapping (bytes32 => uint256)  public _orderGasFee; 
214   
215     mapping (address => uint)     public _withdrawalApplication;
216 
217     address public       _feeAccount; 
218     address public       _airdropContract;  
219     address public       _gasStorage;
220 
221     uint256 public _withdrawalApplicationPeriod = 10 days;
222  
223     uint256 public _takerFeeRate   = 0.002 ether;
224     uint256 public _makerFeeRate   = 0.001 ether;    
225  
226     string  private constant EIP712DOMAIN_TYPE  = "EIP712Domain(string name)";
227     bytes32 private constant EIP712DOMAIN_TYPEHASH = keccak256(abi.encodePacked(EIP712DOMAIN_TYPE)); 
228     bytes32 private constant DOMAIN_SEPARATOR = keccak256(abi.encode(EIP712DOMAIN_TYPEHASH,keccak256(bytes("Dex.io"))));
229  
230     string  private constant  ORDER_TYPE = "Order(address token,address baseToken,uint256 tokenAmount,uint256 baseTokenAmount,uint256 nonce,bool sell,uint256 expireTime,uint256 maxGasFee,address gasToken,uint timestamp)";    
231     bytes32 private constant  ORDER_TYPEHASH = keccak256(abi.encodePacked(ORDER_TYPE)); 
232     
233     string  private constant  WITHDRAW_TYPE = "Withdraw(address token,uint256 tokenAmount,address to,uint256 nonce,address feeToken,uint256 feeWithdrawal,uint timestamp)";    
234     bytes32 private constant  WITHDRAW_TYPEHASH = keccak256(abi.encodePacked(WITHDRAW_TYPE));
235 
236     event Trade(bytes32 takerHash,bytes32 makerHash,uint256 tradeAmount,uint256 tradeBaseTokenAmount,uint256 tradeNonce,uint256 takerCostFee,
237           uint makerCostFee,bool sellerIsMaker,uint256 gasFee);
238 
239     event Balance(uint256 takerBaseTokenBalance,uint256 takerTokenBalance,uint256 makerBaseTokenBalance,uint256 makerTokenBalance); 
240 
241     event Deposit(address indexed token, address indexed user, uint256 amount, uint256 balance);
242     event Withdraw(address indexed token,address indexed from,address indexed to, uint256 amount, uint256 balance); 
243     event Transfer(address indexed token,address indexed from,address indexed to, uint256 amount, uint256 fromBalance,uint256 toBalance); 
244     event Airdrop(address indexed to, address indexed token,uint256 amount); 
245 
246     event WithdrawalApplication(address user,uint timestamp);
247 
248     modifier onlyRelayer {
249         if (msg.sender != owner && !_relayers[msg.sender]) revert(ONLY_RELAYER);
250         _;
251     } 
252 
253     modifier onlyAirdropContract {
254         if (msg.sender != _airdropContract) revert(ONLY_AIRDROP);
255         _;
256     }   
257  
258     /** 
259     *  @dev approved in 10 days 
260     */  
261     modifier onlyWithdrawalApplicationApproved  {
262         require (
263              _withdrawalApplication[msg.sender] != uint(0) &&
264              block.timestamp - _withdrawalApplicationPeriod > _withdrawalApplication[msg.sender],
265              ONLY_WITHDRAWALAPPROVED);
266         _;
267     }   
268 
269   
270     /** 
271     *  @param feeAccount  account to receive the fee
272     */  
273     constructor(address feeAccount) public { 
274         _feeAccount = feeAccount;  
275     }
276 
277     /** 
278     *  @dev do no send eth to dex contract directly.
279     */
280     function() external {
281         revert();
282     }  
283   
284     /** 
285     *  @dev set a relayer
286     */ 
287     function setRelayer(address relayer, bool isRelayer) public onlyOwner {
288         _relayers[relayer] = isRelayer;
289     } 
290  
291     /** 
292     *  @dev check a relayer
293     */ 
294     function isRelayer(address relayer) public view returns(bool)  {
295         return _relayers[relayer];
296     } 
297  
298     /** 
299     *  @dev set account that receive the fee
300     */ 
301     function setFeeAccount(address feeAccount) public onlyOwner {
302         _feeAccount = feeAccount;
303     }
304  
305     /** 
306     *  @dev set set maker and taker fee rate
307     *  @param makerFeeRate maker fee rate can't be more than 0.5%
308     *  @param takerFeeRate taker fee rate can't be more than 0.5%
309     */ 
310     function setFee(uint256 makerFeeRate,uint256 takerFeeRate) public onlyOwner { 
311 
312         require(makerFeeRate <=  0.005 ether && takerFeeRate <=  0.005 ether,MAX_VALUE_LIMIT); 
313 
314         _makerFeeRate = makerFeeRate;
315         _takerFeeRate = takerFeeRate; 
316     }   
317   
318     /** 
319     *  @dev set gasStorage contract to save gas
320     */ 
321     function setGasStorage(address gasStorage) public onlyOwner {
322         _gasStorage = gasStorage;
323     }
324  
325     /** 
326     *  @dev set airdrop contract to implement airdrop function
327     */ 
328     function setAirdrop(address airdrop) public onlyOwner{
329         _airdropContract = airdrop;
330     }
331  
332     /** 
333     *  @dev set withdraw application period
334     *  @param period the period can't be more than 10 days
335     */ 
336     function setWithdrawalApplicationPeriod(uint period) public onlyOwner {
337 
338         if(period > 10 days ){
339             return;
340         }
341 
342         _withdrawalApplicationPeriod = period; 
343     }
344  
345     /** 
346     *  @dev invalid the orders before nonce
347     */ 
348     function invalidateOrdersBefore(address user, uint256 nonce) public onlyRelayer {
349         if (nonce < _invalidOrderNonce[user]) {
350             revert(INVALID_NONCE);   
351         }
352 
353         _invalidOrderNonce[user] = nonce;
354     } 
355   
356     /** 
357     *  @dev deposit token 
358     */ 
359     function depositToken(address token, uint256 amount)  public {  
360         require(ERC20(token).transferFrom(msg.sender, address(this), amount),TRANSFER_FAILED); 
361         _deposit(msg.sender,token,amount); 
362     }
363  
364     /** 
365     *  @dev deposit token from msg.sender to someone
366     */ 
367     function depositTokenTo(address to,address token, uint256 amount)  public {  
368         require(ERC20(token).transferFrom(msg.sender, address(this), amount),TRANSFER_FAILED); 
369         _deposit(to,token,amount); 
370     }
371 
372     /** 
373     *  @dev deposit eth
374     */ 
375     function deposit() public payable { 
376         _deposit(msg.sender,address(0),msg.value); 
377     }
378  
379     /** 
380     *  @dev deposit eth from msg.sender to someone
381     */ 
382     function depositTo(address to) public payable {
383         _deposit(to,address(0),msg.value);
384     } 
385  
386     /** 
387     *  @dev _deposit
388     */ 
389     function _deposit(address user,address token,uint256 amount) internal {
390     
391         _balances[token][user] = _balances[token][user].add(amount);   
392         
393         emit Deposit(token, user, amount, _balances[token][user]);
394     } 
395      
396     /** 
397     *  @dev submit a withdrawal application, user can not place any orders after submit a withdrawal application
398     */ 
399     function submitWithdrawApplication() public {
400         _withdrawalApplication[msg.sender] = block.timestamp;
401         emit WithdrawalApplication(msg.sender,block.timestamp);
402     }
403  
404     /** 
405     *  @dev cancel withdraw application
406     */ 
407     function cancelWithdrawApplication() public {
408         _withdrawalApplication[msg.sender] = 0; 
409         emit WithdrawalApplication(msg.sender,0);
410     }
411  
412     /** 
413     *  @dev check user withdraw application status
414     */ 
415     function isWithdrawApplication(address user) view public returns(bool) {
416         if(_withdrawalApplication[user] == uint(0)) {
417             return false;
418         }
419         return true;
420     }   
421 
422     /** 
423     *  @dev withdraw token 
424     */ 
425     function _withdraw(address from,address payable to,address token,uint256 amount) internal {    
426 
427         if ( _balances[token][from] < amount) { 
428             revert(INSUFFICIENT_FOUND);
429         }  
430         
431         _balances[token][from] = _balances[token][from].sub(amount);
432 
433         if(token == address(0)) {  
434             to.transfer(amount);
435         }else{    
436             require(ERC20(token).transfer(to, amount),TRANSFER_FAILED); 
437         }  
438 
439         emit Withdraw(token, from, to, amount, _balances[token][from]);
440     }  
441 
442 
443     /** 
444     *  @dev user withdraw token 
445     */ 
446     function withdraw(address token) public onlyWithdrawalApplicationApproved { 
447         uint256 amount = _balances[token][msg.sender];
448         if(amount != 0){ 
449             _withdraw(msg.sender,msg.sender,token,amount);
450         }
451     } 
452          
453     /** 
454     *  @dev user withdraw many tokens 
455     */ 
456     function withdrawAll(address[] memory tokens) public onlyWithdrawalApplicationApproved { 
457         
458         for(uint256 i = 0; i< tokens.length ;i++){ 
459 
460             uint256 amount = _balances[tokens[i]][msg.sender];
461             
462             if(amount == 0){
463                 continue;
464             }
465 
466             _withdraw(msg.sender,msg.sender,tokens[i],amount); 
467         }
468     }
469   
470     /** 
471     *  @dev user send withdraw request with relayer's authorized signature 
472     */ 
473     function authorizedWithdraw(address payable to,address token,uint256 amount,
474             uint256 nonce,uint expiredTime,address relayer,uint8 v, bytes32 r,bytes32 s) public
475     {  
476         require(_withdrawalApplication[msg.sender] == uint(0));
477         require(expiredTime >= block.timestamp,INVALID_TIME);
478         require(_relayers[relayer] == true,ONLY_RELAYER);
479 
480         bytes32 hash = keccak256(abi.encodePacked(msg.sender,to, token, amount, nonce, expiredTime));
481         
482         if (_withdrawn[hash]) {
483             revert(WITHDRAW_EXISTS);    
484         }   
485 
486         _withdrawn[hash] = true;  
487 
488         if (ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s) != relayer) {
489             revert(ECRECOVER_FAILED);
490         } 
491 
492         _withdraw(msg.sender,to,token,amount);  
493     }
494  
495     /** 
496     *  @dev withdraw the token from Dex Wallet to Etheruem Wallet,signType [0 = signTypeDataV3, 1 = eth_sign] 
497     */ 
498     function adminWithdraw(address from,address payable to,address token,uint256 amount,uint256 nonce,uint8 v,bytes32[2] memory rs, 
499             address feeToken,uint256 feeWithdrawal,uint timestamp,uint signType) public onlyRelayer  { 
500 
501         bytes32 hash = ecrecoverWithdraw(from,to,token,amount,nonce,v,rs,feeToken,feeWithdrawal,timestamp,signType);     
502 
503         if (_withdrawn[hash]) {
504             revert(WITHDRAW_EXISTS);    
505         }    
506 
507         _withdrawn[hash] = true;   
508 
509         _transfer(from,to,token,amount,feeToken,feeWithdrawal,false);
510     } 
511  
512     /** 
513     *  @dev transfer the token between Dex Wallet,signType [0 = signTypeDataV3, 1 = eth_sign] 
514     */ 
515     function adminTransfer(address from,address payable to,address token,uint256 amount,uint256 nonce,uint8 v,bytes32[2] memory rs, 
516             address feeToken,uint256 feeWithdrawal,uint timestamp,uint signType) public onlyRelayer  { 
517 
518         bytes32 hash = ecrecoverWithdraw(from,to,token,amount,nonce,v,rs,feeToken,feeWithdrawal,timestamp,signType);     
519 
520         if (_withdrawn[hash]) {
521             revert(WITHDRAW_EXISTS);    
522         }    
523         _withdrawn[hash] = true;  
524 
525 
526         _transfer(from,to,token,amount,feeToken,feeWithdrawal,true);
527     }  
528  
529     /** 
530     *  @dev   transfer the token 
531     *  @param from   token sender
532     *  @param to     token receiver  
533     *  @param token   The address of token to transfer
534     *  @param amount   The amount to transfer 
535     *  @param feeToken   The address of token  to pay the fee
536     *  @param feeWithdrawal  The amount of feeToken to pay the fee
537     *  @param isInternal  True is transfer token from a Dex Wallet to a Dex Wallet, False is transfer a token from Dex wallet to a Etheruem Wallet
538     */ 
539     function _transfer(address from,address payable to,address token,uint256 amount, address feeToken,uint256 feeWithdrawal, bool isInternal) internal  { 
540   
541         if (feeWithdrawal > 0)
542         { 
543             require(_balances[feeToken][from] >= feeWithdrawal,  INSUFFICIENT_FOUND ); 
544             _balances[feeToken][from]        = _balances[feeToken][from].sub(feeWithdrawal);
545             _balances[feeToken][_feeAccount] = _balances[feeToken][_feeAccount].add(feeWithdrawal); 
546         }   
547 
548         if ( _balances[token][from] < amount) {  revert(INSUFFICIENT_FOUND); }  
549         
550         _balances[token][from] = _balances[token][from].sub(amount);  
551         
552         if(isInternal)
553         {
554             _balances[token][to] = _balances[token][to].add(amount);
555 
556             emit Transfer(token, from, to, amount, _balances[token][from], _balances[token][to]);
557 
558         }else{
559             if(token == address(0)) {  
560                 to.transfer(amount);
561             }else{    
562                 require(ERC20(token).transfer(to, amount),TRANSFER_FAILED); 
563             }  
564 
565             emit Withdraw(token, from, to, amount, _balances[token][from]);
566         }  
567     }       
568  
569     /** 
570     *  @dev  mirgate function will withdraw all user token balances to wallet
571     */ 
572     function adminWithdrawAll(address payable user,address[] memory tokens) public onlyOwner { 
573 
574         for(uint256 i = 0; i< tokens.length ;i++){
575 
576             address token = tokens[i];
577             uint256 amount = _balances[token][user];
578 
579             if(amount == 0){
580                 continue;
581             }
582 
583             _withdraw(user,user,token,amount);
584         }
585     }
586  
587     /** 
588     *  @dev  get the balance of the account 
589     */  
590     function balanceOf(address token, address user) public view returns (uint256) {
591         return _balances[token][user];
592     }   
593  
594     /** 
595     *  @dev  trade order only call by relayer, ti.signType: 0 = signTypeDataV3, 1 = eth_sign 
596     */ 
597     function tradeOrder(Order memory taker,Order memory maker, TradeInfo memory ti) public onlyRelayer 
598     {
599         uint256 gasInitial = gasleft();
600 
601         bytes32 takerHash = ecrecoverOrder(taker,taker.signType); 
602         bytes32 makerHash = ecrecoverOrder(maker,maker.signType);
603     
604         bytes32 tradeHash = keccak256(abi.encodePacked(takerHash ,makerHash)); 
605 
606         require(_traded[tradeHash] == false,TRADE_EXISTS);  
607 
608         _traded[tradeHash] = true;     
609 
610         _tradeOrder(taker,maker,ti,takerHash,makerHash);     
611 
612         uint256 gasUsed = gasInitial - gasleft();
613         
614         _burnGas(gasUsed);
615     }
616  
617     /** 
618     *  @dev  trade order internal
619     */ 
620     function _tradeOrder(Order memory taker,Order memory maker, TradeInfo memory ti, bytes32 takerHash,bytes32 makerHash) internal
621     {   
622         require(taker.baseToken == maker.baseToken && taker.token == maker.token);
623         require(ti.tradeTokenAmount > 0 , INVALID_AMOUNT );
624         require((block.timestamp <= taker.expireTime) && (block.timestamp <= maker.expireTime)  ,  INVALID_TIME ); 
625         require( (_invalidOrderNonce[taker.user] < taker.nonce) &&(_invalidOrderNonce[maker.user] < maker.nonce),INVALID_NONCE) ; 
626 
627         require( (taker.tokenAmount.sub(_orderFills[takerHash]) >= ti.tradeTokenAmount) &&
628                 (maker.tokenAmount.sub(_orderFills[makerHash]) >= ti.tradeTokenAmount), AMOUNT_EXCEEDED); 
629 
630         require(taker.gasToken == ti.tradeGasToken, INVALID_GASTOKEN);
631 
632         uint256 tradeBaseTokenAmount = ti.tradeTokenAmount.mul(maker.baseTokenAmount).div(maker.tokenAmount);     
633  
634         (uint256 takerFee,uint256 makerFee) = calcMaxFee(ti,tradeBaseTokenAmount,maker.sell);    
635 
636         uint  gasFee = ti.tradeGasFee;
637 
638         if(gasFee != 0)
639         {  
640             if( taker.maxGasFee < _orderGasFee[takerHash].add(gasFee))
641             {
642                 gasFee = taker.maxGasFee.sub(_orderGasFee[takerHash]);
643             } 
644 
645             if(gasFee != 0)
646             {
647                 _orderGasFee[takerHash] = _orderGasFee[takerHash].add(gasFee); 
648                 _balances[taker.gasToken][taker.user]   = _balances[taker.gasToken][taker.user].sub(gasFee); 
649             } 
650         } 
651          
652         if( maker.sell)
653         {  
654             //maker is seller 
655             _updateOrderBalance(taker.user,maker.user,taker.baseToken,taker.token,
656                             tradeBaseTokenAmount,ti.tradeTokenAmount,takerFee,makerFee);
657         }else
658         {
659             //maker is buyer
660             _updateOrderBalance(maker.user,taker.user,taker.baseToken,taker.token,
661                             tradeBaseTokenAmount,ti.tradeTokenAmount,makerFee,takerFee); 
662         }
663 
664         //fill order
665         _orderFills[takerHash] = _orderFills[takerHash].add(ti.tradeTokenAmount);  
666         _orderFills[makerHash] = _orderFills[makerHash].add(ti.tradeTokenAmount);     
667 
668         emit Trade(takerHash,makerHash,ti.tradeTokenAmount,tradeBaseTokenAmount,ti.tradeNonce,takerFee,makerFee, maker.sell ,gasFee);
669  
670         emit Balance(_balances[taker.baseToken][taker.user],_balances[taker.token][taker.user],_balances[maker.baseToken][maker.user],_balances[maker.token][maker.user]); 
671     }  
672    
673     /** 
674     *  @dev  update the balance after each order traded
675     */ 
676     function _updateOrderBalance(address buyer,address seller,address base,address token,uint256 baseAmount,uint256 amount,uint256 buyFee,uint256 sellFee) internal
677     {
678         _balances[base][seller]    = _balances[base][seller].add(baseAmount.sub(sellFee));    
679         _balances[base][buyer]     = _balances[base][buyer].sub(baseAmount);
680 
681         _balances[token][buyer]    = _balances[token][buyer].add(amount.sub(buyFee));  
682         _balances[token][seller]   = _balances[token][seller].sub(amount);    
683     
684         _balances[base][_feeAccount]    = _balances[base][_feeAccount].add(sellFee);  
685         _balances[token][_feeAccount]    = _balances[token][_feeAccount].add(buyFee);   
686     }
687  
688     /** 
689     *  @dev  calc max fee for maker and taker
690     *  @return return a taker and maker fee limit by _takerFeeRate and _makerFeeRate
691     */ 
692     function calcMaxFee(TradeInfo memory ti,uint256 tradeBaseTokenAmount,bool sellerIsMaker)  view public returns (uint256 takerFee,uint256 makerFee) { 
693    
694         uint maxTakerFee;
695         uint maxMakerFee;
696 
697         takerFee     = ti.tradeTakerFee;
698         makerFee      = ti.tradeMakerFee; 
699         
700         if(sellerIsMaker)
701         { 
702             // taker is buyer
703             maxTakerFee = (ti.tradeTokenAmount * _takerFeeRate) / 1 ether; 
704             maxMakerFee = (tradeBaseTokenAmount * _makerFeeRate) / 1 ether; 
705         }else{
706             // maker is buyer
707             maxTakerFee = (tradeBaseTokenAmount * _takerFeeRate) / 1 ether; 
708             maxMakerFee = (ti.tradeTokenAmount  * _makerFeeRate) / 1 ether; 
709         } 
710 
711         if(ti.tradeTakerFee > maxTakerFee)
712         {
713             takerFee = maxTakerFee;
714         }  
715 
716         if(ti.tradeMakerFee > maxMakerFee)
717         {
718             makerFee = maxMakerFee;
719         }  
720     } 
721  
722     /** 
723     *  @dev  get fee Rate 
724     */ 
725     function getFeeRate() view public  returns(uint256 makerFeeRate,uint256 takerFeeRate)
726     {
727         return (_makerFeeRate,_takerFeeRate);
728     } 
729  
730     /** 
731     *  @dev get order filled amount
732     *  @param orderHash   the order hash  
733     *  @return return the filled amount for a order
734     */ 
735     function getOrderFills(bytes32 orderHash) view public returns(uint256 filledAmount)
736     {
737         return _orderFills[orderHash];
738     }
739 
740     ///@dev check orders traded
741     function isTraded(bytes32 buyOrderHash,bytes32 sellOrderHash) view public returns(bool traded)
742     {
743         return _traded[keccak256(abi.encodePacked(buyOrderHash, sellOrderHash))];
744     }   
745  
746     /** 
747     *  @dev Airdrop the token directly to Dex user's walle,only airdrop contract can call this function.
748     *  @param to   the recipient
749     *  @param token  the ERC20 token to send  
750     *  @param amount  the token amount to send 
751     */ 
752     function airdrop(address to,address token,uint256 amount) public onlyAirdropContract  
753     {  
754         //Not EOA
755         require(tx.origin != msg.sender);
756         require(_balances[token][msg.sender] >= amount ,INSUFFICIENT_FOUND);
757 
758         _balances[token][msg.sender] = _balances[token][msg.sender].sub(amount); 
759         _balances[token][to] = _balances[token][to].add(amount);  
760 
761         emit Airdrop(to,token,amount);
762     }   
763 
764     /** 
765     *  @dev ecreover the order sign   
766     *  @return return a order hash
767     */ 
768     function ecrecoverOrder(Order memory order,uint signType) public pure returns (bytes32 orderHash) {  
769  
770         if(signType == 0 )
771         {
772             orderHash = keccak256(abi.encode(
773                 ORDER_TYPEHASH,
774                 order.token,order.baseToken,order.tokenAmount,order.baseTokenAmount,order.nonce,order.sell,order.expireTime,order.maxGasFee,order.gasToken,order.timestamp));
775             if (ecrecover(keccak256(abi.encodePacked("\x19\x01",DOMAIN_SEPARATOR,orderHash)),order.V,order.R, order.S) != order.user) {
776                     revert(ECRECOVER_FAILED);
777             }  
778         }else {   
779 
780             orderHash = keccak256(abi.encodePacked(order.token,order.baseToken,order.tokenAmount,order.baseTokenAmount,order.nonce,order.sell,order.expireTime,order.maxGasFee,order.gasToken,order.timestamp)); 
781             if(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",orderHash)),order.V,order.R, order.S) != order.user) {
782                 revert(ECRECOVER_FAILED);
783             }  
784         } 
785     }   
786 
787     /** 
788     *  @dev ecrecover the withdraw sign
789     *  @return return a withdraw hash
790     */
791     function ecrecoverWithdraw(address from,address payable to,address token,uint256 amount,uint256 nonce,uint8 v,bytes32[2] memory rs, 
792             address feeToken,uint256 feeWithdrawal,uint timestamp,uint signType) public pure returns (bytes32 orderHash) {  
793   
794         if(signType == 1 ) {
795 
796             orderHash = keccak256(abi.encodePacked(token, amount, to, nonce,feeToken,feeWithdrawal,timestamp));
797 
798             if (ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash)), v, rs[0], rs[1]) != from) {
799                 revert(ECRECOVER_FAILED);
800             }
801  
802         } else {
803             orderHash = keccak256(abi.encode(WITHDRAW_TYPEHASH,token, amount, to, nonce,feeToken,feeWithdrawal,timestamp));
804 
805             if (ecrecover(keccak256(abi.encodePacked("\x19\x01",DOMAIN_SEPARATOR,orderHash)), v, rs[0], rs[1]) != from) {
806                 revert(ECRECOVER_FAILED);
807             }  
808         } 
809     }  
810   
811     /**
812    * @dev burn the stored gastoken
813    * @param gasUsed The gas uesed to calc the gastoken to burn
814    */
815     function _burnGas(uint gasUsed) internal {
816 
817         if(_gasStorage == address(0x0)){
818             return;
819         } 
820 
821         IGasStorage(_gasStorage).burn(gasUsed); 
822     }
823 
824 }