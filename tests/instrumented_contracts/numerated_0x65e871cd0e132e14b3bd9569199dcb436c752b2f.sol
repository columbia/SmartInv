1 pragma solidity ^0.4.23;
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
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 library Dictionary {
113     uint constant private NULL = 0;
114 
115     struct Node {
116         uint prev;
117         uint next;
118         uint data;
119         bool initialized;
120     }
121 
122     struct Data {
123         mapping(uint => Node) list;
124         uint firstNodeId;
125         uint lastNodeId;
126         uint len;
127     }
128 
129     function insertAfter(Data storage self, uint afterId, uint id, uint data) internal {
130         if (self.list[id].initialized) {
131             self.list[id].data = data;
132             return;
133         }
134         self.list[id].prev = afterId;
135         if (self.list[afterId].next == NULL) {
136             self.list[id].next =  NULL;
137             self.lastNodeId = id;
138         } else {
139             self.list[id].next = self.list[afterId].next;
140             self.list[self.list[afterId].next].prev = id;
141         }
142         self.list[id].data = data;
143         self.list[id].initialized = true;
144         self.list[afterId].next = id;
145         self.len++;
146     }
147 
148     function insertBefore(Data storage self, uint beforeId, uint id, uint data) internal {
149         if (self.list[id].initialized) {
150             self.list[id].data = data;
151             return;
152         }
153         self.list[id].next = beforeId;
154         if (self.list[beforeId].prev == NULL) {
155             self.list[id].prev = NULL;
156             self.firstNodeId = id;
157         } else {
158             self.list[id].prev = self.list[beforeId].prev;
159             self.list[self.list[beforeId].prev].next = id;
160         }
161         self.list[id].data = data;
162         self.list[id].initialized = true;
163         self.list[beforeId].prev = id;
164         self.len++;
165     }
166 
167     function insertBeginning(Data storage self, uint id, uint data) internal {
168         if (self.list[id].initialized) {
169             self.list[id].data = data;
170             return;
171         }
172         if (self.firstNodeId == NULL) {
173             self.firstNodeId = id;
174             self.lastNodeId = id;
175             self.list[id] = Node({ prev: 0, next: 0, data: data, initialized: true });
176             self.len++;
177         } else
178             insertBefore(self, self.firstNodeId, id, data);
179     }
180 
181     function insertEnd(Data storage self, uint id, uint data) internal {
182         if (self.lastNodeId == NULL) insertBeginning(self, id, data);
183         else
184             insertAfter(self, self.lastNodeId, id, data);
185     }
186 
187     function set(Data storage self, uint id, uint data) internal {
188         insertEnd(self, id, data);
189     }
190 
191     function get(Data storage self, uint id) internal view returns (uint) {
192         return self.list[id].data;
193     }
194 
195     function remove(Data storage self, uint id) internal returns (bool) {
196         uint nextId = self.list[id].next;
197         uint prevId = self.list[id].prev;
198 
199         if (prevId == NULL) self.firstNodeId = nextId; //first node
200         else self.list[prevId].next = nextId;
201 
202         if (nextId == NULL) self.lastNodeId = prevId; //last node
203         else self.list[nextId].prev = prevId;
204 
205         delete self.list[id];
206         self.len--;
207 
208         return true;
209     }
210 
211     function getSize(Data storage self) internal view returns (uint) {
212         return self.len;
213     }
214 
215     function next(Data storage self, uint id) internal view returns (uint) {
216         return self.list[id].next;
217     }
218 
219     function prev(Data storage self, uint id) internal view returns (uint) {
220         return self.list[id].prev;
221     }
222 
223     function keys(Data storage self) internal constant returns (uint[]) {
224         uint[] memory arr = new uint[](self.len);
225         uint node = self.firstNodeId;
226         for (uint i=0; i < self.len; i++) {
227             arr[i] = node;
228             node = next(self, node);
229         }
230         return arr;
231     }
232 }
233 
234 interface Provider {
235     function isBrickOwner(uint _brickId, address _address) external view returns (bool success);
236     function addBrick(uint _brickId, string _title, string _url, uint32 _expired, string _description, bytes32[] _tags, uint _value)
237         external returns (bool success);
238     function changeBrick(
239         uint _brickId,
240         string _title,
241         string _url,
242         string _description,
243         bytes32[] _tags,
244         uint _value) external returns (bool success);
245     function accept(uint _brickId, address[] _builderAddresses, uint[] percentages, uint _additionalValue) external returns (uint total);
246     function cancel(uint _brickId) external returns (uint value);
247     function startWork(uint _brickId, bytes32 _builderId, bytes32 _nickName, address _builderAddress) external returns(bool success);
248     function getBrickIds() external view returns(uint[]);
249     function getBrickSize() external view returns(uint);
250     function getBrick(uint _brickId) external view returns(
251         string title,
252         string url, 
253         address owner,
254         uint value,
255         uint32 dateCreated,
256         uint32 dateCompleted, 
257         uint32 expired,
258         uint status
259     );
260 
261     function getBrickDetail(uint _brickId) external view returns(
262         bytes32[] tags, 
263         string description, 
264         uint32 builders, 
265         address[] winners
266     );
267 
268     function getBrickBuilders(uint _brickId) external view returns (
269         address[] addresses,
270         uint[] dates,
271         bytes32[] keys,
272         bytes32[] names
273     );
274 
275     function filterBrick(
276         uint _brickId, 
277         bytes32[] _tags, 
278         uint _status, 
279         uint _started,
280         uint _expired
281         ) external view returns (
282       bool
283     );
284 
285 
286     function participated( 
287         uint _brickId,
288         address _builder
289         ) external view returns (
290         bool
291     ); 
292 }
293 
294 // solhint-disable-next-line compiler-fixed, compiler-gt-0_4
295 
296 
297 
298 
299 
300 
301 
302 
303 contract WeBuildWorldImplementation is Ownable, Provider {
304     using SafeMath for uint256;	
305     using Dictionary for Dictionary.Data;
306 
307     enum BrickStatus { Inactive, Active, Completed, Cancelled }
308 
309     struct Builder {
310         address addr;
311         uint dateAdded;
312         bytes32 key;
313         bytes32 nickName;
314     }
315     
316     struct Brick {
317         string title;
318         string url;
319         string description;
320         bytes32[] tags;
321         address owner;
322         uint value;
323         uint32 dateCreated;
324         uint32 dateCompleted;
325         uint32 expired;
326         uint32 numBuilders;
327         BrickStatus status;
328         address[] winners;
329         mapping (uint => Builder) builders;
330     }
331 
332     address public main = 0x0;
333     mapping (uint => Brick) public bricks;
334 
335     string public constant VERSION = "0.1";
336     Dictionary.Data public brickIds;
337     uint public constant DENOMINATOR = 10000;
338 
339     modifier onlyMain() {
340         require(msg.sender == main);
341         _;
342     }
343 
344     function () public payable {
345         revert();
346     }    
347 
348     function isBrickOwner(uint _brickId, address _address) external view returns (bool success) {
349         return bricks[_brickId].owner == _address;
350     }    
351 
352     function addBrick(uint _brickId, string _title, string _url, uint32 _expired, string _description, bytes32[] _tags, uint _value) 
353         external onlyMain
354         returns (bool success)
355     {
356         // greater than 0.01 eth
357         require(_value >= 10 ** 16);
358         // solhint-disable-next-line
359         require(bricks[_brickId].owner == 0x0 || bricks[_brickId].owner == tx.origin);
360 
361         Brick memory brick = Brick({
362             title: _title,
363             url: _url,
364             description: _description,   
365             tags: _tags,
366             // solhint-disable-next-line
367             owner: tx.origin,
368             status: BrickStatus.Active,
369             value: _value,
370             // solhint-disable-next-line 
371             dateCreated: uint32(now),
372             dateCompleted: 0,
373             expired: _expired,
374             numBuilders: 0,
375             winners: new address[](0)
376         });
377 
378         // only add when it's new
379         if (bricks[_brickId].owner == 0x0) {
380             brickIds.insertBeginning(_brickId, 0);
381         }
382         bricks[_brickId] = brick;
383 
384         return true;
385     }
386 
387     function changeBrick(uint _brickId, string _title, string _url, string _description, bytes32[] _tags, uint _value) 
388         external onlyMain
389         returns (bool success) 
390     {
391         require(bricks[_brickId].status == BrickStatus.Active);
392 
393         bricks[_brickId].title = _title;
394         bricks[_brickId].url = _url;
395         bricks[_brickId].description = _description;
396         bricks[_brickId].tags = _tags;
397 
398         // Add to the fund.
399         if (_value > 0) {
400             bricks[_brickId].value = bricks[_brickId].value.add(_value);
401         }
402 
403         return true;
404     }
405 
406     // msg.value is tip.
407     function accept(uint _brickId, address[] _winners, uint[] _weights, uint _value) 
408         external onlyMain
409         returns (uint) 
410     {
411         require(bricks[_brickId].status == BrickStatus.Active);
412         require(_winners.length == _weights.length);
413         // disallow to take to your own.
414 
415         uint total = 0;
416         bool included = false;
417         for (uint i = 0; i < _winners.length; i++) {
418             // solhint-disable-next-line
419             require(_winners[i] != tx.origin, "Owner should not win this himself");
420             for (uint j =0; j < bricks[_brickId].numBuilders; j++) {
421                 if (bricks[_brickId].builders[j].addr == _winners[i]) {
422                     included = true;
423                     break;
424                 }
425             }
426             total = total.add(_weights[i]);
427         }
428 
429         require(included, "Winner doesn't participant");
430         require(total == DENOMINATOR, "total should be in total equals to denominator");
431 
432         bricks[_brickId].status = BrickStatus.Completed;
433         bricks[_brickId].winners = _winners;
434         // solhint-disable-next-line
435         bricks[_brickId].dateCompleted = uint32(now);
436 
437         if (_value > 0) {
438             bricks[_brickId].value = bricks[_brickId].value.add(_value);
439         }
440 
441         return bricks[_brickId].value;
442     }
443 
444     function cancel(uint _brickId) 
445         external onlyMain
446         returns (uint value) 
447     {
448         require(bricks[_brickId].status != BrickStatus.Completed);
449         require(bricks[_brickId].status != BrickStatus.Cancelled);
450 
451         bricks[_brickId].status = BrickStatus.Cancelled;
452 
453         return bricks[_brickId].value;
454     }
455 
456     function startWork(uint _brickId, bytes32 _builderId, bytes32 _nickName, address _builderAddress) 
457         external onlyMain returns(bool success)
458     {
459         require(_builderAddress != 0x0);
460         require(bricks[_brickId].status == BrickStatus.Active);
461         require(_brickId >= 0);
462         require(bricks[_brickId].expired >= now);
463 
464         bool included = false;
465 
466         for (uint i = 0; i < bricks[_brickId].numBuilders; i++) {
467             if (bricks[_brickId].builders[i].addr == _builderAddress) {
468                 included = true;
469                 break;
470             }
471         }
472         require(!included);
473 
474         // bricks[_brickId]
475         Builder memory builder = Builder({
476             addr: _builderAddress,
477             key: _builderId,
478             nickName: _nickName,
479             // solhint-disable-next-line
480             dateAdded: now
481         });
482         bricks[_brickId].builders[bricks[_brickId].numBuilders++] = builder;
483 
484         return true;
485     }
486 
487     function getBrickIds() external view returns(uint[]) {
488         return brickIds.keys();
489     }    
490 
491     function getBrickSize() external view returns(uint) {
492         return brickIds.getSize();
493     }
494 
495     function _matchedTags(bytes32[] _tags, bytes32[] _stack) private pure returns (bool){
496         if(_tags.length > 0){
497             for (uint i = 0; i < _tags.length; i++) {
498                 for(uint j = 0; j < _stack.length; j++){
499                     if(_tags[i] == _stack[j]){
500                         return true;
501                     }
502                 }
503             }
504             return false;
505         }else{
506             return true;
507         } 
508     }
509 
510     function participated(
511         uint _brickId,   
512         address _builder
513         )
514         external view returns (bool) {
515  
516         for (uint j = 0; j < bricks[_brickId].numBuilders; j++) {
517             if (bricks[_brickId].builders[j].addr == _builder) {
518                 return true;
519             }
520         } 
521 
522         return false;
523     }
524 
525     
526     function filterBrick(
527         uint _brickId, 
528         bytes32[] _tags, 
529         uint _status, 
530         uint _started,
531         uint _expired
532         )
533         external view returns (bool) {  
534         Brick memory brick = bricks[_brickId];  
535 
536         bool satisfy = _matchedTags(_tags, brick.tags);  
537 
538         if(_started > 0){
539             satisfy = brick.dateCreated >= _started;
540         }
541         
542         if(_expired > 0){
543             satisfy = brick.expired >= _expired;
544         }
545  
546         return satisfy && (uint(brick.status) == _status
547             || uint(BrickStatus.Cancelled) < _status 
548             || uint(BrickStatus.Inactive) > _status);
549     }
550 
551     function getBrick(uint _brickId) external view returns (
552         string title,
553         string url,
554         address owner,
555         uint value,
556         uint32 dateCreated,
557         uint32 dateCompleted,
558         uint32 expired,
559         uint status
560     ) {
561         Brick memory brick = bricks[_brickId];
562         return (
563             brick.title,
564             brick.url,
565             brick.owner,
566             brick.value,
567             brick.dateCreated,
568             brick.dateCompleted,
569             brick.expired,
570             uint(brick.status)
571         );
572     }
573     
574     function getBrickDetail(uint _brickId) external view returns (
575         bytes32[] tags,
576         string description, 
577         uint32 builders,
578         address[] winners
579     ) {
580         Brick memory brick = bricks[_brickId];
581         return ( 
582             brick.tags, 
583             brick.description, 
584             brick.numBuilders,
585             brick.winners
586         );
587     }
588 
589     function getBrickBuilders(uint _brickId) external view returns (
590         address[] addresses,
591         uint[] dates,
592         bytes32[] keys,
593         bytes32[] names
594     )
595     {
596         // Brick memory brick = bricks[_brickId];
597         addresses = new address[](bricks[_brickId].numBuilders);
598         dates = new uint[](bricks[_brickId].numBuilders);
599         keys = new bytes32[](bricks[_brickId].numBuilders);
600         names = new bytes32[](bricks[_brickId].numBuilders);
601 
602         for (uint i = 0; i < bricks[_brickId].numBuilders; i++) {
603             addresses[i] = bricks[_brickId].builders[i].addr;
604             dates[i] = bricks[_brickId].builders[i].dateAdded;
605             keys[i] = bricks[_brickId].builders[i].key;
606             names[i] = bricks[_brickId].builders[i].nickName;
607         }
608     }    
609 
610     function setMain(address _address) public onlyOwner returns(bool) {
611         main = _address;
612         return true;
613     }     
614 }