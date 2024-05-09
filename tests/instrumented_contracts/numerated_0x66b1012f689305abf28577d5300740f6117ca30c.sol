1 pragma solidity ^0.5.15;
2 
3 library SafeMath {
4     
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16 
17     
18     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21 
22         return c;
23     }
24 
25     
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         
28         
29         
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36 
37         return c;
38     }
39 
40     
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         return div(a, b, "SafeMath: division by zero");
43     }
44 
45     
46     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         
48         require(b > 0, errorMessage);
49         uint256 c = a / b;
50         
51 
52         return c;
53     }
54 
55     
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         return mod(a, b, "SafeMath: modulo by zero");
58     }
59 
60     
61     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b != 0, errorMessage);
63         return a % b;
64     }
65 }
66 
67 interface IERC20 {
68     /**
69      * @dev Returns the amount of tokens in existence.
70      */
71     function totalSupply() external view returns (uint256);
72 
73     /**
74      * @dev Returns the amount of tokens owned by `account`.
75      */
76     function balanceOf(address account) external view returns (uint256);
77 
78     /**
79      * @dev Moves `amount` tokens from the caller's account to `recipient`.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transfer(address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Returns the remaining number of tokens that `spender` will be
89      * allowed to spend on behalf of `owner` through {transferFrom}. This is
90      * zero by default.
91      *
92      * This value changes when {approve} or {transferFrom} are called.
93      */
94     function allowance(address owner, address spender) external view returns (uint256);
95 
96     /**
97      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * IMPORTANT: Beware that changing an allowance with this method brings the risk
102      * that someone may use both the old and the new allowance by unfortunate
103      * transaction ordering. One possible solution to mitigate this race
104      * condition is to first reduce the spender's allowance to 0 and set the
105      * desired value afterwards:
106      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107      *
108      * Emits an {Approval} event.
109      */
110     function approve(address spender, uint256 amount) external returns (bool);
111 
112     /**
113      * @dev Moves `amount` tokens from `sender` to `recipient` using the
114      * allowance mechanism. `amount` is then deducted from the caller's
115      * allowance.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Emitted when `value` tokens are moved from one account (`from`) to
125      * another (`to`).
126      *
127      * Note that `value` may be zero.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 value);
130 
131     /**
132      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
133      * a call to {approve}. `value` is the new allowance.
134      */
135     event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 // File: @openzeppelin/contracts/utils/Address.sol
139 
140 pragma solidity ^0.5.5;
141 
142 /**
143  * @dev Collection of functions related to the address type
144  */
145 library Address {
146     /**
147      * @dev Returns true if `account` is a contract.
148      *
149      * This test is non-exhaustive, and there may be false-negatives: during the
150      * execution of a contract's constructor, its address will be reported as
151      * not containing a contract.
152      *
153      * IMPORTANT: It is unsafe to assume that an address for which this
154      * function returns false is an externally-owned account (EOA) and not a
155      * contract.
156      */
157     function isContract(address account) internal view returns (bool) {
158         // This method relies in extcodesize, which returns 0 for contracts in
159         // construction, since the code is only stored at the end of the
160         // constructor execution.
161 
162         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
163         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
164         // for accounts without code, i.e. `keccak256('')`
165         bytes32 codehash;
166         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
167         // solhint-disable-next-line no-inline-assembly
168         assembly { codehash := extcodehash(account) }
169         return (codehash != 0x0 && codehash != accountHash);
170     }
171 
172     /**
173      * @dev Converts an `address` into `address payable`. Note that this is
174      * simply a type cast: the actual underlying value is not changed.
175      *
176      * _Available since v2.4.0._
177      */
178     function toPayable(address account) internal pure returns (address payable) {
179         return address(uint160(account));
180     }
181 
182     /**
183      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
184      * `recipient`, forwarding all available gas and reverting on errors.
185      *
186      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
187      * of certain opcodes, possibly making contracts go over the 2300 gas limit
188      * imposed by `transfer`, making them unable to receive funds via
189      * `transfer`. {sendValue} removes this limitation.
190      *
191      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
192      *
193      * IMPORTANT: because control is transferred to `recipient`, care must be
194      * taken to not create reentrancy vulnerabilities. Consider using
195      * {ReentrancyGuard} or the
196      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
197      *
198      * _Available since v2.4.0._
199      */
200     function sendValue(address payable recipient, uint256 amount) internal {
201         require(address(this).balance >= amount, "Address: insufficient balance");
202 
203         // solhint-disable-next-line avoid-call-value
204         (bool success, ) = recipient.call.value(amount)("");
205         require(success, "Address: unable to send value, recipient may have reverted");
206     }
207 }
208 
209 
210 /**
211  * @title SafeERC20
212  * @dev Wrappers around ERC20 operations that throw on failure (when the token
213  * contract returns false). Tokens that return no value (and instead revert or
214  * throw on failure) are also supported, non-reverting calls are assumed to be
215  * successful.
216  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
217  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
218  */
219 library SafeERC20 {
220     using SafeMath for uint256;
221     using Address for address;
222 
223     function safeTransfer(IERC20 token, address to, uint256 value) internal {
224         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
225     }
226 
227     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
228         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
229     }
230 
231     function safeApprove(IERC20 token, address spender, uint256 value) internal {
232         // safeApprove should only be called when setting an initial allowance,
233         // or when resetting it to zero. To increase and decrease it, use
234         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
235         // solhint-disable-next-line max-line-length
236         require((value == 0) || (token.allowance(address(this), spender) == 0),
237             "SafeERC20: approve from non-zero to non-zero allowance"
238         );
239         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
240     }
241 
242     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
243         uint256 newAllowance = token.allowance(address(this), spender).add(value);
244         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
245     }
246 
247     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
248         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
249         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
250     }
251 
252     /**
253      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
254      * on the return value: the return value is optional (but if data is returned, it must not be false).
255      * @param token The token targeted by the call.
256      * @param data The call data (encoded using abi.encode or one of its variants).
257      */
258     function callOptionalReturn(IERC20 token, bytes memory data) private {
259         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
260         // we're implementing it ourselves.
261 
262         // A Solidity high level call has three parts:
263         //  1. The target address is checked to verify it contains contract code
264         //  2. The call itself is made, and success asserted
265         //  3. The return value is decoded, which in turn checks the size of the returned data.
266         // solhint-disable-next-line max-line-length
267         require(address(token).isContract(), "SafeERC20: call to non-contract");
268 
269         // solhint-disable-next-line avoid-low-level-calls
270         (bool success, bytes memory returndata) = address(token).call(data);
271         require(success, "SafeERC20: low-level call failed");
272 
273         if (returndata.length > 0) { // Return data is optional
274             // solhint-disable-next-line max-line-length
275             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
276         }
277     }
278 }
279 
280 contract Context {
281     
282     
283     constructor () internal { }
284     
285 
286     function _msgSender() internal view returns (address payable) {
287         return msg.sender;
288     }
289 
290     function _msgData() internal view returns (bytes memory) {
291         this; 
292         return msg.data;
293     }
294 }
295 
296 contract Ownable is Context {
297     
298     using SafeMath for uint256;
299     
300     address private _owner;
301 
302     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
303 
304     
305     constructor () internal {
306         address msgSender = _msgSender();
307         _owner = msgSender;
308         emit OwnershipTransferred(address(0), msgSender);
309     }
310 
311     
312     function owner() public view returns (address) {
313         return _owner;
314     }
315 
316     
317     modifier onlyOwner() {
318         require(isOwner(), "Ownable: caller is not the owner");
319         _;
320     }
321 
322     
323     function isOwner() public view returns (bool) {
324         return _msgSender() == _owner;
325     }
326 
327     
328     function renounceOwnership() public onlyOwner {
329         emit OwnershipTransferred(_owner, address(0));
330         _owner = address(0);
331     }
332 
333     
334     function transferOwnership(address newOwner) public onlyOwner {
335         _transferOwnership(newOwner);
336     }
337 
338     
339     function _transferOwnership(address newOwner) internal {
340         require(newOwner != address(0), "Ownable: new owner is the zero address");
341         emit OwnershipTransferred(_owner, newOwner);
342         _owner = newOwner;
343     }
344 }
345 
346 interface PZSConfig {
347     
348     function getStage(uint8 version) external view returns(uint256 minimum,uint256 maximum,uint256 period,uint256 scale,uint256 totalSuply,uint256 startTime,uint256 partnerBecome);
349     
350     function checkStart(uint8 version) external view returns(bool);
351     
352     function partnerBecome(uint8 version) external view returns(uint256);
353     
354     function underway() external view returns(uint8);
355     
356     function getCommon() external view returns(uint256 withdrawFee,uint256 partnerBecomePercent,uint256 partnerDirectPercent,uint256 partnerReferRewardPercent,uint256[2] memory referRewardPercent);
357 
358 }
359 
360 contract PZSSub is Ownable{
361     
362     using SafeMath for uint256;
363     
364     using SafeERC20 for IERC20;
365     
366     IERC20 public pzsImpl;
367     
368     
369     address private ROOT_ADDRESS = address(0xe060545d74CF8F5B2fDfC95b0E73673B7Bbfd291);
370     
371     address payable private PROJECT_NODE_ADDRESS = address(0xf99faD379C981aAf9f5b7537949B2c8D97e77Bba);
372     
373     address payable private PROJECT_LEADER_ADDRESS = address(0x30D1BcDf6726832f131818FcEDeC9784dD11E18f);
374     
375     address payable private PROJECT_FEE_ADDRESS = address(0xCE79D3d0A8Ad2c783e11090ECDa57C17c752da36);
376     
377     
378     //---------------------------------------------------------------------------------------------
379     constructor(address conf,address pzt) public {
380         config = PZSConfig(conf);
381         
382         //registration(INIT_ADDRESS,address(0),false);
383         registration(ROOT_ADDRESS,address(0),true);
384         
385         pzsImpl = IERC20(pzt);
386     }
387     
388     function upgrade(address[] calldata addList,address referAddress) external onlyOwner returns(bool){
389         for(uint8 i;i<addList.length;i++){
390             registration(addList[i],referAddress,true);
391         }
392     }
393     
394     function changePZS(address pzsAddress) external onlyOwner returns(bool) {
395         pzsImpl = IERC20(pzsAddress);
396     }
397     
398     function changeConfig(address conf) external onlyOwner returns(bool) {
399         config = PZSConfig(conf);
400     }
401     
402     struct User {
403         
404         bool active;
405         
406         address referrer;
407         
408         uint256 id;
409         
410         bool node;
411         
412         uint256 direcCount;
413         
414         uint256 indirectCount;
415         
416         uint256 teamCount;
417         
418         uint256[3] subAmount;
419         
420         uint256[3] subAward;
421         
422         uint256[3] partnerAward;
423     }
424     
425     
426     PZSConfig private config;
427     
428     //Recommend reward generation one, generation two
429     //uint256[2] public referRewardPercent = [20,15];
430     
431     //Super node subscription incentive rate
432     //uint256 public partnerReferRewardPercent = 15;
433     
434     uint8 public teamCountLimit = 15;
435     //uint256 public withdrawFee = 0.005 ether;
436     
437     //Under the umbrella of the super node purchase rebate rate
438     //uint256 public partnerBecomePercent = 50;
439     
440     //Ordinary nodes directly push the reward rate
441     //uint256 public partnerDirectPercent = 20;
442     
443     mapping(address=>User) public users;
444     
445     mapping(address=>uint256[3]) awards;
446     
447     mapping(uint256=>address) public addressIndexs;
448     
449     //mapping(address=>uint256[3]) partnerAwards;
450     
451     uint256 public userCounter;
452     
453     uint256[3] public totalSubEth;
454     
455     event Registration(address indexed user, address indexed referrer);
456     
457     event ApplyForPartner(address indexed user,address indexed referrer,address indexed node,uint256 partnerDirectAward,uint256 partnerBecomeAward);
458     
459     event Subscribe(address indexed user,uint256 changeAmount,uint256 exchangeAmout);
460     
461     event WithdrawAward(address indexed user,uint256 subAward);
462     
463     //event WithdrawPartnerAward(address indexed user,uint256 subAward);
464     
465     //event AllotPartnerAward(address indexed user,address indexed node,uint256 partnerAward);
466     
467     //event AllotSubAward(address indexed user,address indexed sub1,address indexed sub2,uint256 subAward1,uint256 subAward2);
468     
469     event AllotSubAward(address indexed user,address indexed subAddress,uint256 partnerAward,uint8 awardType);
470     
471     function isUserExists(address userAddress) private view returns(bool) {
472         
473         return users[userAddress].active;
474     }
475     
476     function underway() public view returns(uint8 version){
477         version = config.underway();
478         return version;
479     }
480     
481     function getGlobalStats(uint8 version) public view returns(uint256[9] memory stats){
482         (uint256 minimum,uint256 maximum,uint256 period,uint256 scale,uint256 totalSuply,uint256 startTime,uint256 partnerBecome) = config.getStage(version);
483         stats[0] = minimum;
484         stats[1] = maximum;
485         stats[2] = period;
486         stats[3] = scale;
487         stats[4] = totalSuply;
488         stats[5] = startTime;
489         stats[6] = partnerBecome;
490         stats[7] = totalSubEth[version].mul(scale);
491         stats[8] = userCounter;
492         return stats;
493     }
494     
495     function getPersonalStats(uint8 version,address userAddress) external view returns (uint256[10] memory stats){
496         User memory user = users[userAddress];
497         stats[0] = user.id;
498         stats[1] = user.node?1:0;
499         stats[2] = user.teamCount;
500         stats[3] = user.direcCount;
501         stats[4] = user.indirectCount;
502         stats[5] = user.subAmount[version];
503         stats[6] = user.subAward[version];
504         stats[7] = user.partnerAward[version];
505         stats[8] = awards[userAddress][version];
506         stats[9] = user.active?1:0;
507     }
508 
509     function getNodeAddress(address userAddress) public view returns (address nodeAddress){
510         
511         while(true){
512             if (users[users[userAddress].referrer].node) {
513                 return users[userAddress].referrer;
514             }
515             userAddress = users[userAddress].referrer;
516             
517             if(userAddress==address(0)){
518                 break;
519             }
520         }
521         
522     }
523     
524     
525     
526     
527     function regist(uint256 id) public  {
528         require(!Address.isContract(msg.sender),"not allow");
529         require(id>0,"error");
530         require(!isUserExists(msg.sender),"exist");
531         address referAddress = addressIndexs[id];
532         require(isUserExists(referAddress),"ref not regist");
533 
534         registration(msg.sender,referAddress,false);
535     }
536     
537     function applyForPartner(uint8 version) public payable returns (bool){
538         
539         require(isUserExists(msg.sender),"User not registered");
540         
541         require(config.checkStart(version),"Unsupported type");
542         
543         require(!users[msg.sender].node,"Has been activated");
544         
545         require(msg.value==config.partnerBecome(version),"amount error");
546         
547         address referrerAddress = users[msg.sender].referrer;
548         
549         address nodeAddress = getNodeAddress(msg.sender);
550         
551         require(referrerAddress!=address(0),"referrerAddress error 0");
552         require(nodeAddress!=address(0),"referrerAddress error 0");
553         
554         (,uint256 partnerBecomePercent,uint256 partnerDirectPercent,,) =  config.getCommon();
555         
556         uint256 partnerDirectAward = msg.value.mul(partnerDirectPercent).div(100);
557         uint256 partnerBecomeAward = msg.value.mul(partnerBecomePercent).div(100);
558         
559         
560         users[msg.sender].node = true;
561         
562         awards[referrerAddress][version] = awards[referrerAddress][version].add(partnerDirectAward);
563         awards[nodeAddress][version] = awards[nodeAddress][version].add(partnerBecomeAward);
564 
565         //partnerAwards[referrerAddress][version] = partnerAwards[referrerAddress][version].add(partnerDirectAward);
566         //partnerAwards[nodeAddress][version] = partnerAwards[nodeAddress][version].add(partnerBecomeAward);
567         
568         users[referrerAddress].partnerAward[version] = users[referrerAddress].partnerAward[version].add(partnerDirectAward);
569         users[nodeAddress].partnerAward[version] = users[nodeAddress].partnerAward[version].add(partnerBecomeAward);
570         
571 
572         PROJECT_NODE_ADDRESS.transfer(msg.value.sub(partnerDirectAward).sub(partnerBecomeAward));
573         
574         emit ApplyForPartner(msg.sender,referrerAddress,nodeAddress,partnerDirectAward,partnerBecomeAward);
575         
576         return true;
577     }
578      
579     function subscribe(uint8 version) public payable returns(bool) {
580         
581         require(isUserExists(msg.sender),"User not registered");
582         
583         require(config.checkStart(version),"Unsupported type");
584         
585         (uint256 minimum,uint256 maximum,,uint256 scale,,,) = config.getStage(version);
586         
587         require(msg.value>=minimum,"error sub type");
588         
589         uint256 subVersionAmount = users[msg.sender].subAmount[version];
590         
591         require(subVersionAmount.add(msg.value)<=maximum,"Exceeding sub limit");
592         
593         (uint256 subAward1,uint256 subAward2) = allotSubAward(version,msg.sender,msg.value);
594         uint256 partnerAward = allotPartnerAward(version,msg.sender,msg.value);
595         
596         PROJECT_LEADER_ADDRESS.transfer(msg.value.sub(subAward1).sub(subAward2).sub(partnerAward));
597         
598         totalSubEth[version] = totalSubEth[version].add(msg.value);
599         users[msg.sender].subAmount[version] = users[msg.sender].subAmount[version].add(msg.value);
600         
601         uint256 exchangePZSAmount = msg.value.mul(scale);
602         
603         //pzsImpl.approve(address(this),exchangePZSAmount);
604         //pzsImpl.safeTransferFrom(address(this),msg.sender,exchangePZSAmount);
605         pzsImpl.safeTransfer(msg.sender,exchangePZSAmount);
606         
607         emit Subscribe(msg.sender,msg.value,exchangePZSAmount);
608         
609         return true;
610     }
611 
612     
613     function withdrawAward(uint8 version) public returns(uint256){
614         uint256 subAward = awards[msg.sender][version];
615         (uint256 withdrawFee,,,,) =  config.getCommon();
616         require(subAward>withdrawFee,"error ");
617         require(address(this).balance >= subAward,"not enought");
618         awards[msg.sender][version] = 0;
619         PROJECT_FEE_ADDRESS.transfer(withdrawFee);
620         msg.sender.transfer(subAward.sub(withdrawFee));
621         emit WithdrawAward(msg.sender,subAward);
622     }
623     
624     /*
625     function withdrawPartnerAward(uint8 version) public payable returns(uint256){
626         uint256 partnerAward = partnerAwards[msg.sender][version];
627         require(partnerAward>0,"error ");
628         require(address(this).balance >= partnerAward,"not enought");
629         partnerAwards[msg.sender][version] = 0;
630         msg.sender.transfer(partnerAward);
631         emit WithdrawPartnerAward(msg.sender,partnerAward);
632     }*/
633     
634     function allotPartnerAward(uint8 version,address userAddress,uint256 amount) private returns (uint256 partnerAward){
635         address nodeAddress = getNodeAddress(msg.sender);
636         
637         (,,,uint256 partnerReferRewardPercent,) =  config.getCommon();
638         partnerAward = amount.mul(partnerReferRewardPercent).div(100);
639         if(nodeAddress==address(0)){
640             partnerAward = 0;
641         }else{
642             awards[nodeAddress][version] = awards[nodeAddress][version].add(partnerAward);
643             
644         }
645         
646         users[nodeAddress].subAward[version] = users[nodeAddress].subAward[version].add(partnerAward);
647         //emit AllotPartnerAward(userAddress,nodeAddress,partnerAward);
648         emit AllotSubAward(userAddress,nodeAddress,partnerAward,3);
649         
650         return partnerAward;
651     }
652     
653     function allotSubAward(uint8 version,address userAddress,uint256 amount) private returns (uint256 subAward1,uint256 subAward2) {
654         address sub1 = users[userAddress].referrer;
655         address sub2 = users[sub1].referrer;
656         (,,,,uint256[2] memory referRewardPercent) =  config.getCommon();
657         subAward1 = amount.mul(referRewardPercent[0]).div(100);
658         subAward2 = amount.mul(referRewardPercent[1]).div(100);
659         
660         if(sub1==address(0)){
661             subAward1 = 0;
662             subAward2 = 0;
663         }else{
664             
665             if(sub2==address(0)){
666                 subAward2 = 0;
667                 awards[sub1][version] = awards[sub1][version].add(subAward1);
668             }else{
669                 awards[sub1][version] = awards[sub1][version].add(subAward1);
670                 awards[sub2][version] = awards[sub2][version].add(subAward2);
671             }
672         }
673         
674         
675         users[sub1].subAward[version] = users[sub1].subAward[version].add(subAward1);
676         users[sub2].subAward[version] = users[sub2].subAward[version].add(subAward2);
677         
678         emit AllotSubAward(userAddress,sub1,subAward1,1);
679         emit AllotSubAward(userAddress,sub2,subAward2,2);
680         //emit AllotSubAward(userAddress,sub1,sub2,subAward1,subAward2);
681         return (subAward1,subAward2);
682     }
683     
684     function registration (address userAddress,address referAddress,bool node) private {
685         require(!isUserExists(msg.sender),"exist");
686         users[userAddress] = createUser(userAddress,referAddress,node);
687         users[referAddress].direcCount++;
688         users[users[referAddress].referrer].indirectCount++;
689         
690         teamCount(userAddress);
691         
692         emit Registration(userAddress,referAddress);
693     }
694     
695     function teamCount(address userAddress) private{
696         address ref = users[userAddress].referrer;
697         
698         for(uint8 i = 0;i<teamCountLimit;i++){
699             
700             if(ref==address(0)){
701                 break;
702             }
703             users[ref].teamCount++;
704 
705             ref = users[ref].referrer;
706         }
707         
708     }
709     
710     function createUser(address userAddress,address referrer,bool node) private returns(User memory user){
711         uint256[3] memory subAmount;
712         uint256[3] memory subAward;
713         uint256[3] memory partnerAward;
714         userCounter++;
715         addressIndexs[userCounter] = userAddress;
716         user = User({
717             active: true,
718             referrer: referrer,
719             id: userCounter,
720             node: node,
721             direcCount: 0,
722             indirectCount: 0,
723             teamCount: 1,
724             subAmount: subAmount,
725             subAward: subAward,
726             partnerAward: partnerAward
727         });
728     }
729     
730 }