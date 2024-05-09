1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 interface itoken {
92     // mapping (address => bool) public frozenAccount;
93     function freezeAccount(address _target, bool _freeze) external;
94     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
95     function balanceOf(address _owner) external view returns (uint256 balance);
96     function transferOwnership(address newOwner) external;
97     function allowance(address _owner, address _spender) external view returns (uint256);
98 }
99 
100 contract OwnerContract is Ownable {
101     itoken public owned;
102     
103     /**
104      * @dev bind a contract as its owner
105      *
106      * @param _contract the contract address that will be binded by this Owner Contract
107      */
108     function setContract(address _contract) public onlyOwner {
109         require(_contract != address(0));
110         owned = itoken(_contract);
111     }
112 
113     /**
114      * @dev change the owner of the contract from this contract to another 
115      *
116      * @param _newOwner the new contract/account address that will be the new owner
117      */
118     function changeContractOwner(address _newOwner) public onlyOwner returns(bool) {
119         require(_newOwner != address(0));
120         owned.transferOwnership(_newOwner);
121         owned = itoken(address(0));
122         
123         return true;
124     }
125 }
126 
127 contract ReleaseToken is OwnerContract {
128     using SafeMath for uint256;
129 
130     // record lock time period and related token amount
131     struct TimeRec {
132         uint256 amount;
133         uint256 remain;
134         uint256 endTime;
135         uint256 duration;
136     }
137 
138     address[] public frozenAccounts;
139     mapping (address => TimeRec[]) frozenTimes;
140     // mapping (address => uint256) releasedAmounts;
141     mapping (address => uint256) preReleaseAmounts;
142 
143     event ReleaseFunds(address _target, uint256 _amount);
144 
145     function removeAccount(uint _ind) internal returns (bool) {
146         require(_ind >= 0);
147         require(_ind < frozenAccounts.length);
148 
149         //if (_ind >= frozenAccounts.length) {
150         //    return false;
151         //}
152 
153         uint256 i = _ind;
154         while (i < frozenAccounts.length.sub(1)) {
155             frozenAccounts[i] = frozenAccounts[i.add(1)];
156             i = i.add(1);
157         }
158 
159         frozenAccounts.length = frozenAccounts.length.sub(1);
160         return true;
161     }
162 
163     function removeLockedTime(address _target, uint _ind) internal returns (bool) {
164         require(_ind >= 0);
165         require(_target != address(0));
166 
167         TimeRec[] storage lockedTimes = frozenTimes[_target];
168         require(_ind < lockedTimes.length);
169         //if (_ind >= lockedTimes.length) {
170         //    return false;
171         //}
172 
173         uint256 i = _ind;
174         while (i < lockedTimes.length.sub(1)) {
175             lockedTimes[i] = lockedTimes[i.add(1)];
176             i = i.add(1);
177         }
178 
179         lockedTimes.length = lockedTimes.length.sub(1);
180         return true;
181     }
182 
183     /**
184      * @dev get total remain locked tokens of an account
185      *
186      * @param _account the owner of some amount of tokens
187      */
188     function getRemainLockedOf(address _account) public view returns (uint256) {
189         require(_account != address(0));
190 
191         uint256 totalRemain = 0;
192         uint256 len = frozenAccounts.length;
193         uint256 i = 0;
194         while (i < len) {
195             address frozenAddr = frozenAccounts[i];
196             if (frozenAddr == _account) {
197                 uint256 timeRecLen = frozenTimes[frozenAddr].length;
198                 uint256 j = 0;
199                 while (j < timeRecLen) {
200                     TimeRec storage timePair = frozenTimes[frozenAddr][j];
201                     totalRemain = totalRemain.add(timePair.remain);
202 
203                     j = j.add(1);
204                 }
205             }
206 
207             i = i.add(1);
208         }
209 
210         return totalRemain;
211     }
212 
213     /**
214      * judge whether we need to release some of the locked token
215      *
216      */
217     function needRelease() public view returns (bool) {
218         uint256 len = frozenAccounts.length;
219         uint256 i = 0;
220         while (i < len) {
221             address frozenAddr = frozenAccounts[i];
222             uint256 timeRecLen = frozenTimes[frozenAddr].length;
223             uint256 j = 0;
224             while (j < timeRecLen) {
225                 TimeRec storage timePair = frozenTimes[frozenAddr][j];
226                 if (now >= timePair.endTime) {
227                     return true;
228                 }
229 
230                 j = j.add(1);
231             }
232 
233             i = i.add(1);
234         }
235 
236         return false;
237     }
238 
239     /**
240      * @dev freeze the amount of tokens of an account
241      *
242      * @param _target the owner of some amount of tokens
243      * @param _value the amount of the tokens
244      * @param _frozenEndTime the end time of the lock period, unit is second
245      * @param _releasePeriod the locking period, unit is second
246      */
247     function freeze(address _target, uint256 _value, uint256 _frozenEndTime, uint256 _releasePeriod) onlyOwner public returns (bool) {
248         //require(_tokenAddr != address(0));
249         require(_target != address(0));
250         require(_value > 0);
251         require(_frozenEndTime > 0 && _releasePeriod >= 0);
252 
253         uint256 len = frozenAccounts.length;
254         
255         for (uint256 i = 0; i < len; i = i.add(1)) {
256             if (frozenAccounts[i] == _target) {
257                 break;
258             }            
259         }
260 
261         if (i >= len) {
262             frozenAccounts.push(_target); // add new account
263 
264             //frozenTimes[_target].push(TimeRec(_value, _value, _frozenEndTime, _releasePeriod))
265         } /* else {
266             uint256 timeArrayLen = frozenTimes[_target].length;
267             uint256 j = 0;
268             while (j < timeArrayLen) {
269                 TimeRec storage lastTime = frozenTimes[_target][j];
270                 if (lastTime.amount == 0 && lastTime.remain == 0 && lastTime.endTime == 0 && lastTime.duration == 0) {
271                     lastTime.amount = _value;
272                     lastTime.remain = _value;
273                     lastTime.endTime = _frozenEndTime;
274                     lastTime.duration = _releasePeriod; 
275                     
276                     break;
277                 }
278 
279                 j = j.add(1);
280             }
281             
282             if (j >= timeArrayLen) {
283                 frozenTimes[_target].push(TimeRec(_value, _value, _frozenEndTime, _releasePeriod));
284             }
285         } */
286 
287         // frozenTimes[_target] = _frozenEndTime;
288         
289         // each time the new locked time will be added to the backend
290         frozenTimes[_target].push(TimeRec(_value, _value, _frozenEndTime, _releasePeriod));
291         owned.freezeAccount(_target, true);
292         
293         return true;
294     }
295 
296     /**
297      * @dev transfer an amount of tokens to an account, and then freeze the tokens
298      *
299      * @param _target the account address that will hold an amount of the tokens
300      * @param _value the amount of the tokens which has been transferred
301      * @param _frozenEndTime the end time of the lock period, unit is second
302      * @param _releasePeriod the locking period, unit is second
303      */
304     function transferAndFreeze(/*address _tokenOwner, */address _target, uint256 _value, uint256 _frozenEndTime, uint256 _releasePeriod) onlyOwner public returns (bool) {
305         //require(_tokenOwner != address(0));
306         require(_target != address(0));
307         require(_value > 0);
308         require(_frozenEndTime > 0 && _releasePeriod >= 0);
309 
310         // check firstly that the allowance of this contract has been set
311         assert(owned.allowance(msg.sender, this) > 0);
312 
313         // freeze the account at first
314         if (!freeze(_target, _value, _frozenEndTime, _releasePeriod)) {
315             return false;
316         }
317 
318         return (owned.transferFrom(msg.sender, _target, _value));
319     }
320 
321     /**
322      * release the token which are locked for once and will be total released at once 
323      * after the end point of the lock period
324      */
325     function releaseAllOnceLock() onlyOwner public returns (bool) {
326         //require(_tokenAddr != address(0));
327 
328         uint256 len = frozenAccounts.length;
329         uint256 i = 0;
330         while (i < len) {
331             address target = frozenAccounts[i];
332             if (frozenTimes[target].length == 1 && 0 == frozenTimes[target][0].duration && frozenTimes[target][0].endTime > 0 && now >= frozenTimes[target][0].endTime) {
333                 bool res = removeAccount(i);
334                 if (!res) {
335                     return false;
336                 }
337                 
338                 owned.freezeAccount(target, false);
339                 //frozenTimes[destAddr][0].endTime = 0;
340                 //frozenTimes[destAddr][0].duration = 0;
341                 ReleaseFunds(target, frozenTimes[target][0].amount);
342                 len = len.sub(1);
343                 //frozenTimes[destAddr][0].amount = 0;
344                 //frozenTimes[destAddr][0].remain = 0;
345             } else { 
346                 // no account has been removed
347                 i = i.add(1);
348             }
349         }
350         
351         return true;
352         //return (releaseMultiAccounts(frozenAccounts));
353     }
354 
355     /**
356      * @dev release the locked tokens owned by an account, which only have only one locked time
357      * and don't have release stage.
358      *
359      * @param _target the account address that hold an amount of locked tokens
360      */
361     function releaseAccount(address _target) onlyOwner public returns (bool) {
362         //require(_tokenAddr != address(0));
363         require(_target != address(0));
364 
365         uint256 len = frozenAccounts.length;
366         uint256 i = 0;
367         while (i < len) {
368             address destAddr = frozenAccounts[i];
369             if (destAddr == _target) {
370                 if (frozenTimes[destAddr].length == 1 && 0 == frozenTimes[destAddr][0].duration && frozenTimes[destAddr][0].endTime > 0 && now >= frozenTimes[destAddr][0].endTime) { 
371                     bool res = removeAccount(i);
372                     if (!res) {
373                         return false;
374                     }
375 
376                     owned.freezeAccount(destAddr, false);
377                     // frozenTimes[destAddr][0].endTime = 0;
378                     // frozenTimes[destAddr][0].duration = 0;
379                     ReleaseFunds(destAddr, frozenTimes[destAddr][0].amount);
380                     // frozenTimes[destAddr][0].amount = 0;
381                     // frozenTimes[destAddr][0].remain = 0;
382 
383                 }
384 
385                 // if the account are not locked for once, we will do nothing here
386                 return true; 
387             }
388 
389             i = i.add(1);
390         }
391         
392         return false;
393     }
394 
395     /**
396      * @dev release the locked tokens owned by a number of accounts
397      *
398      * @param _targets the accounts list that hold an amount of locked tokens 
399      */
400     function releaseMultiAccounts(address[] _targets) onlyOwner public returns (bool) {
401         //require(_tokenAddr != address(0));
402         require(_targets.length != 0);
403 
404         uint256 i = 0;
405         while (i < _targets.length) {
406             if (!releaseAccount(_targets[i])) {
407                 return false;
408             }
409 
410             i = i.add(1);
411         }
412 
413         return true;
414     }
415 
416     /**
417      * @dev release the locked tokens owned by an account with several stages
418      * this need the contract get approval from the account by call approve() in the token contract
419      *
420      * @param _target the account address that hold an amount of locked tokens
421      * @param _dest the secondary address that will hold the released tokens
422      */
423     function releaseWithStage(address _target, address _dest) onlyOwner public returns (bool) {
424         //require(_tokenAddr != address(0));
425         require(_target != address(0));
426         require(_dest != address(0));
427         // require(_value > 0);
428         
429         // check firstly that the allowance of this contract from _target account has been set
430         assert(owned.allowance(_target, this) > 0);
431 
432         uint256 len = frozenAccounts.length;
433         uint256 i = 0;
434         while (i < len) {
435             // firstly find the target address
436             address frozenAddr = frozenAccounts[i];
437             if (frozenAddr == _target) {
438                 uint256 timeRecLen = frozenTimes[frozenAddr].length;
439 
440                 bool released = false;
441                 for (uint256 j = 0; j < timeRecLen; released = false) {
442                     // iterate every time records to caculate how many tokens need to be released.
443                     TimeRec storage timePair = frozenTimes[frozenAddr][j];
444                     uint256 nowTime = now;
445                     if (nowTime > timePair.endTime && timePair.endTime > 0 && timePair.duration > 0) {                        
446                         uint256 value = timePair.amount * (nowTime - timePair.endTime) / timePair.duration;
447                         if (value > timePair.remain) {
448                             value = timePair.remain;
449                         } 
450                         
451                         // owned.freezeAccount(frozenAddr, false);
452                         
453                         timePair.endTime = nowTime;        
454                         timePair.remain = timePair.remain.sub(value);
455                         if (timePair.remain < 1e8) {
456                             if (!removeLockedTime(frozenAddr, j)) {
457                                 return false;
458                             }
459                             released = true;
460                             timeRecLen = timeRecLen.sub(1);
461                         }
462                         // if (!owned.transferFrom(_target, _dest, value)) {
463                         //     return false;
464                         // }
465                         ReleaseFunds(frozenAddr, value);
466                         preReleaseAmounts[frozenAddr] = preReleaseAmounts[frozenAddr].add(value);
467                         //owned.freezeAccount(frozenAddr, true);
468                     } else if (nowTime >= timePair.endTime && timePair.endTime > 0 && timePair.duration == 0) {
469                         // owned.freezeAccount(frozenAddr, false);
470                         
471                         if (!removeLockedTime(frozenAddr, j)) {
472                             return false;
473                         }
474                         released = true;
475                         timeRecLen = timeRecLen.sub(1);
476 
477                         // if (!owned.transferFrom(_target, _dest, timePair.amount)) {
478                         //     return false;
479                         // }
480                         ReleaseFunds(frozenAddr, timePair.amount);
481                         preReleaseAmounts[frozenAddr] = preReleaseAmounts[frozenAddr].add(timePair.amount);
482                         //owned.freezeAccount(frozenAddr, true);
483                     } //else if (timePair.amount == 0 && timePair.remain == 0 && timePair.endTime == 0 && timePair.duration == 0) {
484                       //  removeLockedTime(frozenAddr, j);
485                     //}
486 
487                     if (!released) {
488                         j = j.add(1);
489                     }
490                 }
491 
492                 // we got some amount need to be released
493                 if (preReleaseAmounts[frozenAddr] > 0) {
494                     owned.freezeAccount(frozenAddr, false);
495                     if (!owned.transferFrom(_target, _dest, preReleaseAmounts[frozenAddr])) {
496                         return false;
497                     }
498                 }
499 
500                 // if all the frozen amounts had been released, then unlock the account finally
501                 if (frozenTimes[frozenAddr].length == 0) {
502                     if (!removeAccount(i)) {
503                         return false;
504                     }                    
505                 } else {
506                     // still has some tokens need to be released in future
507                     owned.freezeAccount(frozenAddr, true);
508                 }
509 
510                 return true;
511             }          
512 
513             i = i.add(1);
514         }
515         
516         return false;
517     }
518 
519     /**
520      * @dev release the locked tokens owned by an account
521      *
522      * @param _targets the account addresses list that hold amounts of locked tokens
523      * @param _dests the secondary addresses list that will hold the released tokens for each target account
524      */
525     function releaseMultiWithStage(address[] _targets, address[] _dests) onlyOwner public returns (bool) {
526         //require(_tokenAddr != address(0));
527         require(_targets.length != 0);
528         require(_dests.length != 0);
529         assert(_targets.length == _dests.length);
530 
531         uint256 i = 0;
532         while (i < _targets.length) {
533             if (!releaseWithStage(_targets[i], _dests[i])) {
534                 return false;
535             }
536 
537             i = i.add(1);
538         }
539 
540         return true;
541     }
542 }