1 /*
2 telegram: @gida
3 hashtag: #gida_corp
4 */
5 pragma solidity ^0.5.7;
6 
7 
8 library SafeMath {
9 
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a / b;
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32 }
33 
34 
35 contract Ownable {
36 
37   address public owner;
38   address public manager;
39   address public introducer;
40   address public ownerWallet1;
41   address public ownerWallet2;
42   address public ownerWallet3;
43 
44   constructor() public {
45     owner = msg.sender;
46     manager = msg.sender;
47     ownerWallet1 = 0x42910288DcD576aE8574D611575Dfe35D9fA2Aa2;
48     ownerWallet2 = 0xc40A767980fe384BBc367A8A0EeFF2BCC871A6c9;
49     ownerWallet3 = 0x7c734D78a247A5eE3f9A64cE061DB270A7cFeF37;
50   }
51 
52   modifier onlyOwner() {
53     require(msg.sender == owner, "only for owner");
54     _;
55   }
56 
57   modifier onlyOwnerOrManager() {
58      require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
59       _;
60   }
61 
62   function transferOwnership(address newOwner) public onlyOwner {
63     owner = newOwner;
64   }
65 
66   function setManager(address _manager) public onlyOwnerOrManager {
67       manager = _manager;
68   }
69 }
70 
71 contract Gida is Ownable {
72 
73     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
74     event consoleEvent(uint _msg);
75     event recoverPasswordEvent(address indexed _user, uint _time);
76     event paymentRejectedEvent(string _message, address indexed _user);
77     event buyLevelEvent(address indexed _user, uint _level, uint _time);
78     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
79     event getIntroducerMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint amount);
80     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint amount);
81     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint amount);
82     //------------------------------
83 
84     mapping (uint => uint) public LEVEL_PRICE;
85     uint REFERRER_1_LEVEL_LIMIT = 3;
86     uint RECOVER_PASSWORD = 0.01 ether;
87     uint PERIOD_LENGTH = 90 days;
88 
89 
90     struct UserStruct {
91         bool isExist;
92         uint id;
93         uint referrerID;
94         uint introducerID;
95         address[] referral;
96         mapping (uint => uint) levelExpired;
97     }
98 
99     mapping (address => UserStruct) public users;
100     mapping (uint => address) public userList;
101     uint public currUserID = 0;
102 
103 
104 
105 
106     constructor() public {
107 
108         LEVEL_PRICE[1] =  0.12 ether;
109 		LEVEL_PRICE[2] =  0.3 ether;
110 		LEVEL_PRICE[3] =  1 ether;
111 		LEVEL_PRICE[4] =  3 ether;
112 		LEVEL_PRICE[5] =  10 ether;
113 		LEVEL_PRICE[6] =  4 ether;
114 		LEVEL_PRICE[7] =  11 ether;
115 		LEVEL_PRICE[8] =  30 ether;
116 		LEVEL_PRICE[9] =  90 ether;
117 		LEVEL_PRICE[10] = 300 ether;
118 		
119         UserStruct memory userStruct1;
120         UserStruct memory userStruct2;
121         UserStruct memory userStruct3;
122         currUserID++;
123 
124         userStruct1 = UserStruct({
125             isExist : true,
126             id : currUserID,
127             referrerID : 0,
128             introducerID : 0,
129             referral : new address[](0)
130         });
131         users[ownerWallet1] = userStruct1;
132         userList[currUserID] = ownerWallet1;
133 
134         users[ownerWallet1].levelExpired[1] = 77777777777;
135         users[ownerWallet1].levelExpired[2] = 77777777777;
136         users[ownerWallet1].levelExpired[3] = 77777777777;
137         users[ownerWallet1].levelExpired[4] = 77777777777;
138         users[ownerWallet1].levelExpired[5] = 77777777777;
139         users[ownerWallet1].levelExpired[6] = 77777777777;
140         users[ownerWallet1].levelExpired[7] = 77777777777;
141         users[ownerWallet1].levelExpired[8] = 77777777777;
142         users[ownerWallet1].levelExpired[9] = 77777777777;
143         users[ownerWallet1].levelExpired[10] = 77777777777;
144 		
145         currUserID++;
146 
147         userStruct2 = UserStruct({
148             isExist : true,
149             id : currUserID,
150             referrerID : 0,
151             introducerID : 0,
152             referral : new address[](0)
153         });
154         users[ownerWallet2] = userStruct2;
155         userList[currUserID] = ownerWallet2;
156 
157         users[ownerWallet2].levelExpired[1] = 77777777777;
158         users[ownerWallet2].levelExpired[2] = 77777777777;
159         users[ownerWallet2].levelExpired[3] = 77777777777;
160         users[ownerWallet2].levelExpired[4] = 77777777777;
161         users[ownerWallet2].levelExpired[5] = 77777777777;
162         users[ownerWallet2].levelExpired[6] = 77777777777;
163         users[ownerWallet2].levelExpired[7] = 77777777777;
164         users[ownerWallet2].levelExpired[8] = 77777777777;
165         users[ownerWallet2].levelExpired[9] = 77777777777;
166         users[ownerWallet2].levelExpired[10] = 77777777777;
167 		
168 		currUserID++;
169 
170         userStruct3 = UserStruct({
171             isExist : true,
172             id : currUserID,
173             referrerID : 0,
174             introducerID : 0,
175             referral : new address[](0)
176         });
177         users[ownerWallet3] = userStruct3;
178         userList[currUserID] = ownerWallet3;
179 
180         users[ownerWallet3].levelExpired[1] = 77777777777;
181         users[ownerWallet3].levelExpired[2] = 77777777777;
182         users[ownerWallet3].levelExpired[3] = 77777777777;
183         users[ownerWallet3].levelExpired[4] = 77777777777;
184         users[ownerWallet3].levelExpired[5] = 77777777777;
185         users[ownerWallet3].levelExpired[6] = 77777777777;
186         users[ownerWallet3].levelExpired[7] = 77777777777;
187         users[ownerWallet3].levelExpired[8] = 77777777777;
188         users[ownerWallet3].levelExpired[9] = 77777777777;
189         users[ownerWallet3].levelExpired[10] = 77777777777;
190     }
191 
192     function () external payable {
193 
194         uint level;
195         uint passwordRecovery = 0;
196 
197         if(msg.value == LEVEL_PRICE[1]){
198             level = 1;
199         }else if(msg.value == LEVEL_PRICE[2]){
200             level = 2;
201         }else if(msg.value == LEVEL_PRICE[3]){
202             level = 3;
203         }else if(msg.value == LEVEL_PRICE[4]){
204             level = 4;
205         }else if(msg.value == LEVEL_PRICE[5]){
206             level = 5;
207         }else if(msg.value == LEVEL_PRICE[6]){
208             level = 6;
209         }else if(msg.value == LEVEL_PRICE[7]){
210             level = 7;
211         }else if(msg.value == LEVEL_PRICE[8]){
212             level = 8;
213         }else if(msg.value == LEVEL_PRICE[9]){
214             level = 9;
215         }else if(msg.value == LEVEL_PRICE[10]){
216             level = 10;
217         }else if(msg.value == RECOVER_PASSWORD){
218             passwordRecovery = 1;
219         }else {
220 			emit paymentRejectedEvent('Incorrect Value send', msg.sender);
221             revert('Incorrect Value send');
222         }
223 
224         if(users[msg.sender].isExist){
225 			if(passwordRecovery==1){
226 				emit recoverPasswordEvent(msg.sender, now);
227 			}else{
228 				buyLevel(level);
229 			}
230         } else if(level == 1) {
231 			if(passwordRecovery==0){
232 				
233 				uint refId = 0;
234 				address referrer = bytesToAddress(msg.data);
235 		
236 				if (users[referrer].isExist){
237 					refId = users[referrer].id;
238 				} else {
239 					emit paymentRejectedEvent('Incorrect referrer', msg.sender);
240 					revert('Incorrect referrer');
241 				}
242 				regUser(refId);
243 			}else{
244 				emit paymentRejectedEvent('User does not exist to recover password.', msg.sender);
245 				revert('User does not exist to recover password.');
246 			}
247         } else {
248 			emit paymentRejectedEvent('Please buy first level for 0.12 ETH', msg.sender);
249             revert('Please buy first level for 0.12 ETH');
250         }
251     }
252 
253     function regUser(uint _introducerID) public payable {
254 	    uint _referrerID;
255         require(!users[msg.sender].isExist, 'User exist');
256 
257         require(_introducerID > 0 && _introducerID <= currUserID, 'Incorrect referrer Id');
258 
259         require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
260 
261 		/* Default will be introducer, if 3 limit not reached */
262 		_referrerID = _introducerID;
263         if(users[userList[_introducerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)
264         {
265             _referrerID = users[findFreeReferrer(userList[_introducerID])].id;
266         }
267 
268 
269         UserStruct memory userStruct;
270         currUserID++;
271 
272         userStruct = UserStruct({
273             isExist : true,
274             id : currUserID,
275             referrerID : _referrerID,
276             introducerID : _introducerID,
277             referral : new address[](0)
278         });
279 
280         users[msg.sender] = userStruct;
281         userList[currUserID] = msg.sender;
282 
283         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
284         users[msg.sender].levelExpired[2] = 0;
285         users[msg.sender].levelExpired[3] = 0;
286         users[msg.sender].levelExpired[4] = 0;
287         users[msg.sender].levelExpired[5] = 0;
288         users[msg.sender].levelExpired[6] = 0;
289         users[msg.sender].levelExpired[7] = 0;
290         users[msg.sender].levelExpired[8] = 0;
291         users[msg.sender].levelExpired[9] = 0;
292         users[msg.sender].levelExpired[10] = 0;
293 
294         users[userList[_referrerID]].referral.push(msg.sender);
295 
296         payForLevel(1, msg.sender);
297 
298         emit regLevelEvent(msg.sender, userList[_referrerID], now);
299     }
300 
301     function buyLevel(uint _level) public payable {
302         require(users[msg.sender].isExist, 'User not exist');
303 
304         require( _level>0 && _level<=10, 'Incorrect level');
305 
306         if(_level == 1){
307             require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
308             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
309         } else {
310             require(msg.value==LEVEL_PRICE[_level], 'Incorrect Value');
311 
312             for(uint l =_level-1; l>0; l-- ){
313                 require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
314             }
315 
316             if(users[msg.sender].levelExpired[_level] == 0){
317                 users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
318             } else {
319                 users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
320             }
321         }
322         payForLevel(_level, msg.sender);
323         emit buyLevelEvent(msg.sender, _level, now);
324     }
325 
326     function payForLevel(uint _level, address _user) internal {
327 
328         address referer;
329         address referer1;
330         address referer2;
331         address referer3;
332         address referer4;
333         if(_level == 1 || _level == 6){
334             referer = userList[users[_user].referrerID];
335         } else if(_level == 2 || _level == 7){
336             referer1 = userList[users[_user].referrerID];
337             referer = userList[users[referer1].referrerID];
338         } else if(_level == 3 || _level == 8){
339             referer1 = userList[users[_user].referrerID];
340             referer2 = userList[users[referer1].referrerID];
341             referer = userList[users[referer2].referrerID];
342         } else if(_level == 4 || _level == 9){
343             referer1 = userList[users[_user].referrerID];
344             referer2 = userList[users[referer1].referrerID];
345             referer3 = userList[users[referer2].referrerID];
346             referer = userList[users[referer3].referrerID];
347         } else if(_level == 5 || _level == 10){
348             referer1 = userList[users[_user].referrerID];
349             referer2 = userList[users[referer1].referrerID];
350             referer3 = userList[users[referer2].referrerID];
351             referer4 = userList[users[referer3].referrerID];
352             referer = userList[users[referer4].referrerID];
353         }
354 		
355 		introducer = userList[users[msg.sender].introducerID];
356 		
357 		/* Split amount and send comission to admins */
358 		uint level;
359 		uint introducerlevel;
360 		uint firstAdminPart;
361 		uint finalToAdmin;
362 		uint introducerPart;
363 		uint refererPart;
364 		bool result;
365 		
366 		level	=	_level;
367 		
368 		if(_level==1){
369 			introducerPart 			=	0.02 ether; /* introducer will get 0.02*/
370 			refererPart 			=	0.1 ether; /* remaining 0.1 will go to referer*/
371 			
372 		}else{
373 			firstAdminPart 			=	(msg.value * 3)/100; /* 3% will go to admin*/
374 			introducerPart 			=	(msg.value * 15)/100; /* introducer will get 15%*/
375 			refererPart 			=	msg.value - (firstAdminPart + introducerPart); /* remaining 82% will go to referer*/
376 		}
377 		
378 		introducerlevel	=	0;
379 		
380 		for(uint l = _level; l <= 10; l++ ){
381 			if(users[introducer].levelExpired[l] >= now){
382 				introducerlevel	=	l;
383 				break;
384 			}
385 		}
386 		
387         if(!users[referer].isExist){
388 			finalToAdmin	=	msg.value;
389 			if(users[introducer].isExist && _level>1){
390 				
391 				if(introducerlevel >= _level){
392 					if(userList[1] != introducer && userList[2] != introducer){
393 						result = address(uint160(introducer)).send(introducerPart);
394 						finalToAdmin	=	finalToAdmin-introducerPart;
395 					}
396 				}else{
397 					firstAdminPart	=	firstAdminPart+introducerPart;
398 				}
399 				transferToAdmin3(firstAdminPart, msg.sender, level);
400 				finalToAdmin	=	finalToAdmin-firstAdminPart;
401 			}
402 			/* If referer not exist then transfer amount to admins */
403 			transferToAdmins(finalToAdmin, msg.sender, level);
404         }else{
405 			
406 			/* Admins are referer */
407 			if(userList[1]==referer || userList[2]==referer ){
408 				finalToAdmin	=	msg.value;
409 				if(users[introducer].isExist && _level>1){
410 					
411 					if(introducerlevel >= _level){
412 						if(userList[1] != introducer && userList[2] != introducer){
413 							result = address(uint160(introducer)).send(introducerPart);
414 							finalToAdmin	=	finalToAdmin-introducerPart;
415 						}
416 					}else{
417 						firstAdminPart	=	firstAdminPart+introducerPart;
418 					}
419 					transferToAdmin3(firstAdminPart, msg.sender, level);
420 					finalToAdmin	=	finalToAdmin-firstAdminPart;
421 				}
422 				/* If referer not exist then transfer amount to admins */
423 				transferToAdmins(finalToAdmin, msg.sender, level);
424 			}else{
425 				
426 				if(users[referer].levelExpired[level] >= now ){
427 					
428 					if(level>1){
429 						if(introducerlevel >= level){
430 							result = address(uint160(introducer)).send(introducerPart);
431 							emit getIntroducerMoneyForLevelEvent(introducer, msg.sender, level, now, introducerPart);
432 						}else{
433 							firstAdminPart	=	firstAdminPart+introducerPart;
434 						}
435 						result = address(uint160(referer)).send(refererPart);
436 						transferToAdmin3(firstAdminPart, msg.sender, level);
437 						emit getMoneyForLevelEvent(referer, msg.sender, level, now, refererPart);
438 					}else{
439 						result 		= 	address(uint160(introducer)).send(introducerPart);
440 						emit getIntroducerMoneyForLevelEvent(introducer, msg.sender, level, now, introducerPart);
441 						result 		= 	address(uint160(referer)).send(refererPart);
442 						emit getMoneyForLevelEvent(referer, msg.sender, level, now, refererPart);
443 					}
444 				} else {
445 					emit lostMoneyForLevelEvent(referer, msg.sender, level, now, refererPart);
446 					payForLevel(level,referer);
447 				}
448 			}
449 		}
450     }
451 	
452 	function transferToAdmins(uint amount, address _sender, uint _level) public payable returns(bool) {
453 		
454 		uint firstPart;
455 		uint secondPart;
456 		
457 		firstPart 	=	(amount*70)/100; /* 70% will go to first admin*/
458 		secondPart =	amount-firstPart; /* remaining 30% will go to second admin*/
459 		transferToAdmin1(firstPart, _sender, _level);
460 		transferToAdmin2(secondPart, _sender, _level);
461 		return true;
462 	}
463 	
464 	function transferToAdmin1(uint amount, address _sender, uint _level) public payable returns(bool) {
465 		address admin1;
466 		bool result1;
467 		admin1 = userList[1];
468 		result1 = address(uint160(admin1)).send(amount);
469 		emit getMoneyForLevelEvent(admin1, _sender, _level, now, amount);
470 		return result1;
471 	}
472 	
473 	function transferToAdmin2(uint amount, address _sender, uint _level) public payable returns(bool) {
474 		address admin2;
475 		bool result2;
476 		admin2 = userList[2];
477 		result2 = address(uint160(admin2)).send(amount);
478 		emit getMoneyForLevelEvent(admin2, _sender, _level, now, amount);
479 		return result2;
480 	}
481 	
482 	function transferToAdmin3(uint amount, address _sender, uint _level) public payable returns(bool) {
483 		address admin2;
484 		bool result2;
485 		admin2 = userList[3];
486 		result2 = address(uint160(admin2)).send(amount);
487 		emit getMoneyForLevelEvent(admin2, _sender, _level, now, amount);
488 		return result2;
489 	}
490 
491     function findFreeReferrer(address _user) public view returns(address) {
492         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){
493             return _user;
494         }
495 
496         address[] memory referrals = new address[](363);
497         referrals[0] = users[_user].referral[0]; 
498         referrals[1] = users[_user].referral[1];
499         referrals[2] = users[_user].referral[2];
500 
501         address freeReferrer;
502         bool noFreeReferrer = true;
503 
504         for(uint i =0; i<363;i++){
505             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){
506                 if(i<120){
507                     referrals[(i+1)*3] = users[referrals[i]].referral[0];
508                     referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
509                     referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
510                 }
511             }else{
512                 noFreeReferrer = false;
513                 freeReferrer = referrals[i];
514                 break;
515             }
516         }
517         require(!noFreeReferrer, 'No Free Referrer');
518         return freeReferrer;
519 
520     }
521 
522     function viewUserReferral(address _user) public view returns(address[] memory) {
523         return users[_user].referral;
524     }
525 
526     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
527         return users[_user].levelExpired[_level];
528     }
529     function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
530         assembly {
531             addr := mload(add(bys, 20))
532         }
533     }
534 }