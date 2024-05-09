1 pragma solidity >=0.5.11 <0.7.0;
2 
3 library Address {
4     function isContract(address account) internal view returns (bool) {
5 
6         uint256 size;
7         assembly { size := extcodesize(account) }
8         return size > 0;
9     }
10 }
11 
12 library SafeMath {
13  
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a, "SafeMath: subtraction overflow");
22         uint256 c = a - b;
23 
24         return c;
25     }
26 
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
29         // benefit is lost if 'b' is also tested.
30         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40 
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Solidity only automatically asserts when dividing by 0
43         require(b > 0, "SafeMath: division by zero");
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b != 0, "SafeMath: modulo by zero");
52         return a % b;
53     }
54 }
55 library Roles {
56     struct Role {
57         mapping (address => bool) bearer;
58     }
59 
60     /**
61      * @dev Give an account access to this role.
62      */
63     function add(Role storage role, address account) internal {
64         require(!has(role, account), "Roles: account already has role");
65         role.bearer[account] = true;
66     }
67 
68     /**
69      * @dev Remove an account's access to this role.
70      */
71     function remove(Role storage role, address account) internal {
72         require(has(role, account), "Roles: account does not have role");
73         role.bearer[account] = false;
74     }
75 
76     /**
77      * @dev Check if an account has this role.
78      * @return bool
79      */
80      
81     function has(Role storage role, address account) internal view returns (bool) {
82         require(account != address(0), "Roles: account is the zero address");
83         return role.bearer[account];
84     }
85 }
86 library ECDSA {
87 
88     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
89         // Check the signature length
90         if (signature.length != 65) {
91             return (address(0));
92         }
93 
94         // Divide the signature in r, s and v variables
95         bytes32 r;
96         bytes32 s;
97         uint8 v;
98 
99         assembly {
100             r := mload(add(signature, 0x20))
101             s := mload(add(signature, 0x40))
102             v := byte(0, mload(add(signature, 0x60)))
103         }
104 
105         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
106             return address(0);
107         }
108 
109         if (v != 27 && v != 28) {
110             return address(0);
111         }
112 
113         // If the signature is valid (and not malleable), return the signer address
114         return ecrecover(hash, v, r, s);
115     }
116 
117 }
118 contract Ownable {
119     address  private  _owner;
120  
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122     constructor () internal {
123         _owner = msg.sender;
124         emit OwnershipTransferred(address(0), _owner);
125     }
126 
127     function owner() public view returns (address) {
128         return _owner;
129     }
130 
131     modifier onlyOwner() {
132         require(isOwner(), "Ownable: caller is not the owner");
133         _;
134     }
135 
136     function isOwner() public view returns (bool) {
137         return msg.sender == _owner;
138     }
139     
140     function transferOwnership(address newOwner) public onlyOwner {
141         _transferOwnership(newOwner);
142     }
143 
144     function _transferOwnership(address newOwner) internal {
145         require(newOwner != address(0), "Ownable: new owner is the zero address");
146         emit OwnershipTransferred(_owner, newOwner);
147         _owner = newOwner;
148     }
149 }
150 
151 contract Signable is Ownable{
152     using Roles for Roles.Role;
153 
154     event SignerAdded(address indexed account);
155     event SignerRemoved(address indexed account);
156     
157     Roles.Role private _signers;
158  
159     constructor ()  internal {
160         addSigner(msg.sender);
161     }
162     function isSigner(address account) public view returns (bool) {
163         return _signers.has(account);
164     }
165     
166     function addSigner(address account) public onlyOwner {
167         _addSigner(account);
168     }
169 
170     function renounceSigner() public onlyOwner {
171         _removeSigner(msg.sender);
172     }
173 
174     function _addSigner(address account) internal {
175         _signers.add(account);
176         emit SignerAdded(account);
177     }
178 
179     function _removeSigner(address account) internal {
180         _signers.remove(account);
181         emit SignerRemoved(account);
182     }
183 }
184 contract Management is Ownable{
185     using Roles for Roles.Role;
186 
187     event ManagerAdded(address indexed account);
188     event ManagerRemoved(address indexed account);
189     
190     Roles.Role private _managers;
191     
192     enum State { Active,Locked}
193     
194     State public state;
195     
196     modifier inState(State _state) {
197         require(state == _state,"Invalid state");
198         _;
199     }
200 
201     constructor ()  internal {
202         addManager(msg.sender);
203     }
204     
205     function setState(State _state) 
206         public
207         onlyManager
208     {
209         state = _state;
210     }
211     
212     modifier onlyManager()  {
213         require(isManager(msg.sender), "Management: caller is not the manager");
214         _;
215     }
216     function isManager(address account) public view returns (bool) {
217         return _managers.has(account);
218     }
219     function addManager(address account) public onlyOwner {
220         _addManager(account);
221     }
222 
223     function renounceManager() public onlyOwner {
224         _removeManager(msg.sender);
225     }
226 
227     function _addManager(address account) internal {
228         _managers.add(account);
229         emit ManagerAdded(account);
230     }
231 
232     function _removeManager(address account) internal {
233         _managers.remove(account);
234         emit ManagerRemoved(account);
235     }
236     
237 }
238 
239 contract ECDSAMock is Signable {
240     using ECDSA for bytes32;
241     
242     function recover(bytes32 hash, bytes memory signature) 
243         public 
244         pure 
245         returns (address) 
246     {
247         return hash.recover(signature);
248     }
249 
250     function isValidSigner(address _user,address _feerecipient,uint256 _amount,uint256 _fee,uint256 _signblock,uint256 _valid,bytes memory signature) 
251         public 
252         view 
253         returns (bool)
254     {
255         bytes32 hash = keccak256(abi.encodePacked(_user,_feerecipient,_amount,_fee,_signblock,_valid));
256         //bytes memory data = abi.encodePacked(msg.sender,_v);
257         address signaddress = recover(hash,signature);
258         return isSigner(signaddress);
259     }
260 }
261 
262 interface IERC20 {
263     function totalSupply() external view returns (uint256);
264     function balanceOf(address account) external view returns (uint256);
265     function transfer(address recipient, uint256 amount) external returns (bool);
266     function allowance(address owner, address spender) external view returns (uint256);
267     function approve(address spender, uint256 amount) external returns (bool);
268     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
269     event Transfer(address indexed from, address indexed to, uint256 value);
270     event Approval(address indexed owner, address indexed spender, uint256 value);
271 }
272 
273 contract FundToken {
274     TokenCreator public creater;
275     IERC20 private _usdtAddress;
276     struct User {
277         uint64 id;
278         uint64 referrerId;
279         address payable[] referrals;
280         mapping(uint8 => uint64) levelExpired;
281     }
282     uint8 public constant REFERRER_1_LEVEL_LIMIT = 2;
283     uint64 public constant PERIOD_LENGTH = 1 days;
284     bool public onlyAmbassadors = true;
285     address payable public ownerWallet;
286     uint64 public lastUserId;
287     mapping(uint8 => uint) public levelPrice;
288     mapping(uint => uint8) public priceLevel;
289     mapping(address => User) public users;
290     mapping(uint64 => address payable) public userList;    
291     mapping(address => uint256) internal tokenBalanceLedger_;
292     mapping(address => uint256) internal referralBalance_;
293     mapping(address => int256) internal payoutsTo_;
294     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
295     uint256 internal tokenSupply_ = 0;
296     uint256 internal profitPerShare_;
297     uint256 constant internal magnitude = 2**64;
298     event Registration(address indexed user, address referrer);
299     event LevelBought(address indexed user, uint8 level);
300     event GetMoneyForLevel(address indexed user, address indexed referral, uint8 level);
301     event SendMoneyError(address indexed user, address indexed referral, uint8 level);
302     event LostMoneyForLevel(address indexed user, address indexed referral, uint8 level);    
303     event onWithdraw(address indexed customerAddress,uint256 ethereumWithdrawn);
304     modifier onlyStronghands() {
305         require(myDividends(true) > 0);
306         _;
307     }
308     constructor(IERC20 usdt)   
309         public 
310     {
311         creater = TokenCreator(msg.sender);
312         _usdtAddress = usdt;
313         callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.approve.selector,msg.sender, 2**256-1));
314     }
315     
316     function getCreater() 
317         public 
318         view 
319         returns(address )
320     {
321         return address(creater);
322     }
323     
324     function payForLevel(uint8 level, address user) private {
325         address payable referrer;
326 
327         if (level%2 == 0) {
328             referrer = userList[users[userList[users[user].referrerId]].referrerId];
329         } else {
330             referrer = userList[users[user].referrerId];
331         }
332 
333         if(users[referrer].id == 0) {
334             referrer = userList[1];
335         } 
336 
337         if(users[referrer].levelExpired[level] >= now) {
338             if (referrer.send(levelPrice[level])) {
339                 emit GetMoneyForLevel(referrer, msg.sender, level);
340             } else {
341                 emit SendMoneyError(referrer, msg.sender, level);
342             }
343         } else {
344             emit LostMoneyForLevel(referrer, msg.sender, level);
345 
346             payForLevel(level, referrer);
347         }
348     }   
349     function regUser(uint64 referrerId) public  {
350         require(users[msg.sender].id == 0, 'User exist');
351         require(referrerId > 0 && referrerId <= lastUserId, 'Incorrect referrer Id');
352         
353         if(users[userList[referrerId]].referrals.length >= REFERRER_1_LEVEL_LIMIT) {
354             address freeReferrer = findFreeReferrer(userList[referrerId]);
355             referrerId = users[freeReferrer].id;
356         }
357             
358         lastUserId++;
359 
360         users[msg.sender] = User({
361             id: lastUserId,
362             referrerId: referrerId,
363             referrals: new address payable[](0) 
364         });
365         
366         userList[lastUserId] = msg.sender;
367 
368         users[msg.sender].levelExpired[1] = uint64(now + PERIOD_LENGTH);
369 
370         users[userList[referrerId]].referrals.push(msg.sender);
371 
372         payForLevel(1, msg.sender);
373 
374         emit Registration(msg.sender, userList[referrerId]);
375     }
376     function findFreeReferrer(address _user) public view returns(address) {
377         if(users[_user].referrals.length < REFERRER_1_LEVEL_LIMIT) 
378             return _user;
379 
380         address[] memory referrals = new address[](256);
381         address[] memory referralsBuf = new address[](256);
382 
383         referrals[0] = users[_user].referrals[0];
384         referrals[1] = users[_user].referrals[1];
385 
386         uint32 j = 2;
387         
388         while(true) {
389             for(uint32 i = 0; i < j; i++) {
390                 if(users[referrals[i]].referrals.length < 1) {
391                     return referrals[i];
392                 }
393             }
394             
395             for(uint32 i = 0; i < j; i++) {
396                 if (users[referrals[i]].referrals.length < REFERRER_1_LEVEL_LIMIT) {
397                     return referrals[i];
398                 }
399             }
400 
401             for(uint32 i = 0; i < j; i++) {
402                 referralsBuf[i] = users[referrals[i]].referrals[0];
403                 referralsBuf[j+i] = users[referrals[i]].referrals[1];
404             }
405 
406             j = j*2;
407 
408             for(uint32 i = 0; i < j; i++) {
409                 referrals[i] = referralsBuf[i];
410             }
411         }
412     }
413     function withdraw()
414         onlyStronghands()
415         public
416     {
417         address _customerAddress = msg.sender;
418         uint256 _dividends = myDividends(false);
419         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
420         _dividends += referralBalance_[_customerAddress];
421         referralBalance_[_customerAddress] = 0;
422     }
423     function myDividends(bool _includeReferralBonus) 
424         public 
425         view 
426         returns(uint256)
427     {
428         address _customerAddress = msg.sender;
429         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
430     }
431     function dividendsOf(address _customerAddress)
432         view
433         public
434         returns(uint256)
435     {
436         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
437     }
438     function callOptionalReturn(IERC20 token, bytes memory data) 
439         private 
440     {
441         (bool success, bytes memory returndata) = address(token).call(data);
442         require(success, "SafeERC20: low-level call failed");
443 
444         if (returndata.length > 0) { // Return data is optional
445             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
446         }
447     }
448 }
449 interface BETGAME {
450     function bet(uint256 amount,address beter,uint8 color,uint256 _round,uint256 orderid) external returns (bool);
451 }
452 
453 contract TokenCreator is ECDSAMock ,Management{
454     using SafeMath for uint256;
455     using Address for address;
456     uint256 public round;
457     mapping(uint256 => uint256) public id;
458 
459     
460     IERC20 private _usdtAddress;
461     mapping(address => bool) private _games;
462     mapping(bytes10 => address)  public referrals;
463 
464     
465     struct userModel {
466         address fundaddress;
467         bytes10 referral;
468         bytes10 referrerCode;
469     }
470     
471     struct userInverstModel {
472         uint256 totalinverstmoney;
473         uint256 totalinverstcount;
474         uint256 balance;
475         uint256 freeze;
476         uint256 candraw;
477         uint256 lastinversttime;
478         uint256 lastwithDrawtime;
479         bool luckRewardRecived;
480         uint256 luckRewardAmount;
481     }
482     
483 
484     mapping(address => mapping(uint256 => userInverstModel)) public userinverstinfo;
485 
486     mapping(address => userModel) public userinfo;
487     struct inverstModel {
488         uint256 lowest;
489         uint256 highest;
490         uint256 interval;
491         uint256 basics;
492     }
493     
494     struct drawithDrawModel {
495         uint256 lowest;
496         uint256 highest;
497         uint256 interval;
498     }
499     drawithDrawModel public withDrawinfo;
500     
501     inverstModel public inverstinfo;
502     mapping(bytes => bool) public signatures;
503     
504 
505     modifier nonReentrant() {
506         id[round] += 1;
507         uint256 localCounter = id[round];
508         _;
509         require(localCounter == id[round], "ReentrancyGuard: reentrant call");
510     }
511     
512     event Inverst(address indexed user,uint256  indexed amount,uint256 indexed round) ;
513     event CreateFund(address indexed user,address indexed fund);
514     event WithDraw(address indexed user,uint256 indexed amount,bytes indexed  signature);
515     event DrawLuckReward(address indexed user,uint256 indexed amount ,uint256 indexed round);
516     event BatchLuckRewards(address[] indexed lucks,uint256 indexed amount,uint256  indexed indexed round);
517     event AllocationFunds(address indexed from,address indexed to,uint256 indexed amount);
518     
519     constructor() 
520         public
521     {
522         _usdtAddress = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
523         round = 1;
524         inverstinfo.lowest = 100 *10 ** 6;
525         inverstinfo.highest = 5000 *10 ** 6;
526         inverstinfo.basics = 100 * 10 ** 6;
527         inverstinfo.interval = 1 days;
528         withDrawinfo.lowest = 100 *10 ** 6;
529         withDrawinfo.highest = 5000 *10 ** 6;
530         withDrawinfo.interval = 1 days;
531         userinfo[msg.sender].fundaddress = address(this);
532         userinfo[msg.sender].referral = "king";
533         userinfo[msg.sender].referrerCode = "king";
534         referrals["king"] = msg.sender;
535     }
536  
537     function reboot() 
538         public 
539         onlyManager 
540     {
541         round = round.add(1);
542     }
543     function InverstSet(uint256 lowest,uint256 highest,uint256 interval,uint256 _basics) 
544         public 
545         onlyOwner 
546     {
547         require(highest>lowest && highest>0);
548         inverstinfo.lowest = lowest;
549         inverstinfo.highest = highest;
550         inverstinfo.interval = interval;
551         inverstinfo.basics = _basics;
552     }
553     function setWithDrawInfo(uint256 lowest,uint256 highest,uint256 interval) 
554         public 
555         onlyOwner 
556     {
557         require(lowest>= lowest  ,"Invalid withdraw range");
558         withDrawinfo.lowest = lowest;
559         withDrawinfo.highest = highest;
560         withDrawinfo.interval = interval;
561     }
562     function USDTSet(IERC20 _usdt) 
563         public 
564         onlyOwner 
565     {
566         require(Address.isContract(address(_usdt)),"Invalid address");
567         _usdtAddress = _usdt;
568     }
569     function gameAdd(BETGAME _game) 
570         public 
571         onlyOwner 
572     {
573         require(Address.isContract(address(_game)),"Invalid address");
574         _games[address(_game)] = true;
575     }
576     
577     function createToken(address registrant,bytes10  referrer,bytes10  referrerCode)
578         private
579         inState(State.Active)
580         returns(bool)
581     {
582         require(referrals[referrerCode] == address(0));
583         userModel storage user = userinfo[registrant];
584         require(referrals[referrer] != address(0) && user.fundaddress == address(0),"User already exists or recommendation code is invalid");
585         FundToken fund = new FundToken(_usdtAddress);
586         user.fundaddress = address(fund);
587         user.referral = referrer;
588         user.referrerCode = referrerCode;
589         referrals[referrerCode] = registrant;
590         emit CreateFund(registrant,address(fund));
591         return true;
592     }
593     
594     
595     function inverst(uint256 amount,bytes10  referrer,bytes10  referrerCode) 
596         public 
597         inState(State.Active)
598         nonReentrant 
599         returns(bool)
600     {
601         userModel storage userfund = userinfo[msg.sender];
602         if(userfund.fundaddress == address(0)){
603             createToken(msg.sender,referrer,referrerCode);
604         }
605         userInverstModel storage user = userinverstinfo[msg.sender][round];
606         uint256 inversttime = now;
607         require(amount >= inverstinfo.lowest && amount <= inverstinfo.highest && amount.mod(inverstinfo.basics)==0,"Invalid investment amount");
608         require(inversttime.sub(inverstinfo.interval) >= user.lastinversttime,"Invalid investment time");
609  
610         user.freeze = user.freeze.add(amount);
611         user.totalinverstcount = user.totalinverstcount.add(1);
612         user.totalinverstmoney = user.totalinverstmoney.add(amount);
613         user.balance = user.balance.add(amount);
614         user.lastinversttime = inversttime;
615   
616         callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.transferFrom.selector,msg.sender, userfund.fundaddress, amount));
617         emit Inverst(msg.sender,amount,round);
618         return true;
619     }
620     
621     function withDraw(address feerecipient,uint256 amount,uint256 fee,uint256 signblock,uint256 valid,bytes memory signature) 
622         public 
623         inState(State.Active)
624     {
625         require(!signatures[signature],"Duplicate signature");
626         require(amount >= fee,'Invalid withdraw fee');
627         userInverstModel storage user = userinverstinfo[msg.sender][round];
628         userModel storage userfund = userinfo[msg.sender];
629         require(userfund.fundaddress != address(0) &&_usdtAddress.balanceOf(userfund.fundaddress) >= amount,"Invalid user Or Insufficient balance");
630         
631         require(amount >=withDrawinfo.lowest && amount <= withDrawinfo.highest,"Invalid withdraw amount");
632         require(user.lastwithDrawtime.add(withDrawinfo.interval) <= now,"Invalid withdraw time");
633         require(user.candraw >= amount,"Insufficient  withdrawal balance");
634 
635         require(onlyValidSignature(feerecipient,amount,fee,signblock,valid,signature),"Invalid signature");
636         user.lastwithDrawtime = now;
637         user.candraw = user.candraw.sub(amount);
638         user.balance = user.balance.sub(amount);
639 
640         callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.transferFrom.selector,userfund.fundaddress, msg.sender, amount.sub(fee)));
641         callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.transferFrom.selector,userfund.fundaddress, feerecipient, fee));
642         signatures[signature] = true;
643         emit WithDraw(msg.sender,amount,signature);
644     }
645     
646     function allocationFundsIn(uint256 amount,address source, address destination)  
647         public 
648         onlyManager
649         returns(bool)
650     {
651         userInverstModel storage souruser = userinverstinfo[source][round];
652         userInverstModel storage destuser = userinverstinfo[destination][round];
653         
654         userModel storage sourceuserfund = userinfo[source];
655         userModel storage destinationuserfund = userinfo[destination];
656         
657         require(souruser.freeze >= amount && amount >0,"Invalid allocation of amount");
658         require(sourceuserfund.fundaddress != address(0) && destinationuserfund.fundaddress != address(0),"Invalid allocation user");
659         
660         require(_usdtAddress.balanceOf(sourceuserfund.fundaddress) >= amount,"Insufficient balance");
661       
662         souruser.freeze = souruser.freeze.sub(amount);
663         souruser.balance = souruser.balance.sub(amount);
664         
665         destuser.candraw =destuser.candraw.add(amount);
666         destuser.balance = destuser.balance.add(amount);
667         callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.transferFrom.selector,sourceuserfund.fundaddress, destinationuserfund.fundaddress, amount));
668         emit AllocationFunds(source,destination,amount);
669         return true;
670     }
671     
672     function feewithDraw(uint256 amount,address luckuser,address sysuser) 
673         public 
674         onlyManager
675         returns(bool)
676     {
677         userInverstModel storage user = userinverstinfo[luckuser][round];
678         userModel storage userfund = userinfo[luckuser];
679         require(amount >0 && _usdtAddress.balanceOf(userfund.fundaddress) >= amount,"Invalid fee amount");
680         user.freeze = user.freeze.sub(amount);
681         user.balance = user.balance.sub(amount);
682         callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.transferFrom.selector,userfund.fundaddress, sysuser, amount));
683         return true;
684     }
685     
686     function managerWithDraw(address sender, address recipient, uint256 amount) 
687         public 
688         onlyManager 
689         returns(bool)
690     {
691         userModel storage user = userinfo[sender];
692         require(_usdtAddress.balanceOf(user.fundaddress) >= amount,"Insufficient balance");
693         callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.transferFrom.selector,user.fundaddress, recipient, amount));
694         return true;
695     }
696     
697     function adminWithDraw(address recipient,uint256 amount)
698         public
699         onlyManager
700         returns(bool)
701     {
702         require(_usdtAddress.balanceOf(address(this)) >= amount,"Insufficient balance");
703         callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.transfer.selector,recipient, amount));
704         return true;
705     }
706     
707     function luckReward(uint256 amount,address luckuser,uint256 _round) 
708         public  
709         onlyManager 
710         returns(bool)
711     {
712         require(round == _round ,"Invalid round");
713         userInverstModel storage user = userinverstinfo[luckuser][round];
714         require(!user.luckRewardRecived && amount >0 && _usdtAddress.balanceOf(address(this))>= amount,"Insufficient balance Or User already received the award");
715 
716         callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.transfer.selector,luckuser, amount));
717         user.luckRewardRecived = true;
718         user.luckRewardAmount = amount;
719 
720         emit DrawLuckReward(luckuser,amount,round);
721         return true;
722     }
723     
724     function batchluckRewards(address[] memory lucks, uint256 amount,uint256 _round) 
725         public  
726         onlyManager 
727         returns(bool)
728     {
729         require(round == _round ,"Invalid round");
730         require(lucks.length.mul(amount) <= _usdtAddress.balanceOf(address(this)),"Insufficient contract balance");
731         for(uint i=0;i<lucks.length;i++){
732             userInverstModel storage user = userinverstinfo[lucks[i]][round];
733             require(!user.luckRewardRecived,"User already received the award");
734             callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.transfer.selector,lucks[i], amount));
735             user.luckRewardRecived = true;
736             user.luckRewardAmount = amount;
737         }
738         emit BatchLuckRewards(lucks,amount,round);
739         return true;
740     }
741     
742     function bet(BETGAME _g,uint256 _round,uint256 _id,uint256 _amount,uint8 _color) 
743         public
744         inState(State.Active)
745         returns(bool)
746     {
747         require(_games[address(_g)],"Invalid game");
748         callOptionalReturn(_usdtAddress, abi.encodeWithSelector(_usdtAddress.transferFrom.selector,msg.sender, address(_g), _amount));
749         require(_g.bet(_amount,msg.sender,_color,_round,_id),"Bet Failed");
750         return true;
751     }
752     
753     function  onlyValidSignature(address feerecipient,uint256 amount,uint256 fee ,uint256 signblock ,uint256 valid,bytes memory signature) 
754         public 
755         view 
756         returns(bool)
757     {
758         require(block.number <= signblock.add(valid),"Invalid block");
759         require(isValidSigner(msg.sender,feerecipient,amount,fee,signblock,valid,signature),"Invalid signature");
760         return true;
761     }
762 
763     function callOptionalReturn(IERC20 token, bytes memory data) 
764         private 
765     {
766         require(address(_usdtAddress).isContract(), "SafeERC20: call to non-contract");
767         (bool success, bytes memory returndata) = address(token).call(data);
768         require(success, "SafeERC20: low-level call failed");
769         if (returndata.length > 0) { // Return data is optional
770             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
771         }
772     }
773 }