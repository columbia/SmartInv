1 pragma solidity >=0.4.23 <0.6.0;
2 
3 contract Eth2PlusV2 {
4     
5     struct User {
6         uint id;
7         address referrer;
8         uint partnersCount;
9         
10         mapping(uint8 => bool) activeX3Levels;
11         mapping(uint8 => bool) activeX6Levels;
12         
13         mapping(uint8 => X3) x3Matrix;
14         mapping(uint8 => X6) x6Matrix;
15     }
16     
17     struct X3 {
18         address currentReferrer;
19         address[] referrals;
20         bool blocked;
21         uint reinvestCount;
22     }
23     
24     struct X6 {
25         address currentReferrer;
26         address[] firstLevelReferrals;
27         address[] secondLevelReferrals;
28         bool blocked;
29         uint reinvestCount;
30 
31         address closedPart;
32     }
33 
34     uint8 public constant LAST_LEVEL = 12;
35     
36     mapping(address => User) public users;
37     mapping(uint => address) public idToAddress;
38     mapping(uint => address) public userIds;
39     mapping(address => uint) public balances; 
40     
41     
42     mapping(address=>mapping(uint=>mapping(uint=>uint256))) public matrixLevelReward;
43     
44     mapping(address=>mapping(uint=>uint256)) public matrixReward;
45 
46     //TODO:
47     uint public lastUserId = 2;
48     address public starNode;
49     
50     address owner;
51     
52     address truncateNode;
53     
54     mapping(uint8 => uint) public levelPrice;
55     
56     mapping(uint8=>uint256) public global1FallUidForLevel;
57 
58     mapping(uint8=>uint256) public global2FallUidForLevel;
59     
60     mapping(uint8=>mapping(uint256=>uint256)) public globalFallCountForLevel;
61     mapping(uint256=>bool) public initedMapping;
62 
63     mapping(uint8=>uint256) globalFallTypeForLevel;
64     
65     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
66     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
67     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
68     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
69     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
70     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
71     
72     
73     Eth2PlusV2 public ethPlus= Eth2PlusV2(0x0CC3E2D0e6fCDa36DF11B00213c0C8eA80B9a682);
74     
75     constructor(address starNodeAddress) public {
76         levelPrice[1] = 0.025 ether;
77         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
78             levelPrice[i] = levelPrice[i-1] * 2;
79         }
80         starNode = starNodeAddress;
81         truncateNode = starNodeAddress;
82         owner=msg.sender;
83         
84         // User memory user = User({
85         //     id: 1,
86         //     referrer: address(0),
87         //     partnersCount: uint(0)
88         // });
89         
90         // users[starNodeAddress] = user;
91         // idToAddress[1] = starNodeAddress;
92         
93         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
94             globalFallTypeForLevel[i]=1;
95             global1FallUidForLevel[i]=0;
96             global2FallUidForLevel[i]=11;
97       
98         }
99         
100         // userIds[1] = starNodeAddress;
101         
102     }
103     function initUser(uint256 _fromuid,uint256 _touid)public {
104         require(msg.sender==owner, "require owner");
105         
106         for(uint256 _uid=_fromuid;_uid<_touid;_uid++){
107             if(initedMapping[_uid]){
108                 continue;
109             }
110             address _userAddr=ethPlus.idToAddress(_uid);
111             if(_userAddr==address(0x0)){
112                 continue;
113             }
114             (,address _referrer,uint256 _partnersCount)=ethPlus.users(_userAddr);
115             initOldUser(_uid,_userAddr,_referrer,_partnersCount);
116             
117             
118             initOldUserMatrixReward(_userAddr,1,ethPlus.matrixReward(_userAddr,1));
119             initOldUserMatrixReward(_userAddr,2,ethPlus.matrixReward(_userAddr,2));
120             
121             
122             for(uint8 i=1;i<=LAST_LEVEL;i++){
123                 if(ethPlus.usersActiveX3Levels(_userAddr,i)){
124                     
125                     uint256 x3MatrixLevelReward=ethPlus.matrixLevelReward(_userAddr,1,i);
126                     initOldUserMatrixLevelReward(_userAddr,1,i,x3MatrixLevelReward);
127                     
128                     (address x3CurrentReferrer,address[] memory x3referrer,bool x3Block)=ethPlus.usersX3Matrix(_userAddr,i);
129                     
130                     initOldUserX3(_uid,_userAddr,i,x3CurrentReferrer,x3referrer,x3Block);
131                     
132                 }
133                 if(ethPlus.usersActiveX6Levels(_userAddr,i)){
134                     uint256 x4MatrixLevelReward=ethPlus.matrixLevelReward(_userAddr,2,i);
135                     initOldUserMatrixLevelReward(_userAddr,2,i,x4MatrixLevelReward);                    
136                     
137                     (address x4CurrentReferrer,address[] memory x4FirstReferrer,address[] memory x4SecondReferrer,bool x4Block,address closedPart)=ethPlus.usersX6Matrix(_userAddr,i);
138                     
139                     initOldUserX4(_uid,_userAddr,i,x4CurrentReferrer,x4FirstReferrer,x4SecondReferrer,x4Block,address(0x0));
140                     
141                 }                
142             }
143             
144             initedMapping[_uid]=true;
145         }
146     }
147     
148             
149     function initOldUser(uint256 _id,address _addr,address _referrer,uint256 _partnersCount)public {
150        require(msg.sender==owner, "require owner");
151        User memory user = User({
152             id: _id,
153             referrer: _referrer,
154             partnersCount: _partnersCount
155         });        
156         users[_addr] = user;
157         idToAddress[_id] = _addr;
158         userIds[_id] = _addr;
159     }
160     
161     function initOldUserX3(uint256 _uid,address _addr,uint8 _level,address _currentReferrer,address[] memory x3referrer,bool _blocked) public{
162         require(msg.sender==owner, "require owner");
163         users[_addr].activeX3Levels[_level] = true;
164  
165         users[_addr].x3Matrix[_level].currentReferrer=_currentReferrer;
166       
167         users[_addr].x3Matrix[_level].referrals=x3referrer;
168         users[_addr].x3Matrix[_level].blocked=_blocked;
169         users[_addr].x3Matrix[_level].reinvestCount=0;
170            
171         
172     }
173 
174     function initOldUserX4(uint256 _uid,address _addr,uint8 _level,address _currentReferrer,address[] memory x4FirstReferrer,address[] memory x4SecondReferrer,bool _blocked,address _closedPart) public{
175         require(msg.sender==owner, "require owner");
176         users[_addr].activeX6Levels[_level] = true;
177 
178         users[_addr].x6Matrix[_level].currentReferrer=_currentReferrer;
179   
180         
181         users[_addr].x6Matrix[_level].firstLevelReferrals=x4FirstReferrer;
182    
183         users[_addr].x6Matrix[_level].secondLevelReferrals=x4SecondReferrer;
184         users[_addr].x6Matrix[_level].blocked=_blocked;
185         users[_addr].x6Matrix[_level].reinvestCount=0;  
186         users[_addr].x6Matrix[_level].closedPart=_closedPart;  
187         
188     }
189     
190     function initOldUserMatrixReward(address _addr,uint matrix,uint256 _reward) public{
191         require(msg.sender==owner, "require owner");
192         matrixReward[_addr][matrix]=_reward;
193         
194     }    
195     
196     
197     function initOldUserMatrixLevelReward(address _addr,uint matrix,uint _level,uint256 _reward) public{
198         require(msg.sender==owner, "require owner");
199         matrixLevelReward[_addr][matrix][_level]=_reward;
200         
201     }        
202     
203     function globalfall(uint8 level) internal{
204         if(globalFallTypeForLevel[level]==1){
205             globalFallTypeForLevel[level]=2;
206             
207             if(global1FallUidForLevel[level]>=10){
208                 global1FallUidForLevel[level]=0;
209             }
210             
211             address receiver=owner;
212             
213             if(lastUserId>global1FallUidForLevel[level]+1){
214                 global1FallUidForLevel[level]++;
215                 receiver=userIds[global1FallUidForLevel[level]];
216             }
217             sendETHDividendsToGobalFall( receiver,level);
218             
219             
220             
221         }else{
222             globalFallTypeForLevel[level]=1;
223             
224             address receiver=owner;
225             
226             if(lastUserId>global2FallUidForLevel[level]+1){
227                 if(globalFallCountForLevel[level][global2FallUidForLevel[level]]>=2){
228                     global2FallUidForLevel[level]++;
229                 }
230                 receiver=userIds[global2FallUidForLevel[level]];
231                 globalFallCountForLevel[level][global2FallUidForLevel[level]]=globalFallCountForLevel[level][global2FallUidForLevel[level]]+1;
232             }
233             sendETHDividendsToGobalFall( receiver,level);     
234             
235          
236         }
237     }
238     
239     function() external payable {
240         if(msg.data.length == 0) {
241             return registration(msg.sender, starNode);
242         }
243         
244         registration(msg.sender, bytesToAddress(msg.data));
245     }
246 
247     function registrationExt(address referrerAddress) external payable {
248         registration(msg.sender, referrerAddress);
249     }
250     
251     function buyNewLevel(uint8 matrix, uint8 level) external payable {
252         require(isUserExists(msg.sender), "user is not exists. Register first.");
253         require(matrix == 1 || matrix == 2, "invalid matrix");
254         require(msg.value == levelPrice[level], "invalid price");
255         require(level > 1 && level <= LAST_LEVEL, "invalid level");
256 
257         if (matrix == 1) {
258             require(!users[msg.sender].activeX3Levels[level], "level already activated");
259 
260             if (users[msg.sender].x3Matrix[level-1].blocked) {
261                 users[msg.sender].x3Matrix[level-1].blocked = false;
262             }
263     
264             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
265             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
266             users[msg.sender].activeX3Levels[level] = true;
267             updateX3Referrer(msg.sender, freeX3Referrer, level);
268             
269             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
270 
271         } else {
272             require(!users[msg.sender].activeX6Levels[level], "level already activated"); 
273 
274             if (users[msg.sender].x6Matrix[level-1].blocked) {
275                 users[msg.sender].x6Matrix[level-1].blocked = false;
276             }
277 
278             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
279             
280             users[msg.sender].activeX6Levels[level] = true;
281             updateX6Referrer(msg.sender, freeX6Referrer, level,false);
282             
283             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
284         }
285     }    
286     
287     function registration(address userAddress, address referrerAddress) private {
288         require(msg.value == 0.05 ether, "registration cost 0.05");
289         require(!isUserExists(userAddress), "user exists");
290         require(isUserExists(referrerAddress), "referrer not exists");
291         
292         uint32 size;
293         assembly {
294             size := extcodesize(userAddress)
295         }
296         require(size == 0, "cannot be a contract");
297         
298         User memory user = User({
299             id: lastUserId,
300             referrer: referrerAddress,
301             partnersCount: 0
302         });
303         
304         users[userAddress] = user;
305         idToAddress[lastUserId] = userAddress;
306         
307         users[userAddress].referrer = referrerAddress;
308         
309         users[userAddress].activeX3Levels[1] = true; 
310         users[userAddress].activeX6Levels[1] = true;
311         
312         
313         userIds[lastUserId] = userAddress;
314         lastUserId++;
315         
316         users[referrerAddress].partnersCount++;
317 
318         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
319         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
320         updateX3Referrer(userAddress, freeX3Referrer, 1);
321 
322         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1,false);
323         
324         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
325     }
326     
327     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
328         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
329 
330         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
331             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
332             return sendETHDividends(referrerAddress, userAddress, 1, level);
333         }
334         
335         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
336         //close matrix
337         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
338         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
339             users[referrerAddress].x3Matrix[level].blocked = true;
340         }
341 
342         //create new one by recursion
343         if (referrerAddress != starNode) {
344             //check referrer active level
345             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
346             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
347                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
348             }
349             
350             users[referrerAddress].x3Matrix[level].reinvestCount++;
351             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
352             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
353         } else {
354             sendETHDividends(starNode, userAddress, 1, level);
355             users[starNode].x3Matrix[level].reinvestCount++;
356             emit Reinvest(starNode, address(0), userAddress, 1, level);
357         }
358     }
359 
360     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level,bool needRSkipecursionDivide) private {
361         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
362         
363         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
364             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
365             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
366             
367             //set current level
368             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
369 
370             if (referrerAddress == starNode) {
371                 return sendETHDividends(referrerAddress, userAddress, 2, level);
372             }
373             
374             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;            
375             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress); 
376             
377             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
378             
379             if ((len == 2) && 
380                 (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
381                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
382                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
383                     emit NewUserPlace(userAddress, ref, 2, level, 5);
384                 } else {
385                     emit NewUserPlace(userAddress, ref, 2, level, 6);
386                 }
387             }  else if ((len == 1 || len == 2) &&
388                     users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
389                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
390                     emit NewUserPlace(userAddress, ref, 2, level, 3);
391                 } else {
392                     emit NewUserPlace(userAddress, ref, 2, level, 4);
393                 }
394             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
395                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
396                     emit NewUserPlace(userAddress, ref, 2, level, 5);
397                 } else {
398                     emit NewUserPlace(userAddress, ref, 2, level, 6);
399                 }
400             }
401 
402             return updateX6ReferrerSecondLevel(userAddress, ref, level,needRSkipecursionDivide);
403         }
404         
405         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
406 
407         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
408             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
409                 users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
410                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
411                 users[referrerAddress].x6Matrix[level].closedPart)) {
412 
413                 updateX6(userAddress, referrerAddress, level, true);
414                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
415             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
416                 users[referrerAddress].x6Matrix[level].closedPart) {
417                 updateX6(userAddress, referrerAddress, level, true);
418                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
419             } else {
420                 updateX6(userAddress, referrerAddress, level, false);
421                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
422             }
423         }
424 
425         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
426             updateX6(userAddress, referrerAddress, level, false);
427             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
428         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
429             updateX6(userAddress, referrerAddress, level, true);
430             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
431         }
432         
433         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
434             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
435             updateX6(userAddress, referrerAddress, level, false);
436         } else {
437             updateX6(userAddress, referrerAddress, level, true);
438         }
439         
440         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
441     }
442 
443     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
444         if (!x2) {
445             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
446             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
447             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
448             //set current level
449             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
450         } else {
451             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
452             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
453             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
454             //set current level
455             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
456         }
457     }
458     
459     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level,bool needRSkipecursionDivide) private {
460         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
461             if(!needRSkipecursionDivide){
462                 return sendETHDividends(referrerAddress, userAddress, 2, level);
463             }else{
464                 return;
465             }
466             
467         }
468         
469         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
470         
471         if (x6.length == 2) {
472             if (x6[0] == referrerAddress ||
473                 x6[1] == referrerAddress) {
474                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
475             } else if (x6.length == 1) {
476                 if (x6[0] == referrerAddress) {
477                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
478                 }
479             }
480         }
481         
482         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
483         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
484         users[referrerAddress].x6Matrix[level].closedPart = address(0);
485 
486         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
487             users[referrerAddress].x6Matrix[level].blocked = true;
488         }
489 
490         users[referrerAddress].x6Matrix[level].reinvestCount++;
491         
492         if (referrerAddress != starNode) {
493             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
494 
495             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
496             if(lastUserId>10){
497                 //cut the divide to global
498                 globalfall(level);
499                 
500                 updateX6Referrer(referrerAddress, freeReferrerAddress, level,true);
501             }else{
502                 updateX6Referrer(referrerAddress, freeReferrerAddress, level,false);
503             }
504     
505         } else {
506             emit Reinvest(starNode, address(0), userAddress, 2, level);
507             sendETHDividends(starNode, userAddress, 2, level);
508         }
509     }
510     
511     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
512         if (users[users[userAddress].referrer].activeX3Levels[level]) {
513             return users[userAddress].referrer;
514         }else{
515             return truncateNode;
516         }
517     }
518     
519     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
520         if (users[users[userAddress].referrer].activeX6Levels[level]) {
521             return users[userAddress].referrer;
522         }else{
523             return truncateNode;
524         }
525     }
526         
527     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
528         return users[userAddress].activeX3Levels[level];
529     }
530 
531     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
532         return users[userAddress].activeX6Levels[level];
533     }
534 
535     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
536         return (users[userAddress].x3Matrix[level].currentReferrer,
537                 users[userAddress].x3Matrix[level].referrals,
538                 users[userAddress].x3Matrix[level].blocked);
539     }
540 
541     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
542         return (users[userAddress].x6Matrix[level].currentReferrer,
543                 users[userAddress].x6Matrix[level].firstLevelReferrals,
544                 users[userAddress].x6Matrix[level].secondLevelReferrals,
545                 users[userAddress].x6Matrix[level].blocked,
546                 users[userAddress].x6Matrix[level].closedPart);
547     }
548     
549     function refreshTruncateNode(address _truncateNode) external{
550         require(msg.sender==owner, "require owner");
551         truncateNode=_truncateNode;
552     }    
553     
554     function isUserExists(address user) public view returns (bool) {
555         return (users[user].id != 0);
556     }
557     
558     function activeAllLevels(address _addr) external{
559         require(msg.sender==owner, "require owner");
560         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
561             users[_addr].activeX3Levels[i] = true;
562             users[_addr].activeX6Levels[i] = true;
563         }
564     }    
565     
566     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
567         address receiver = userAddress;
568         bool isExtraDividends;
569         if (matrix == 1) {
570                 if (users[receiver].x3Matrix[level].blocked) {
571                     emit MissedEthReceive(receiver, _from, 1, level);
572                     isExtraDividends = true;
573                     return (owner, isExtraDividends);
574                 } else {
575                     return (receiver, isExtraDividends);
576                 }
577            
578         } else {
579                 if (users[receiver].x6Matrix[level].blocked) {
580                     emit MissedEthReceive(receiver, _from, 2, level);
581                     isExtraDividends = true;
582                     return (owner, isExtraDividends);
583                 } else {
584                     return (receiver, isExtraDividends);
585                 }
586             
587         }
588     }
589     
590     function sendETHDividendsToGobalFall(address receiver, uint8 level) private {
591 
592         matrixLevelReward[receiver][2][level]=matrixLevelReward[receiver][2][level]+levelPrice[level];
593         matrixReward[receiver][2]=matrixReward[receiver][2]+levelPrice[level];
594         if (!address(uint160(receiver)).send(levelPrice[level])) {
595             return address(uint160(receiver)).transfer(address(this).balance);
596         }
597     }
598 
599     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
600         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
601 
602         matrixLevelReward[receiver][matrix][level]=matrixLevelReward[receiver][matrix][level]+levelPrice[level];
603         matrixReward[receiver][matrix]=matrixReward[receiver][matrix]+levelPrice[level];
604 
605         if (!address(uint160(receiver)).send(levelPrice[level])) {
606             return address(uint160(receiver)).transfer(address(this).balance);
607         }
608         
609         if (isExtraDividends) {
610             emit SentExtraEthDividends(_from, receiver, matrix, level);
611         }
612     }
613     
614     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
615         assembly {
616             addr := mload(add(bys, 20))
617         }
618     }
619     
620     function transferOwnerShip(address _owner) public{
621         require(msg.sender==owner, "require owner");
622         owner = _owner;
623     }
624     
625     function refreshLastId(uint256 _lastId) public{
626         require(msg.sender==owner, "require owner");
627         lastUserId = _lastId;
628     }    
629 
630 }