1 // SPDX-License-Identifier: none
2 
3 pragma solidity >=0.5.0 <0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 library Address {
17     function isContract(address account) internal view returns (bool) {
18         // This method relies on extcodesize, which returns 0 for contracts in
19         // construction, since the code is only stored at the end of the
20         // constructor execution.
21 
22         uint256 size;
23         // solhint-disable-next-line no-inline-assembly
24         assembly { size := extcodesize(account) }
25         return size > 0;
26     }
27     
28     function sendValue(address payable recipient, uint256 amount) internal {
29         require(address(this).balance >= amount, "Address: insufficient balance");
30 
31         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
32         (bool success, ) = recipient.call{ value: amount }("");
33         require(success, "Address: unable to send value, recipient may have reverted");
34     }
35     
36     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
37       return functionCall(target, data, "Address: low-level call failed");
38     }
39     
40     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
41         return functionCallWithValue(target, data, 0, errorMessage);
42     }
43     
44     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
45         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
46     }
47     
48     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
49         require(address(this).balance >= value, "Address: insufficient balance for call");
50         require(isContract(target), "Address: call to non-contract");
51 
52         // solhint-disable-next-line avoid-low-level-calls
53         (bool success, bytes memory returndata) = target.call{ value: value }(data);
54         return _verifyCallResult(success, returndata, errorMessage);
55     }
56     
57     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
58         return functionStaticCall(target, data, "Address: low-level static call failed");
59     }
60     
61     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
62         require(isContract(target), "Address: static call to non-contract");
63 
64         // solhint-disable-next-line avoid-low-level-calls
65         (bool success, bytes memory returndata) = target.staticcall(data);
66         return _verifyCallResult(success, returndata, errorMessage);
67     }
68     
69     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
70         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
71     }
72     
73     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
74         require(isContract(target), "Address: delegate call to non-contract");
75 
76         // solhint-disable-next-line avoid-low-level-calls
77         (bool success, bytes memory returndata) = target.delegatecall(data);
78         return _verifyCallResult(success, returndata, errorMessage);
79     }
80 
81     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
82         if (success) {
83             return returndata;
84         } else {
85             // Look for revert reason and bubble it up if present
86             if (returndata.length > 0) {
87                 // The easiest way to bubble the revert reason is using memory via assembly
88 
89                 // solhint-disable-next-line no-inline-assembly
90                 assembly {
91                     let returndata_size := mload(returndata)
92                     revert(add(32, returndata), returndata_size)
93                 }
94             } else {
95                 revert(errorMessage);
96             }
97         }
98     }
99 }
100 
101 library SafeMath {
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return sub(a, b, "SafeMath: subtraction overflow");
111     }
112 
113     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         require(b <= a, errorMessage);
115         uint256 c = a - b;
116 
117         return c;
118     }
119 
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         if (a == 0) {
122             return 0;
123         }
124 
125         uint256 c = a * b;
126         require(c / a == b, "SafeMath: multiplication overflow");
127 
128         return c;
129     }
130 
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         return div(a, b, "SafeMath: division by zero");
133     }
134 
135     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b > 0, errorMessage);
137         uint256 c = a / b;
138         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139 
140         return c;
141     }
142 
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146     
147     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b != 0, errorMessage);
149         return a % b;
150     }
151 }
152 
153 interface IERC20 {
154     function totalSupply() external view returns (uint256);
155     function decimals() external view returns (uint8);
156     function balanceOf(address account) external view returns (uint256);
157     function transfer(address recipient, uint256 amount) external returns (bool);
158     function allowance(address owner, address spender) external view returns (uint256);
159     function approve(address spender, uint256 amount) external returns (bool);
160     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
161     event Transfer(address indexed from,address indexed to,uint256 value);
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 library SafeERC20 {
166     using SafeMath for uint256;
167     using Address for address;
168 
169     function safeTransfer(IERC20 token, address to, uint256 value) internal {
170         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
171     }
172 
173     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
174         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
175     }
176 
177     function safeApprove(IERC20 token, address spender, uint256 value) internal {
178         require((value == 0) || (token.allowance(address(this), spender) == 0),
179             "SafeERC20: approve from non-zero to non-zero allowance"
180         );
181         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
182     }
183 
184     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
185         uint256 newAllowance = token.allowance(address(this), spender).add(value);
186         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
187     }
188 
189     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
190         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
191         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
192     }
193 
194     function callOptionalReturn(IERC20 token, bytes memory data) private {
195         require(address(token).isContract(), "SafeERC20: call to non-contract");
196         (bool success, bytes memory returndata) = address(token).call(data);
197         require(success, "SafeERC20: low-level call failed");
198 
199         if (returndata.length > 0) {
200             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
201         }
202     }
203 }
204 
205 contract YFDOTStake is Context {
206     using SafeERC20 for IERC20;
207     using Address for address;
208     using SafeMath for uint256;
209     
210     struct periodList{
211         uint256 periodTime;
212         uint256 cooldownTime;
213         uint256 formulaParam1;
214         uint256 formulaParam2;
215         uint256 formulaPenalty1;
216         uint256 formulaPenalty2;
217     }
218     
219     struct userStaking{
220         bool activeStake;
221         uint periodChoosed;
222         address tokenWantStake;
223         uint256 amountStaked;
224         uint256 startStake;
225         uint256 claimStake;
226         uint256 endStake;
227         uint256 cooldownDate;
228         uint256 claimed;
229     }
230     
231     struct rewardDetail{
232         string symboltoken;
233         uint256 equalReward;
234     }
235     
236     mapping (uint => periodList) private period;
237     mapping (address => rewardDetail) private ERC20perYFDOT;
238     mapping (address => userStaking) private stakerDetail;
239     
240     address private _owner;
241     address private _YFDOTtoken;
242     address[] private _tokenStakeList;
243     address[] private _stakerList;
244     uint[] private _periodList;
245     
246     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
247     event Stake(address indexed staker, address indexed tokenStakeTarget, uint256 indexed amountTokenStaked);
248     event Unstake(address indexed staker, address indexed tokenStakeTarget, uint256 indexed amountTokenStaked);
249     event Claim(address indexed staker, address indexed tokenStakeTarget, uint256 indexed amountReward);
250     
251     constructor(address YFDOTAddress){
252         rewardDetail storage est = ERC20perYFDOT[YFDOTAddress];
253         rewardDetail storage nul = ERC20perYFDOT[address(0)];
254         require(YFDOTAddress.isContract() == true,"This address is not Smartcontract");
255         require(IERC20(YFDOTAddress).totalSupply() != 0, "This address is not ERC20 Token");
256         address msgSender = _msgSender();
257         _YFDOTtoken = YFDOTAddress;
258         _owner = msgSender;
259         _tokenStakeList.push(YFDOTAddress);
260         est.equalReward = 10**18;
261         est.symboltoken = "YFDOT";
262         nul.symboltoken = "N/A";
263         emit OwnershipTransferred(address(0), msgSender);
264     }
265     
266     function owner() public view returns (address) {
267         return _owner;
268     }
269 
270     modifier onlyOwner() {
271         require(_owner == _msgSender(), "Caller is not the owner");
272         _;
273     }
274 
275     function renounceOwnership() public virtual onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279     
280     function transferOwnership(address newOwner) public virtual onlyOwner {
281         require(newOwner != address(0), "New owner is the zero address");
282         emit OwnershipTransferred(_owner, newOwner);
283         _owner = newOwner;
284     }
285     
286     function addTokenReward(address erc20Token, uint256 amountEqual, string memory symboltokens) public virtual onlyOwner{
287         require(erc20Token.isContract() == true,"This address is not Smartcontract");
288         require(IERC20(erc20Token).totalSupply() != 0, "This address is not ERC20 Token");
289         rewardDetail storage est = ERC20perYFDOT[erc20Token];
290         est.equalReward = amountEqual;
291         est.symboltoken = symboltokens;
292         
293         _tokenStakeList.push(erc20Token);
294     }
295     
296     function editTokenReward(address erc20Token, uint256 amountEqual, string memory symboltokens) public virtual onlyOwner{
297         require(erc20Token.isContract() == true,"This address is not Smartcontract");
298         require(IERC20(erc20Token).totalSupply() != 0, "This address is not ERC20 Token");
299         
300         rewardDetail storage est = ERC20perYFDOT[erc20Token];
301         est.equalReward = amountEqual;
302         est.symboltoken = symboltokens;
303     }
304     
305     function addPeriod(uint256 timePeriodStake, uint256 timeCooldownUnstake, uint256 formula1, uint256 formula2, uint256 fpel1, uint256 fpel2) public virtual onlyOwner{
306         uint newPeriod = _periodList.length;
307         if(newPeriod == 0){
308             newPeriod = 1;
309         }else{
310             newPeriod = newPeriod + 1;
311         }
312         
313         periodList storage sys = period[newPeriod];
314         sys.periodTime = timePeriodStake;
315         sys.cooldownTime = timeCooldownUnstake;
316         sys.formulaParam1 = formula1;
317         sys.formulaParam2 = formula2;
318         sys.formulaPenalty1 = fpel1;
319         sys.formulaPenalty2 = fpel2;
320         
321         _periodList.push(newPeriod);
322     }
323     
324     function editPeriod(uint periodEdit, uint256 timePeriodStake, uint256 timeCooldownUnstake, uint256 formula1, uint256 formula2, uint256 fpel1, uint256 fpel2) public virtual onlyOwner{
325         periodList storage sys = period[periodEdit];
326         sys.periodTime = timePeriodStake;
327         sys.cooldownTime = timeCooldownUnstake;
328         sys.formulaParam1 = formula1;
329         sys.formulaParam2 = formula2;
330         sys.formulaPenalty1 = fpel1;
331         sys.formulaPenalty2 = fpel2;
332     }
333     
334     function claimReward() public virtual{
335         address msgSender = _msgSender();
336         userStaking storage usr = stakerDetail[msgSender];
337         uint256 getrewardbalance = IERC20(usr.tokenWantStake).balanceOf(address(this));
338         uint256 getReward = getRewardClaimable(msgSender);
339         uint256 today = block.timestamp;
340         
341         require(getrewardbalance >= getReward, "Please wait until reward pool filled, try again later.");
342         require(usr.claimStake < block.timestamp, "Please wait until wait time reached.");
343         
344         usr.claimed = usr.claimed.add(getReward);
345         usr.claimStake = today.add(7 days);
346         IERC20(usr.tokenWantStake).safeTransfer(msgSender, getReward);
347         emit Claim(msgSender, usr.tokenWantStake, getReward);
348     }
349     
350     function stakeNow(address tokenTargetStake, uint256 amountWantStake, uint periodwant) public virtual{
351         address msgSender = _msgSender();
352         uint256 getallowance = IERC20(_YFDOTtoken).allowance(msgSender, address(this));
353         
354         if(getRewardClaimable(msgSender) > 0){
355             revert("Please claim your reward from previous staking");
356         }
357         
358         require(amountWantStake >= 500000000000, "Minimum staking 0.00005 YFDOT");
359         require(getallowance >= amountWantStake, "Insufficient YFDOT token approval balance, you must increase your allowance" );
360         
361         uint256 today = block.timestamp;
362         userStaking storage usr = stakerDetail[msgSender];
363         periodList storage sys = period[periodwant];
364         
365         usr.activeStake = true;
366         usr.periodChoosed = periodwant;
367         usr.tokenWantStake = tokenTargetStake;
368         usr.amountStaked = amountWantStake;
369         usr.startStake = today;
370         usr.claimStake = today.add(7 days);
371         usr.cooldownDate = today.add(sys.cooldownTime);
372         usr.endStake = today.add(sys.periodTime);
373         usr.claimed = 0;
374         
375         bool checkregis = false;
376         for(uint i = 0; i < _stakerList.length; i++){
377             if(_stakerList[i] == msgSender){
378                 checkregis = true;
379             }
380         }
381         
382         if(checkregis == false){
383             _stakerList.push(msgSender);
384         }
385         
386         IERC20(_YFDOTtoken).safeTransferFrom(msgSender, address(this), amountWantStake);
387         emit Stake(msgSender, tokenTargetStake, amountWantStake);
388     }
389     
390     function unstakeNow() public virtual{
391         address msgSender = _msgSender();
392         userStaking storage usr = stakerDetail[msgSender];
393         periodList storage sys = period[usr.periodChoosed];
394         
395         require(usr.activeStake == true, "Stake not active yet" );
396         
397         uint256 tokenUnstake;
398         if(block.timestamp < usr.cooldownDate){
399             uint256 penfee = usr.amountStaked.mul(sys.formulaPenalty1);
400             penfee = penfee.div(sys.formulaPenalty2);
401             penfee = penfee.div(100);
402             tokenUnstake = usr.amountStaked.sub(penfee);
403         }else{
404             tokenUnstake = usr.amountStaked;
405         }
406         
407         usr.activeStake = false;
408         if(block.timestamp < usr.endStake){
409             usr.endStake = block.timestamp;
410         }
411         
412         IERC20(_YFDOTtoken).safeTransfer(msgSender, tokenUnstake);
413         
414         emit Unstake(msgSender, usr.tokenWantStake, usr.amountStaked);
415     }
416     
417     function getEqualReward(address erc20Token) public view returns(uint256, string memory){
418         rewardDetail storage est = ERC20perYFDOT[erc20Token];
419         return(
420             est.equalReward,
421             est.symboltoken
422         );
423     }
424     
425     function getTotalStaker() public view returns(uint256){
426         return _stakerList.length;
427     }
428     
429     function getActiveStaker() view public returns(uint256){
430         uint256 activeStake;
431         for(uint i = 0; i < _stakerList.length; i++){
432             userStaking memory l = stakerDetail[_stakerList[i]];
433             if(l.activeStake == true){
434                 activeStake = activeStake + 1;
435             }
436         }
437         return activeStake;
438     }
439     
440     function getTokenList() public view returns(address[] memory){
441         return _tokenStakeList;
442     }
443     
444     function getPeriodList() public view returns(uint[] memory){
445         return _periodList;
446     }
447     
448     function getPeriodDetail(uint periodwant) public view returns(uint256, uint256, uint256, uint256, uint256, uint256){
449         periodList storage sys = period[periodwant];
450         return(
451             sys.periodTime,
452             sys.cooldownTime,
453             sys.formulaParam1,
454             sys.formulaParam2,
455             sys.formulaPenalty1,
456             sys.formulaPenalty2
457         );
458     }
459     
460     function getUserInfo(address stakerAddress) public view returns(bool, uint, address, string memory, uint256, uint256, uint256, uint256, uint256, uint256){
461         userStaking storage usr = stakerDetail[stakerAddress];
462         rewardDetail storage est = ERC20perYFDOT[usr.tokenWantStake];
463         
464         uint256 amountTotalStaked;
465         if(usr.activeStake == false){
466             amountTotalStaked = 0;
467         }else{
468             amountTotalStaked = usr.amountStaked;
469         }
470         return(
471             usr.activeStake,
472             usr.periodChoosed,
473             usr.tokenWantStake,
474             est.symboltoken,
475             amountTotalStaked,
476             usr.startStake,
477             usr.claimStake,
478             usr.endStake,
479             usr.cooldownDate,
480             usr.claimed
481         );
482     }
483     
484     function getRewardClaimable(address stakerAddress) public view returns(uint256){
485         userStaking storage usr = stakerDetail[stakerAddress];
486         periodList storage sys = period[usr.periodChoosed];
487         rewardDetail storage est = ERC20perYFDOT[usr.tokenWantStake];
488         
489         uint256 rewards;
490         
491         if(usr.amountStaked == 0 && usr.tokenWantStake == address(0)){
492             rewards = 0;
493         }else{
494             uint256 perSec = usr.amountStaked.mul(sys.formulaParam1);
495             perSec = perSec.div(sys.formulaParam2);
496             perSec = perSec.div(100);
497             
498             uint256 today = block.timestamp;
499             uint256 diffTime;
500             if(today > usr.endStake){
501                 diffTime = usr.endStake.sub(usr.startStake);
502             }else{
503                 diffTime = today.sub(usr.startStake);
504             }
505             rewards = perSec.mul(diffTime);
506             uint256 getTokenEqual = est.equalReward;
507             rewards = rewards.mul(getTokenEqual);
508             rewards = rewards.div(10**18);
509             rewards = rewards.sub(usr.claimed);
510         }
511         return rewards;
512     }
513     
514     function getRewardObtained(address stakerAddress) public view returns(uint256){
515         userStaking storage usr = stakerDetail[stakerAddress];
516         periodList storage sys = period[usr.periodChoosed];
517         rewardDetail storage est = ERC20perYFDOT[usr.tokenWantStake];
518         uint256 rewards;
519         
520         if(usr.amountStaked == 0 && usr.tokenWantStake == address(0)){
521             rewards = 0;
522         }else{
523             uint256 perSec = usr.amountStaked.mul(sys.formulaParam1);
524             perSec = perSec.div(sys.formulaParam2);
525             perSec = perSec.div(100);
526             
527             uint256 today = block.timestamp;
528             uint256 diffTime;
529             if(today > usr.endStake){
530                 diffTime = usr.endStake.sub(usr.startStake);
531             }else{
532                 diffTime = today.sub(usr.startStake);
533             }
534             rewards = perSec.mul(diffTime);
535             uint256 getTokenEqual = est.equalReward;
536             rewards = rewards.mul(getTokenEqual);
537             rewards = rewards.div(10**18);
538         }
539         return rewards;
540     }
541     
542     function getRewardEstimator(address stakerAddress) public view returns(uint256,uint256,uint256,uint256,uint256,uint256){
543         userStaking storage usr = stakerDetail[stakerAddress];
544         periodList storage sys = period[usr.periodChoosed];
545         rewardDetail storage est = ERC20perYFDOT[usr.tokenWantStake];
546         uint256 amountStakedNow;
547         
548         if(usr.activeStake == true){
549             amountStakedNow = usr.amountStaked;
550             uint256 perSec = amountStakedNow.mul(sys.formulaParam1);
551             uint256 getTokenEqual = est.equalReward;
552             perSec = perSec.div(sys.formulaParam2);
553             perSec = perSec.div(100);
554             perSec = perSec.mul(getTokenEqual);
555             perSec = perSec.div(10**18);
556             
557             return(
558                 perSec,
559                 perSec.mul(60),
560                 perSec.mul(3600),
561                 perSec.mul(86400),
562                 perSec.mul(604800),
563                 perSec.mul(2592000)
564             );
565         }else{
566             return(0,0,0,0,0,0);
567         }
568         
569     }
570     
571     function getRewardCalculator(address tokenWantStake, uint256 amountWantStake, uint periodwant) public view returns(uint256){
572         periodList storage sys = period[periodwant];
573         rewardDetail storage est = ERC20perYFDOT[tokenWantStake];
574         
575         uint256 perSec = amountWantStake.mul(sys.formulaParam1);
576         perSec = perSec.div(sys.formulaParam2);
577         perSec = perSec.div(100);
578         
579         uint256 startDate = block.timestamp;
580         uint256 endDate = startDate.add(sys.periodTime);
581         uint256 diffTime = endDate.sub(startDate);
582         uint256 rewards = perSec.mul(diffTime);
583         uint256 getTokenEqual = est.equalReward;
584         rewards = rewards.mul(getTokenEqual);
585         rewards = rewards.div(10**18);
586         return rewards;
587     }
588 }