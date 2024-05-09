1 /**
2  * ▒█▀▀█ ░▀░ █▀▀█ █▀▀▄ █▀▄▀█ █▀▀█ █▀▀▄ 
3  * ▒█▀▀▄ ▀█▀ █▄▄▀ █░░█ █░▀░█ █▄▄█ █░░█ 
4  * ▒█▄▄█ ▀▀▀ ▀░▀▀ ▀▀▀░ ▀░░░▀ ▀░░▀ ▀░░▀ 
5  *
6  * Birdman helps grow the Microverse community,
7  * which is considered the premature version of Mutual Constructor.
8  */
9 
10 pragma solidity ^0.4.23;
11 
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipRenounced(address indexed previousOwner);
22   event OwnershipTransferred(
23     address indexed previousOwner,
24     address indexed newOwner
25   );
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   constructor() public {
33     owner = msg.sender;
34   }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   /**
45    * @dev Allows the current owner to relinquish control of the contract.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address _newOwner) public onlyOwner {
57     _transferOwnership(_newOwner);
58   }
59 
60   /**
61    * @dev Transfers control of the contract to a newOwner.
62    * @param _newOwner The address to transfer ownership to.
63    */
64   function _transferOwnership(address _newOwner) internal {
65     require(_newOwner != address(0));
66     emit OwnershipTransferred(owner, _newOwner);
67     owner = _newOwner;
68   }
69 
70 }
71 
72 
73 /**
74  * @title AdminUtils
75  * @dev customized admin control panel
76  * @dev just want to keep everything safe
77  */
78 contract AdminUtils is Ownable {
79 
80     mapping (address => uint256) adminContracts;
81 
82     address internal root;
83 
84     /* modifiers */
85     modifier OnlyContract() {
86         require(isSuperContract(msg.sender));
87         _;
88     }
89 
90     modifier OwnerOrContract() {
91         require(msg.sender == owner || isSuperContract(msg.sender));
92         _;
93     }
94 
95     modifier onlyRoot() {
96         require(msg.sender == root);
97         _;
98     }
99 
100     /* constructor */
101     constructor() public {
102         // This is a safe key stored offline
103         root = 0xe07faf5B0e91007183b76F37AC54d38f90111D40;
104     }
105 
106     /**
107      * @dev this is the kickass idea from @dan
108      * and well we will see how it works
109      */
110     function claimOwnership()
111         external
112         onlyRoot
113         returns (bool) {
114         owner = root;
115         return true;
116     }
117 
118     /**
119      * @dev function to address a super contract address
120      * some functions are meant to be called from another contract
121      * but not from any contracts
122      * @param _address A contract address
123      */
124     function addContractAddress(address _address)
125         public
126         onlyOwner
127         returns (bool) {
128 
129         uint256 codeLength;
130 
131         assembly {
132             codeLength := extcodesize(_address)
133         }
134 
135         if (codeLength == 0) {
136             return false;
137         }
138 
139         adminContracts[_address] = 1;
140         return true;
141     }
142 
143     /**
144      * @dev remove the contract address as a super user role
145      * have it here just in case
146      * @param _address A contract address
147      */
148     function removeContractAddress(address _address)
149         public
150         onlyOwner
151         returns (bool) {
152 
153         uint256 codeLength;
154 
155         assembly {
156             codeLength := extcodesize(_address)
157         }
158 
159         if (codeLength == 0) {
160             return false;
161         }
162 
163         adminContracts[_address] = 0;
164         return true;
165     }
166 
167     /**
168      * @dev check contract eligibility
169      * @param _address A contract address
170      */
171     function isSuperContract(address _address)
172         public
173         view
174         returns (bool) {
175 
176         uint256 codeLength;
177 
178         assembly {
179             codeLength := extcodesize(_address)
180         }
181 
182         if (codeLength == 0) {
183             return false;
184         }
185 
186         if (adminContracts[_address] == 1) {
187             return true;
188         } else {
189             return false;
190         }
191     }
192 }
193 
194 
195 /**
196  * @title SafeMath
197  * @dev Math operations with safety checks that throw on error
198  */
199 library SafeMath {
200 
201     /**
202     * @dev Multiplies two numbers, throws on overflow.
203     */
204     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
205         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
206         // benefit is lost if 'b' is also tested.
207         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
208         if (a == 0) {
209             return 0;
210         }
211 
212         c = a * b;
213         assert(c / a == b);
214         return c;
215     }
216 
217     /**
218     * @dev Integer division of two numbers, truncating the quotient.
219     */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         // assert(b > 0); // Solidity automatically throws when dividing by 0
222         // uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224         return a / b;
225     }
226 
227     /**
228     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
229     */
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         assert(b <= a);
232         return a - b;
233     }
234 
235     /**
236     * @dev Adds two numbers, throws on overflow.
237     */
238     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
239         c = a + b;
240         assert(c >= a);
241         return c;
242     }
243 }
244 
245 
246 /**
247  * @title Contract that will work with ERC223 tokens.
248  */
249 contract ERC223ReceivingContract { 
250 /**
251  * @dev Standard ERC223 function that will handle incoming token transfers.
252  *
253  * @param _from  Token sender address.
254  * @param _value Amount of tokens.
255  * @param _data  Transaction metadata.
256  */
257     function tokenFallback(address _from, uint _value, bytes _data) public;
258 }
259 
260 /**
261  * @title EvilMortyTokenInterface
262  */
263 contract EvilMortyTokenInterface {
264 
265     /**
266      * @dev Check balance of a given address
267      * @param sender address
268      */
269     function balanceOf(address sender) public view returns (uint256);
270 }
271 
272 /**
273  * @title Birdman
274  */
275 contract Birdman is AdminUtils, ERC223ReceivingContract {
276 
277     using SafeMath for uint256;
278 
279     event MCApplied(address sender);
280     event MCAdded(address sender);
281     event MCRemoved(address sender);
282     event ShareSent(address indexed receiver, uint256 value);
283     event SystemChangeValidMCAmount(uint256 oldValue, uint256 newValue);
284     event SystemChangeMaxNumMC(uint256 oldValue, uint256 newValue);
285     event SystemChangeShareTimeGap(uint256 oldValue, uint256 newValue);
286     event SystemChangeVettingTime(uint256 oldValue, uint256 newValue);
287 
288     EvilMortyTokenInterface internal EvilMortyInstance;
289 
290     uint256 public validMCAmount = 5000000e18;
291     uint256 public maxNumMC = 20;
292     uint256 public vettingTime = 86400; // in block height, roughly 15 days
293     uint256 public shareTimeGap = 86400; // in block height, roughly 15 days
294     uint256 public numMC;
295     uint256 public numMCApplied;
296     uint256 public nextShareTime = 6213990; // around UTC 01:00, 8/26/2018
297     uint256 public weiAmountShare;
298 
299     mapping (uint256 => MC) constructors;
300     mapping (address => uint256) addressToIndex;
301 
302     struct MC {
303       address playerAddress;
304       uint256 timeSince;
305       uint256 nextSharedSentTime;
306       bool passed;
307     }
308     
309     uint256[] emptyIndexes;
310 
311     modifier isValidMC() {
312         require (EvilMortyInstance.balanceOf(msg.sender) >= validMCAmount);
313         _;
314     }
315 
316     modifier canAddMC() {
317       require (numMCApplied < maxNumMC);
318       // make sure no one cheats
319       require (addressToIndex[msg.sender] == 0);
320       
321       _; 
322     }
323 
324     modifier isEvilMortyToken() {
325         require(msg.sender == address(EvilMortyInstance));
326         _;
327     }
328 
329     /* constructor */
330     constructor(address EvilMortyAddress)
331         public {
332         EvilMortyInstance = EvilMortyTokenInterface(EvilMortyAddress);
333     }
334 
335     /**
336      * @dev Allow funds to be sent to this contract
337      * if the sender is the owner or a super contract
338      * then it will do nothing
339      */
340     function ()
341         public
342         payable {
343         if (msg.sender == owner || isSuperContract(msg.sender)) {
344             return;
345         }
346         applyMC();
347     }
348 
349     /**
350      * @dev Allow morty token to be sent to this contract
351      * if the sender is the owner it will do nothing
352      */
353     function tokenFallback(address _from, uint256 _value, bytes)
354         public
355         isEvilMortyToken {
356         if (_from == owner) {
357             return;
358         }
359         claimShare(addressToIndex[_from]);
360     }
361 
362     /**
363      * @dev Apply for becoming a MC
364      */
365     function applyMC()
366         public
367         payable
368         canAddMC {
369 
370         require (EvilMortyInstance.balanceOf(msg.sender) >= validMCAmount);
371 
372         numMCApplied = numMCApplied.add(1);
373         uint256 newIndex = numMCApplied;
374 
375         if (emptyIndexes.length > 0) {
376             newIndex = emptyIndexes[emptyIndexes.length-1];
377             delete emptyIndexes[emptyIndexes.length-1];
378             emptyIndexes.length--;
379         }
380 
381         constructors[newIndex] = MC({
382             playerAddress: msg.sender,
383             timeSince: block.number.add(vettingTime),
384             nextSharedSentTime: nextShareTime,
385             passed: false
386         });
387 
388         addressToIndex[msg.sender] = newIndex;
389 
390         emit MCApplied(msg.sender);
391     }
392 
393     /**
394      * @dev Get a MC's info given index
395      * @param _index the MC's index
396      */
397     function getMC(uint256 _index)
398         public
399         view
400         returns (address, uint256, uint256, bool) {
401         MC storage mc = constructors[_index];
402         return (
403             mc.playerAddress,
404             mc.timeSince,
405             mc.nextSharedSentTime,
406             mc.passed
407         );
408     }
409 
410     /**
411      * @dev Get number of empty indexes
412      */
413     function numEmptyIndexes()
414         public
415         view
416         returns (uint256) {
417         return emptyIndexes.length;
418     }
419 
420     /**
421      * @dev Get the MC index given address
422      * @param _address MC's address
423      */
424     function getIndex(address _address)
425         public
426         view
427         returns (uint256) {
428         return addressToIndex[_address];
429     }
430 
431     /**
432      * @dev Update all MC's status
433      */
434     function updateMCs()
435         public {
436 
437         if (numMCApplied == 0) {
438             return;
439         }
440 
441         for (uint256 i = 0; i < maxNumMC; i ++) {
442             updateMC(i);
443         }
444     }
445 
446     /**
447      * @dev Update a MC's status, if
448      * - the MC's balance is below min requirement, it will be deleted;
449      * - the MC's vetting time is passed, it will be added
450      * @param _index the MC's index
451      */
452     function updateMC(uint256 _index)
453         public {
454         MC storage mc = constructors[_index];
455 
456         // skip empty index
457         if (mc.playerAddress == 0) {
458             return;
459         }
460 
461         if (EvilMortyInstance.balanceOf(mc.playerAddress) < validMCAmount) {
462             // remove MC
463             numMCApplied = numMCApplied.sub(1);
464             if (mc.passed == true) {
465                 numMC = numMC.sub(1);
466             }
467             emptyIndexes.push(_index);
468             emit MCRemoved(mc.playerAddress);
469             delete addressToIndex[mc.playerAddress];
470             delete constructors[_index];
471             return;
472         }
473 
474         if (mc.passed == false && mc.timeSince < block.number) {
475              mc.passed = true;
476              numMC = numMC.add(1);
477              emit MCAdded(mc.playerAddress);
478              return;
479         }
480     }
481 
482     /**
483      * @dev Update funds to be sent in this shares period
484      */
485     function updateWeiAmountShare()
486         public {
487         if (numMC == 0) {
488             return;
489         }
490         if (nextShareTime < block.number) {
491             weiAmountShare = address(this).balance.div(numMC);
492 
493             // make height accurate
494             uint256 timeGap = block.number.sub(nextShareTime);
495             uint256 gap = timeGap.div(shareTimeGap).add(1);
496             nextShareTime = nextShareTime.add(shareTimeGap.mul(gap));
497         }
498     }
499 
500     /**
501      * @dev Ask for funds for a MC
502      * @param _index the Mc's index
503      */
504     function claimShare(uint256 _index)
505         public {
506 
507         // need update all MCs first
508         updateMCs();
509 
510         MC storage mc = constructors[_index];
511 
512         // skip empty index
513         if (mc.playerAddress == 0) {
514             return;
515         }
516 
517         if (mc.passed == false) {
518             return;
519         }
520 
521         if (mc.nextSharedSentTime < block.number) {
522             // update next share time
523             updateWeiAmountShare();
524             mc.nextSharedSentTime = nextShareTime;
525             // every mc gets equal share
526             mc.playerAddress.transfer(weiAmountShare);
527             emit ShareSent(mc.playerAddress, weiAmountShare);
528         }
529     }
530 
531     /**
532      * @dev Upgrade evil morty
533      * in case of upgrade needed
534      */
535     function upgradeEvilMorty(address _address)
536         external
537         onlyOwner {
538 
539         uint256 codeLength;
540 
541         assembly {
542             codeLength := extcodesize(_address)
543         }
544 
545         if (codeLength == 0) {
546             return;
547         }
548 
549         EvilMortyInstance = EvilMortyTokenInterface(_address);
550     }
551 
552     /**
553      * @dev Update min requirement for being a MC
554      * a system event is emitted to capture the change
555      * @param _amount new amount
556      */
557     function updateValidMCAmount(uint256 _amount)
558         external
559         onlyOwner {
560         emit SystemChangeValidMCAmount(validMCAmount, _amount);
561         validMCAmount = _amount;
562     }
563 
564     /**
565      * @dev Update max number of MCs
566      * a system event is emitted to capture the change
567      */
568     function updateMaxNumMC(uint256 _num)
569         external
570         onlyOwner {
571         emit SystemChangeMaxNumMC(maxNumMC, _num);
572         maxNumMC = _num;
573     }
574 
575     /**
576      * @dev Update the length of a share period
577      * a system event is emitted to capture the change
578      * @param _height bloch heights
579      */
580     function updateShareTimeGap(uint256 _height)
581         external
582         onlyOwner {
583         emit SystemChangeShareTimeGap(shareTimeGap, _height);
584         shareTimeGap = _height;
585     }
586 
587     /**
588      * @dev Update the length of vetting time
589      * a system event is emitted to capture the change
590      * @param _height bloch heights
591      */
592     function updateVettingTime(uint256 _height)
593         external
594         onlyOwner {
595         emit SystemChangeVettingTime(vettingTime, _height);
596         vettingTime = _height;
597     }
598 }