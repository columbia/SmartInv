1 // SPDX-License-Identifier: BSD-3-Clause
2 
3 /** 
4 *                                                                                                                                  
5 *       ##### /                                                             #######      /                                         
6 *    ######  /          #                                                 /       ###  #/                                          
7 *   /#   /  /          ###                                               /         ##  ##                                          
8 *  /    /  /            #                                                ##        #   ##                                          
9 *      /  /                                                               ###          ##                                          
10 *     ## ##           ###        /###    ###  /###         /###          ## ###        ##  /##      /###    ###  /###       /##    
11 *     ## ##            ###      / ###  /  ###/ #### /     / #### /        ### ###      ## / ###    / ###  /  ###/ #### /   / ###   
12 *     ## ##             ##     /   ###/    ##   ###/     ##  ###/           ### ###    ##/   ###  /   ###/    ##   ###/   /   ###  
13 *     ## ##             ##    ##    ##     ##    ##   k ####                  ### /##  ##     ## ##    ##     ##         ##    ### 
14 *     ## ##             ##    ##    ##     ##    ##   a   ###                   #/ /## ##     ## ##    ##     ##         ########  
15 *     #  ##             ##    ##    ##     ##    ##   i     ###                  #/ ## ##     ## ##    ##     ##         #######   
16 *        /              ##    ##    ##     ##    ##   z       ###                 # /  ##     ## ##    ##     ##         ##        
17 *    /##/           /   ##    ##    ##     ##    ##   e  /###  ##       /##        /   ##     ## ##    /#     ##         ####    / 
18 *   /  ############/    ### /  ######      ###   ###  n / #### /       /  ########/    ##     ##  ####/ ##    ###         ######/  
19 *  /     #########       ##/    ####        ###   ### -    ###/       /     #####       ##    ##   ###   ##    ###         #####   
20 *  #                                                  w               |                       /                                    
21 *   ##                                                e                \)                    /                                     
22 *                                                     b                                     /                                      
23 *                                                                                          /                                       
24 *
25 *
26 * Lion's Share is the very first true follow-me matrix smart contract ever created. 
27 * https://www.lionsshare.io
28 * Get your share, join today!
29 */
30 
31 pragma solidity 0.6.8;
32 
33 contract LionShare {
34 
35   struct Account {
36     uint32 id;
37     uint32 directSales;
38     uint8[] activeLevel;
39     bool exists;
40     address sponsor;
41     mapping(uint8 => L1) x31Positions;
42     mapping(uint8 => L2) x22Positions;
43   }
44 
45   struct L1 {
46     uint32 directSales;
47     uint16 cycles;
48     uint8 passup;
49     uint8 reEntryCheck;
50     uint8 placement;
51     address sponsor;
52   }
53 
54   struct L2 {
55     uint32 directSales;
56     uint16 cycles;
57     uint8 passup;
58     uint8 cycle;
59     uint8 reEntryCheck;
60     uint8 placementLastLevel;
61     uint8 placementSide;
62     address sponsor;
63     address placedUnder;
64     address[] placementFirstLevel;
65   }
66 
67   uint internal constant ENTRY_ENABLED = 1;
68   uint internal constant ENTRY_DISABLED = 2;
69   uint public constant REENTRY_REQ = 2;
70 
71   mapping(address => Account) public members;
72   mapping(uint32 => address) public idToMember;
73   mapping(uint8 => uint) public levelCost;
74   
75   uint internal reentry_status;
76   uint32 public lastId;
77   uint8 public topLevel;
78   address internal owner;
79 
80   event Registration(address member, uint memberId, address sponsor);
81   event Upgrade(address member, address sponsor, uint8 matrix, uint8 level);
82   event PlacementL1(address member, address sponsor, uint8 level, uint8 placement, bool passup);  
83   event PlacementL2(address member, address sponsor, uint8 level, uint8 placementSide, address placedUnder, bool passup);
84   event Cycle(address indexed member, address fromPosition, uint8 matrix, uint8 level);
85   event PlacementReEntry(address indexed member, address reEntryFrom, uint8 matrix, uint8 level);
86   event FundsPayout(address indexed member, address payoutFrom, uint8 matrix, uint8 level);
87   event FundsPassup(address indexed member, address passupFrom, uint8 matrix, uint8 level);
88 
89   modifier isOwner(address _account) {
90     require(owner == _account, "Restricted Access!");
91     _;
92   }
93 
94   modifier isMember(address _addr) {
95     require(members[_addr].exists, "Register Account First!");
96     _;
97   }
98   
99   modifier blockReEntry() {
100     require(reentry_status != ENTRY_DISABLED, "Security Block");
101     reentry_status = ENTRY_DISABLED;
102 
103     _;
104 
105     reentry_status = ENTRY_ENABLED;
106   }
107 
108   constructor(address _addr) public {
109     owner = msg.sender;
110 
111     reentry_status = ENTRY_ENABLED;
112 
113     levelCost[1] = 0.02 ether;
114     topLevel = 1;
115 
116     createAccount(_addr, _addr, true);
117     handlePositionL1(_addr, _addr, _addr, 1, true);
118     handlePositionL2(_addr, _addr, _addr, 1, true);
119   }
120 
121   fallback() external payable blockReEntry() {
122     preRegistration(msg.sender, bytesToAddress(msg.data));
123   }
124 
125   receive() external payable blockReEntry() {
126     preRegistration(msg.sender, idToMember[1]);
127   }
128 
129   function registration(address _sponsor) external payable blockReEntry() {
130     preRegistration(msg.sender, _sponsor);
131   }
132 
133   function preRegistration(address _addr, address _sponsor) internal {
134     require((levelCost[1] * 2) == msg.value, "Require .04 eth to register!");
135 
136     createAccount(_addr, _sponsor, false);
137 
138     members[_sponsor].directSales++;
139     
140     handlePositionL1(_addr, _sponsor, _sponsor, 1, false);
141     handlePositionL2(_addr, _sponsor, _sponsor, 1, false);
142     
143     handlePayout(_addr, 0, 1);
144     handlePayout(_addr, 1, 1);
145   }
146   
147   function createAccount(address _addr, address _sponsor, bool _initial) internal {
148     require(!members[_addr].exists, "Already a member!");
149 
150     if (_initial == false) {
151       require(members[_sponsor].exists, "Sponsor dont exist!");
152     }
153 
154     lastId++;    
155 
156     members[_addr] = Account({id: lastId, sponsor: _sponsor, exists: true, directSales: 0, activeLevel: new uint8[](2)});
157     idToMember[lastId] = _addr;
158     
159     emit Registration(_addr, lastId, _sponsor);
160   }
161 
162   function purchaseLevel(uint8 _matrix, uint8 _level) external payable isMember(msg.sender) blockReEntry() {
163     require((_matrix == 1 || _matrix == 2), "Invalid matrix identifier.");
164     require((_level > 0 && _level <= topLevel), "Invalid matrix level.");    
165 
166     uint8 activeLevel = members[msg.sender].activeLevel[(_matrix - 1)];
167     uint8 otherLevel = 1;
168 
169     if (_matrix == 2) {
170       otherLevel = 0;
171     }
172 
173     require((activeLevel < _level), "Already active at level!");
174     require((activeLevel == (_level - 1)), "Level upgrade req. in order!");
175     require(((members[msg.sender].activeLevel[otherLevel] * 2) >= _level), "Double upgrade exeeded.");
176     require((msg.value == levelCost[_level]), "Wrong amount transferred.");
177   
178     address sponsor = members[msg.sender].sponsor;
179     
180     Upgrade(msg.sender, sponsor, _matrix, _level);
181 
182     if (_matrix == 1) {
183       handlePositionL1(msg.sender, sponsor, findActiveSponsor(msg.sender, sponsor, 0, _level, true), _level, false);
184     } else {
185       handlePositionL2(msg.sender, sponsor, findActiveSponsor(msg.sender, sponsor, 1, _level, true), _level, false);
186     }
187 
188     handlePayout(msg.sender, (_matrix - 1), _level);    
189   }
190 
191   function handlePositionL1(address _addr, address _mainSponsor, address _sponsor, uint8 _level, bool _initial) internal {
192     Account storage member = members[_addr];
193 
194     member.activeLevel[0] = _level;
195     member.x31Positions[_level] = L1({sponsor: _sponsor, placement: 0, directSales: 0, cycles: 0, passup: 0, reEntryCheck: 0});
196 
197     if (_initial == true) {
198       return;
199     } else if (_mainSponsor == _sponsor) {
200       members[_mainSponsor].x31Positions[_level].directSales++;
201     } else {
202       member.x31Positions[_level].reEntryCheck = 1;
203     }
204     
205     sponsorPlaceL1(_addr, _sponsor, _level, false);
206   }
207 
208   function sponsorPlaceL1(address _addr, address _sponsor, uint8 _level, bool passup) internal {
209     L1 storage position = members[_sponsor].x31Positions[_level];
210 
211     emit PlacementL1(_addr, _sponsor, _level, (position.placement + 1), passup);
212 
213     if (position.placement >= 2) {
214       emit Cycle(_sponsor, _addr, 1, _level);
215 
216       position.placement = 0;
217       position.cycles++;
218 
219       if (_sponsor != idToMember[1]) {
220         position.passup++;
221 
222         sponsorPlaceL1(_sponsor, position.sponsor, _level, true);
223       }
224     } else {
225       position.placement++;
226     }
227   }
228 
229   function handlePositionL2(address _addr, address _mainSponsor, address _sponsor, uint8 _level, bool _initial) internal {
230     Account storage member = members[_addr];
231     
232     member.activeLevel[1] = _level;
233     member.x22Positions[_level] = L2({sponsor: _sponsor, directSales: 0, cycles: 0, passup: 0, cycle: 0, reEntryCheck: 0, placementSide: 0, placedUnder: _sponsor, placementFirstLevel: new address[](0), placementLastLevel: 0});
234 
235     if (_initial == true) {
236       return;
237     } else if (_mainSponsor == _sponsor) {
238       members[_mainSponsor].x22Positions[_level].directSales++;
239     } else {
240       member.x22Positions[_level].reEntryCheck = 1;
241     }
242 
243     sponsorPlaceL2(_addr, _sponsor, _level, false);
244   }
245 
246   function sponsorPlaceL2(address _addr, address _sponsor, uint8 _level, bool passup) internal {
247     L2 storage member = members[_addr].x22Positions[_level];
248     L2 storage position = members[_sponsor].x22Positions[_level];
249 
250     if (position.placementFirstLevel.length < 2) {
251       if (position.placementFirstLevel.length == 0) {
252         member.placementSide = 1;
253       } else {
254         member.placementSide = 2;
255       }
256       
257       member.placedUnder = _sponsor;
258       position.placementFirstLevel.push(_addr);
259 
260       if (_sponsor != idToMember[1]) {
261         position.passup++;
262       }
263       
264       positionPlaceLastLevelL2(_addr, _sponsor, position.placedUnder, position.placementSide, _level);
265     } else {
266 
267       if (position.placementLastLevel == 0) {
268         member.placementSide = 1;
269         member.placedUnder = position.placementFirstLevel[0];
270         position.placementLastLevel += 1;      
271       } else if ((position.placementLastLevel & 2) == 0) {
272         member.placementSide = 2;
273         member.placedUnder = position.placementFirstLevel[0];
274         position.placementLastLevel += 2;
275       } else if ((position.placementLastLevel & 4) == 0) {
276         member.placementSide = 1;
277         member.placedUnder = position.placementFirstLevel[1];
278         position.placementLastLevel += 4;
279       } else {
280         member.placementSide = 2;
281         member.placedUnder = position.placementFirstLevel[1];
282         position.placementLastLevel += 8;
283       }
284 
285       if (member.placedUnder != idToMember[1]) {
286         members[member.placedUnder].x22Positions[_level].placementFirstLevel.push(_addr);        
287       }
288     }
289 
290     if ((position.placementLastLevel & 15) == 15) {
291       emit Cycle(_sponsor, _addr, 2, _level);
292 
293       position.placementFirstLevel = new address[](0);
294       position.placementLastLevel = 0;
295       position.cycles++;
296 
297       if (_sponsor != idToMember[1]) {
298         position.cycle++;
299 
300         sponsorPlaceL2(_sponsor, position.sponsor, _level, true);
301       }
302     }
303 
304     emit PlacementL2(_addr, _sponsor, _level, member.placementSide, member.placedUnder, passup);
305   }
306 
307   function positionPlaceLastLevelL2(address _addr, address _sponsor, address _position, uint8 _placementSide, uint8 _level) internal {
308     L2 storage position = members[_position].x22Positions[_level];
309 
310     if (position.placementSide == 0 && _sponsor == idToMember[1]) {
311       return;
312     }
313     
314     if (_placementSide == 1) {
315       if ((position.placementLastLevel & 1) == 0) {
316         position.placementLastLevel += 1;
317       } else {
318         position.placementLastLevel += 2;
319       }
320     } else {
321       if ((position.placementLastLevel & 4) == 0) {
322         position.placementLastLevel += 4;
323       } else {
324         position.placementLastLevel += 8;
325       }
326     }
327 
328     if ((position.placementLastLevel & 15) == 15) {
329       emit Cycle(_position, _addr, 2, _level);
330 
331       position.placementFirstLevel = new address[](0);
332       position.placementLastLevel = 0;
333       position.cycles++;
334 
335       if (_position != idToMember[1]) {
336         position.cycle++;
337 
338         sponsorPlaceL2(_position, position.sponsor, _level, true);
339       }
340     }
341   }
342 
343   function findActiveSponsor(address _addr, address _sponsor, uint8 _matrix, uint8 _level, bool _emit) internal returns (address) {
344     address sponsorAddress = _sponsor;
345 
346     while (true) {
347       if (members[sponsorAddress].activeLevel[_matrix] >= _level) {
348         return sponsorAddress;
349       }
350 
351       if (_emit == true) {
352         emit FundsPassup(sponsorAddress, _addr, (_matrix + 1), _level);
353       }
354 
355       sponsorAddress = members[sponsorAddress].sponsor;
356     }
357   }
358 
359   function handleReEntryL1(address _addr, uint8 _level) internal {
360     L1 storage member = members[_addr].x31Positions[_level];
361     bool reentry = false;
362 
363     member.reEntryCheck++;
364 
365     if (member.reEntryCheck >= REENTRY_REQ) {
366       address sponsor = members[_addr].sponsor;
367 
368       if (members[sponsor].activeLevel[0] >= _level) {
369         member.reEntryCheck = 0;
370         reentry = true;
371       } else {
372         sponsor = findActiveSponsor(_addr, sponsor, 0, _level, false);
373 
374         if (member.sponsor != sponsor && members[sponsor].activeLevel[0] >= _level) {        
375           reentry = true;
376         }
377       }
378 
379       if (reentry == true) {
380         member.sponsor = sponsor;
381 
382         emit PlacementReEntry(sponsor, _addr, 1, _level);
383       }
384     }
385   }
386 
387   function handleReEntryL2(address _addr, uint8 _level) internal {
388     L2 storage member = members[_addr].x22Positions[_level];
389     bool reentry = false;
390 
391     member.reEntryCheck++;
392 
393     if (member.reEntryCheck >= REENTRY_REQ) {
394       address sponsor = members[_addr].sponsor;
395 
396       if (members[sponsor].activeLevel[1] >= _level) {
397         member.reEntryCheck = 0;
398         member.sponsor = sponsor;
399         reentry = true;
400       } else {
401         address active_sponsor = findActiveSponsor(_addr, sponsor, 1, _level, false);
402 
403         if (member.sponsor != active_sponsor && members[active_sponsor].activeLevel[1] >= _level) {
404           member.sponsor = active_sponsor;
405           reentry = true;
406         }
407       }
408 
409       if (reentry == true) {
410         emit PlacementReEntry(member.sponsor, _addr, 2, _level);
411       }
412     }
413   }
414 
415   function findPayoutReceiver(address _addr, uint8 _matrix, uint8 _level) internal returns (address) {    
416     address from;
417     address receiver;
418 
419     if (_matrix == 0) {      
420       receiver = members[_addr].x31Positions[_level].sponsor;
421 
422       while (true) {
423         L1 storage member = members[receiver].x31Positions[_level];
424 
425         if (member.passup == 0) {
426           return receiver;
427         }
428 
429         member.passup--;
430         from = receiver;
431         receiver = member.sponsor;
432 
433         if (_level > 1 && member.reEntryCheck > 0) {          
434           handleReEntryL1(from, _level);
435         }
436       }
437     } else {
438       receiver = members[_addr].x22Positions[_level].sponsor;
439 
440       while (true) {
441         L2 storage member = members[receiver].x22Positions[_level];
442 
443         if (member.passup == 0 && member.cycle == 0) {
444           return receiver;
445         }
446 
447         if (member.passup > 0) {
448           member.passup--;
449           receiver = member.placedUnder;
450         } else {
451           member.cycle--;
452           from = receiver;
453           receiver = member.sponsor;  
454 
455           if (_level > 1 && member.reEntryCheck > 0) {
456             handleReEntryL2(from, _level);
457           }
458         }
459       }
460     }
461   }
462 
463   function handlePayout(address _addr, uint8 _matrix, uint8 _level) internal {
464     address receiver = findPayoutReceiver(_addr, _matrix, _level);
465 
466     emit FundsPayout(receiver, _addr, (_matrix + 1), _level);
467 
468     (bool success, ) = address(uint160(receiver)).call{ value: levelCost[_level], gas: 40000 }("");
469 
470     if (success == false) { //Failsafe to prevent malicious contracts from blocking matrix
471       (success, ) = address(uint160(idToMember[1])).call{ value: levelCost[_level], gas: 40000 }("");
472       require(success, 'Transfer Failed');
473     }
474   }
475 
476   function getAffiliateId() external view returns (uint) {
477     return members[msg.sender].id;
478   }
479 
480   function getAffiliateWallet(uint32 memberId) external view returns (address) {
481     return idToMember[memberId];
482   }
483 
484   function setupAccount(address _addr, address _sponsor, uint8 _level) external isOwner(msg.sender) {
485     createAccount(_addr, _sponsor, false);
486     compLevel(_addr, 1, _level);
487     compLevel(_addr, 2, _level);
488   }
489 
490   function compLevel(address _addr, uint8 _matrix, uint8 _level) public isOwner(msg.sender) isMember(_addr) {
491     require((_matrix == 1 || _matrix == 2), "Invalid matrix identifier.");
492     require((_level > 0 && _level <= topLevel), "Invalid matrix level.");
493 
494     uint8 matrix = _matrix - 1;
495     uint8 activeLevel = members[_addr].activeLevel[matrix];
496     address sponsor = members[_addr].sponsor;
497 
498     require((activeLevel < _level), "Already active at level!");
499 
500     for (uint8 num = (activeLevel + 1);num <= _level;num++) {
501       Upgrade(_addr, sponsor, _matrix, num);
502 
503       if (matrix == 0) {
504         handlePositionL1(_addr, sponsor, findActiveSponsor(_addr, sponsor, 0, num, true), num, false);
505       } else {
506         handlePositionL2(_addr, sponsor, findActiveSponsor(_addr, sponsor, 1, num, true), num, false);
507       }
508     }
509   }
510 
511   function addLevel(uint _levelPrice) external isOwner(msg.sender) {
512     require((levelCost[topLevel] < _levelPrice), "Check price point!");
513 
514     topLevel++;
515 
516     levelCost[topLevel] = _levelPrice;
517 
518     handlePositionL1(idToMember[1], idToMember[1], idToMember[1], topLevel, true);
519     handlePositionL2(idToMember[1], idToMember[1], idToMember[1], topLevel, true);
520   }
521 
522   function updateLevelCost(uint8 _level, uint _levelPrice) external isOwner(msg.sender) {
523     require((_level > 0 && _level <= topLevel), "Invalid matrix level.");
524     require((_levelPrice > 0), "Check price point!");
525 
526     if (_level > 1) {
527       require((levelCost[(_level - 1)] < _levelPrice), "Check price point!");
528     }
529 
530     if (_level < topLevel) {
531       require((levelCost[(_level + 1)] > _levelPrice), "Check price point!");
532     }
533 
534     levelCost[_level] = _levelPrice;
535   }
536 
537   function bytesToAddress(bytes memory _source) private pure returns (address addr) {
538     assembly {
539       addr := mload(add(_source, 20))
540     }
541   }
542 }