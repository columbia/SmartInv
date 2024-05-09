1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    * @notice Renouncing to ownership will leave the contract without an owner.
88    * It will not be possible to call the functions with the `onlyOwner`
89    * modifier anymore.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address _newOwner) public onlyOwner {
101     _transferOwnership(_newOwner);
102   }
103 
104   /**
105    * @dev Transfers control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function _transferOwnership(address _newOwner) internal {
109     require(_newOwner != address(0));
110     emit OwnershipTransferred(owner, _newOwner);
111     owner = _newOwner;
112   }
113 }
114 
115 contract ReentrancyGuard {
116 
117   /**
118    * @dev We use a single lock for the whole contract.
119    */
120   bool private reentrancyLock = false;
121 
122   /**
123    * @dev Prevents a contract from calling itself, directly or indirectly.
124    * @notice If you mark a function `nonReentrant`, you should also
125    * mark it `external`. Calling one nonReentrant function from
126    * another is not supported. Instead, you can implement a
127    * `private` function doing the actual work, and a `external`
128    * wrapper marked as `nonReentrant`.
129    */
130   modifier nonReentrant() {
131     require(!reentrancyLock);
132     reentrancyLock = true;
133     _;
134     reentrancyLock = false;
135   }
136 
137 }
138 
139 contract WillAlwaysLove is Ownable, ReentrancyGuard {
140     using SafeMath for uint256;
141 
142     // ------------------------------------------------------------
143 
144     uint256 public constant DEFAULT_INITIAL_COST = 0.025 ether;
145     uint256 public constant DEFAULT_LOCK_COST_PER_HOUR = 0.0006 ether; // 10 szabo per minute
146     uint256 public constant DEFAULT_MAX_LOCK_DURATION = 1 weeks;
147 
148     uint256 public constant DEVELOPER_CUT = 25; // %
149 
150     // ------------------------------------------------------------
151 
152     struct LoveStory {
153         address owner;
154         bytes32 loverName;
155         bytes32 lovedOneName;
156         uint256 transferCost;
157         uint256 lockedUntil;
158         string data;
159     }
160 
161     // ------------------------------------------------------------
162 
163     uint256 public initialCost;
164     uint256 public lockCostPerHour;
165     uint256 public maxLockDuration;
166 
167     mapping(bytes16 => LoveStory) private loveStories;
168     uint256 public loveStoriesCount;
169 
170     mapping (address => uint256) private pendingWithdrawals;
171 
172     // ------------------------------------------------------------
173 
174     event LoveStoryCreated(
175         bytes16 id,
176         address owner,
177         bytes32 loverName,
178         bytes32 lovedOneName,
179         uint256 transferCost,
180         uint256 lockedUntil,
181         string data
182     );
183 
184     event LoveStoryUpdated(
185         bytes16 id,
186         bytes32 loverName,
187         bytes32 lovedOneName,
188         string data
189     );
190 
191     event LoveStoryTransferred(
192         bytes16 id,
193         address oldOwner,
194         address newOwner,
195         bytes32 newLoverName,
196         bytes32 newLovedOneName,
197         uint256 newtransferCost,
198         uint256 lockedUntil,
199         string data
200     );
201 
202     event Withdrawal(
203         address withdrawer,
204         uint256 amount
205     );
206 
207     // ------------------------------------------------------------
208 
209     modifier onlyForUnregisteredId(bytes16 _id) {
210         require(!isIdRegistered(_id));
211         _;
212     }
213 
214     modifier onlyForRegisteredId(bytes16 _id) {
215         require(isIdRegistered(_id));
216         _;
217     }
218 
219     modifier onlyForValidId(bytes16 _id) {
220         require(isIdValid(_id));
221         _;
222     }
223 
224     modifier onlyWithPendingWithdrawal() {
225         require(withdrawableAmount() != 0);
226         _;
227     }
228 
229     modifier onlyLoveStoryOwner(bytes16 _id) {
230         require(loveStories[_id].owner == msg.sender);
231         _;
232     }
233 
234     // ------------------------------------------------------------
235 
236     constructor ()
237         public
238     {
239         initialCost = DEFAULT_INITIAL_COST;
240         lockCostPerHour = DEFAULT_LOCK_COST_PER_HOUR;
241         maxLockDuration = DEFAULT_MAX_LOCK_DURATION;
242     }
243 
244     function ()
245         public
246         payable
247     {
248     }
249 
250     function createCost(uint256 _lockDurationInHours)
251         public
252         view
253         returns (uint256)
254     {
255         return initialCost.add(lockCostPerHour.mul(_lockDurationInHours));
256     }
257 
258     function createLoveStory(bytes16 _id, bytes32 _loverName, bytes32 _lovedOneName, uint256 _lockDurationInHours)
259         public
260         payable
261     {
262         createLoveStoryWithData(_id, _loverName, _lovedOneName, _lockDurationInHours, "");
263     }
264 
265     function createLoveStoryWithData(bytes16 _id, bytes32 _loverName, bytes32 _lovedOneName, uint256 _lockDurationInHours, string _data)
266         public
267         payable
268         onlyForValidId(_id)
269         onlyForUnregisteredId(_id)
270     {
271         require(msg.value >= createCost(_lockDurationInHours));
272 
273         _updateLoveStory(_id, _loverName, _lovedOneName, _lockDurationInHours, _data);
274         loveStoriesCount = loveStoriesCount.add(1);
275 
276         pendingWithdrawals[owner] = pendingWithdrawals[owner].add(msg.value);
277 
278         LoveStory storage _loveStory = loveStories[_id];
279 
280         emit LoveStoryCreated (
281             _id,
282             _loveStory.owner,
283             _loveStory.loverName,
284             _loveStory.lovedOneName,
285             _loveStory.transferCost,
286             _loveStory.lockedUntil,
287             _loveStory.data
288         );
289     }
290 
291     function updateLoveStory(bytes16 _id, bytes32 _loverName, bytes32 _lovedOneName)
292         public
293         onlyLoveStoryOwner(_id)
294     {
295         LoveStory storage _loveStory = loveStories[_id];
296 
297         _loveStory.loverName = _loverName;
298         _loveStory.lovedOneName = _lovedOneName;
299 
300         emit LoveStoryUpdated (
301             _id,
302             _loveStory.loverName,
303             _loveStory.lovedOneName,
304             _loveStory.data
305         );
306     }
307 
308     function updateLoveStoryWithData(bytes16 _id, bytes32 _loverName, bytes32 _lovedOneName, string _data)
309         public
310         onlyLoveStoryOwner(_id)
311     {
312         LoveStory storage _loveStory = loveStories[_id];
313 
314         _loveStory.loverName = _loverName;
315         _loveStory.lovedOneName = _lovedOneName;
316         _loveStory.data = _data;
317 
318         emit LoveStoryUpdated (
319             _id,
320             _loveStory.loverName,
321             _loveStory.lovedOneName,
322             _loveStory.data
323         );
324     }
325 
326     function transferCost(bytes16 _id, uint256 _lockDurationInHours)
327         public
328         view
329         onlyForValidId(_id)
330         onlyForRegisteredId(_id)
331         returns (uint256)
332     {
333         return loveStories[_id].transferCost.add(lockCostPerHour.mul(_lockDurationInHours));
334     }
335 
336     function transferLoveStory(bytes16 _id, bytes32 _loverName, bytes32 _lovedOneName, uint256 _lockDurationInHours)
337         public
338         payable
339         onlyForValidId(_id)
340         onlyForRegisteredId(_id)
341     {
342         LoveStory storage _loveStory = loveStories[_id];
343         transferLoveStoryWithData(_id, _loverName, _lovedOneName, _lockDurationInHours, _loveStory.data);
344     }
345 
346     function transferLoveStoryWithData(bytes16 _id, bytes32 _loverName, bytes32 _lovedOneName, uint256 _lockDurationInHours, string _data)
347         public
348         payable
349         onlyForValidId(_id)
350         onlyForRegisteredId(_id)
351     {
352         LoveStory storage _loveStory = loveStories[_id];
353         address _oldOwner = _loveStory.owner;
354 
355         require(_oldOwner != msg.sender);
356         require(msg.value >= transferCost(_id, _lockDurationInHours));
357         require(now >= _loveStory.lockedUntil);
358 
359         _updateLoveStory(_id, _loverName, _lovedOneName, _lockDurationInHours, _data);
360 
361         uint256 _developerPayment = msg.value.mul(DEVELOPER_CUT).div(100);
362         uint256 _oldOwnerPayment = msg.value.sub(_developerPayment);
363 
364         require(msg.value == _developerPayment.add(_oldOwnerPayment));
365 
366         pendingWithdrawals[owner] = pendingWithdrawals[owner].add(_developerPayment);
367         pendingWithdrawals[_oldOwner] = pendingWithdrawals[_oldOwner].add(_oldOwnerPayment);
368 
369         emit LoveStoryTransferred (
370             _id,
371             _oldOwner,
372             _loveStory.owner,
373             _loveStory.loverName,
374             _loveStory.lovedOneName,
375             _loveStory.transferCost,
376             _loveStory.lockedUntil,
377             _loveStory.data
378         );
379     }
380 
381     function readLoveStory(bytes16 _id)
382         public
383         view
384         returns (address _loveStoryOwner, bytes32 _loverName, bytes32 _lovedOneName, uint256 _transferCost, uint256 _lockedUntil, string _data)
385     {
386         LoveStory storage _loveStory = loveStories[_id];
387 
388         _loveStoryOwner = _loveStory.owner;
389         _loverName = _loveStory.loverName;
390         _lovedOneName = _loveStory.lovedOneName;
391         _transferCost = _loveStory.transferCost;
392         _lockedUntil = _loveStory.lockedUntil;
393         _data = _loveStory.data;
394     }
395 
396     function isIdRegistered(bytes16 _id)
397         public
398         view
399         returns (bool)
400     {
401         return loveStories[_id].owner != 0x0;
402     }
403 
404     function isIdValid(bytes16 _id)
405         public
406         pure
407         returns (bool)
408     {
409         for (uint256 i = 0; i < 16; i = i.add(1))
410         {
411             if (i == 0)
412             {
413                 // First char must be between 'a' and 'z'. It CAN'T be NULL.
414                 if ( ! _isLowercaseLetter(_id[i]) )
415                 {
416                     return false;
417                 }
418             }
419             else if (i == 15)
420             {
421                 // Last char must between 'a' and 'z'. It can also be a terminating NULL.
422                 if ( !(_isLowercaseLetter(_id[i]) || _id[i] == 0) )
423                 {
424                     return false;
425                 }
426             }
427             else
428             {
429                 // In-between chars must between 'a' and 'z' or '-'. Otherwise, they should be the unset bytes.
430                 // The last part is verifiied by requiring that an in-bewteen char that is NULL
431                 // must *also* be follwed by a NULL.
432                 if ( !(_isLowercaseLetter(_id[i]) || (_id[i] == 0x2D && _id[i+1] != 0) || (_id[i] == _id[i+1] && _id[i] == 0)) )
433                 {
434                     return false;
435                 }
436             }
437         }
438 
439         return true;
440     }
441 
442     function withdrawableAmount()
443         public
444         view
445         returns (uint256)
446     {
447         return pendingWithdrawals[msg.sender];
448     }
449 
450     function withdraw()
451         external
452         nonReentrant
453         onlyWithPendingWithdrawal
454     {
455         uint256 amount = pendingWithdrawals[msg.sender];
456 
457         pendingWithdrawals[msg.sender] = 0;
458 
459         msg.sender.transfer(amount);
460 
461         emit Withdrawal (
462             msg.sender,
463             amount
464         );
465     }
466 
467     function withdrawableAmountFor(address _withdrawer)
468         public
469         view
470         onlyOwner
471         returns (uint256)
472     {
473         return pendingWithdrawals[_withdrawer];
474     }
475 
476     function changeInitialCost(uint256 _initialCost)
477         external
478         onlyOwner
479     {
480         initialCost = _initialCost;
481     }
482 
483     function changeLockCostPerHour(uint256 _lockCostPerHour)
484         external
485         onlyOwner
486     {
487         lockCostPerHour = _lockCostPerHour;
488     }
489 
490     function changeMaxLockDuration(uint256 _maxLockDuration)
491         external
492         onlyOwner
493     {
494         maxLockDuration = _maxLockDuration;
495     }
496 
497     // ------------------------------------------------------------
498 
499     function _updateLoveStory(bytes16 _id, bytes32 _loverName, bytes32 _lovedOneName, uint256 _lockDurationInHours, string _data)
500         private
501     {
502         require(_lockDurationInHours * 1 hours <= maxLockDuration);
503 
504         LoveStory storage _loveStory = loveStories[_id];
505 
506         _loveStory.owner = msg.sender;
507         _loveStory.loverName = _loverName;
508         _loveStory.lovedOneName = _lovedOneName;
509         _loveStory.transferCost = msg.value.mul(2);
510         _loveStory.lockedUntil = now.add(_lockDurationInHours.mul(1 hours));
511         _loveStory.data = _data;
512     }
513 
514     function _isLowercaseLetter(byte _char)
515         private
516         pure
517         returns (bool)
518     {
519         // Char must be a small case letter: [a-z]
520         return _char >= 0x61 && _char <= 0x7A;
521     }
522 }