1 pragma solidity >=0.4.23 <0.6.0;
2 
3 
4 interface UmiTokenInterface{
5     function putIntoBlacklist(address _addr) external ;
6     function removeFromBlacklist(address _addr) external ;
7     function inBlacklist(address _addr)external view returns (bool);
8     function transfer(address to, uint256 value) external returns (bool) ;
9     function mint(address account, uint256 amount) external  returns (bool) ;
10     function balanceOf(address account) external view returns (uint256);
11 }
12 
13 interface IUniswapV2Router01 {
14     function factory() external pure returns (address);
15     function WETH() external pure returns (address);
16 
17     function addLiquidity(
18         address tokenA,
19         address tokenB,
20         uint amountADesired,
21         uint amountBDesired,
22         uint amountAMin,
23         uint amountBMin,
24         address to,
25         uint deadline
26     ) external returns (uint amountA, uint amountB, uint liquidity);
27     function addLiquidityETH(
28         address token,
29         uint amountTokenDesired,
30         uint amountTokenMin,
31         uint amountETHMin,
32         address to,
33         uint deadline
34     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
35     function removeLiquidity(
36         address tokenA,
37         address tokenB,
38         uint liquidity,
39         uint amountAMin,
40         uint amountBMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountA, uint amountB);
44     function removeLiquidityETH(
45         address token,
46         uint liquidity,
47         uint amountTokenMin,
48         uint amountETHMin,
49         address to,
50         uint deadline
51     ) external returns (uint amountToken, uint amountETH);
52     function removeLiquidityWithPermit(
53         address tokenA,
54         address tokenB,
55         uint liquidity,
56         uint amountAMin,
57         uint amountBMin,
58         address to,
59         uint deadline,
60         bool approveMax, uint8 v, bytes32 r, bytes32 s
61     ) external returns (uint amountA, uint amountB);
62     function removeLiquidityETHWithPermit(
63         address token,
64         uint liquidity,
65         uint amountTokenMin,
66         uint amountETHMin,
67         address to,
68         uint deadline,
69         bool approveMax, uint8 v, bytes32 r, bytes32 s
70     ) external returns (uint amountToken, uint amountETH);
71     function swapExactTokensForTokens(
72         uint amountIn,
73         uint amountOutMin,
74         address[] calldata path,
75         address to,
76         uint deadline
77     ) external returns (uint[] memory amounts);
78     function swapTokensForExactTokens(
79         uint amountOut,
80         uint amountInMax,
81         address[] calldata path,
82         address to,
83         uint deadline
84     ) external returns (uint[] memory amounts);
85     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
86         external
87         payable
88         returns (uint[] memory amounts);
89     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
90         external
91         returns (uint[] memory amounts);
92     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
93         external
94         returns (uint[] memory amounts);
95     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
96         external
97         payable
98         returns (uint[] memory amounts);
99 
100     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
101     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
102     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
103     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
104     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
105 }
106 
107 
108 contract UniSage {
109     
110     struct User {
111         address referrer;
112         uint partnersCount;
113         
114         mapping(uint8 => bool) activeLevels;
115         
116         mapping(uint8 => MA) matrix;
117       
118     }
119     
120     struct MA {
121         address currentReferrer;
122         address[] x3referrals;
123         address[] x2referrals;
124         bool blocked;
125         uint x2ReinvestCount;
126         uint x3ReinvestCount;
127     }
128     
129     
130     uint8 public constant LAST_LEVEL = 10;
131     
132     mapping(address => User) public users;
133 
134     mapping(address=>bool) public addrRegisted;
135     address public starNode;
136     
137     address owner;
138     
139     address truncateNode;
140     
141     bool public airdropPhase=true;
142     bool public openAirdrop=true;
143     
144     mapping(uint8 => uint) public levelPrice;
145     
146     address public umiTokenAddr=0x5284d793542815354b9604f06Df14f157BE90462;
147     UmiTokenInterface public umiToken = UmiTokenInterface(umiTokenAddr);
148     
149     bool public open=true;
150     uint256 public maxAirdropAmount=500000000000000000000000;
151     uint256 public hasAirdropAmount=0;
152     uint256 public perAirdrop=50000000000000000000;
153     uint256 public perAirdropForReferrer=5000000000000000000;
154     uint256 public startLiquiRate=100;
155     uint256 public mineRate=1000;
156     bool public openAMM=true;
157     
158     
159     address payable uniswapToAddr;
160     address payable public uniswapAddr;
161     IUniswapV2Router01 public uniswap;    
162     
163     
164     mapping(address=>mapping(uint=>mapping(uint=>uint256))) public matrixLevelReward;
165     
166     mapping(address=>mapping(uint=>uint256)) public matrixReward;
167     
168     mapping(address=>mapping(uint=>uint256)) public addressLevelMine;
169     mapping(address=>uint256) public addressMine;
170     
171     uint256 public globalMine=0;
172     uint256 public globalInvest=0;
173     
174     event Registration(address indexed user, address indexed referrer, address indexed userAddr, address referrerAddr);
175     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
176     event BurnOut(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
177     
178     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
179     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
180     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
181     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
182     
183     
184     constructor(address starNodeAddress) public {
185         
186         levelPrice[1] = 0.05 ether;
187         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
188             levelPrice[i] = levelPrice[i-1] * 2;
189         }
190         starNode = starNodeAddress;
191         truncateNode = starNodeAddress;
192         owner=msg.sender;
193         
194         User memory user = User({
195             // id: 1,
196             referrer: address(0),
197             partnersCount: uint(0)
198         });
199         
200         users[starNodeAddress] = user;
201         
202         // idToAddress[1] = starNodeAddress;
203         
204         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
205             users[starNodeAddress].activeLevels[i] = true;
206         }
207         
208         // userIds[1] = starNodeAddress;
209         addrRegisted[starNodeAddress]=true;
210         uniswapAddr=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
211         uniswap = IUniswapV2Router01(uniswapAddr);
212         uniswapToAddr = 0xcD3f2DB9551e83161a0031F8A9272a0b4795E40E;  
213         
214         
215         //approve enough umi to uniswap
216         _increaseApprove(999999999999000000000000000000);        
217     }
218     
219     function() external payable {
220         
221         // require(!airdropPhase,"can not regist in airdropPhase!");
222         // require(msg.value == 0.1 ether, "registration cost 0.1");
223         // if(msg.data.length == 0) {
224         //     return registration(msg.sender, starNode,false);
225         // }
226         
227         // registration(msg.sender, bytesToAddress(msg.data),false);
228     }
229 
230     function registrationExt(address referrerAddress) external payable {
231         require(!airdropPhase,"can not regist in airdropPhase!");
232         require(msg.value == 0.05 ether, "registration cost 0.05");
233         registration(msg.sender, referrerAddress,false);
234     }
235     
236 
237     function registrationForAirdrop(address referrerAddress) external{
238         require(airdropPhase,"can not get airdrop in not airdropPhase!");
239         require(hasAirdropAmount+perAirdrop+perAirdropForReferrer<=maxAirdropAmount,"hasAirdropAmount+perAirdrop+perAirdropForReferrer>maxAirdropAmount");
240         registration(msg.sender, referrerAddress,true);
241         hasAirdropAmount=hasAirdropAmount+perAirdrop+perAirdropForReferrer;
242     }
243     
244     function registration(address userAddress, address referrerAddress,bool fromAirdrop) private {
245         require(open,"has not open!");
246         require(!isUserExists(userAddress), "user exists");
247         require(isUserExists(referrerAddress), "referrer not exists");
248         
249         uint32 size;
250         assembly {
251             size := extcodesize(userAddress)
252         }
253         require(size == 0, "cannot be a contract");
254         
255         User memory user = User({
256             // id: lastUserId,
257             referrer: referrerAddress,
258             partnersCount: 0
259         });
260         
261         users[userAddress] = user;
262         // idToAddress[lastUserId] = userAddress;
263         
264         users[userAddress].referrer = referrerAddress;
265         
266         
267         
268         // userIds[lastUserId] = userAddress;
269         // lastUserId++;
270         
271         users[referrerAddress].partnersCount++;        
272         if(fromAirdrop){
273             if(openAirdrop){
274                 umiToken.mint(userAddress,perAirdrop);
275                 umiToken.putIntoBlacklist(userAddress);
276                 umiToken.mint(referrerAddress,perAirdropForReferrer);               
277             }
278         } else{
279             address activedReferrer = findActivedReferrer(userAddress, 1);
280             users[userAddress].matrix[1].currentReferrer = activedReferrer;
281             users[userAddress].activeLevels[1] = true;
282             updateMatrixReferrer(userAddress, activedReferrer, 1);
283             
284         }
285         addrRegisted[userAddress]=true;
286         globalInvest=globalInvest+msg.value;
287         emit Registration(userAddress, referrerAddress, userAddress, referrerAddress);
288     }
289     
290     function updateMatrixReferrer(address userAddress, address referrerAddress, uint8 level) private {
291         users[referrerAddress].matrix[level].x3referrals.push(userAddress);
292 
293         if (users[referrerAddress].matrix[level].x3referrals.length == 1||referrerAddress == starNode) {
294             emit NewUserPlace(userAddress, referrerAddress, 1, level, 1);
295             return sendETHDividends(referrerAddress, userAddress, 1, level,levelPrice[level]);
296         }else if(users[referrerAddress].matrix[level].x3referrals.length == 2){
297             emit NewUserPlace(userAddress, referrerAddress, 1, level, 2);
298             //1/2 ether to x2
299             uint256 x3Reward=levelPrice[level]/2;
300             sendETHDividends(referrerAddress, userAddress, 1, level,x3Reward);
301             address activedReferrerAddress = findActivedReferrer(referrerAddress, level);           
302             updateMatrixM2Referrer(referrerAddress,activedReferrerAddress,level,(levelPrice[level]-x3Reward));  
303             
304         }else if(users[referrerAddress].matrix[level].x3referrals.length == 3){
305             emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
306                //close matrix
307             users[referrerAddress].matrix[level].x3referrals = new address[](0);
308 
309             
310             uint256 x3Reward=levelPrice[level]/2;
311             sendETHDividends(referrerAddress, userAddress, 1, level,x3Reward);
312             
313             if (!users[referrerAddress].activeLevels[level+1] && level != LAST_LEVEL) {
314                 users[referrerAddress].matrix[level].blocked = true;
315             }            
316             
317             uint256 restETH=(levelPrice[level]-x3Reward);
318             //1/2 ether to uniswap
319             if(openAMM){
320                 uint256 liquidETH=restETH/2;
321                 uint256 liquidToken=liquidETH*startLiquiRate;
322                 _addLiquid(liquidETH,liquidToken);
323                 _swap(restETH-liquidETH);
324             }else{
325                 if(!address(uint160(owner)).send(restETH)){
326                     address(uint160(owner)).transfer(address(this).balance);
327                 }
328             }
329 
330             //mine
331             uint256 mineToken=restETH*currentMineRate();
332             umiToken.mint(referrerAddress,mineToken);
333             addressLevelMine[referrerAddress][level]=addressLevelMine[referrerAddress][level]+mineToken;
334             addressMine[referrerAddress]=addressMine[referrerAddress]+mineToken;
335             globalMine=globalMine+mineToken;
336             // updateMatrixM2Referrer(userAddress,referrerAddress,level,(levelPrice[level]-x3Reward));
337         }
338       
339     }  
340     
341     
342     function updateMatrixM2Referrer(address userAddress, address referrerAddress, uint8 level,uint256 x2Reward) private {
343         users[referrerAddress].matrix[level].x2referrals.push(userAddress);
344         
345         if(referrerAddress == starNode){
346             sendETHDividends(referrerAddress, userAddress, 2, level,x2Reward);
347         }else if(users[referrerAddress].matrix[level].x2referrals.length == 1&&!burnOut(referrerAddress,level)){
348             sendETHDividends(referrerAddress, userAddress, 2, level,x2Reward);
349         }else if(users[referrerAddress].matrix[level].x2referrals.length == 1&&users[referrerAddress].matrix[level].x2ReinvestCount==0){
350             sendETHDividends(referrerAddress, userAddress, 2, level,x2Reward);
351         }else{
352             address activedReferrerAddress = findActivedReferrer(referrerAddress, level);           
353 
354             updateMatrixM2Referrer(referrerAddress,activedReferrerAddress,level,x2Reward);
355         }
356         
357         if(users[referrerAddress].matrix[level].x2referrals.length == 1&&users[referrerAddress].matrix[level].x2ReinvestCount!=0&&burnOut(referrerAddress,level)){
358             emit BurnOut(referrerAddress, userAddress, userAddress, 2, level);
359         }
360         
361         if(users[referrerAddress].matrix[level].x2referrals.length == 2){
362             users[referrerAddress].matrix[level].x2ReinvestCount++;
363             users[referrerAddress].matrix[level].x2referrals=new address[](0);
364         }        
365     }
366     
367     function burnOut(address addr,uint8 level) public view returns(bool){
368         uint256 tokenBalance=umiToken.balanceOf(addr);
369         return tokenBalance<levelPrice[level]*1000;
370     }
371     
372     function buyNewLevel(uint8 level) external payable {
373         require(open,"has not open!");
374         require(!airdropPhase,"can not regist in airdropPhase!");
375         require(isUserExists(msg.sender), "user is not exists. Register first.");
376         require(msg.value == levelPrice[level], "invalid price");
377         require(level >= 1 && level <= LAST_LEVEL, "invalid level");
378 
379         require(!users[msg.sender].activeLevels[level], "level already activated");
380 
381         if (users[msg.sender].matrix[level-1].blocked) {
382             users[msg.sender].matrix[level-1].blocked = false;
383         }
384         //if in blacklist remove it
385         if(umiToken.inBlacklist(msg.sender)){
386             umiToken.removeFromBlacklist(msg.sender);    
387         }
388         
389         address activedReferrerAddress = findActivedReferrer(msg.sender, level);
390         users[msg.sender].matrix[level].currentReferrer = activedReferrerAddress;
391         users[msg.sender].activeLevels[level] = true;
392         updateMatrixReferrer(msg.sender, activedReferrerAddress, level);
393         globalInvest=globalInvest+msg.value;            
394         emit Upgrade(msg.sender, activedReferrerAddress, 1, level);
395     }     
396 
397     function activeAllLevels(address _addr,address _referrer) external{
398         require(msg.sender==owner, "require owner");
399         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
400             users[_addr].activeLevels[i] = true;
401             users[_addr].matrix[i].currentReferrer = _referrer;   
402             globalInvest=globalInvest+levelPrice[i];  
403               
404         }
405         if(umiToken.inBlacklist(_addr)){
406             umiToken.removeFromBlacklist(_addr);    
407         }
408     }    
409 
410     
411     function findActivedReferrer(address userAddress, uint8 level) public view returns(address) {
412         uint8 findCount=0;
413         while(true){
414             if(findCount>2){
415                 return truncateNode;
416             }
417             findCount++;
418             if (users[users[userAddress].referrer].activeLevels[level]) {
419                 return users[userAddress].referrer;
420             }else{
421                 userAddress=users[userAddress].referrer;
422             }            
423         }
424     }
425     
426 
427         
428     function usersActiveLevels(address userAddress, uint8 level) public view returns(bool) {
429         return users[userAddress].activeLevels[level];
430     }
431 
432 
433     function usersMatrix(address userAddress, uint8 level) public view returns(address, address[] memory,address[] memory, bool,uint256,uint256) {
434         return (users[userAddress].matrix[level].currentReferrer,
435                 users[userAddress].matrix[level].x3referrals,
436                 users[userAddress].matrix[level].x2referrals,
437                 users[userAddress].matrix[level].blocked,
438                 users[userAddress].matrix[level].x2ReinvestCount,
439                 users[userAddress].matrix[level].x3ReinvestCount);
440     }
441 
442 
443     
444     function refreshTruncateNode(address _truncateNode) external{
445         require(msg.sender==owner, "require owner");
446         truncateNode=_truncateNode;
447     }    
448     
449     function isUserExists(address user) public view returns (bool) {
450         return addrRegisted[user];
451     }
452     
453 
454     
455     function findEthReceiver(address userAddress, address _from, uint8 level) private returns(address, bool) {
456         address receiver = userAddress;
457         bool isExtraDividends;
458      
459         if (users[receiver].matrix[level].blocked) {
460             emit MissedEthReceive(receiver, _from, 1, level);
461             isExtraDividends = true;
462             return (owner, isExtraDividends);
463         } else {
464             return (receiver, isExtraDividends);
465         }
466            
467     
468     }
469     
470 
471     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level,uint256 ethValue) private {
472         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, level);
473 
474         matrixLevelReward[receiver][matrix][level]=matrixLevelReward[receiver][matrix][level]+ethValue;
475         matrixReward[receiver][matrix]=matrixReward[receiver][matrix]+ethValue;
476         if (!address(uint160(receiver)).send(ethValue)) {
477              address(uint160(receiver)).transfer(address(this).balance);
478              return;
479         }
480         if (isExtraDividends) {
481             emit SentExtraEthDividends(_from, receiver, matrix, level);
482         }
483         
484         
485     }
486     
487     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
488         assembly {
489             addr := mload(add(bys, 20))
490         }
491     }
492     
493     function refreshOpen(bool _open) external{
494         require(msg.sender==owner, "require owner");
495         open=_open;
496     }
497 
498     function refreshOwner(address _owner) external{
499         require(msg.sender==owner, "require owner");
500         owner=_owner;
501     }
502     function refreshAirdropPhase(bool _airdropPhase) external{
503         require(msg.sender==owner, "require owner");
504         airdropPhase=_airdropPhase;
505     }
506     function refreshOpenAMM(bool _openAMM) external{
507         require(msg.sender==owner, "require owner");
508         openAMM=_openAMM;
509     }    
510     
511     
512     function _addLiquid(uint256 liquidETH, uint256 liquidToken ) internal{
513 
514         umiToken.mint(address(this),liquidToken);
515 
516         bool addLiquidityETHResult;
517         (addLiquidityETHResult,) = uniswapAddr.call.value(liquidETH)(abi.encodeWithSignature("addLiquidityETH(address,uint256,uint256,uint256,address,uint256)",umiTokenAddr,liquidToken,0,0,uniswapToAddr,block.timestamp));
518         require(addLiquidityETHResult,"addLiquidity failed!");
519     }
520     
521     function removeLiquidityETHWrapper(
522         address _token,
523         uint _liquidity,
524         uint _amountTokenMin,
525         uint _amountETHMin,
526         address _to,
527         uint _deadline
528     ) external returns (uint _amountToken, uint _amountETH){
529         require(msg.sender==owner, "require owner");
530         (_amountToken,_amountETH) = uniswap.removeLiquidityETH(_token,_liquidity,_amountTokenMin,_amountETHMin,_to,_deadline);
531     }
532     
533 
534 
535     function _swap(uint256 swapEth) internal{
536         // function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
537         bool swapResult;
538         address[] memory paths = new address[](2);
539         paths[0]=uniswap.WETH();
540         paths[1]=umiTokenAddr;
541         
542         (swapResult,) = uniswapAddr.call.value(swapEth)(abi.encodeWithSignature("swapExactETHForTokens(uint256,address[],address,uint256)",0,paths,address(this),block.timestamp));
543         require(swapResult,"swap failed!");
544     }    
545     
546 	function etherProceeds() external{
547 	    require(msg.sender==owner, "require owner");
548 		if(!msg.sender.send(address(this).balance)) revert();
549 	}
550 	
551 	function refreshTokenAddr(address _addr) external
552 	{
553 	    require(msg.sender==owner, "require owner");
554         umiTokenAddr=_addr;
555         umiToken = UmiTokenInterface(umiTokenAddr);	    
556 	}		
557 	function refreshUniswapToAddr(address payable _addr) external
558 	{
559 	    require(msg.sender==owner, "require owner");
560         uniswapToAddr=_addr;
561 	}		
562 	
563 	function refreshOpenAirdrop(bool _openAirdrop) external{
564 	    require(msg.sender==owner, "require owner");
565 	    openAirdrop=_openAirdrop;
566 	}
567 	   
568 	function queryGlobalMine() public view returns(uint256){
569 	    return globalMine;
570 	}
571 	function queryGlobalInvest()public view returns(uint256){
572 	    return globalInvest;
573 	}
574 	
575 	function queryUserTotalMine(address _addr) public view returns(uint256){
576 	    return addressMine[_addr];
577 	}
578 	function queryUserTotalReward(address _addr)public view returns(uint256){
579 	    return matrixReward[_addr][1]+matrixReward[_addr][2];
580 	}
581 	function queryUserX3LevelReward(address _addr ,uint8 level) public view returns(uint256){
582 	    return matrixLevelReward[_addr][1][level];
583 	}
584 	function queryUserX2LevelReward(address _addr ,uint8 level) public view returns(uint256){
585 	    return matrixLevelReward[_addr][2][level];
586 	}   
587 	function queryUserX3LevelMine(address _addr ,uint8 level) public view returns(uint256){
588 	    return addressLevelMine[_addr][level];
589 	}
590 	
591 	
592 	function increaseApprove(uint256 amount) external{
593 	    require(msg.sender==owner, "require owner");
594 	    _increaseApprove(amount);
595 	}
596 	
597     function _increaseApprove(uint256 amount) internal{
598         bool approveResult;
599         (approveResult,)=umiTokenAddr.call(abi.encodeWithSignature("approve(address,uint256)",uniswapAddr,amount));
600         require(approveResult,"approve failed!");
601     }
602     
603     function currentMineRate() public view returns (uint256){
604         if(globalMine<10000000000000000000000000 ){
605             return 1000;
606         }else if(globalMine>=10000000000000000000000000&&globalMine<15000000000000000000000000){
607             return 500;
608         }else if(globalMine>=15000000000000000000000000&&globalMine<17500000000000000000000000){
609             return 250;
610         }else if(globalMine>=17500000000000000000000000&&globalMine<27500000000000000000000000){
611             return 125;
612         }else{
613             return 0;
614         }
615     }
616 
617 }