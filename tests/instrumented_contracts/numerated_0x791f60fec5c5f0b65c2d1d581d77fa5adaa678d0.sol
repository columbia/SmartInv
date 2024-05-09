1 /*
2 
3 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
4 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKkkKWMMMMMMWKkkKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXl''dNMMMMMMNo''oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxoOWMMMMMMWkoxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKONMMMMMMXkKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0kXMMMMMMXk0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0O0XMMMMX0O0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOkXNNXk0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk:;::;c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOxOKkdc,....,ldk0Ox0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMMMMMMMMMMMMWOc,',,,;coddddoc;,,,',lOWMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 MMMMMMMMMMMMMMMMMMMMMMMMMMMXd,.';oOXWMMMMMMWXOo;'.,dXMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 MMMMMMMMMMMMMMMMMMMMMMMMMMMNd,'l0WMMMWNXXNWMMMW0c',dNMMMMMMMMMMMMMMMMMMMMMMMMMMM
20 MMMMMMMMMMMMMMMMMMMMMMMMWX0x,'lXMMMNkdxdollkNMMMKc';dOXMMMMMMMMMMMMMMMMMMMMMMMMM
21 MMMMMMMMMMMMMMMMMMMMMMMMNo,'.;OMMMNd,cOOd:.'dNMMWk,'',dWMMMMMMMMMMMMMMMMMMMMMMMM
22 MMMMMMMMMMMMMMMMMMMMMMMMXl'..;OMMMXl.',,''.'lXMMMO;..'oNMMMMMMMMMMMMMMMMMMMMMMMM
23 MMMMMMMMMMMMMMMMMMMMMMMMWOdc',xWMMWOc,...',c0WMMNd''cdOWMMMMMMMMMMMMMMMMMMMMMMMM
24 MMMMMMMMMMMMMMMMMMMMMMMMMMWKl';kWMMMN0kxxk0NMMMNx;'cKWWMMMMMMMMMMMMMMMMMMMMMMMMM
25 MMMMMMMMMMMMMMMMMMMMMMMMMMMXd;.,o0NMMMMMMMMMMN0l,.,oXMMMMMMMMMMMMMMMMMMMMMMMMMMM
26 MMMMMMMMMMMMMMMMMMMMMMMMMMMXd;'.',cdk0KKKK0kdc,'..,dXMMMMMMMMMMMMMMMMMMMMMMMMMMM
27 MMMMMMMMMMMMMMMMMMMMMMMMMMMMW0l,:l:,',,,,,,,,:oc,c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMM
28 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;dNN0o;'..';dKNWk;xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
29 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;oNMWNOc''c0NMMMk;xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
30 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKl:dKWMKc..cKMMXkccOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
31 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXx:lXMXo;;oXMNd;oKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
32 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOlcdkOkkOOklcxNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
33 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0c'',,;,,':OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
34 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNNKkxxxxxxxxOXNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
35 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNNNNNNNNNNNNNNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
36 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
37 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
38 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
39 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
41 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
42 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
43 
44 */
45 
46 pragma solidity ^0.6.6;
47 
48 abstract contract Context {
49     function _msgSender() internal virtual view returns (address payable) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal virtual view returns (bytes memory) {
54         this;
55         return msg.data;
56     }
57 }
58 
59 interface IERC20 {
60 
61     function totalSupply() external view returns (uint256);
62 
63     function balanceOf(address account) external view returns (uint256);
64 
65     function transfer(address recipient, uint256 amount)
66         external
67         returns (bool);
68 
69     function allowance(address owner, address spender)
70         external
71         view
72         returns (uint256);
73 
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     function mint(address _to, uint256 _amount) external;
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(
87         address indexed owner,
88         address indexed spender,
89         uint256 value
90     );
91 }
92 
93 library SafeMath {
94 
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a, "SafeMath: addition overflow");
98 
99         return c;
100     }
101 
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         return sub(a, b, "SafeMath: subtraction overflow");
104     }
105 
106     function sub(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         if (a == 0) {
119             return 0;
120         }
121 
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124 
125         return c;
126     }
127 
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         return div(a, b, "SafeMath: division by zero");
130     }
131 
132     function div(
133         uint256 a,
134         uint256 b,
135         string memory errorMessage
136     ) internal pure returns (uint256) {
137         require(b > 0, errorMessage);
138         uint256 c = a / b;
139         return c;
140     }
141 
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     function mod(
147         uint256 a,
148         uint256 b,
149         string memory errorMessage
150     ) internal pure returns (uint256) {
151         require(b != 0, errorMessage);
152         return a % b;
153     }
154 }
155 
156 interface xiControlMigrator {
157     function migrate(IERC20 token) external returns (IERC20);
158 }
159 
160 library Address {
161 
162     function isContract(address account) internal view returns (bool) {
163 
164         uint256 size;
165         // solhint-disable-next-line no-inline-assembly
166         assembly {
167             size := extcodesize(account)
168         }
169         return size > 0;
170     }
171 
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(
174             address(this).balance >= amount,
175             "Address: insufficient balance"
176         );
177 
178         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
179         (bool success, ) = recipient.call{value: amount}("");
180         require(
181             success,
182             "Address: unable to send value, recipient may have reverted"
183         );
184     }
185 
186     function functionCall(address target, bytes memory data)
187         internal
188         returns (bytes memory)
189     {
190         return functionCall(target, data, "Address: low-level call failed");
191     }
192 
193     function functionCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal returns (bytes memory) {
198         return _functionCallWithValue(target, data, 0, errorMessage);
199     }
200 
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value
205     ) internal returns (bytes memory) {
206         return
207             functionCallWithValue(
208                 target,
209                 data,
210                 value,
211                 "Address: low-level call with value failed"
212             );
213     }
214 
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(
222             address(this).balance >= value,
223             "Address: insufficient balance for call"
224         );
225         return _functionCallWithValue(target, data, value, errorMessage);
226     }
227 
228     function _functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 weiValue,
232         string memory errorMessage
233     ) private returns (bytes memory) {
234         require(isContract(target), "Address: call to non-contract");
235 
236         // solhint-disable-next-line avoid-low-level-calls
237         (bool success, bytes memory returndata) = target.call{value: weiValue}(
238             data
239         );
240         if (success) {
241             return returndata;
242         } else {
243             if (returndata.length > 0) {
244                 // solhint-disable-next-line no-inline-assembly
245                 assembly {
246                     let returndata_size := mload(returndata)
247                     revert(add(32, returndata), returndata_size)
248                 }
249             } else {
250                 revert(errorMessage);
251             }
252         }
253     }
254 }
255 
256 library SafeERC20 {
257     using SafeMath for uint256;
258     using Address for address;
259 
260     function safeTransfer(
261         IERC20 token,
262         address to,
263         uint256 value
264     ) internal {
265         _callOptionalReturn(
266             token,
267             abi.encodeWithSelector(token.transfer.selector, to, value)
268         );
269     }
270 
271     function safeTransferFrom(
272         IERC20 token,
273         address from,
274         address to,
275         uint256 value
276     ) internal {
277         _callOptionalReturn(
278             token,
279             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
280         );
281     }
282 
283     function safeApprove(
284         IERC20 token,
285         address spender,
286         uint256 value
287     ) internal {
288         require(
289             (value == 0) || (token.allowance(address(this), spender) == 0),
290             "SafeERC20: approve from non-zero to non-zero allowance"
291         );
292         _callOptionalReturn(
293             token,
294             abi.encodeWithSelector(token.approve.selector, spender, value)
295         );
296     }
297 
298     function safeIncreaseAllowance(
299         IERC20 token,
300         address spender,
301         uint256 value
302     ) internal {
303         uint256 newAllowance = token.allowance(address(this), spender).add(
304             value
305         );
306         _callOptionalReturn(
307             token,
308             abi.encodeWithSelector(
309                 token.approve.selector,
310                 spender,
311                 newAllowance
312             )
313         );
314     }
315 
316     function safeDecreaseAllowance(
317         IERC20 token,
318         address spender,
319         uint256 value
320     ) internal {
321         uint256 newAllowance = token.allowance(address(this), spender).sub(
322             value,
323             "SafeERC20: decreased allowance below zero"
324         );
325         _callOptionalReturn(
326             token,
327             abi.encodeWithSelector(
328                 token.approve.selector,
329                 spender,
330                 newAllowance
331             )
332         );
333     }
334 
335 
336     function _callOptionalReturn(IERC20 token, bytes memory data) private {
337         bytes memory returndata = address(token).functionCall(
338             data,
339             "SafeERC20: low-level call failed"
340         );
341         if (returndata.length > 0) {
342             // solhint-disable-next-line max-line-length
343             require(
344                 abi.decode(returndata, (bool)),
345                 "SafeERC20: ERC20 operation did not succeed"
346             );
347         }
348     }
349 }
350 
351 contract Ownable is Context {
352     address private _owner;
353 
354     event OwnershipTransferred(
355         address indexed previousOwner,
356         address indexed newOwner
357     );
358 
359     constructor() internal {
360         address msgSender = _msgSender();
361         _owner = msgSender;
362         emit OwnershipTransferred(address(0), msgSender);
363     }
364 
365     function owner() public view returns (address) {
366         return _owner;
367     }
368 
369     modifier onlyOwner() {
370         require(_owner == _msgSender(), "Ownable: caller is not the owner");
371         _;
372     }
373 
374     function renounceOwnership() public virtual onlyOwner {
375         emit OwnershipTransferred(_owner, address(0));
376         _owner = address(0);
377     }
378 
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(
381             newOwner != address(0),
382             "Ownable: new owner is the zero address"
383         );
384         emit OwnershipTransferred(_owner, newOwner);
385         _owner = newOwner;
386     }
387 }
388 
389 contract TokenRecover is Ownable {
390     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
391         IERC20(tokenAddress).transfer(owner(), tokenAmount);
392     }
393 }
394 
395 contract XiControl is Ownable, TokenRecover {
396     using SafeMath for uint256;
397     using SafeERC20 for IERC20;
398 
399     struct UserDat {
400         uint256 amount;
401         uint256 rewardDebt;
402     }
403 
404     struct PuddleData {
405         IERC20 Univ2Token;
406         uint256 allocPoint;
407         uint256 lastRewardBlock;
408         uint256 accRiPerShare;
409     }
410 
411     IERC20 public ri;
412 
413     address public administrator;
414 
415     uint256 public rewardPerBlock;
416 
417     xiControlMigrator public migrator;
418 
419 
420     PuddleData[] public puddleData;
421 
422     mapping(address => bool) public Univ2TokenExistsInPuddle;
423 
424     mapping(uint256 => mapping(address => UserDat)) public userDat;
425 
426     uint256 public totalAllocPoint = 0;
427 
428     uint256 public startBlock;
429 
430     uint256 public halvePeriod = 2073600;
431     uint256 public minimumRewardPerBlock = 24048 szabo;
432     uint256 public lastHalveBlock;
433 
434     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
435     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
436     event ExitPoolDisgracefully(address indexed user, uint256 indexed pid, uint256 amount);
437     event Halve(uint256 newRewardPerBlock, uint256 nextHalveBlockNumber);
438 
439     constructor( IERC20 _ri, address _administrator, uint256 _startBlock) public {
440         ri = _ri;
441         administrator = _administrator;
442         rewardPerBlock = 769544 szabo;
443         startBlock = _startBlock;
444         lastHalveBlock = _startBlock;
445     }
446 
447     function doHalvingCheck(bool _withUpdate) public {
448         if (rewardPerBlock <= minimumRewardPerBlock) {
449             return;
450         }
451         bool doHalve = block.number > lastHalveBlock + halvePeriod;
452         if (!doHalve) {
453             return;
454         }
455         uint256 newRewardPerBlock = rewardPerBlock.div(2);
456         if (newRewardPerBlock >= minimumRewardPerBlock) {
457             rewardPerBlock = newRewardPerBlock;
458             lastHalveBlock = block.number;
459             emit Halve(newRewardPerBlock, block.number + halvePeriod);
460 
461             if (_withUpdate) {
462                 massUpdatePuddles();
463             }
464         }
465     }
466 
467     function puddleLength() external view returns (uint256) {
468         return puddleData.length;
469     }
470 
471     function add(uint256 _allocPoint, IERC20 _Univ2Token, bool _withUpdate) public onlyOwner {
472         require(!Univ2TokenExistsInPuddle[address(_Univ2Token)], "LP Token Address already exists in puddle");
473 
474         if (_withUpdate) {
475             massUpdatePuddles();
476         }
477         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
478         totalAllocPoint = totalAllocPoint.add(_allocPoint);
479         puddleData.push(
480             PuddleData({
481                 Univ2Token: _Univ2Token,
482                 allocPoint: _allocPoint,
483                 lastRewardBlock: lastRewardBlock,
484                 accRiPerShare: 0
485             })
486         );
487         Univ2TokenExistsInPuddle[address(_Univ2Token)] = true;
488     }
489 
490     function updateUniv2TokenExists(address _Univ2TokenAddr, bool _isExists) external onlyOwner {
491         Univ2TokenExistsInPuddle[_Univ2TokenAddr] = _isExists;
492     }
493 
494     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
495         if (_withUpdate) {
496             massUpdatePuddles();
497         }
498         totalAllocPoint = totalAllocPoint.sub(puddleData[_pid].allocPoint).add( _allocPoint);
499         puddleData[_pid].allocPoint = _allocPoint;
500     }
501 
502     function setMigrator(xiControlMigrator _migrator) public onlyOwner {
503         migrator = _migrator;
504     }
505 
506     function migrate(uint256 _pid) public onlyOwner {
507         require(address(migrator) != address(0), "Address of migrator is null");
508 
509         PuddleData storage puddle = puddleData[_pid];
510         IERC20 Univ2Token = puddle.Univ2Token;
511         uint256 bal = Univ2Token.balanceOf(address(this));
512         Univ2Token.safeApprove(address(migrator), bal);
513         IERC20 newUniv2Token = migrator.migrate(Univ2Token);
514 
515         require(!Univ2TokenExistsInPuddle[address(newUniv2Token)], "New LP Token Address already exists in puddle");
516         require(bal == newUniv2Token.balanceOf(address(this)), "New LP Token balance incorrect");
517 
518         puddle.Univ2Token = newUniv2Token;
519 
520         Univ2TokenExistsInPuddle[address(newUniv2Token)] = true;
521     }
522 
523     function pendingRI(uint256 _pid, address _user) external view returns (uint256) {
524         PuddleData storage puddle = puddleData[_pid];
525         UserDat storage user = userDat[_pid][_user];
526         uint256 accRiPerShare = puddle.accRiPerShare;
527         uint256 poolTokenSupply = puddle.Univ2Token.balanceOf(address(this));
528         if (block.number > puddle.lastRewardBlock && poolTokenSupply != 0) {
529             uint256 blockPassed = block.number.sub(puddle.lastRewardBlock);
530             uint256 riReward = blockPassed
531                 .mul(rewardPerBlock)
532                 .mul(puddle.allocPoint)
533                 .div(totalAllocPoint);
534             accRiPerShare = accRiPerShare.add(
535                 riReward.mul(1e12).div(poolTokenSupply)
536             );
537         }
538         return
539             user.amount.mul(accRiPerShare).div(1e12).sub(user.rewardDebt);
540     }
541 
542     function massUpdatePuddles() public {
543         uint256 length = puddleData.length;
544         for (uint256 pid = 0; pid < length; ++pid) {
545             updatePuddle(pid);
546         }
547     }
548 
549     function updatePuddle(uint256 _pid) public {
550         doHalvingCheck(false);
551         PuddleData storage puddle = puddleData[_pid];
552         if (block.number <= puddle.lastRewardBlock) {
553             return;
554         }
555 
556         uint256 poolTokenSupply = puddle.Univ2Token.balanceOf(address(this));
557         if (poolTokenSupply == 0) {
558             puddle.lastRewardBlock = block.number;
559             return;
560         }
561         uint256 blockPassed = block.number.sub(puddle.lastRewardBlock);
562         uint256 riReward = blockPassed
563             .mul(rewardPerBlock)
564             .mul(puddle.allocPoint)
565             .div(totalAllocPoint);
566         ri.mint(administrator, riReward.div(10));
567         ri.mint(address(this), riReward);
568         puddle.accRiPerShare = puddle.accRiPerShare.add(
569             riReward.mul(1e12).div(poolTokenSupply)
570         );
571         puddle.lastRewardBlock = block.number;
572     }
573 
574     function deposit(uint256 _pid, uint256 _amount) public {
575         PuddleData storage puddle = puddleData[_pid];
576         UserDat storage user = userDat[_pid][msg.sender];
577         updatePuddle(_pid);
578         if (user.amount > 0) {
579             uint256 pending = user
580                 .amount
581                 .mul(puddle.accRiPerShare)
582                 .div(1e12)
583                 .sub(user.rewardDebt);
584             safeRiTransfer(msg.sender, pending);
585         }
586         puddle.Univ2Token.safeTransferFrom(address(msg.sender), address(this), _amount);
587         user.amount = user.amount.add(_amount);
588         user.rewardDebt = user.amount.mul(puddle.accRiPerShare).div(1e12);
589         emit Deposit(msg.sender, _pid, _amount);
590     }
591 
592     function withdraw(uint256 _pid, uint256 _amount) public {
593         PuddleData storage puddle = puddleData[_pid];
594         UserDat storage user = userDat[_pid][msg.sender];
595         require(user.amount >= _amount, "Insufficient Amount to withdraw");
596         updatePuddle(_pid);
597         uint256 pending = user.amount.mul(puddle.accRiPerShare).div(1e12).sub(user.rewardDebt);
598         safeRiTransfer(msg.sender, pending);
599         user.amount = user.amount.sub(_amount);
600         user.rewardDebt = user.amount.mul(puddle.accRiPerShare).div(1e12);
601         puddle.Univ2Token.safeTransfer(address(msg.sender), _amount);
602         emit Withdraw(msg.sender, _pid, _amount);
603     }
604 
605     function exitPoolDisgracefully(uint256 _pid) public {
606         PuddleData storage puddle = puddleData[_pid];
607         UserDat storage user = userDat[_pid][msg.sender];
608         puddle.Univ2Token.safeTransfer(address(msg.sender), user.amount);
609         emit ExitPoolDisgracefully(msg.sender, _pid, user.amount);
610         user.amount = 0;
611         user.rewardDebt = 0;
612     }
613 
614     function safeRiTransfer(address _to, uint256 _amount) internal {
615         uint256 riBal = ri.balanceOf(address(this));
616         if (_amount > riBal) {
617             ri.transfer(_to, riBal);
618         } else {
619             ri.transfer(_to, _amount);
620         }
621     }
622 }