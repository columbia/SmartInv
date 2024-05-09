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
13     uint public oldSCUserId = 64;
14 
15       //Structure to store the user related data
16       struct UserStruct {
17         bool isExist;
18         uint id;
19         uint referrerIDMatrix1;
20         uint referrerIDMatrix2;
21         address[] referralMatrix1;
22         address[] referralMatrix2;
23         uint referralCounter;
24         mapping(uint => uint) levelExpiredMatrix1;
25         mapping(uint => uint) levelExpiredMatrix2;
26         mapping(uint => uint) levelExpiredMatrix3; 
27     }
28 
29     //A person can have maximum 2 branches
30     uint constant private REFERRER_1_LEVEL_LIMIT = 2;
31     //period of a particular level
32     uint constant private PERIOD_LENGTH = 90 days;
33     //person where the new user will be joined
34     uint public availablePersonID;
35     //Addresses of the Team   
36     address [] public shareHoldersM1;
37     //Addresses of the Team   
38     address [] public shareHoldersM2;
39     //Addresses of the Team   
40     address [] public shareHoldersM3;
41     //cost of each level
42     mapping(uint => uint) public LEVEL_PRICE;
43     mapping(uint => uint) public LEVEL_PRICEM3;
44     uint public REFERRAL_COMMISSION;
45 
46     mapping (uint => uint) public uplinesToRcvEth;
47 
48     //data of each user from the address
49     mapping (address => UserStruct) public users;
50     //user address by their id
51     mapping (uint => address) public userList;
52     //to track latest user ID
53     uint public currUserID = 0;
54 
55     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
56     event buyLevelEvent(address indexed _user, uint _level, uint _time, uint _matrix);
57     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
58     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _matrix);
59     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _matrix);
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61     event syncComplete();
62 
63     constructor() public {
64         _owner = msg.sender;
65 
66         LEVEL_PRICE[1] = 0.05 ether;
67         LEVEL_PRICE[2] = 0.1 ether;
68         LEVEL_PRICE[3] = 0.3 ether;
69         LEVEL_PRICE[4] = 1.25 ether;
70         LEVEL_PRICE[5] = 5 ether;
71         LEVEL_PRICE[6] = 10 ether;
72         
73         LEVEL_PRICEM3[1] = 0.05 ether;
74         LEVEL_PRICEM3[2] = 0.12 ether;
75         LEVEL_PRICEM3[3] = 0.35 ether;
76         LEVEL_PRICEM3[4] = 1.24 ether;
77         LEVEL_PRICEM3[5] = 5.4 ether;
78         LEVEL_PRICEM3[6] = 10 ether;
79 
80         REFERRAL_COMMISSION = 0.03 ether;
81 
82         uplinesToRcvEth[1] = 5;
83         uplinesToRcvEth[2] = 6;
84         uplinesToRcvEth[3] = 7;
85         uplinesToRcvEth[4] = 8;
86         uplinesToRcvEth[5] = 9;
87         uplinesToRcvEth[6] = 10;
88         
89         availablePersonID = 1;
90 
91     }
92 
93     /**
94      * @dev allows only the user to run the function
95      */
96     modifier onlyOwner() {
97         require(msg.sender == _owner, "only Owner");
98         _;
99     }
100 
101     function () external payable {
102       
103         uint level;
104 
105         //check the level on the basis of amount sent
106         if(msg.value == LEVEL_PRICE[1]) level = 1;
107         else if(msg.value == LEVEL_PRICE[2]) level = 2;
108         else if(msg.value == LEVEL_PRICE[3]) level = 3;
109         else if(msg.value == LEVEL_PRICE[4]) level = 4;
110         else if(msg.value == LEVEL_PRICE[5]) level = 5;
111         else if(msg.value == LEVEL_PRICE[6]) level = 6;
112         
113         else revert('Incorrect Value send, please check');
114 
115         //if user has already registered previously
116         if(users[msg.sender].isExist) 
117             buyLevelMatrix2(level);
118 
119         else if(level == 1) {
120             uint refId = 0;
121             address referrer = bytesToAddress(msg.data);
122 
123             if(users[referrer].isExist) refId = users[referrer].id;
124             else revert('Incorrect referrer id');
125 
126             regUser(refId);
127         }
128         else revert('Please buy first level for 0.05 ETH and then proceed');
129     }
130 
131     /**
132         * @dev function to register the user after the pre registration
133         * @param _referrerID id of the referrer
134     */
135     function regUser(uint _referrerID) public payable {
136 
137         require(!users[msg.sender].isExist, 'User exist');
138         require(address(oldSC) == address(0), 'Initialize Still Open');
139         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
140         require(msg.value == LEVEL_PRICE[1] + REFERRAL_COMMISSION, 'Incorrect Value');
141         
142 
143         uint _referrerIDMatrix1;
144         uint _referrerIDMatrix2 = _referrerID;
145 
146         _referrerIDMatrix1 = findAvailablePersonMatrix1();
147 
148         if(users[userList[_referrerIDMatrix2]].referralMatrix2.length >= REFERRER_1_LEVEL_LIMIT) 
149             _referrerIDMatrix2 = users[findAvailablePersonMatrix2(userList[_referrerIDMatrix2])].id;
150         
151 
152         UserStruct memory userStruct;
153         currUserID++;
154 
155         userStruct = UserStruct({
156             isExist: true,
157             id: currUserID,
158             referrerIDMatrix1: _referrerIDMatrix1,
159             referrerIDMatrix2: _referrerIDMatrix2,
160             referralCounter: 0,
161             referralMatrix1: new address[](0),
162             referralMatrix2: new address[](0)
163         });
164 
165         users[msg.sender] = userStruct;
166         userList[currUserID] = msg.sender;
167 
168         
169         users[msg.sender].levelExpiredMatrix2[1] = now + PERIOD_LENGTH;
170 
171         users[userList[_referrerIDMatrix1]].referralMatrix1.push(msg.sender);
172         users[userList[_referrerIDMatrix2]].referralMatrix2.push(msg.sender);
173         
174         address(uint160(userList[_referrerID])).transfer(REFERRAL_COMMISSION);
175 
176         payForLevelMatrix2(1,msg.sender);
177 
178         //increase the referrer counter of the referrer
179         users[userList[_referrerID]].referralCounter++;
180 
181         emit regLevelEvent(msg.sender, userList[_referrerID], now);
182     }
183     
184     function changeAvailablePerson(uint _availablePersonID) public onlyOwner{
185         
186         availablePersonID = _availablePersonID;
187     }
188 
189     function syncClose() external onlyOwner {
190         require(address(oldSC) != address(0), 'Initialize already closed');
191         oldSC = Etrix(0);
192     }
193 
194     function syncWithOldSC(uint limit) public onlyOwner {
195         require(address(oldSC) != address(0), 'Initialize closed');
196         
197         address refM1;
198         address refM2;
199         
200         //UserStruct memory userStruct;
201 
202         for(uint i = 0; i < limit; i++) {
203             address user = oldSC.userList(oldSCUserId);
204             (bool isExist,, uint referrerIDM1, uint referrerIDM2,uint _referralCounter) = oldSC.users(user);
205 
206             if(isExist) {
207                 oldSCUserId++;
208                 
209                  refM1 = oldSC.userList(referrerIDM1);
210                  refM2 = oldSC.userList(referrerIDM2);
211 
212                 if(!users[user].isExist) {
213                     
214                     users[user].isExist= true;
215                     users[user].id= ++currUserID;
216                     users[user].referrerIDMatrix1= users[refM1].id;
217                     users[user].referrerIDMatrix2= users[refM2].id;
218                     users[user].referralCounter= _referralCounter;
219                     users[user].referralMatrix1= oldSC.viewUserReferralMatrix1(user);
220                     users[user].referralMatrix2= oldSC.viewUserReferralMatrix1(user);
221         
222 
223                 
224                 userList[currUserID] = user;
225 
226                 users[refM1].referralMatrix1.push(user);
227                 users[refM2].referralMatrix2.push(user);
228                 uint256 levelTimeM1;
229                 uint256 levelTimeM2; 
230 
231                     for(uint j = 1; j <= 6; j++) {
232                          levelTimeM1 = oldSC.viewUserLevelExpiredMatrix1(user, j);
233                          levelTimeM2 = oldSC.viewUserLevelExpiredMatrix2(user, j);
234                          
235                         if(levelTimeM1 != 0)
236                             users[user].levelExpiredMatrix1[j] = levelTimeM1 + 30 days;
237                         if(levelTimeM2 != 0)
238                             users[user].levelExpiredMatrix2[j] = levelTimeM2 + 30 days;
239                     }
240 
241                     emit regLevelEvent(user, address(0x0), block.timestamp);
242                 }
243             }
244             else break;
245         }
246         emit syncComplete();
247     }
248 
249 
250     /**
251         * @dev function to register the user in the pre registration
252     */
253     function preRegAdmins(address [] memory _adminAddress) public onlyOwner{
254 
255         require(currUserID <=100, "No more admins can be registered");
256 
257         UserStruct memory userStruct;
258 
259         for(uint i = 0; i < _adminAddress.length; i++){
260 
261             require(!users[_adminAddress[i]].isExist, 'One of the users exist');
262             currUserID++;
263 
264             if(currUserID == 1){
265                 userStruct = UserStruct({
266                 isExist: true,
267                 id: currUserID,
268                 referrerIDMatrix1: 1,
269                 referrerIDMatrix2: 1,
270                 referralCounter: 2,
271                 referralMatrix1: new address[](0),
272                 referralMatrix2: new address[](0)
273         });
274 
275             users[_adminAddress[i]] = userStruct;
276             userList[currUserID] = _adminAddress[i];
277 
278             for(uint j = 1; j <= 6; j++) {
279                 users[_adminAddress[i]].levelExpiredMatrix1[j] = 66666666666;
280                 users[_adminAddress[i]].levelExpiredMatrix2[j] = 66666666666;
281                 users[_adminAddress[i]].levelExpiredMatrix3[j] = 66666666666;
282             }
283             
284         }
285             else {
286                     uint _referrerIDMatrix1;
287                     uint _referrerIDMatrix2 = 1;
288 
289                     _referrerIDMatrix1 = findAvailablePersonMatrix1();
290 
291                     if(users[userList[_referrerIDMatrix2]].referralMatrix2.length >= REFERRER_1_LEVEL_LIMIT) 
292                         _referrerIDMatrix2 = users[findAvailablePersonMatrix2(userList[_referrerIDMatrix2])].id;
293 
294                                        
295                     userStruct = UserStruct({
296                         isExist: true,
297                         id: currUserID,
298                         referrerIDMatrix1: _referrerIDMatrix1,
299                         referrerIDMatrix2: _referrerIDMatrix2,
300                         referralCounter: 2,
301                         referralMatrix1: new address[](0),
302                         referralMatrix2: new address[](0)
303                     });
304 
305                     users[_adminAddress[i]] = userStruct;
306                     userList[currUserID] = _adminAddress[i];
307 
308                     for(uint j = 1; j <= 6; j++) {
309                         users[_adminAddress[i]].levelExpiredMatrix1[j] = 66666666666;
310                         users[_adminAddress[i]].levelExpiredMatrix2[j] = 66666666666;
311                         users[_adminAddress[i]].levelExpiredMatrix3[j] = 66666666666;
312                     }
313 
314                     users[userList[_referrerIDMatrix1]].referralMatrix1.push(_adminAddress[i]);
315                     users[userList[_referrerIDMatrix2]].referralMatrix2.push(_adminAddress[i]);
316 
317                 }
318                 emit regLevelEvent(_adminAddress[i], address(0x0), block.timestamp);
319     }
320 }
321 
322     function addShareHolderM1(address [] memory _shareHolderAddress) public onlyOwner returns(address[] memory){
323 
324         for(uint i=0; i < _shareHolderAddress.length; i++){
325 
326             if(shareHoldersM1.length < 20) {
327                 shareHoldersM1.push(_shareHolderAddress[i]);
328             }
329         }
330         return shareHoldersM1;
331     }
332 
333     function removeShareHolderM1(address  _shareHolderAddress) public onlyOwner returns(address[] memory){
334 
335         for(uint i=0; i < shareHoldersM1.length; i++){
336             if(shareHoldersM1[i] == _shareHolderAddress) {
337                 shareHoldersM1[i] = shareHoldersM1[shareHoldersM1.length-1];
338                 delete shareHoldersM1[shareHoldersM1.length-1];
339                 shareHoldersM1.length--;
340             }
341         }
342         return shareHoldersM1;
343 
344     }
345 
346     function addShareHolderM2(address [] memory _shareHolderAddress) public onlyOwner returns(address[] memory){
347 
348         for(uint i=0; i < _shareHolderAddress.length; i++){
349 
350             if(shareHoldersM2.length < 20) {
351                 shareHoldersM2.push(_shareHolderAddress[i]);
352             }
353         }
354         return shareHoldersM2;
355     }
356 
357     function removeShareHolderM2(address  _shareHolderAddress) public onlyOwner returns(address[] memory){
358 
359         for(uint i=0; i < shareHoldersM2.length; i++){
360             if(shareHoldersM2[i] == _shareHolderAddress) {
361                 shareHoldersM2[i] = shareHoldersM2[shareHoldersM2.length-1];
362                 delete shareHoldersM2[shareHoldersM2.length-1];
363                 shareHoldersM2.length--;
364             }
365         }
366         return shareHoldersM2;
367 
368     }
369 
370     function addShareHolderM3(address [] memory _shareHolderAddress) public onlyOwner returns(address[] memory){
371 
372         for(uint i=0; i < _shareHolderAddress.length; i++){
373 
374             if(shareHoldersM3.length < 20) {
375                 shareHoldersM3.push(_shareHolderAddress[i]);
376             }
377         }
378         return shareHoldersM3;
379     }
380 
381     function removeShareHolderM3(address  _shareHolderAddress) public onlyOwner returns(address[] memory){
382 
383         for(uint i=0; i < shareHoldersM3.length; i++){
384             if(shareHoldersM3[i] == _shareHolderAddress) {
385                 shareHoldersM3[i] = shareHoldersM3[shareHoldersM3.length-1];
386                 delete shareHoldersM3[shareHoldersM3.length-1];
387                 shareHoldersM3.length--;
388             }
389         }
390         return shareHoldersM3;
391 
392     }
393 
394     /**
395         * @dev function to find the next available person in the complete binary tree
396         * @return id of the available person in the tree.
397     */
398     function findAvailablePersonMatrix1() internal returns(uint){
399        
400         uint _referrerID;
401         uint _referralLength = users[userList[availablePersonID]].referralMatrix1.length;
402         
403          if(_referralLength == REFERRER_1_LEVEL_LIMIT) {       
404              availablePersonID++;
405              _referrerID = availablePersonID;
406         }
407         else if( _referralLength == 1) {
408             _referrerID = availablePersonID;
409             availablePersonID++;            
410         }
411         else{
412              _referrerID = availablePersonID;
413         }
414 
415         return _referrerID;
416     }
417 
418     function findAvailablePersonMatrix2(address _user) public view returns(address) {
419         if(users[_user].referralMatrix2.length < REFERRER_1_LEVEL_LIMIT) return _user;
420 
421         address[] memory referrals = new address[](1022);
422         referrals[0] = users[_user].referralMatrix2[0];
423         referrals[1] = users[_user].referralMatrix2[1];
424 
425         address freeReferrer;
426         bool noFreeReferrer = true;
427 
428         for(uint i = 0; i < 1022; i++) {
429             if(users[referrals[i]].referralMatrix2.length == REFERRER_1_LEVEL_LIMIT) {
430                 if(i < 510) {
431                     referrals[(i+1)*2] = users[referrals[i]].referralMatrix2[0];
432                     referrals[(i+1)*2+1] = users[referrals[i]].referralMatrix2[1];
433                 }
434             }
435             else {
436                 noFreeReferrer = false;
437                 freeReferrer = referrals[i];
438                 break;
439             }
440         }
441 
442         require(!noFreeReferrer, 'No Free Referrer');
443 
444         return freeReferrer;
445     }
446 
447 
448     function getUserUpline(address _user, uint height)
449     public
450     view
451     returns (address)
452   {
453     if (height <= 0 || _user == address(0)) {
454       return _user;
455     }
456 
457     return this.getUserUpline(userList[users[_user].referrerIDMatrix2], height - 1);
458   }
459 
460    
461 
462     /**
463         * @dev function to buy the level for Company forced matrix
464         * @param _level level which a user wants to buy
465     */
466     function buyLevelMatrix1(uint _level) public payable {
467 
468         require(users[msg.sender].isExist, 'User not exist'); 
469         require(_level > 0 && _level <= 6, 'Incorrect level');
470 
471         if(_level == 1) {
472             require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
473 
474             if(users[msg.sender].levelExpiredMatrix1[1] > now)             
475                 users[msg.sender].levelExpiredMatrix1[1] += PERIOD_LENGTH;
476                             
477             else 
478                 users[msg.sender].levelExpiredMatrix1[1] = now + PERIOD_LENGTH;
479             
480         }
481         else {
482             require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
483 
484             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpiredMatrix1[l] >= now, 'Buy the previous level');
485 
486             if(users[msg.sender].levelExpiredMatrix1[_level] == 0 || now > users[msg.sender].levelExpiredMatrix1[_level])
487                 users[msg.sender].levelExpiredMatrix1[_level] = now + PERIOD_LENGTH;
488             else users[msg.sender].levelExpiredMatrix1[_level] += PERIOD_LENGTH;
489         }
490 
491         payForLevelMatrix1(_level, msg.sender);
492 
493         emit buyLevelEvent(msg.sender, _level, now, 1);
494     }
495 
496     /**
497         * @dev function to buy the level for Team matrix
498         * @param _level level which a user wants to buy
499     */
500     function buyLevelMatrix2(uint _level) public payable {
501         
502         require(users[msg.sender].isExist, 'User not exist'); 
503         require(_level > 0 && _level <= 6, 'Incorrect level');
504 
505         if(_level == 1) {
506             require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
507 
508             if(users[msg.sender].levelExpiredMatrix2[1] > now)               
509                 users[msg.sender].levelExpiredMatrix2[1] += PERIOD_LENGTH;
510                             
511             else 
512                 users[msg.sender].levelExpiredMatrix2[1] = now + PERIOD_LENGTH;
513             
514        }
515         else {
516             require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
517 
518             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpiredMatrix2[l] >= now, 'Buy the previous level');
519 
520             if(users[msg.sender].levelExpiredMatrix2[_level] == 0 || now > users[msg.sender].levelExpiredMatrix2[_level]) 
521                 users[msg.sender].levelExpiredMatrix2[_level] = now + PERIOD_LENGTH;
522             
523             else users[msg.sender].levelExpiredMatrix2[_level] += PERIOD_LENGTH;
524         }
525 
526         payForLevelMatrix2(_level, msg.sender);
527 
528         emit buyLevelEvent(msg.sender, _level, now, 2);
529     }
530 
531     /**
532         * @dev function to buy the level for Hybrid matrix
533         * @param _level level which a user wants to buy
534     */
535     function buyLevelMatrix3(uint _level) public payable {
536         
537         require(users[msg.sender].isExist, 'User not exist'); 
538         require(_level > 0 && _level <= 6, 'Incorrect level');
539 
540         if(_level == 1) {
541             require(msg.value == LEVEL_PRICEM3[1], 'Incorrect Value');
542 
543             if(users[msg.sender].levelExpiredMatrix3[1] > now)               
544                 users[msg.sender].levelExpiredMatrix3[1] += PERIOD_LENGTH;
545                             
546             else 
547                 users[msg.sender].levelExpiredMatrix3[1] = now + PERIOD_LENGTH;
548             
549        }
550         else {
551             require(msg.value == LEVEL_PRICEM3[_level], 'Incorrect Value');
552 
553             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpiredMatrix3[l] >= now, 'Buy the previous level');
554 
555             if(users[msg.sender].levelExpiredMatrix3[_level] == 0 || now > users[msg.sender].levelExpiredMatrix3[_level]) 
556                 users[msg.sender].levelExpiredMatrix3[_level] = now + PERIOD_LENGTH;
557             
558             else users[msg.sender].levelExpiredMatrix3[_level] += PERIOD_LENGTH;
559         }
560 
561         payForLevelMatrix3(_level, msg.sender);
562 
563         emit buyLevelEvent(msg.sender, _level, now, 3);
564     }
565 
566     function payForLevelMatrix1(uint _level, address _user) internal {
567         address actualReferer;
568         address tempReferer1;
569         address tempReferer2;
570         uint userID;
571 
572         if(_level == 1) {
573             actualReferer = userList[users[_user].referrerIDMatrix1];
574             userID = users[actualReferer].id;
575         }
576         else if(_level == 2) {
577             tempReferer1 = userList[users[_user].referrerIDMatrix1];
578             actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
579             userID = users[actualReferer].id;
580         }
581         else if(_level == 3) {
582             tempReferer1 = userList[users[_user].referrerIDMatrix1];
583             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
584             actualReferer = userList[users[tempReferer2].referrerIDMatrix1];
585             userID = users[actualReferer].id;
586         }
587         else if(_level == 4) {
588             tempReferer1 = userList[users[_user].referrerIDMatrix1];
589             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
590             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
591             actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
592             userID = users[actualReferer].id;
593         }
594         else if(_level == 5) {
595             tempReferer1 = userList[users[_user].referrerIDMatrix1];
596             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
597             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
598             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
599             actualReferer = userList[users[tempReferer2].referrerIDMatrix1];
600             userID = users[actualReferer].id;
601         }
602         else if(_level == 6) {
603             tempReferer1 = userList[users[_user].referrerIDMatrix1];
604             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
605             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
606             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
607             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
608             actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
609             userID = users[actualReferer].id;
610         }
611 
612         if(!users[actualReferer].isExist) actualReferer = userList[1];
613 
614         bool sent = false;
615         
616         if(userID > 0 && userID <= 63) {
617            for(uint i=0; i < shareHoldersM1.length; i++) {
618                 address(uint160(shareHoldersM1[i])).transfer(LEVEL_PRICE[_level]/(shareHoldersM1.length));
619                 emit getMoneyForLevelEvent(shareHoldersM1[i], msg.sender, _level, now, 1);
620             }
621             if(address(this).balance > 0)
622                 address(uint160(userList[1])).transfer(address(this).balance);
623           }
624         
625         else{
626           if(users[actualReferer].levelExpiredMatrix1[_level] >= now && users[actualReferer].referralCounter >= 2) {
627               sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level]);
628                 if (sent) {
629                         emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 1);
630                     }
631                 }
632             if(!sent) {
633               emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 1);
634                 payForLevelMatrix1(_level, actualReferer);
635              }
636 
637         }
638             
639     }
640 
641     function payForLevelMatrix2(uint _level, address _user) internal {
642         address actualReferer;
643         address tempReferer1;
644         address tempReferer2;
645         uint userID;
646 
647         if(_level == 1) {
648             actualReferer = userList[users[_user].referrerIDMatrix2];
649             userID = users[actualReferer].id;
650         }
651         else if(_level == 2) {
652             tempReferer1 = userList[users[_user].referrerIDMatrix2];
653             actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
654             userID = users[actualReferer].id;
655         }
656         else if(_level == 3) {
657             tempReferer1 = userList[users[_user].referrerIDMatrix2];
658             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
659             actualReferer = userList[users[tempReferer2].referrerIDMatrix2];
660             userID = users[actualReferer].id;
661         }
662         else if(_level == 4) {
663             tempReferer1 = userList[users[_user].referrerIDMatrix2];
664             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
665             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
666             actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
667             userID = users[actualReferer].id;
668         }
669         else if(_level == 5) {
670             tempReferer1 = userList[users[_user].referrerIDMatrix2];
671             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
672             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
673             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
674             actualReferer = userList[users[tempReferer2].referrerIDMatrix2];
675             userID = users[actualReferer].id;
676         }
677         else if(_level == 6) {
678             tempReferer1 = userList[users[_user].referrerIDMatrix2];
679             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
680             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
681             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
682             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
683             actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
684             userID = users[actualReferer].id;
685         }
686 
687         if(!users[actualReferer].isExist) actualReferer = userList[1];
688 
689         bool sent = false;
690         
691         if(userID > 0 && userID <= 63) {
692            for(uint i=0; i < shareHoldersM2.length; i++) {
693                 address(uint160(shareHoldersM2[i])).transfer(LEVEL_PRICE[_level]/(shareHoldersM2.length));
694                 emit getMoneyForLevelEvent(shareHoldersM2[i], msg.sender, _level, now, 2);
695             }
696             if(address(this).balance > 0)
697                 address(uint160(userList[1])).transfer(address(this).balance);
698           }
699         
700         else{
701           if(users[actualReferer].levelExpiredMatrix2[_level] >= now) {
702               sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level]);
703                 if (sent) {
704                         emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 2);
705                     }
706                 }
707             if(!sent) {
708               emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 2);
709                 payForLevelMatrix2(_level, actualReferer);
710              }
711         }
712             
713     }
714 
715     function payForLevelMatrix3(uint _level, address _user) internal {
716         uint height = _level;
717         address referrer = getUserUpline(_user, height);
718 
719         if (referrer == address(0)) { referrer = userList[1]; }
720     
721         uint uplines = uplinesToRcvEth[_level];
722         bool chkLostProfit = false;
723         for (uint i = 1; i <= uplines; i++) {
724             referrer = getUserUpline(_user, i);
725           
726             if (viewUserLevelExpiredMatrix3(referrer, _level) < now) {
727                 chkLostProfit = true;
728                 uplines++;
729                 emit lostMoneyForLevelEvent(referrer, msg.sender, _level, now, 3);
730                 continue;
731             }
732             else {chkLostProfit = false;}
733             
734             if (referrer == address(0)) { referrer = userList[1]; }
735 
736             if(users[referrer].id >0 && users[referrer].id <= 63){
737                 
738                 uint test = (uplines - i) + 1;
739                 uint totalValue = test * (LEVEL_PRICEM3[_level]/uplinesToRcvEth[_level]);
740                 
741                 for(uint j=0; j < shareHoldersM3.length; j++) {
742                         address(uint160(shareHoldersM3[j])).transfer(totalValue/(shareHoldersM3.length));
743                         emit getMoneyForLevelEvent(shareHoldersM3[j], msg.sender, _level, now, 3);
744                     }
745                     break;
746                     
747             }
748             else {
749                 if (address(uint160(referrer)).send( LEVEL_PRICEM3[_level] / uplinesToRcvEth[_level] )) {               
750                     emit getMoneyForLevelEvent(referrer, msg.sender, _level, now, 3);
751                 }
752             }               
753     }
754             if(address(this).balance > 0)
755                 address(uint160(userList[1])).transfer(address(this).balance);
756           
757   }
758 
759     /**
760      * @dev Transfers ownership of the contract to a new account (`newOwner`).
761      * Can only be called by the current owner.
762      */
763     function transferOwnership(address newOwner) external onlyOwner {
764         _transferOwnership(newOwner);
765     }
766 
767      /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      */
770     function _transferOwnership(address newOwner) internal {
771         require(newOwner != address(0), "New owner cannot be the zero address");
772         emit OwnershipTransferred(_owner, newOwner);
773         _owner = newOwner;
774     }
775 
776     /**
777      * @dev Read only function to see the 2 children of a node in Company forced matrix
778      * @return 2 branches
779      */
780     function viewUserReferralMatrix1(address _user) public view returns(address[] memory) {
781         return users[_user].referralMatrix1;
782     }
783 
784     /**
785      * @dev Read only function to see the 2 children of a node in Team Matrix
786      * @return 2 branches
787      */
788     function viewUserReferralMatrix2(address _user) public view returns(address[] memory) {
789         return users[_user].referralMatrix2;
790     }
791     
792     /**
793      * @dev Read only function to see the expiration time of a particular level in Company forced Matrix
794      * @return unix timestamp
795      */
796     function viewUserLevelExpiredMatrix1(address _user, uint _level) public view returns(uint256) {
797         return users[_user].levelExpiredMatrix1[_level];
798     }
799 
800     /**
801      * @dev Read only function to see the expiration time of a particular level in Team Matrix
802      * @return unix timestamp
803      */
804     function viewUserLevelExpiredMatrix2(address _user, uint _level) public view returns(uint256) {
805         return users[_user].levelExpiredMatrix2[_level];
806     }
807 
808     /**
809      * @dev Read only function to see the expiration time of a particular level in Hybrid Matrix
810      * @return unix timestamp
811      */
812     function viewUserLevelExpiredMatrix3(address _user, uint _level) public view returns(uint256) {
813         return users[_user].levelExpiredMatrix3[_level];
814     }
815 
816     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
817         assembly {
818             addr := mload(add(bys, 20))
819         }
820     }
821 }