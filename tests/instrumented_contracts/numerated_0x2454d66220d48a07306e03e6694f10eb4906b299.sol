1 pragma solidity >=0.4.23 <0.6.0;
2 
3 contract DoradoWorld{
4     struct User {
5         uint id;
6         address referrer;
7         uint partnersCount;
8         
9         mapping(uint8 => bool) activeD3Levels;
10         mapping(uint8 => bool) activeD4Levels;
11         
12         mapping(uint8 => D3) D3Matrix;
13         mapping(uint8 => D4) D4Matrix;
14         mapping(uint8 => D5) D5Matrix;
15     }
16     struct D5 {
17          uint[] D5No;
18     }
19     struct D3 {
20         address currentReferrer;
21         address[] referrals;
22         bool blocked;
23         uint reinvestCount;
24     }
25     struct D4 {
26         address currentReferrer;
27         address[] firstLevelReferrals;
28         address[] secondLevelReferrals;
29         bool blocked;
30         uint reinvestCount;
31 
32         address closedPart;
33     }
34     
35     uint8[15] private D3ReEntry = [
36        0,1,0,2,3,3,3,1,3,3,3,3,3,3,3
37     ];
38     
39     uint8[15] private D4ReEntry = [
40        0,0,0,1,3,3,3,1,1,3,3,3,3,3,3
41     ];
42     
43     uint[3] private D5LevelPrice = [
44         0.05 ether,
45         0.80 ether,
46         3.00 ether
47     ];
48     
49     uint8 public constant LAST_LEVEL = 15;
50     mapping(address => User) public users;
51     mapping(uint => address) public idToAddress;
52     mapping(uint => address) public userIds;
53     mapping(address => uint) public balances; 
54     mapping(uint8 => uint[]) private L5Matrix;
55     uint public lastUserId = 2;
56     address public owner;
57     
58     mapping(uint8 => uint) public levelPrice;
59 
60     
61     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
62     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
63     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
64     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint256 place);
65     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
66     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
67     
68     event NewD5Matrix(uint newid, uint benid, bool reentry);
69     event Reentry(uint newid, uint benid);
70     event D5NewId(uint newid, uint topid, uint botid,uint8 position,uint numcount);
71     event payout(uint indexed benid,address indexed receiver,uint indexed dividend,uint8 matrix);
72     event payoutblock(address receiver,uint reentry);
73     event Testor(string str,uint8 level,uint place);
74    
75     
76     constructor(address ownerAddress) public {
77         levelPrice[1] = 0.025 ether;
78         for (uint8 i = 2; i <= 10; i++) {
79             levelPrice[i] = levelPrice[i-1] * 2;
80         }
81         
82         levelPrice[11] = 25 ether;
83         levelPrice[12] = 50 ether;
84         levelPrice[13] = 60 ether;
85         levelPrice[14] = 70 ether;
86         levelPrice[15] = 100 ether;
87         
88         owner = ownerAddress;
89         User memory user = User({
90             id: 1,
91             referrer: address(0),
92             partnersCount: uint(0)
93         });
94         
95         users[ownerAddress] = user;
96         idToAddress[1] = ownerAddress;
97         
98         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
99             users[ownerAddress].activeD3Levels[i] = true;
100             users[ownerAddress].activeD4Levels[i] = true;
101         }
102         
103         userIds[1] = ownerAddress;
104         for (uint8 i = 1; i <= 3; i++) {
105             users[ownerAddress].D5Matrix[i].D5No.push(1);
106             L5Matrix[i].push(1);
107             
108         }
109        
110         
111             /*L5Matrix[1][1] = 1;
112         
113         users[ownerAddress].D5Matrix[2].D5No.push(1);
114             L5Matrix[2][1] = 1;
115             
116         users[ownerAddress].D5Matrix[3].D5No.push(1);
117             
118     
119         */
120 
121     }
122     
123     function() external payable {
124         if(msg.data.length == 0) {
125             return registration(msg.sender, owner);
126         }
127         
128         registration(msg.sender, bytesToAddress(msg.data));
129     }
130 
131     function registrationExt(address referrerAddress) external payable {
132        registration(msg.sender, referrerAddress);
133     }
134     
135     function buyNewLevel(uint8 matrix, uint8 level) external payable {
136         require(isUserExists(msg.sender), "user is not exists. Register first.");
137         require(matrix == 1 || matrix == 2, "invalid matrix");
138         require(msg.value == levelPrice[level], "invalid price");
139         require(level > 1 && level <= LAST_LEVEL, "invalid level");
140 
141         if (matrix == 1) {
142             require(!users[msg.sender].activeD3Levels[level], "level already activated");
143 
144             if (users[msg.sender].D3Matrix[level-1].blocked) {
145                 users[msg.sender].D3Matrix[level-1].blocked = false;
146             }
147     
148             address freeD3Referrer = findFreeD3Referrer(msg.sender, level);
149             users[msg.sender].D3Matrix[level].currentReferrer = freeD3Referrer;
150             users[msg.sender].activeD3Levels[level] = true;
151             updateD3Referrer(msg.sender, freeD3Referrer, level);
152             
153             emit Upgrade(msg.sender, freeD3Referrer, 1, level);
154 
155         } else {
156             require(!users[msg.sender].activeD4Levels[level], "level already activated"); 
157 
158             if (users[msg.sender].D4Matrix[level-1].blocked) {
159                 users[msg.sender].D4Matrix[level-1].blocked = false;
160             }
161 
162             address freeD4Referrer = findFreeD4Referrer(msg.sender, level);
163             
164             users[msg.sender].activeD4Levels[level] = true;
165             updateD4Referrer(msg.sender, freeD4Referrer, level);
166             
167             emit Upgrade(msg.sender, freeD4Referrer, 2, level);
168         }
169     }    
170     
171     function registration(address userAddress, address referrerAddress) private {
172         require(msg.value == 0.05 ether, "registration cost 0.05");
173         require(!isUserExists(userAddress), "user exists");
174         require(isUserExists(referrerAddress), "referrer not exists");
175         
176         uint32 size;
177         assembly {
178             size := extcodesize(userAddress)
179         }
180         require(size == 0, "cannot be a contract");
181         
182         User memory user = User({
183             id: lastUserId,
184             referrer: referrerAddress,
185             partnersCount: 0
186         });
187         
188         users[userAddress] = user;
189         idToAddress[lastUserId] = userAddress;
190         
191         users[userAddress].referrer = referrerAddress;
192         
193         users[userAddress].activeD3Levels[1] = true; 
194         users[userAddress].activeD4Levels[1] = true;
195         
196         
197         userIds[lastUserId] = userAddress;
198         lastUserId++;
199         
200         users[referrerAddress].partnersCount++;
201 
202         address freeD3Referrer = findFreeD3Referrer(userAddress, 1);
203         users[userAddress].D3Matrix[1].currentReferrer = freeD3Referrer;
204         updateD3Referrer(userAddress, freeD3Referrer, 1);
205 
206         updateD4Referrer(userAddress, findFreeD4Referrer(userAddress, 1), 1);
207         
208         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
209     }
210     
211     function d5martixstructure(uint newid) private pure returns(uint,bool){
212 	
213 		uint8 matrix = 5;
214 		uint benid = 0;
215 		bool flag = true;
216 		uint numcount =1;
217 		uint topid = 0;
218 		uint botid = 0;
219 		uint8 position = 0;
220 		uint8 d5level = 1;
221 	    bool reentry= false;
222 
223 		while(flag){
224 
225 		topid = setUpperLine5(newid,d5level);
226 		position = 0;
227         
228 			if(topid > 0){
229 			    botid = setDownlineLimit5(topid,d5level);
230 			    
231 				if(d5level == 6){
232 					benid = topid;
233 					flag = false;
234 				}else{
235 				    //emit D5NewId(newid,topid,botid,position,numcount);
236 					if(newid == botid){
237 						position = 1;
238 					}else{
239 					   
240 			    
241 						for (uint8 i = 1; i <= matrix; i++) {
242 				
243 							if(newid < (botid + (numcount * i))){
244 								position = i;
245 								i = matrix;
246 							}
247 						}
248 						
249 					}
250 		            
251 					if((position == 2) || (position == 4)){
252 						benid = topid;
253 						flag = false;
254 					}
255 				}
256 				
257 
258 				d5level += 1;
259 			numcount = numcount * 5;
260 			}else{
261 				benid =0;
262 				flag = false;
263 			}
264 			
265 			
266 		}
267 		d5level -= 1;
268 		if(benid > 0){
269 		    //emit D5NewId(newid, topid, botid,d5level,numcount);
270 		    if((d5level == 3) || (d5level == 4) || (d5level == 5)){
271 		        numcount = numcount / 5;
272 		        if(((botid + numcount) + 15) >= newid){
273 				    reentry = true;
274 				}
275 				    
276 		    }
277 				
278 		    if((d5level == 6) && ((botid + 15) >= newid)){
279 				reentry = true;
280 	    	}
281 		}
282 		if(benid == 0){
283 		    benid =1;
284 		}
285         return (benid,reentry);
286 
287 }
288      
289     function setUpperLine5(uint TrefId,uint8 level) internal pure returns(uint){
290     	for (uint8 i = 1; i <= level; i++) {
291     		if(TrefId == 1){
292         		TrefId = 0;
293     		}else if(TrefId == 0){
294         		TrefId = 0;
295     		}else if((1 < TrefId) && (TrefId < 7)){
296         		TrefId = 1;
297 			}else{
298 				TrefId -= 1;
299 				if((TrefId % 5) > 0){
300 				TrefId = uint(TrefId / 5);
301 				TrefId += 1;
302 				}else{
303 				TrefId = uint(TrefId / 5);  
304 				}
305 				
306 			}	
307     	}
308     	return TrefId;
309     }
310     
311     function setDownlineLimit5(uint TrefId,uint8 level) internal pure returns(uint){
312     	uint8 ded = 1;
313 		uint8 add = 2;
314     	for (uint8 i = 1; i < level; i++) {
315     		ded *= 5;
316 			add += ded;
317 		}
318 		ded *= 5;
319 		TrefId = ((ded * TrefId) - ded) + add;
320     	return TrefId;
321     }
322     
323     function updateD5Referrer(address userAddress, uint8 level) private {
324         uint newid = uint(L5Matrix[level].length);
325         newid = newid + 1;
326         users[userAddress].D5Matrix[level].D5No.push(newid);
327         L5Matrix[level].push(users[userAddress].id);
328         (uint benid, bool reentry) = d5martixstructure(newid);
329         emit NewD5Matrix(newid,benid,reentry);
330         if(reentry){
331             emit Reentry(newid,benid);
332             updateD5Referrer(idToAddress[L5Matrix[level][benid]],level);
333          }else{
334             emit payout(benid,idToAddress[L5Matrix[level][benid]],D5LevelPrice[level-1],level + 2);
335             return sendETHD5(idToAddress[L5Matrix[level][benid]],D5LevelPrice[level-1]);
336            // emit payout(benid,idToAddress[L5Matrix[level][benid]],D5LevelPrice[level]);
337         }
338         
339     }
340     
341     function updateD3Referrer(address userAddress, address referrerAddress,uint8 level) private {
342        // emit Testor(users[referrerAddress].D3Matrix[level].referrals.length);
343         users[referrerAddress].D3Matrix[level].referrals.push(userAddress);
344        //  emit Testor(users[referrerAddress].D3Matrix[level].referrals.length);
345        // uint256 referrals = users[referrerAddress].D3Matrix[level].referrals.length;
346         uint reentry = users[referrerAddress].D3Matrix[level].reinvestCount;
347        //uint reentry =0;
348       
349        
350         if (users[referrerAddress].D3Matrix[level].referrals.length < 3) {
351         	
352             emit NewUserPlace(userAddress, referrerAddress, 1, level,users[referrerAddress].D3Matrix[level].referrals.length);
353            
354             uint8 autolevel  = 1;
355             uint8 flag  = 0;
356             uint numcount;
357             if(level == 2){
358             	if((reentry == 0) && (users[referrerAddress].D3Matrix[level].referrals.length == 1)){
359             		flag  = 1;
360             		numcount = 1;
361             	}
362         	}else if(level > 3){
363         	    if(level > 7){
364         	        autolevel = 2;
365         	    }
366         	   if((level == 6) && (reentry == 0) && (users[referrerAddress].D3Matrix[level].referrals.length == 1)){
367         	        flag  = 1;
368             	    numcount = 1;
369             	    autolevel = 2;
370         	   }
371         	   if((level == 8) && (reentry == 0) && (users[referrerAddress].D3Matrix[level].referrals.length == 1)){
372         	        flag  = 1;
373             	    numcount = 1;
374             	    autolevel = 3;
375         	   }
376             	if(reentry >= 1){
377             		flag  = 1;
378             		numcount = D3ReEntry[level-1];
379             	}
380             
381             }
382         	
383             if(flag == 1){
384         		uint dividend = uint(levelPrice[level] - (D5LevelPrice[autolevel-1] * numcount));
385         		for (uint8 i = 1; i <= numcount; i++) {
386         			updateD5Referrer(referrerAddress,autolevel);
387         		}
388         		emit payout(2,referrerAddress,dividend,1);
389         		return sendETHDividendsRemain(referrerAddress, userAddress, 1, level,dividend);
390         	//emit payout(users[referrerAddress].D3Matrix[level].referrals.length,referrerAddress,dividend);
391         	}else{
392         	    emit payout(1,referrerAddress,levelPrice[level],1);
393             	return sendETHDividends(referrerAddress, userAddress, 1, level);
394             //	emit payout(users[referrerAddress].D3Matrix[level].referrals.length,referrerAddress,levelPrice[level]);
395             }
396         
397             //return sendETHDividends(referrerAddress, userAddress, 1, level);
398             
399         }
400         
401          //close matrix
402         users[referrerAddress].D3Matrix[level].referrals = new address[](0);
403         if (!users[referrerAddress].activeD3Levels[level+1] && level != LAST_LEVEL) {
404             if(reentry >= 1){
405         		users[referrerAddress].D3Matrix[level].blocked = true;
406         	//	emit payout(1,referrerAddress,levelPrice[level]);
407         	emit payoutblock(referrerAddress,reentry);
408         	}
409         }
410 
411         //create new one by recursion
412         if (referrerAddress != owner) {
413             //check referrer active level
414             address freeReferrerAddress = findFreeD3Referrer(referrerAddress, level);
415             if (users[referrerAddress].D3Matrix[level].currentReferrer != freeReferrerAddress) {
416                 users[referrerAddress].D3Matrix[level].currentReferrer = freeReferrerAddress;
417             }
418             
419             users[referrerAddress].D3Matrix[level].reinvestCount++;
420            // emit NewUserPlace(userAddress, referrerAddress, 1, level,3);
421             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
422             
423            
424             updateD3Referrer(referrerAddress, freeReferrerAddress, level);
425         } else {
426             sendETHDividends(owner, userAddress, 1, level);
427      		users[owner].D3Matrix[level].reinvestCount++;
428      	//	emit NewUserPlace(userAddress,owner, 1, level,3);
429             emit Reinvest(owner, address(0), userAddress, 1, level);
430         }
431     }
432     
433     function updateD4Referrer(address userAddress, address referrerAddress, uint8 level) private {
434         require(users[referrerAddress].activeD4Levels[level], "500. Referrer level is inactive");
435         
436         if (users[referrerAddress].D4Matrix[level].firstLevelReferrals.length < 2) {
437             users[referrerAddress].D4Matrix[level].firstLevelReferrals.push(userAddress);
438             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].D4Matrix[level].firstLevelReferrals.length));
439             
440             //set current level
441             users[userAddress].D4Matrix[level].currentReferrer = referrerAddress;
442 
443             if (referrerAddress == owner) {
444                 return sendETHDividends(referrerAddress, userAddress, 2, level);
445             }
446             
447             address ref = users[referrerAddress].D4Matrix[level].currentReferrer;            
448             users[ref].D4Matrix[level].secondLevelReferrals.push(userAddress); 
449             
450             uint len = users[ref].D4Matrix[level].firstLevelReferrals.length;
451             
452             if ((len == 2) && 
453                 (users[ref].D4Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
454                 (users[ref].D4Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
455                 if (users[referrerAddress].D4Matrix[level].firstLevelReferrals.length == 1) {
456                     emit NewUserPlace(userAddress, ref, 2, level, 5);
457                 } else {
458                     emit NewUserPlace(userAddress, ref, 2, level, 6);
459                 }
460             }  else if ((len == 1 || len == 2) &&
461                     users[ref].D4Matrix[level].firstLevelReferrals[0] == referrerAddress) {
462                 if (users[referrerAddress].D4Matrix[level].firstLevelReferrals.length == 1) {
463                     emit NewUserPlace(userAddress, ref, 2, level, 3);
464                 } else {
465                     emit NewUserPlace(userAddress, ref, 2, level, 4);
466                 }
467             } else if (len == 2 && users[ref].D4Matrix[level].firstLevelReferrals[1] == referrerAddress) {
468                 if (users[referrerAddress].D4Matrix[level].firstLevelReferrals.length == 1) {
469                     emit NewUserPlace(userAddress, ref, 2, level, 5);
470                 } else {
471                     emit NewUserPlace(userAddress, ref, 2, level, 6);
472                 }
473             }
474 
475             return updateD4ReferrerSecondLevel(userAddress, ref, level);
476         }
477         
478         users[referrerAddress].D4Matrix[level].secondLevelReferrals.push(userAddress);
479 
480         if (users[referrerAddress].D4Matrix[level].closedPart != address(0)) {
481             if ((users[referrerAddress].D4Matrix[level].firstLevelReferrals[0] == 
482                 users[referrerAddress].D4Matrix[level].firstLevelReferrals[1]) &&
483                 (users[referrerAddress].D4Matrix[level].firstLevelReferrals[0] ==
484                 users[referrerAddress].D4Matrix[level].closedPart)) {
485 
486                 updateD4(userAddress, referrerAddress, level, true);
487                 return updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);
488             } else if (users[referrerAddress].D4Matrix[level].firstLevelReferrals[0] == 
489                 users[referrerAddress].D4Matrix[level].closedPart) {
490                 updateD4(userAddress, referrerAddress, level, true);
491                 return updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);
492             } else {
493                 updateD4(userAddress, referrerAddress, level, false);
494                 return updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);
495             }
496         }
497 
498         if (users[referrerAddress].D4Matrix[level].firstLevelReferrals[1] == userAddress) {
499             updateD4(userAddress, referrerAddress, level, false);
500             return updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);
501         } else if (users[referrerAddress].D4Matrix[level].firstLevelReferrals[0] == userAddress) {
502             updateD4(userAddress, referrerAddress, level, true);
503             return updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);
504         }
505         
506         if (users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[0]].D4Matrix[level].firstLevelReferrals.length <= 
507             users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[1]].D4Matrix[level].firstLevelReferrals.length) {
508             updateD4(userAddress, referrerAddress, level, false);
509         } else {
510             updateD4(userAddress, referrerAddress, level, true);
511         }
512         
513         updateD4ReferrerSecondLevel(userAddress, referrerAddress, level);
514     }
515 
516     function updateD4(address userAddress, address referrerAddress, uint8 level, bool x2) private {
517         if (!x2) {
518             users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[0]].D4Matrix[level].firstLevelReferrals.push(userAddress);
519             emit NewUserPlace(userAddress, users[referrerAddress].D4Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[0]].D4Matrix[level].firstLevelReferrals.length));
520             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[0]].D4Matrix[level].firstLevelReferrals.length));
521             //set current level
522             users[userAddress].D4Matrix[level].currentReferrer = users[referrerAddress].D4Matrix[level].firstLevelReferrals[0];
523         } else {
524             users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[1]].D4Matrix[level].firstLevelReferrals.push(userAddress);
525             emit NewUserPlace(userAddress, users[referrerAddress].D4Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[1]].D4Matrix[level].firstLevelReferrals.length));
526             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].D4Matrix[level].firstLevelReferrals[1]].D4Matrix[level].firstLevelReferrals.length));
527             //set current level
528             users[userAddress].D4Matrix[level].currentReferrer = users[referrerAddress].D4Matrix[level].firstLevelReferrals[1];
529         }
530     }
531     
532     function updateD4ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
533         
534         if (users[referrerAddress].D4Matrix[level].secondLevelReferrals.length < 4) {
535           //  uint8 jlevel = level;
536         	
537         	if(level > 3){
538         	    uint numcount = D4ReEntry[level-1];
539         	    
540             	uint8 autolevel  = 1;
541             	if(level > 7){
542             	    autolevel  = 2;
543             	}
544             	uint dividend = uint(levelPrice[level] - (D5LevelPrice[autolevel - 1] * numcount));
545             	
546         		for (uint8 i = 1; i <= numcount; i++) {
547         		    updateD5Referrer(referrerAddress,autolevel);
548         		}
549         	    emit payout(2,referrerAddress,dividend,2);
550         		return sendETHDividendsRemain(referrerAddress, userAddress, 2, level,dividend);
551         	}else{
552         	    emit payout(1,referrerAddress,levelPrice[level],2);
553                 return sendETHDividends(referrerAddress, userAddress, 2, level);
554             }
555           }
556         
557         address[] memory D4data = users[users[referrerAddress].D4Matrix[level].currentReferrer].D4Matrix[level].firstLevelReferrals;
558         
559         if (D4data.length == 2) {
560             if (D4data[0] == referrerAddress ||
561                 D4data[1] == referrerAddress) {
562                 users[users[referrerAddress].D4Matrix[level].currentReferrer].D4Matrix[level].closedPart = referrerAddress;
563             } else if (D4data.length == 1) {
564                 if (D4data[0] == referrerAddress) {
565                     users[users[referrerAddress].D4Matrix[level].currentReferrer].D4Matrix[level].closedPart = referrerAddress;
566                 }
567             }
568         }
569         
570         users[referrerAddress].D4Matrix[level].firstLevelReferrals = new address[](0);
571         users[referrerAddress].D4Matrix[level].secondLevelReferrals = new address[](0);
572         users[referrerAddress].D4Matrix[level].closedPart = address(0);
573         
574         if (!users[referrerAddress].activeD4Levels[level+1] && level != LAST_LEVEL) {
575             if(users[referrerAddress].D4Matrix[level].reinvestCount >= 1){
576         		users[referrerAddress].D4Matrix[level].blocked = true;
577         	    emit payoutblock(referrerAddress,users[referrerAddress].D4Matrix[level].reinvestCount);
578         	}
579         }
580 
581         users[referrerAddress].D4Matrix[level].reinvestCount++;
582         
583         
584         if (referrerAddress != owner) {
585             address freeReferrerAddress = findFreeD4Referrer(referrerAddress, level);
586            // emit NewUserPlace(userAddress, referrerAddress, 2, level,6);
587             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
588             updateD4Referrer(referrerAddress, freeReferrerAddress, level);
589         } else {
590           //  emit NewUserPlace(userAddress,owner, 2, level,6);
591             emit Reinvest(owner, address(0), userAddress, 2, level);
592             sendETHDividends(owner, userAddress, 2, level);
593         }
594     }
595     
596     function findFreeD3Referrer(address userAddress, uint8 level) public view returns(address) {
597         while (true) {
598             if (users[users[userAddress].referrer].activeD3Levels[level]) {
599                 return users[userAddress].referrer;
600             }
601             
602             userAddress = users[userAddress].referrer;
603         }
604     }
605     
606     function findFreeD4Referrer(address userAddress, uint8 level) public view returns(address) {
607         while (true) {
608             if (users[users[userAddress].referrer].activeD4Levels[level]) {
609                 return users[userAddress].referrer;
610             }
611             
612             userAddress = users[userAddress].referrer;
613         }
614     }
615         
616     function usersActiveD3Levels(address userAddress, uint8 level) public view returns(bool) {
617         return users[userAddress].activeD3Levels[level];
618     }
619 
620     function usersActiveD4Levels(address userAddress, uint8 level) public view returns(bool) {
621         return users[userAddress].activeD4Levels[level];
622     }
623 
624     function usersD3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
625         return (users[userAddress].D3Matrix[level].currentReferrer,
626                 users[userAddress].D3Matrix[level].referrals,
627                 users[userAddress].D3Matrix[level].blocked);
628     }
629 
630     function usersD4Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
631         return (users[userAddress].D4Matrix[level].currentReferrer,
632                 users[userAddress].D4Matrix[level].firstLevelReferrals,
633                 users[userAddress].D4Matrix[level].secondLevelReferrals,
634                 users[userAddress].D4Matrix[level].blocked,
635                 users[userAddress].D4Matrix[level].closedPart);
636     }
637     
638     function usersD5Matrix(address userAddress, uint8 level) public view returns(uint, uint[] memory) {
639         return (L5Matrix[level].length,users[userAddress].D5Matrix[level].D5No);
640     }
641     
642     function isUserExists(address user) public view returns (bool) {
643         return (users[user].id != 0);
644     }
645 
646     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
647         address receiver = userAddress;
648         bool isExtraDividends;
649         if (matrix == 1) {
650             while (true) {
651                 if (users[receiver].D3Matrix[level].blocked) {
652                     emit MissedEthReceive(receiver, _from, 1, level);
653                     isExtraDividends = true;
654                     receiver = users[receiver].D3Matrix[level].currentReferrer;
655                 } else {
656                     return (receiver, isExtraDividends);
657                 }
658             }
659         } else {
660             while (true) {
661                 if (users[receiver].D4Matrix[level].blocked) {
662                     emit MissedEthReceive(receiver, _from, 2, level);
663                     isExtraDividends = true;
664                     receiver = users[receiver].D4Matrix[level].currentReferrer;
665                 } else {
666                     return (receiver, isExtraDividends);
667                 }
668             }
669         }
670     }
671 
672     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
673         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
674 
675         if (!address(uint160(receiver)).send(levelPrice[level])) {
676             return address(uint160(receiver)).transfer(address(this).balance);
677         }
678         
679         if (isExtraDividends) {
680             emit SentExtraEthDividends(_from, receiver, matrix, level);
681         }
682     }
683     
684     function sendETHDividendsRemain(address userAddress, address _from, uint8 matrix, uint8 level,uint dividend) private {
685         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
686 
687         if (!address(uint160(receiver)).send(dividend)) {
688             return address(uint160(receiver)).transfer(address(this).balance);
689         }
690         
691         if (isExtraDividends) {
692             emit SentExtraEthDividends(_from, receiver, matrix, level);
693         }
694     }
695     
696     function sendETHD5(address receiver,uint dividend) private {
697         
698         if (!address(uint160(receiver)).send(dividend)) {
699             return address(uint160(receiver)).transfer(address(this).balance);
700         }
701         
702     }
703     
704     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
705         assembly {
706             addr := mload(add(bys, 20))
707         }
708     }
709 }