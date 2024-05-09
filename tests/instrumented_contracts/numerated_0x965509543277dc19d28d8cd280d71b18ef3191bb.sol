1 /*
2 Etrix 2.0 
3 Developed and created with love
4 */
5 
6 pragma solidity 0.5.11;
7 
8 
9 contract Etrix {
10 
11     address public _owner;
12     Etrix public oldSC = Etrix(0xCB8E1352034b97Fb60fDD891c0b23A32AF29d25d);
13     Etrix public newSC = Etrix(0x81c51a0B5c22dcA578039C7401B245aFd34F52F4);
14     uint public oldSCUserId = 2;
15 
16       //Structure to store the user related data
17       struct UserStruct {
18         bool isExist;
19         uint id;
20         uint referrerIDMatrix1;
21         uint referrerIDMatrix2;
22         address[] referralMatrix1;
23         address[] referralMatrix2;
24         uint referralCounter;
25         mapping(uint => uint) levelExpiredMatrix1;
26         mapping(uint => uint) levelExpiredMatrix2;
27         mapping(uint => uint) levelExpiredMatrix3; 
28     }
29 
30     //A person can have maximum 2 branches
31     uint constant private REFERRER_1_LEVEL_LIMIT = 2;
32     //period of a particular level
33     uint constant private PERIOD_LENGTH = 90 days;
34     //person where the new user will be joined
35     uint public availablePersonID;
36     //Addresses of the Team   
37     address [] public shareHoldersM1;
38     //Addresses of the Team   
39     address [] public shareHoldersM2;
40     //Addresses of the Team   
41     address [] public shareHoldersM3;
42     //cost of each level
43     mapping(uint => uint) public LEVEL_PRICE;
44     mapping(uint => uint) public LEVEL_PRICEM3;
45     uint public REFERRAL_COMMISSION;
46 
47     mapping (uint => uint) public uplinesToRcvEth;
48 
49     //data of each user from the address
50     mapping (address => UserStruct) public users;
51     //user address by their id
52     mapping (uint => address) public userList;
53     //to track latest user ID
54     uint public currUserID = 0;
55 
56     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
57     event buyLevelEvent(address indexed _user, uint _level, uint _time, uint _matrix);
58     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
59     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _matrix);
60     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _matrix);
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62     event syncComplete();
63 
64     constructor() public {
65         _owner = msg.sender;
66 
67         LEVEL_PRICE[1] = 0.05 ether;
68         LEVEL_PRICE[2] = 0.1 ether;
69         LEVEL_PRICE[3] = 0.3 ether;
70         LEVEL_PRICE[4] = 1.25 ether;
71         LEVEL_PRICE[5] = 5 ether;
72         LEVEL_PRICE[6] = 10 ether;
73         
74         LEVEL_PRICEM3[1] = 0.05 ether;
75         LEVEL_PRICEM3[2] = 0.12 ether;
76         LEVEL_PRICEM3[3] = 0.35 ether;
77         LEVEL_PRICEM3[4] = 1.24 ether;
78         LEVEL_PRICEM3[5] = 5.4 ether;
79         LEVEL_PRICEM3[6] = 10 ether;
80 
81         REFERRAL_COMMISSION = 0.03 ether;
82 
83         uplinesToRcvEth[1] = 5;
84         uplinesToRcvEth[2] = 6;
85         uplinesToRcvEth[3] = 7;
86         uplinesToRcvEth[4] = 8;
87         uplinesToRcvEth[5] = 9;
88         uplinesToRcvEth[6] = 10;
89         
90         availablePersonID = 1;
91 
92     }
93 
94     /**
95      * @dev allows only the user to run the function
96      */
97     modifier onlyOwner() {
98         require(msg.sender == _owner, "only Owner");
99         _;
100     }
101 
102     function () external payable {
103       
104         uint level;
105 
106         //check the level on the basis of amount sent
107         if(msg.value == LEVEL_PRICE[1]) level = 1;
108         else if(msg.value == LEVEL_PRICE[2]) level = 2;
109         else if(msg.value == LEVEL_PRICE[3]) level = 3;
110         else if(msg.value == LEVEL_PRICE[4]) level = 4;
111         else if(msg.value == LEVEL_PRICE[5]) level = 5;
112         else if(msg.value == LEVEL_PRICE[6]) level = 6;
113         
114         else revert('Incorrect Value send, please check');
115 
116         //if user has already registered previously
117         if(users[msg.sender].isExist) 
118             buyLevelMatrix2(level);
119 
120         else if(level == 1) {
121             uint refId = 0;
122             address referrer = bytesToAddress(msg.data);
123 
124             if(users[referrer].isExist) refId = users[referrer].id;
125             else revert('Incorrect referrer id');
126 
127             regUser(refId);
128         }
129         else revert('Please buy first level for 0.05 ETH and then proceed');
130     }
131 
132     /**
133         * @dev function to register the user after the pre registration
134         * @param _referrerID id of the referrer
135     */
136     function regUser(uint _referrerID) public payable {
137 
138         require(!users[msg.sender].isExist, 'User exist');
139         require(address(oldSC) == address(0), 'Initialize Still Open');
140         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
141         require(msg.value == LEVEL_PRICE[1] + REFERRAL_COMMISSION, 'Incorrect Value');
142         
143 
144         uint _referrerIDMatrix1;
145         uint _referrerIDMatrix2 = _referrerID;
146 
147         _referrerIDMatrix1 = findAvailablePersonMatrix1();
148 
149         if(users[userList[_referrerIDMatrix2]].referralMatrix2.length >= REFERRER_1_LEVEL_LIMIT) 
150             _referrerIDMatrix2 = users[findAvailablePersonMatrix2(userList[_referrerIDMatrix2])].id;
151         
152 
153         UserStruct memory userStruct;
154         currUserID++;
155 
156         userStruct = UserStruct({
157             isExist: true,
158             id: currUserID,
159             referrerIDMatrix1: _referrerIDMatrix1,
160             referrerIDMatrix2: _referrerIDMatrix2,
161             referralCounter: 0,
162             referralMatrix1: new address[](0),
163             referralMatrix2: new address[](0)
164         });
165 
166         users[msg.sender] = userStruct;
167         userList[currUserID] = msg.sender;
168 
169         
170         users[msg.sender].levelExpiredMatrix2[1] = now + PERIOD_LENGTH;
171 
172         users[userList[_referrerIDMatrix1]].referralMatrix1.push(msg.sender);
173         users[userList[_referrerIDMatrix2]].referralMatrix2.push(msg.sender);
174         
175         address(uint160(userList[_referrerID])).transfer(REFERRAL_COMMISSION);
176 
177         payForLevelMatrix2(1,msg.sender);
178 
179         //increase the referrer counter of the referrer
180         users[userList[_referrerID]].referralCounter++;
181 
182         emit regLevelEvent(msg.sender, userList[_referrerID], now);
183     }
184     
185     /**
186         * @dev function to register the user after the pre registration
187         * @param _referrerID id of the referrer
188     */
189     function regExtraUsers(uint [] memory _referrerID, address [] memory _userAddress) public onlyOwner {
190 
191         
192         require(address(oldSC) != address(0), 'Initialize close');
193         require(_referrerID.length == _userAddress.length);
194 
195         uint _referrerIDMatrix1;
196         uint _referrerIDMatrix2;
197         for(uint i = 0; i < _referrerID.length; i++){
198             
199             (,,,,uint _referralCounter) = newSC.users(_userAddress[i]);
200             
201         _referrerIDMatrix2 = _referrerID[i];
202         _referrerIDMatrix1 = findAvailablePersonMatrix1();
203 
204         if(users[userList[_referrerIDMatrix2]].referralMatrix2.length >= REFERRER_1_LEVEL_LIMIT) 
205             _referrerIDMatrix2 = users[findAvailablePersonMatrix2(userList[_referrerIDMatrix2])].id;
206         
207 
208         UserStruct memory userStruct;
209         currUserID++;
210 
211         userStruct = UserStruct({
212             isExist: true,
213             id: currUserID,
214             referrerIDMatrix1: _referrerIDMatrix1,
215             referrerIDMatrix2: _referrerIDMatrix2,
216             referralCounter: _referralCounter,
217             referralMatrix1: new address[](0),
218             referralMatrix2: new address[](0)
219         });
220 
221         users[_userAddress[i]] = userStruct;
222         userList[currUserID] = _userAddress[i];
223         
224          for(uint j = 1; j <= 6; j++) {
225 
226                 users[_userAddress[i]].levelExpiredMatrix1[j] = newSC.viewUserLevelExpiredMatrix1(_userAddress[i], j);
227                 users[_userAddress[i]].levelExpiredMatrix2[j] = newSC.viewUserLevelExpiredMatrix2(_userAddress[i], j);
228                 users[_userAddress[i]].levelExpiredMatrix3[j] = newSC.viewUserLevelExpiredMatrix3(_userAddress[i], j);
229          }
230 
231         users[userList[_referrerIDMatrix1]].referralMatrix1.push(_userAddress[i]);
232         users[userList[_referrerIDMatrix2]].referralMatrix2.push(_userAddress[i]);
233         
234         
235         //increase the referrer counter of the referrer
236         users[userList[_referrerID[i]]].referralCounter++;
237 
238         emit regLevelEvent(msg.sender, userList[_referrerID[i]], now);
239     }
240 }
241 
242 /**
243         * @dev function to register the user in the pre registration
244     */
245     function preRegAdmins(address [] memory _adminAddress) public onlyOwner{
246 
247         require(currUserID <= 100, "No more admins can be registered");
248 
249         UserStruct memory userStruct;
250 
251         for(uint i = 0; i < _adminAddress.length; i++){
252 
253             require(!users[_adminAddress[i]].isExist, 'One of the users exist');
254             currUserID++;
255 
256             if(currUserID == 1){
257                 userStruct = UserStruct({
258                 isExist: true,
259                 id: currUserID,
260                 referrerIDMatrix1: 1,
261                 referrerIDMatrix2: 1,
262                 referralCounter: 87,
263                 referralMatrix1: new address[](0),
264                 referralMatrix2: new address[](0)
265         });
266 
267             users[_adminAddress[i]] = userStruct;
268             userList[currUserID] = _adminAddress[i];
269 
270             for(uint j = 1; j <= 6; j++) {
271                 users[_adminAddress[i]].levelExpiredMatrix1[j] = 66666666666;
272                 users[_adminAddress[i]].levelExpiredMatrix2[j] = 66666666666;
273                 users[_adminAddress[i]].levelExpiredMatrix3[j] = 66666666666;
274             }
275             
276         }
277             else {
278                     uint _referrerIDMatrix1;
279                     uint _referrerIDMatrix2 = 1;
280 
281                     _referrerIDMatrix1 = findAvailablePersonMatrix1();
282 
283                     if(users[userList[_referrerIDMatrix2]].referralMatrix2.length >= REFERRER_1_LEVEL_LIMIT) 
284                         _referrerIDMatrix2 = users[findAvailablePersonMatrix2(userList[_referrerIDMatrix2])].id;
285 
286                                        
287                     userStruct = UserStruct({
288                         isExist: true,
289                         id: currUserID,
290                         referrerIDMatrix1: _referrerIDMatrix1,
291                         referrerIDMatrix2: _referrerIDMatrix2,
292                         referralCounter: 2,
293                         referralMatrix1: new address[](0),
294                         referralMatrix2: new address[](0)
295                     });
296 
297                     users[_adminAddress[i]] = userStruct;
298                     userList[currUserID] = _adminAddress[i];
299 
300                     for(uint j = 1; j <= 6; j++) {
301                         users[_adminAddress[i]].levelExpiredMatrix1[j] = 66666666666;
302                         users[_adminAddress[i]].levelExpiredMatrix2[j] = 66666666666;
303                         users[_adminAddress[i]].levelExpiredMatrix3[j] = 66666666666;
304                     }
305 
306                     users[userList[_referrerIDMatrix1]].referralMatrix1.push(_adminAddress[i]);
307                     users[userList[_referrerIDMatrix2]].referralMatrix2.push(_adminAddress[i]);
308 
309                 }
310                 emit regLevelEvent(_adminAddress[i], address(0x0), block.timestamp);
311     }
312 }
313     
314     function changeAvailablePerson(uint _availablePersonID) public onlyOwner{
315         
316         availablePersonID = _availablePersonID;
317     }
318 
319     function syncClose() external onlyOwner {
320         require(address(oldSC) != address(0), 'Initialize already closed');
321         oldSC = Etrix(0);
322     }
323 
324     function syncWithOldSC(uint limit) public onlyOwner {
325         require(address(oldSC) != address(0), 'Initialize closed');
326         
327         address refM1;
328         address refM2;
329         
330         //UserStruct memory userStruct;
331 
332         for(uint i = 0; i < limit; i++) {
333             address user = oldSC.userList(oldSCUserId);
334             (,, uint referrerIDM1, uint referrerIDM2,uint _referralCounter) = oldSC.users(user);
335 
336             
337                 oldSCUserId++;
338                 
339                  refM1 = oldSC.userList(referrerIDM1);
340                  refM2 = oldSC.userList(referrerIDM2);
341 
342                     users[user].isExist= true;
343                     users[user].id= ++currUserID;
344                     users[user].referrerIDMatrix1= referrerIDM1;
345                     users[user].referrerIDMatrix2= referrerIDM2;
346                     users[user].referralCounter= _referralCounter;
347                     
348                 
349                 userList[currUserID] = user;
350 
351                 users[refM1].referralMatrix1.push(user);
352                 users[refM2].referralMatrix2.push(user);
353                 
354                     for(uint j = 1; j <= 6; j++) {
355                          
356                          users[user].levelExpiredMatrix1[j] = newSC.viewUserLevelExpiredMatrix1(user, j);
357                          users[user].levelExpiredMatrix2[j] = newSC.viewUserLevelExpiredMatrix2(user, j);
358                          users[user].levelExpiredMatrix3[j] = newSC.viewUserLevelExpiredMatrix3(user, j);
359                     }
360 
361                     emit regLevelEvent(user, address(0x0), block.timestamp);
362         }
363         emit syncComplete();
364     }
365 
366 
367     function addShareHolderM1(address [] memory _shareHolderAddress) public onlyOwner returns(address[] memory){
368 
369         for(uint i=0; i < _shareHolderAddress.length; i++){
370 
371             if(shareHoldersM1.length < 20) {
372                 shareHoldersM1.push(_shareHolderAddress[i]);
373             }
374         }
375         return shareHoldersM1;
376     }
377 
378     function removeShareHolderM1(address  _shareHolderAddress) public onlyOwner returns(address[] memory){
379 
380         for(uint i=0; i < shareHoldersM1.length; i++){
381             if(shareHoldersM1[i] == _shareHolderAddress) {
382                 shareHoldersM1[i] = shareHoldersM1[shareHoldersM1.length-1];
383                 delete shareHoldersM1[shareHoldersM1.length-1];
384                 shareHoldersM1.length--;
385             }
386         }
387         return shareHoldersM1;
388 
389     }
390 
391     function addShareHolderM2(address [] memory _shareHolderAddress) public onlyOwner returns(address[] memory){
392 
393         for(uint i=0; i < _shareHolderAddress.length; i++){
394 
395             if(shareHoldersM2.length < 20) {
396                 shareHoldersM2.push(_shareHolderAddress[i]);
397             }
398         }
399         return shareHoldersM2;
400     }
401 
402     function removeShareHolderM2(address  _shareHolderAddress) public onlyOwner returns(address[] memory){
403 
404         for(uint i=0; i < shareHoldersM2.length; i++){
405             if(shareHoldersM2[i] == _shareHolderAddress) {
406                 shareHoldersM2[i] = shareHoldersM2[shareHoldersM2.length-1];
407                 delete shareHoldersM2[shareHoldersM2.length-1];
408                 shareHoldersM2.length--;
409             }
410         }
411         return shareHoldersM2;
412 
413     }
414 
415     function addShareHolderM3(address [] memory _shareHolderAddress) public onlyOwner returns(address[] memory){
416 
417         for(uint i=0; i < _shareHolderAddress.length; i++){
418 
419             if(shareHoldersM3.length < 20) {
420                 shareHoldersM3.push(_shareHolderAddress[i]);
421             }
422         }
423         return shareHoldersM3;
424     }
425 
426     function removeShareHolderM3(address  _shareHolderAddress) public onlyOwner returns(address[] memory){
427 
428         for(uint i=0; i < shareHoldersM3.length; i++){
429             if(shareHoldersM3[i] == _shareHolderAddress) {
430                 shareHoldersM3[i] = shareHoldersM3[shareHoldersM3.length-1];
431                 delete shareHoldersM3[shareHoldersM3.length-1];
432                 shareHoldersM3.length--;
433             }
434         }
435         return shareHoldersM3;
436 
437     }
438 
439     /**
440         * @dev function to find the next available person in the complete binary tree
441         * @return id of the available person in the tree.
442     */
443     function findAvailablePersonMatrix1() internal returns(uint){
444        
445         uint _referrerID;
446         uint _referralLength = users[userList[availablePersonID]].referralMatrix1.length;
447         
448          if(_referralLength >= REFERRER_1_LEVEL_LIMIT) {       
449              availablePersonID++;
450              _referrerID = availablePersonID;
451         }
452         else if( _referralLength == 1) {
453             _referrerID = availablePersonID;
454             availablePersonID++;            
455         }
456         else{
457              _referrerID = availablePersonID;
458         }
459 
460         return _referrerID;
461     }
462 
463     function findAvailablePersonMatrix2(address _user) public view returns(address) {
464         if(users[_user].referralMatrix2.length < REFERRER_1_LEVEL_LIMIT) return _user;
465 
466         address[] memory referrals = new address[](1022);
467         referrals[0] = users[_user].referralMatrix2[0];
468         referrals[1] = users[_user].referralMatrix2[1];
469 
470         address freeReferrer;
471         bool noFreeReferrer = true;
472 
473         for(uint i = 0; i < 1022; i++) {
474             if(users[referrals[i]].referralMatrix2.length >= REFERRER_1_LEVEL_LIMIT) {
475                 if(i < 510) {
476                     referrals[(i+1)*2] = users[referrals[i]].referralMatrix2[0];
477                     referrals[(i+1)*2+1] = users[referrals[i]].referralMatrix2[1];
478                 }
479             }
480             else {
481                 noFreeReferrer = false;
482                 freeReferrer = referrals[i];
483                 break;
484             }
485         }
486 
487         require(!noFreeReferrer, 'No Free Referrer');
488 
489         return freeReferrer;
490     }
491 
492 
493     function getUserUpline(address _user, uint height)
494     public
495     view
496     returns (address)
497   {
498     if (height <= 0 || _user == address(0)) {
499       return _user;
500     }
501 
502     return this.getUserUpline(userList[users[_user].referrerIDMatrix2], height - 1);
503   }
504 
505    
506 
507     /**
508         * @dev function to buy the level for Company forced matrix
509         * @param _level level which a user wants to buy
510     */
511     function buyLevelMatrix1(uint _level) public payable {
512 
513         require(users[msg.sender].isExist, 'User not exist'); 
514         require(_level > 0 && _level <= 6, 'Incorrect level');
515 
516         if(_level == 1) {
517             require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
518 
519             if(users[msg.sender].levelExpiredMatrix1[1] > now)             
520                 users[msg.sender].levelExpiredMatrix1[1] += PERIOD_LENGTH;
521                             
522             else 
523                 users[msg.sender].levelExpiredMatrix1[1] = now + PERIOD_LENGTH;
524             
525         }
526         else {
527             require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
528 
529             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpiredMatrix1[l] >= now, 'Buy the previous level');
530 
531             if(users[msg.sender].levelExpiredMatrix1[_level] == 0 || now > users[msg.sender].levelExpiredMatrix1[_level])
532                 users[msg.sender].levelExpiredMatrix1[_level] = now + PERIOD_LENGTH;
533             else users[msg.sender].levelExpiredMatrix1[_level] += PERIOD_LENGTH;
534         }
535 
536         payForLevelMatrix1(_level, msg.sender);
537 
538         emit buyLevelEvent(msg.sender, _level, now, 1);
539     }
540 
541     /**
542         * @dev function to buy the level for Team matrix
543         * @param _level level which a user wants to buy
544     */
545     function buyLevelMatrix2(uint _level) public payable {
546         
547         require(users[msg.sender].isExist, 'User not exist'); 
548         require(_level > 0 && _level <= 6, 'Incorrect level');
549 
550         if(_level == 1) {
551             require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
552 
553             if(users[msg.sender].levelExpiredMatrix2[1] > now)               
554                 users[msg.sender].levelExpiredMatrix2[1] += PERIOD_LENGTH;
555                             
556             else 
557                 users[msg.sender].levelExpiredMatrix2[1] = now + PERIOD_LENGTH;
558             
559        }
560         else {
561             require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
562 
563             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpiredMatrix2[l] >= now, 'Buy the previous level');
564 
565             if(users[msg.sender].levelExpiredMatrix2[_level] == 0 || now > users[msg.sender].levelExpiredMatrix2[_level]) 
566                 users[msg.sender].levelExpiredMatrix2[_level] = now + PERIOD_LENGTH;
567             
568             else users[msg.sender].levelExpiredMatrix2[_level] += PERIOD_LENGTH;
569         }
570 
571         payForLevelMatrix2(_level, msg.sender);
572 
573         emit buyLevelEvent(msg.sender, _level, now, 2);
574     }
575 
576     /**
577         * @dev function to buy the level for Hybrid matrix
578         * @param _level level which a user wants to buy
579     */
580     function buyLevelMatrix3(uint _level) public payable {
581         
582         require(users[msg.sender].isExist, 'User not exist'); 
583         require(_level > 0 && _level <= 6, 'Incorrect level');
584 
585         if(_level == 1) {
586             require(msg.value == LEVEL_PRICEM3[1], 'Incorrect Value');
587 
588             if(users[msg.sender].levelExpiredMatrix3[1] > now)               
589                 users[msg.sender].levelExpiredMatrix3[1] += PERIOD_LENGTH;
590                             
591             else 
592                 users[msg.sender].levelExpiredMatrix3[1] = now + PERIOD_LENGTH;
593             
594        }
595         else {
596             require(msg.value == LEVEL_PRICEM3[_level], 'Incorrect Value');
597 
598             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpiredMatrix3[l] >= now, 'Buy the previous level');
599 
600             if(users[msg.sender].levelExpiredMatrix3[_level] == 0 || now > users[msg.sender].levelExpiredMatrix3[_level]) 
601                 users[msg.sender].levelExpiredMatrix3[_level] = now + PERIOD_LENGTH;
602             
603             else users[msg.sender].levelExpiredMatrix3[_level] += PERIOD_LENGTH;
604         }
605 
606         payForLevelMatrix3(_level, msg.sender);
607 
608         emit buyLevelEvent(msg.sender, _level, now, 3);
609     }
610 
611     function payForLevelMatrix1(uint _level, address _user) internal {
612         address actualReferer;
613         address tempReferer1;
614         address tempReferer2;
615         uint userID;
616 
617         if(_level == 1) {
618             actualReferer = userList[users[_user].referrerIDMatrix1];
619             userID = users[actualReferer].id;
620         }
621         else if(_level == 2) {
622             tempReferer1 = userList[users[_user].referrerIDMatrix1];
623             actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
624             userID = users[actualReferer].id;
625         }
626         else if(_level == 3) {
627             tempReferer1 = userList[users[_user].referrerIDMatrix1];
628             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
629             actualReferer = userList[users[tempReferer2].referrerIDMatrix1];
630             userID = users[actualReferer].id;
631         }
632         else if(_level == 4) {
633             tempReferer1 = userList[users[_user].referrerIDMatrix1];
634             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
635             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
636             actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
637             userID = users[actualReferer].id;
638         }
639         else if(_level == 5) {
640             tempReferer1 = userList[users[_user].referrerIDMatrix1];
641             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
642             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
643             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
644             actualReferer = userList[users[tempReferer2].referrerIDMatrix1];
645             userID = users[actualReferer].id;
646         }
647         else if(_level == 6) {
648             tempReferer1 = userList[users[_user].referrerIDMatrix1];
649             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
650             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
651             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
652             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
653             actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
654             userID = users[actualReferer].id;
655         }
656 
657         if(!users[actualReferer].isExist) actualReferer = userList[1];
658 
659         bool sent = false;
660         
661         if(userID > 0 && userID <= 63) {
662            for(uint i=0; i < shareHoldersM1.length; i++) {
663                 address(uint160(shareHoldersM1[i])).transfer(LEVEL_PRICE[_level]/(shareHoldersM1.length));
664                 emit getMoneyForLevelEvent(shareHoldersM1[i], msg.sender, _level, now, 1);
665             }
666             if(address(this).balance > 0)
667                 address(uint160(userList[1])).transfer(address(this).balance);
668           }
669         
670         else{
671           if(users[actualReferer].levelExpiredMatrix1[_level] >= now && users[actualReferer].referralCounter >= 2) {
672               sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level]);
673                 if (sent) {
674                         emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 1);
675                     }
676                 }
677             if(!sent) {
678               emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 1);
679                 payForLevelMatrix1(_level, actualReferer);
680              }
681 
682         }
683             
684     }
685 
686     function payForLevelMatrix2(uint _level, address _user) internal {
687         address actualReferer;
688         address tempReferer1;
689         address tempReferer2;
690         uint userID;
691 
692         if(_level == 1) {
693             actualReferer = userList[users[_user].referrerIDMatrix2];
694             userID = users[actualReferer].id;
695         }
696         else if(_level == 2) {
697             tempReferer1 = userList[users[_user].referrerIDMatrix2];
698             actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
699             userID = users[actualReferer].id;
700         }
701         else if(_level == 3) {
702             tempReferer1 = userList[users[_user].referrerIDMatrix2];
703             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
704             actualReferer = userList[users[tempReferer2].referrerIDMatrix2];
705             userID = users[actualReferer].id;
706         }
707         else if(_level == 4) {
708             tempReferer1 = userList[users[_user].referrerIDMatrix2];
709             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
710             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
711             actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
712             userID = users[actualReferer].id;
713         }
714         else if(_level == 5) {
715             tempReferer1 = userList[users[_user].referrerIDMatrix2];
716             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
717             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
718             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
719             actualReferer = userList[users[tempReferer2].referrerIDMatrix2];
720             userID = users[actualReferer].id;
721         }
722         else if(_level == 6) {
723             tempReferer1 = userList[users[_user].referrerIDMatrix2];
724             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
725             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
726             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
727             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
728             actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
729             userID = users[actualReferer].id;
730         }
731 
732         if(!users[actualReferer].isExist) actualReferer = userList[1];
733 
734         bool sent = false;
735         
736         if(userID > 0 && userID <= 63) {
737            for(uint i=0; i < shareHoldersM2.length; i++) {
738                 address(uint160(shareHoldersM2[i])).transfer(LEVEL_PRICE[_level]/(shareHoldersM2.length));
739                 emit getMoneyForLevelEvent(shareHoldersM2[i], msg.sender, _level, now, 2);
740             }
741             if(address(this).balance > 0)
742                 address(uint160(userList[1])).transfer(address(this).balance);
743           }
744         
745         else{
746           if(users[actualReferer].levelExpiredMatrix2[_level] >= now) {
747               sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level]);
748                 if (sent) {
749                         emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 2);
750                     }
751                 }
752             if(!sent) {
753               emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 2);
754                 payForLevelMatrix2(_level, actualReferer);
755              }
756         }
757             
758     }
759 
760     function payForLevelMatrix3(uint _level, address _user) internal {
761         uint height = _level;
762         address referrer = getUserUpline(_user, height);
763 
764         if (referrer == address(0)) { referrer = userList[1]; }
765     
766         uint uplines = uplinesToRcvEth[_level];
767         bool chkLostProfit = false;
768         for (uint i = 1; i <= uplines; i++) {
769             referrer = getUserUpline(_user, i);
770           
771             if (viewUserLevelExpiredMatrix3(referrer, _level) < now) {
772                 chkLostProfit = true;
773                 uplines++;
774                 emit lostMoneyForLevelEvent(referrer, msg.sender, _level, now, 3);
775                 continue;
776             }
777             else {chkLostProfit = false;}
778             
779             if (referrer == address(0)) { referrer = userList[1]; }
780 
781             if(users[referrer].id >0 && users[referrer].id <= 63){
782                 
783                 uint test = (uplines - i) + 1;
784                 uint totalValue = test * (LEVEL_PRICEM3[_level]/uplinesToRcvEth[_level]);
785                 
786                 for(uint j=0; j < shareHoldersM3.length; j++) {
787                         address(uint160(shareHoldersM3[j])).transfer(totalValue/(shareHoldersM3.length));
788                         emit getMoneyForLevelEvent(shareHoldersM3[j], msg.sender, _level, now, 3);
789                     }
790                     break;
791                     
792             }
793             else {
794                 if (address(uint160(referrer)).send( LEVEL_PRICEM3[_level] / uplinesToRcvEth[_level] )) {               
795                     emit getMoneyForLevelEvent(referrer, msg.sender, _level, now, 3);
796                 }
797             }               
798     }
799             if(address(this).balance > 0)
800                 address(uint160(userList[1])).transfer(address(this).balance);
801           
802   }
803 
804     /**
805      * @dev Transfers ownership of the contract to a new account (`newOwner`).
806      * Can only be called by the current owner.
807      */
808     function transferOwnership(address newOwner) external onlyOwner {
809         _transferOwnership(newOwner);
810     }
811 
812      /**
813      * @dev Transfers ownership of the contract to a new account (`newOwner`).
814      */
815     function _transferOwnership(address newOwner) internal {
816         require(newOwner != address(0), "New owner cannot be the zero address");
817         emit OwnershipTransferred(_owner, newOwner);
818         _owner = newOwner;
819     }
820 
821     /**
822      * @dev Read only function to see the 2 children of a node in Company forced matrix
823      * @return 2 branches
824      */
825     function viewUserReferralMatrix1(address _user) public view returns(address[] memory) {
826         return users[_user].referralMatrix1;
827     }
828 
829     /**
830      * @dev Read only function to see the 2 children of a node in Team Matrix
831      * @return 2 branches
832      */
833     function viewUserReferralMatrix2(address _user) public view returns(address[] memory) {
834         return users[_user].referralMatrix2;
835     }
836     
837     /**
838      * @dev Read only function to see the expiration time of a particular level in Company forced Matrix
839      * @return unix timestamp
840      */
841     function viewUserLevelExpiredMatrix1(address _user, uint _level) public view returns(uint256) {
842         return users[_user].levelExpiredMatrix1[_level];
843     }
844 
845     /**
846      * @dev Read only function to see the expiration time of a particular level in Team Matrix
847      * @return unix timestamp
848      */
849     function viewUserLevelExpiredMatrix2(address _user, uint _level) public view returns(uint256) {
850         return users[_user].levelExpiredMatrix2[_level];
851     }
852 
853     /**
854      * @dev Read only function to see the expiration time of a particular level in Hybrid Matrix
855      * @return unix timestamp
856      */
857     function viewUserLevelExpiredMatrix3(address _user, uint _level) public view returns(uint256) {
858         return users[_user].levelExpiredMatrix3[_level];
859     }
860 
861     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
862         assembly {
863             addr := mload(add(bys, 20))
864         }
865     }
866 }