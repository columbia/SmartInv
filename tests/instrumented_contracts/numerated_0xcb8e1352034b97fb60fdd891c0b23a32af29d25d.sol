1 pragma solidity 0.5.11;
2 
3 
4 contract Etrix {
5 
6     address public _owner;
7 
8       //Structure to store the user related data
9       struct UserStruct {
10         bool isExist;
11         uint id;
12         uint referrerIDMatrix1;
13         uint referrerIDMatrix2;
14         address[] referralMatrix1;
15         address[] referralMatrix2;
16         uint referralCounter;
17         mapping(uint => uint) levelExpiredMatrix1;
18         mapping(uint => uint) levelExpiredMatrix2; 
19     }
20 
21     //A person can have maximum 2 branches
22     uint constant private REFERRER_1_LEVEL_LIMIT = 2;
23     //period of a particular level
24     uint constant private PERIOD_LENGTH = 60 days;
25     //person where the new user will be joined
26     uint public availablePersonID;
27     //Addresses of the Team   
28     address [] public shareHolders;
29     //cost of each level
30     mapping(uint => uint) public LEVEL_PRICE;
31 
32     //data of each user from the address
33     mapping (address => UserStruct) public users;
34     //user address by their id
35     mapping (uint => address) public userList;
36     //to track latest user ID
37     uint public currUserID = 0;
38 
39     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
40     event buyLevelEvent(address indexed _user, uint _level, uint _time, uint _matrix);
41     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
42     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _matrix);
43     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _matrix);
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     constructor() public {
47         _owner = msg.sender;
48 
49         LEVEL_PRICE[1] = 0.05 ether;
50         LEVEL_PRICE[2] = 0.1 ether;
51         LEVEL_PRICE[3] = 0.3 ether;
52         LEVEL_PRICE[4] = 1.25 ether;
53         LEVEL_PRICE[5] = 5 ether;
54         LEVEL_PRICE[6] = 10 ether;
55         
56         availablePersonID = 1;
57 
58     }
59 
60     /**
61      * @dev allows only the user to run the function
62      */
63     modifier onlyOwner() {
64         require(msg.sender == _owner, "only Owner");
65         _;
66     }
67 
68     function () external payable {
69       
70         uint level;
71 
72         //check the level on the basis of amount sent
73         if(msg.value == LEVEL_PRICE[1]) level = 1;
74         else if(msg.value == LEVEL_PRICE[2]) level = 2;
75         else if(msg.value == LEVEL_PRICE[3]) level = 3;
76         else if(msg.value == LEVEL_PRICE[4]) level = 4;
77         else if(msg.value == LEVEL_PRICE[5]) level = 5;
78         else if(msg.value == LEVEL_PRICE[6]) level = 6;
79         
80         else revert('Incorrect Value send, please check');
81 
82         //if user has already registered previously
83         if(users[msg.sender].isExist) 
84             buyLevelMatrix1(level);
85 
86         else if(level == 1) {
87             uint refId = 0;
88             address referrer = bytesToAddress(msg.data);
89 
90             if(users[referrer].isExist) refId = users[referrer].id;
91             else revert('Incorrect referrer id');
92 
93             regUser(refId);
94         }
95         else revert('Please buy first level for 0.05 ETH and then proceed');
96     }
97 
98     /**
99         * @dev function to register the user after the pre registration
100         * @param _referrerID id of the referrer
101     */
102     function regUser(uint _referrerID) public payable {
103 
104         require(!users[msg.sender].isExist, 'User exist');
105         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
106         require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
107         
108 
109         uint _referrerIDMatrix1;
110         uint _referrerIDMatrix2 = _referrerID;
111 
112         _referrerIDMatrix1 = findAvailablePersonMatrix1();
113 
114         if(users[userList[_referrerIDMatrix2]].referralMatrix2.length >= REFERRER_1_LEVEL_LIMIT) 
115             _referrerIDMatrix2 = users[findAvailablePersonMatrix2(userList[_referrerIDMatrix2])].id;
116         
117 
118         UserStruct memory userStruct;
119         currUserID++;
120 
121         userStruct = UserStruct({
122             isExist: true,
123             id: currUserID,
124             referrerIDMatrix1: _referrerIDMatrix1,
125             referrerIDMatrix2: _referrerIDMatrix2,
126             referralCounter: 0,
127             referralMatrix1: new address[](0),
128             referralMatrix2: new address[](0)
129         });
130 
131         users[msg.sender] = userStruct;
132         userList[currUserID] = msg.sender;
133 
134         
135         users[msg.sender].levelExpiredMatrix1[1] = now + PERIOD_LENGTH;
136 
137         users[userList[_referrerIDMatrix1]].referralMatrix1.push(msg.sender);
138         users[userList[_referrerIDMatrix2]].referralMatrix2.push(msg.sender);
139 
140         payForLevelMatrix1(1,msg.sender);
141 
142         //increase the referrer counter of the referrer
143         users[userList[_referrerID]].referralCounter++;
144 
145         emit regLevelEvent(msg.sender, userList[_referrerID], now);
146     }
147 
148     /**
149         * @dev function to register the user in the pre registration
150     */
151     function preRegAdmins(address [] memory _adminAddress) public onlyOwner{
152 
153         require(currUserID <= 100, "No more admins can be registered");
154 
155         UserStruct memory userStruct;
156 
157         for(uint i = 0; i < _adminAddress.length; i++){
158 
159             require(!users[_adminAddress[i]].isExist, 'One of the users exist');
160             currUserID++;
161 
162             if(currUserID == 1){
163                 userStruct = UserStruct({
164                 isExist: true,
165                 id: currUserID,
166                 referrerIDMatrix1: 1,
167                 referrerIDMatrix2: 1,
168                 referralCounter: 2,
169                 referralMatrix1: new address[](0),
170                 referralMatrix2: new address[](0)
171         });
172 
173             users[_adminAddress[i]] = userStruct;
174             userList[currUserID] = _adminAddress[i];
175 
176             for(uint j = 1; j <= 6; j++) {
177                 users[_adminAddress[i]].levelExpiredMatrix1[j] = 66666666666;
178                 users[_adminAddress[i]].levelExpiredMatrix2[j] = 66666666666;
179             }
180             
181         }
182             else {
183                     uint _referrerIDMatrix1;
184                     uint _referrerIDMatrix2 = 1;
185 
186                     _referrerIDMatrix1 = findAvailablePersonMatrix1();
187 
188                     if(users[userList[_referrerIDMatrix2]].referralMatrix2.length >= REFERRER_1_LEVEL_LIMIT) 
189                         _referrerIDMatrix2 = users[findAvailablePersonMatrix2(userList[_referrerIDMatrix2])].id;
190 
191                                        
192                     userStruct = UserStruct({
193                         isExist: true,
194                         id: currUserID,
195                         referrerIDMatrix1: _referrerIDMatrix1,
196                         referrerIDMatrix2: _referrerIDMatrix2,
197                         referralCounter: 2,
198                         referralMatrix1: new address[](0),
199                         referralMatrix2: new address[](0)
200                     });
201 
202                     users[_adminAddress[i]] = userStruct;
203                     userList[currUserID] = _adminAddress[i];
204 
205                     for(uint j = 1; j <= 6; j++) {
206                         users[_adminAddress[i]].levelExpiredMatrix1[j] = 66666666666;
207                         users[_adminAddress[i]].levelExpiredMatrix2[j] = 66666666666;
208                     }
209 
210                     users[userList[_referrerIDMatrix1]].referralMatrix1.push(_adminAddress[i]);
211                     users[userList[_referrerIDMatrix2]].referralMatrix2.push(_adminAddress[i]);
212 
213                 }
214     }
215 }
216 
217     function addShareHolder(address [] memory _shareHolderAddress) public onlyOwner returns(address[] memory){
218 
219         for(uint i=0; i < _shareHolderAddress.length; i++){
220 
221             if(shareHolders.length < 20) {
222                 shareHolders.push(_shareHolderAddress[i]);
223             }
224         }
225         return shareHolders;
226     }
227 
228     function removeShareHolder(address  _shareHolderAddress) public onlyOwner returns(address[] memory){
229 
230         for(uint i=0; i < shareHolders.length; i++){
231             if(shareHolders[i] == _shareHolderAddress) {
232                 shareHolders[i] = shareHolders[shareHolders.length-1];
233                 delete shareHolders[shareHolders.length-1];
234                 shareHolders.length--;
235             }
236         }
237         return shareHolders;
238 
239     }
240 
241     /**
242         * @dev function to find the next available person in the complete binary tree
243         * @return id of the available person in the tree.
244     */
245     function findAvailablePersonMatrix1() internal returns(uint){
246        
247         uint _referrerID;
248         uint _referralLength = users[userList[availablePersonID]].referralMatrix1.length;
249         
250          if(_referralLength == REFERRER_1_LEVEL_LIMIT) {       
251              availablePersonID++;
252              _referrerID = availablePersonID;
253         }
254         else if( _referralLength == 1) {
255             _referrerID = availablePersonID;
256             availablePersonID++;            
257         }
258         else{
259              _referrerID = availablePersonID;
260         }
261 
262         return _referrerID;
263     }
264 
265     function findAvailablePersonMatrix2(address _user) public view returns(address) {
266         if(users[_user].referralMatrix2.length < REFERRER_1_LEVEL_LIMIT) return _user;
267 
268         address[] memory referrals = new address[](1022);
269         referrals[0] = users[_user].referralMatrix2[0];
270         referrals[1] = users[_user].referralMatrix2[1];
271 
272         address freeReferrer;
273         bool noFreeReferrer = true;
274 
275         for(uint i = 0; i < 1022; i++) {
276             if(users[referrals[i]].referralMatrix2.length == REFERRER_1_LEVEL_LIMIT) {
277                 if(i < 510) {
278                     referrals[(i+1)*2] = users[referrals[i]].referralMatrix2[0];
279                     referrals[(i+1)*2+1] = users[referrals[i]].referralMatrix2[1];
280                 }
281             }
282             else {
283                 noFreeReferrer = false;
284                 freeReferrer = referrals[i];
285                 break;
286             }
287         }
288 
289         require(!noFreeReferrer, 'No Free Referrer');
290 
291         return freeReferrer;
292     }
293 
294    
295 
296     /**
297         * @dev function to buy the level for Company forced matrix
298         * @param _level level which a user wants to buy
299     */
300     function buyLevelMatrix1(uint _level) public payable {
301 
302         require(users[msg.sender].isExist, 'User not exist'); 
303         require(_level > 0 && _level <= 6, 'Incorrect level');
304 
305         if(_level == 1) {
306             require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
307 
308             if(users[msg.sender].levelExpiredMatrix1[1] > now)             
309                 users[msg.sender].levelExpiredMatrix1[1] += PERIOD_LENGTH;
310                             
311             else 
312                 users[msg.sender].levelExpiredMatrix1[1] = now + PERIOD_LENGTH;
313             
314         }
315         else {
316             require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
317 
318             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpiredMatrix1[l] >= now, 'Buy the previous level');
319 
320             if(users[msg.sender].levelExpiredMatrix1[_level] == 0 || now > users[msg.sender].levelExpiredMatrix1[_level])
321                 users[msg.sender].levelExpiredMatrix1[_level] = now + PERIOD_LENGTH;
322             else users[msg.sender].levelExpiredMatrix1[_level] += PERIOD_LENGTH;
323         }
324 
325         payForLevelMatrix1(_level, msg.sender);
326 
327         emit buyLevelEvent(msg.sender, _level, now, 1);
328     }
329 
330     /**
331         * @dev function to buy the level for Team matrix
332         * @param _level level which a user wants to buy
333     */
334     function buyLevelMatrix2(uint _level) public payable {
335         
336         require(users[msg.sender].isExist, 'User not exist'); 
337         require(users[msg.sender].referralCounter >= 2, 'Need atleast 2 direct referrals to activate Team Matrix');
338         require(_level > 0 && _level <= 6, 'Incorrect level');
339 
340         if(_level == 1) {
341             require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
342 
343             if(users[msg.sender].levelExpiredMatrix2[1] > now)               
344                 users[msg.sender].levelExpiredMatrix2[1] += PERIOD_LENGTH;
345                             
346             else 
347                 users[msg.sender].levelExpiredMatrix2[1] = now + PERIOD_LENGTH;
348             
349        }
350         else {
351             require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
352 
353             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpiredMatrix2[l] >= now, 'Buy the previous level');
354 
355             if(users[msg.sender].levelExpiredMatrix2[_level] == 0 || now > users[msg.sender].levelExpiredMatrix2[_level]) 
356                 users[msg.sender].levelExpiredMatrix2[_level] = now + PERIOD_LENGTH;
357             
358             else users[msg.sender].levelExpiredMatrix2[_level] += PERIOD_LENGTH;
359         }
360 
361         payForLevelMatrix2(_level, msg.sender);
362 
363         emit buyLevelEvent(msg.sender, _level, now, 2);
364     }
365 
366     function payForLevelMatrix1(uint _level, address _user) internal {
367         address actualReferer;
368         address tempReferer1;
369         address tempReferer2;
370         uint userID;
371 
372         if(_level == 1) {
373             actualReferer = userList[users[_user].referrerIDMatrix1];
374             userID = users[actualReferer].id;
375         }
376         else if(_level == 2) {
377             tempReferer1 = userList[users[_user].referrerIDMatrix1];
378             actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
379             userID = users[actualReferer].id;
380         }
381         else if(_level == 3) {
382             tempReferer1 = userList[users[_user].referrerIDMatrix1];
383             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
384             actualReferer = userList[users[tempReferer2].referrerIDMatrix1];
385             userID = users[actualReferer].id;
386         }
387         else if(_level == 4) {
388             tempReferer1 = userList[users[_user].referrerIDMatrix1];
389             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
390             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
391             actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
392             userID = users[actualReferer].id;
393         }
394         else if(_level == 5) {
395             tempReferer1 = userList[users[_user].referrerIDMatrix1];
396             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
397             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
398             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
399             actualReferer = userList[users[tempReferer2].referrerIDMatrix1];
400             userID = users[actualReferer].id;
401         }
402         else if(_level == 6) {
403             tempReferer1 = userList[users[_user].referrerIDMatrix1];
404             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
405             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
406             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix1];
407             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix1];
408             actualReferer = userList[users[tempReferer1].referrerIDMatrix1];
409             userID = users[actualReferer].id;
410         }
411 
412         if(!users[actualReferer].isExist) actualReferer = userList[1];
413 
414         bool sent = false;
415         
416         if(userID > 0 && userID <= 63) {
417            for(uint i=0; i < shareHolders.length; i++) {
418                 address(uint160(shareHolders[i])).transfer(LEVEL_PRICE[_level]/(shareHolders.length));
419                 emit getMoneyForLevelEvent(shareHolders[i], msg.sender, _level, now, 1);
420             }
421             if(address(this).balance > 0)
422                 address(uint160(userList[1])).transfer(address(this).balance);
423           }
424         
425         else{
426           if(users[actualReferer].levelExpiredMatrix1[_level] >= now && users[actualReferer].referralCounter >= 2) {
427               sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level]);
428                 if (sent) {
429                         emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 1);
430                     }
431                 }
432             if(!sent) {
433               emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 1);
434                 payForLevelMatrix1(_level, actualReferer);
435              }
436 
437         }
438             
439     }
440 
441     function payForLevelMatrix2(uint _level, address _user) internal {
442         address actualReferer;
443         address tempReferer1;
444         address tempReferer2;
445         uint userID;
446 
447         if(_level == 1) {
448             actualReferer = userList[users[_user].referrerIDMatrix2];
449             userID = users[actualReferer].id;
450         }
451         else if(_level == 2) {
452             tempReferer1 = userList[users[_user].referrerIDMatrix2];
453             actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
454             userID = users[actualReferer].id;
455         }
456         else if(_level == 3) {
457             tempReferer1 = userList[users[_user].referrerIDMatrix2];
458             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
459             actualReferer = userList[users[tempReferer2].referrerIDMatrix2];
460             userID = users[actualReferer].id;
461         }
462         else if(_level == 4) {
463             tempReferer1 = userList[users[_user].referrerIDMatrix2];
464             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
465             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
466             actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
467             userID = users[actualReferer].id;
468         }
469         else if(_level == 5) {
470             tempReferer1 = userList[users[_user].referrerIDMatrix2];
471             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
472             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
473             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
474             actualReferer = userList[users[tempReferer2].referrerIDMatrix2];
475             userID = users[actualReferer].id;
476         }
477         else if(_level == 6) {
478             tempReferer1 = userList[users[_user].referrerIDMatrix2];
479             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
480             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
481             tempReferer2 = userList[users[tempReferer1].referrerIDMatrix2];
482             tempReferer1 = userList[users[tempReferer2].referrerIDMatrix2];
483             actualReferer = userList[users[tempReferer1].referrerIDMatrix2];
484             userID = users[actualReferer].id;
485         }
486 
487         if(!users[actualReferer].isExist) actualReferer = userList[1];
488 
489         bool sent = false;
490         
491         if(userID > 0 && userID <= 63) {
492            for(uint i=0; i < shareHolders.length; i++) {
493                 address(uint160(shareHolders[i])).transfer(LEVEL_PRICE[_level]/(shareHolders.length));
494                 emit getMoneyForLevelEvent(shareHolders[i], msg.sender, _level, now, 2);
495             }
496             if(address(this).balance > 0)
497                 address(uint160(userList[1])).transfer(address(this).balance);
498           }
499         
500         else{
501           if(users[actualReferer].levelExpiredMatrix2[_level] >= now) {
502               sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level]);
503                 if (sent) {
504                         emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 2);
505                     }
506                 }
507             if(!sent) {
508               emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 2);
509                 payForLevelMatrix2(_level, actualReferer);
510              }
511 
512         }
513             
514     }
515 
516     /**
517      * @dev Transfers ownership of the contract to a new account (`newOwner`).
518      * Can only be called by the current owner.
519      */
520     function transferOwnership(address newOwner) external onlyOwner {
521         _transferOwnership(newOwner);
522     }
523 
524      /**
525      * @dev Transfers ownership of the contract to a new account (`newOwner`).
526      */
527     function _transferOwnership(address newOwner) internal {
528         require(newOwner != address(0), "New owner cannot be the zero address");
529         emit OwnershipTransferred(_owner, newOwner);
530         _owner = newOwner;
531     }
532 
533     /**
534      * @dev Read only function to see the 2 children of a node in Company forced matrix
535      * @return 2 branches
536      */
537     function viewUserReferralMatrix1(address _user) public view returns(address[] memory) {
538         return users[_user].referralMatrix1;
539     }
540 
541     /**
542      * @dev Read only function to see the 2 children of a node in Team Matrix
543      * @return 2 branches
544      */
545     function viewUserReferralMatrix2(address _user) public view returns(address[] memory) {
546         return users[_user].referralMatrix2;
547     }
548     
549     /**
550      * @dev Read only function to see the expiration time of a particular level in Company forced Matrix
551      * @return unix timestamp
552      */
553     function viewUserLevelExpiredMatrix1(address _user, uint _level) public view returns(uint256) {
554         return users[_user].levelExpiredMatrix1[_level];
555     }
556 
557     /**
558      * @dev Read only function to see the expiration time of a particular level in Team Matrix
559      * @return unix timestamp
560      */
561     function viewUserLevelExpiredMatrix2(address _user, uint _level) public view returns(uint256) {
562         return users[_user].levelExpiredMatrix2[_level];
563     }
564 
565     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
566         assembly {
567             addr := mload(add(bys, 20))
568         }
569     }
570 }