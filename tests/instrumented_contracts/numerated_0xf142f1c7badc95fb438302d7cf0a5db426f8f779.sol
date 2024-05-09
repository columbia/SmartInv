1 pragma solidity ^0.4.21;
2 contract TripioToken {
3     function transfer(address _to, uint256 _value) public returns (bool);
4     function balanceOf(address who) public view returns (uint256);
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
6 }
7 /**
8  * Owned contract
9  */
10 contract Owned {
11     address public owner;
12     address public newOwner;
13 
14     event OwnershipTransferred(address indexed from, address indexed to);
15 
16     function Owned() public {
17         owner = msg.sender;
18     }
19 
20     /**
21      * Only the owner of contract
22      */ 
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     /**
29      * transfer the ownership to other
30      * - Only the owner can operate
31      */ 
32     function transferOwnership(address _newOwner) public onlyOwner {
33         newOwner = _newOwner;
34     }
35 
36     /** 
37      * Accept the ownership from last owner
38      */ 
39     function acceptOwnership() public {
40         require(msg.sender == newOwner);
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43         newOwner = address(0);
44     }
45 }
46 contract TPTData {
47     address public trioContract;
48 
49     struct Contributor {
50         uint256 next;
51         uint256 prev;
52         uint256 cid;
53         address contributor;
54         bytes32 name;
55     }
56     
57     struct ContributorChain {
58         uint256 balance;
59         uint256 head;
60         uint256 tail;
61         uint256 index;
62         mapping(uint256 => Contributor) nodes; // cid -> Contributor
63     }
64 
65     struct Schedule {
66         uint256 next;
67         uint256 prev;
68         uint256 sid;
69         uint32 timestamp;
70         uint256 trio;
71     }
72 
73     struct ScheduleChain {
74         uint256 balance;
75         uint256 head;
76         uint256 tail;
77         uint256 index;
78         mapping (uint256 => Schedule) nodes;
79     }
80 
81     // The contributors chain
82     ContributorChain contributorChain;
83 
84     // The schedules chains
85     mapping (uint256 => ScheduleChain) scheduleChains;
86 
87     /**
88      * The contributor is valid
89      */
90     modifier contributorValid(uint256 _cid) {
91         require(contributorChain.nodes[_cid].cid == _cid);
92         _;
93     }
94 
95     /**
96      * The schedule is valid
97      */
98     modifier scheduleValid(uint256 _cid, uint256 _sid) {
99         require(scheduleChains[_cid].nodes[_sid].sid == _sid);
100         _;
101     }
102 }
103 contract TPTContributors is TPTData, Owned {
104     function TPTContributors() public {
105         
106     }
107 
108     /**
109      * This emits when contributors are added
110      */
111     event ContributorsAdded(address[] indexed _contributors);
112 
113     /**
114      * This emits when contributors are removed
115      */
116     event ContributorsRemoved(uint256[] indexed _cids);
117 
118 
119     /**
120      * Record `_contributor`
121      */
122     function _pushContributor(address _contributor, bytes32 _name) internal {
123         require(_contributor != address(0));
124         uint256 prev = 0;
125         uint256 cid = contributorChain.index + 1;
126         if (contributorChain.balance == 0) {
127             contributorChain = ContributorChain(1, cid, cid, cid);
128             contributorChain.nodes[cid] = Contributor(0, 0, cid, _contributor, _name);
129         } else {
130             contributorChain.index = cid;
131             prev = contributorChain.tail;
132             contributorChain.balance++;
133 
134             contributorChain.nodes[cid] = Contributor(0, prev, cid, _contributor, _name);
135             contributorChain.nodes[prev].next = cid;
136             contributorChain.tail = cid;
137         }
138     }
139 
140     /**
141      * Remove contributor by `_cid`
142      */
143     function _removeContributor(uint _cid) internal contributorValid(_cid) {
144         require(_cid != 0);
145         uint256 next = 0;
146         uint256 prev = 0;
147         require(contributorChain.nodes[_cid].cid == _cid);
148         next = contributorChain.nodes[_cid].next;
149         prev = contributorChain.nodes[_cid].prev;
150         if (next == 0) {
151             if(prev != 0) {
152                 contributorChain.nodes[prev].next = 0;
153                 delete contributorChain.nodes[_cid];
154                 contributorChain.tail = prev;
155             }else {
156                 delete contributorChain.nodes[_cid];
157                 delete contributorChain;
158             }
159         } else {
160             if (prev == 0) {
161                 contributorChain.head = next;
162                 contributorChain.nodes[next].prev = 0;
163                 delete contributorChain.nodes[_cid];
164             } else {
165                 contributorChain.nodes[prev].next = next;
166                 contributorChain.nodes[next].prev = prev;
167                 delete contributorChain.nodes[_cid];
168             }
169         }
170         if(contributorChain.balance > 0) {
171             contributorChain.balance--;
172         }
173     }
174 
175     /**
176      * Record `_contributors`
177      * @param _contributors The contributor
178      */
179     function addContributors(address[] _contributors, bytes32[] _names) external onlyOwner {
180         require(_contributors.length == _names.length && _contributors.length > 0);
181         for(uint256 i = 0; i < _contributors.length; i++) {
182             _pushContributor(_contributors[i], _names[i]);
183         }
184 
185         // Event
186         emit ContributorsAdded(_contributors);
187     }
188 
189     /**
190      * Remove contributor by `_cids`
191      * @param _cids The contributor's ids
192      */
193     function removeContributors(uint256[] _cids) external onlyOwner {
194         for(uint256 i = 0; i < _cids.length; i++) {
195             _removeContributor(_cids[i]);
196         }
197 
198         // Event
199         emit ContributorsRemoved(_cids);
200     }
201 
202     /**
203      * Returns all the contributors
204      * @return All the contributors
205      */
206     function contributors() public view returns(uint256[]) {
207         uint256 count;
208         uint256 index;
209         uint256 next;
210         index = 0;
211         next = contributorChain.head;
212         count = contributorChain.balance;
213         if (count > 0) {
214             uint256[] memory result = new uint256[](count);
215             while(next != 0 && index < count) {
216                 result[index] = contributorChain.nodes[next].cid;
217                 next = contributorChain.nodes[next].next;
218                 index++;
219             }
220             return result;
221         } else {
222             return new uint256[](0);
223         }
224     }
225 
226     /**
227      * Return the contributor by `_cid`
228      * @return The contributor
229      */
230     function contributor(uint _cid) external view returns(address, bytes32) {
231         return (contributorChain.nodes[_cid].contributor, contributorChain.nodes[_cid].name);
232     }  
233 }
234 contract TPTSchedules is TPTData, Owned {
235     function TPTSchedules() public {
236         
237     }
238 
239     /**
240      * This emits when schedules are inserted
241      */
242     event SchedulesInserted(uint256 _cid);
243 
244     /**
245      * This emits when schedules are removed
246      */
247     event SchedulesRemoved(uint _cid, uint256[] _sids);
248 
249     /**
250      * Record TRIO transfer schedule to  `_contributor`
251      * @param _cid The contributor
252      * @param _timestamps The transfer timestamps
253      * @param _trios The transfer trios
254      */
255     function insertSchedules(uint256 _cid, uint32[] _timestamps, uint256[] _trios) 
256         external 
257         onlyOwner 
258         contributorValid(_cid) {
259         require(_timestamps.length > 0 && _timestamps.length == _trios.length);
260         for (uint256 i = 0; i < _timestamps.length; i++) {
261             uint256 prev = 0;
262             uint256 next = 0;
263             uint256 sid = scheduleChains[_cid].index + 1;
264             if (scheduleChains[_cid].balance == 0) {
265                 scheduleChains[_cid] = ScheduleChain(1, sid, sid, sid);
266                 scheduleChains[_cid].nodes[sid] = Schedule(0, 0, sid, _timestamps[i], _trios[i]);
267             } else {
268                 scheduleChains[_cid].index = sid;
269                 scheduleChains[_cid].balance++;
270                 prev = scheduleChains[_cid].tail;
271                 while(scheduleChains[_cid].nodes[prev].timestamp > _timestamps[i] && prev != 0) {
272                     prev = scheduleChains[_cid].nodes[prev].prev;
273                 }
274                 if (prev == 0) {
275                     next = scheduleChains[_cid].head;
276                     scheduleChains[_cid].nodes[sid] = Schedule(next, 0, sid, _timestamps[i], _trios[i]);
277                     scheduleChains[_cid].nodes[next].prev = sid;
278                     scheduleChains[_cid].head = sid;
279                 } else {
280                     next = scheduleChains[_cid].nodes[prev].next;
281                     scheduleChains[_cid].nodes[sid] = Schedule(next, prev, sid, _timestamps[i], _trios[i]);
282                     scheduleChains[_cid].nodes[prev].next = sid;
283                     if (next == 0) {
284                         scheduleChains[_cid].tail = sid;
285                     }else {
286                         scheduleChains[_cid].nodes[next].prev = sid;
287                     }
288                 }
289             }
290         }
291 
292         // Event
293         emit SchedulesInserted(_cid);
294     }
295 
296     /**
297      * Remove schedule by `_cid` and `_sids`
298      * @param _cid The contributor's id
299      * @param _sids The schedule's ids
300      */
301     function removeSchedules(uint _cid, uint256[] _sids) 
302         public 
303         onlyOwner 
304         contributorValid(_cid) {
305         uint256 next = 0;
306         uint256 prev = 0;
307         uint256 sid;
308         for (uint256 i = 0; i < _sids.length; i++) {
309             sid = _sids[i];
310             require(scheduleChains[_cid].nodes[sid].sid == sid);
311             next = scheduleChains[_cid].nodes[sid].next;
312             prev = scheduleChains[_cid].nodes[sid].prev;
313             if (next == 0) {
314                 if(prev != 0) {
315                     scheduleChains[_cid].nodes[prev].next = 0;
316                     delete scheduleChains[_cid].nodes[sid];
317                     scheduleChains[_cid].tail = prev;
318                 }else {
319                     delete scheduleChains[_cid].nodes[sid];
320                     delete scheduleChains[_cid];
321                 }
322             } else {
323                 if (prev == 0) {
324                     scheduleChains[_cid].head = next;
325                     scheduleChains[_cid].nodes[next].prev = 0;
326                     delete scheduleChains[_cid].nodes[sid];
327                 } else {
328                     scheduleChains[_cid].nodes[prev].next = next;
329                     scheduleChains[_cid].nodes[next].prev = prev;
330                     delete scheduleChains[_cid].nodes[sid];
331                 }
332             }
333             if(scheduleChains[_cid].balance > 0) {
334                 scheduleChains[_cid].balance--;
335             }   
336         }
337 
338         // Event
339         emit SchedulesRemoved(_cid, _sids);
340     }
341 
342     /**
343      * Return all the schedules of `_cid`
344      * @param _cid The contributor's id 
345      * @return All the schedules of `_cid`
346      */
347     function schedules(uint256 _cid) 
348         public 
349         contributorValid(_cid) 
350         view 
351         returns(uint256[]) {
352         uint256 count;
353         uint256 index;
354         uint256 next;
355         index = 0;
356         next = scheduleChains[_cid].head;
357         count = scheduleChains[_cid].balance;
358         if (count > 0) {
359             uint256[] memory result = new uint256[](count);
360             while(next != 0 && index < count) {
361                 result[index] = scheduleChains[_cid].nodes[next].sid;
362                 next = scheduleChains[_cid].nodes[next].next;
363                 index++;
364             }
365             return result;
366         } else {
367             return new uint256[](0);
368         }
369     }
370 
371     /**
372      * Return the schedule by `_cid` and `_sid`
373      * @param _cid The contributor's id
374      * @param _sid The schedule's id
375      * @return The schedule
376      */
377     function schedule(uint256 _cid, uint256 _sid) 
378         public
379         scheduleValid(_cid, _sid) 
380         view 
381         returns(uint32, uint256) {
382         return (scheduleChains[_cid].nodes[_sid].timestamp, scheduleChains[_cid].nodes[_sid].trio);
383     }
384 }
385 contract TPTTransfer is TPTContributors, TPTSchedules {
386     function TPTTransfer() public {
387         
388     }
389 
390     /**
391      * This emits when transfer 
392      */
393     event AutoTransfer(address indexed _to, uint256 _trio);
394 
395     /**
396      * This emits when 
397      */
398     event AutoTransferCompleted();
399 
400     /**
401      * Withdraw TRIO TOKEN balance from contract account, the balance will transfer to the contract owner
402      */
403     function withdrawToken() external onlyOwner {
404         TripioToken tripio = TripioToken(trioContract);
405         uint256 tokens = tripio.balanceOf(address(this));
406         tripio.transfer(owner, tokens);
407     }
408 
409     /**
410      * Auto Transfer All Schedules
411      */
412     function autoTransfer() external onlyOwner {
413         // TRIO contract
414         TripioToken tripio = TripioToken(trioContract);
415         
416         // All contributors
417         uint256[] memory _contributors = contributors();
418         for (uint256 i = 0; i < _contributors.length; i++) {
419             // cid and contributor address
420             uint256 _cid = _contributors[i];
421             address _contributor = contributorChain.nodes[_cid].contributor;
422             
423             // All schedules
424             uint256[] memory _schedules = schedules(_cid);
425             for (uint256 j = 0; j < _schedules.length; j++) {
426                 // sid, trio and timestamp
427                 uint256 _sid = _schedules[j];
428                 uint256 _trio = scheduleChains[_cid].nodes[_sid].trio;
429                 uint256 _timestamp = scheduleChains[_cid].nodes[_sid].timestamp;
430 
431                 // hasn't arrived
432                 if(_timestamp > now) {
433                     break;
434                 }
435                 // Transfer TRIO to contributor
436                 tripio.transfer(_contributor, _trio);
437 
438                 // Remove schedule of contributor
439                 uint256[] memory _sids = new uint256[](1);
440                 _sids[0] = _sid;
441                 removeSchedules(_cid, _sids);
442                 emit AutoTransfer(_contributor, _trio);
443             }
444         }
445 
446         emit AutoTransferCompleted();
447     }
448 
449     /**
450      * Is there any transfer in schedule
451      */
452     function totalTransfersInSchedule() external view returns(uint256,uint256) {
453         // All contributors
454         uint256[] memory _contributors = contributors();
455         uint256 total = 0;
456         uint256 amount = 0;
457         for (uint256 i = 0; i < _contributors.length; i++) {
458             // cid and contributor address
459             uint256 _cid = _contributors[i];            
460             // All schedules
461             uint256[] memory _schedules = schedules(_cid);
462             for (uint256 j = 0; j < _schedules.length; j++) {
463                 // sid, trio and timestamp
464                 uint256 _sid = _schedules[j];
465                 uint256 _timestamp = scheduleChains[_cid].nodes[_sid].timestamp;
466                 if(_timestamp < now) {
467                     total++;
468                     amount += scheduleChains[_cid].nodes[_sid].trio;
469                 }
470             }
471         }
472         return (total,amount);
473     }
474 }
475 
476 contract TrioPeriodicTransfer is TPTTransfer {
477     function TrioPeriodicTransfer(address _trio) public {
478         trioContract = _trio;
479     }
480 }