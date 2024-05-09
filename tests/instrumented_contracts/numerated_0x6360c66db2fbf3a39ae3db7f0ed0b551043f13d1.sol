1 pragma solidity ^0.4.16;
2 
3 /***********************************************
4  ***************
5  * UTF8 library
6  * == FINAL ==
7  ***************
8  **********************************************/
9 library UTF8 {
10     function getStringLength(string str) internal pure returns(int256 length) {
11         uint256 i = 0;
12         bytes memory str_rep = bytes(str);
13         while(i < str_rep.length) {
14             if (str_rep[i] >> 7 == 0)         i += 1;
15             else if (str_rep[i] >> 5 == 0x6)  i += 2;
16             else if (str_rep[i] >> 4 == 0xE)  i += 3;
17             else if (str_rep[i] >> 3 == 0x1E) i += 4;
18             else                              i += 1;
19             length++;
20         }
21     }
22 }
23 
24 
25 /***********************************************
26  ***************
27  * Math library
28  ***************
29  **********************************************/
30 library Math {
31     function divide(int256 numerator, int256 denominator, uint256 precision) internal pure returns(int256) {
32         int256 _numerator = numerator * int256(10 ** (precision + 1));
33         int256 _quotient  = ((_numerator / denominator) + 5) / 10;
34         return _quotient;
35     }
36 
37     function rand(uint256 nonce, int256 min, int256 max) internal view returns(int256) {
38         return int256(uint256(keccak256(nonce + block.number + block.timestamp)) % uint256((max - min))) + min;
39     }
40 
41     function rand16(uint256 nonce, uint16 min, uint16 max) internal view returns(uint16) {
42         return uint16(uint256(keccak256(nonce + block.number + block.timestamp)) % uint256(max - min)) + min;
43     }
44 
45     function rand8(uint256 nonce, uint8 min, uint8 max) internal view returns(uint8) {
46         return uint8(uint256(keccak256(nonce + block.number + block.timestamp)) % uint256(max - min)) + min;
47     }
48 
49     function percent(uint256 value, uint256 per) internal pure returns(uint256) {
50         return uint256((divide(int256(value), 100, 4) * int256(per)) / 10000);
51     }
52 }
53 
54 
55 /***********************************************
56  ***************
57  * Ownable contract
58  * == FINAL ==
59  ***************
60  **********************************************/
61 contract Ownable {
62     address public owner;
63     
64     modifier onlyOwner()  { require(msg.sender == owner); _; }
65 
66     function Ownable() public { owner = msg.sender; }
67 
68     function updateContractOwner(address newOwner) external onlyOwner {
69         require(newOwner != address(0));
70         owner = newOwner;
71     }
72 }
73 
74 
75 /***********************************************
76  ***************
77  * Priced contract
78  ***************
79  **********************************************/
80 contract Priced is Ownable {
81     uint256 private price       = 500000000000000000;  // Basic price in wei
82     uint16  private zMax        = 1600;                // Max z for get price percent
83     uint256 private zPrice      = 25000000000000000;   // Price for each item in z index (in wei)
84     uint8   private commission  = 10;                  // Update commission in percent
85 
86     function setPriceData(uint256 _price, uint16 _zMax, uint256 _zPrice, uint8 _commission) external onlyOwner {
87         price       = _price;
88         zMax        = _zMax;
89         zPrice      = _zPrice;
90         commission  = _commission;
91     }
92 
93     function getCreatePrice(uint16 z, uint256 zCount) internal view returns(uint256) {
94         return ((price * uint256(Math.divide(int256(z), int256(zMax), 4))) / 10000) + (zPrice * zCount);
95     }
96 
97     function getCommission(uint256 starPrice) internal view returns(uint256) {
98         return Math.percent(starPrice, commission);
99     }
100 }
101 
102 
103 /***********************************************
104  ***************
105  * Control contract
106  * == FINAL ==
107  ***************
108  **********************************************/
109 contract Control is Ownable {
110     /**
111      * Withdraw balance
112      */
113     function withdrawBalance(address recipient, uint256 value) external onlyOwner {
114         require(value > 0);
115         require(value < address(this).balance);
116         recipient.transfer(value);
117     }
118 }
119 
120 
121 /***********************************************
122  ***************
123  * Storage contract
124  ***************
125  **********************************************/
126 contract Storage {
127     struct Star {
128         address owner;   // Star owner
129         uint8   gid;     // Star galaxy id
130         uint8   zIndex;  // Star z
131         uint16  box;     // Current xy box 
132         uint8   inbox;   // Random x-y in box
133         uint8   stype;   // Star type
134         uint8   color;   // Star color
135         uint256 price;   // Price for this star
136         uint256 sell;    // Sell price for this star
137         bool    deleted; // Star is deleted
138         string  name;    // User defined star name
139         string  message; // User defined message
140     }
141 
142     // General stars storage
143     Star[] internal stars;
144 
145     // Stars at zIndex area (gid => zIndex => count)
146     mapping(uint8 => mapping(uint8 => uint16)) internal zCount;    
147 
148     // Stars positions (gid => zIndex => box => starId)
149     mapping(uint8 => mapping(uint8 => mapping(uint16 => uint256))) private positions;    
150 
151 
152     /**
153      * Add new star
154      */
155     function addStar(address owner, uint8 gid, uint8 zIndex, uint16 box, uint8 inbox, uint8 stype, uint8 color, uint256 price) internal returns(uint256) {
156         Star memory _star = Star({
157             owner: owner,
158             gid: gid, zIndex: zIndex, box: box, inbox: inbox,
159             stype: stype, color: color,
160             price: price, sell: 0, deleted: false, name: "", message: ""
161         });
162         uint256 starId = stars.push(_star) - 1;
163         placeStar(gid, zIndex, box, starId);
164         return starId;
165     }
166 
167     function placeStar(uint8 gid, uint8 zIndex, uint16 box, uint256 starId) private {
168         zCount[gid][zIndex]         = zCount[gid][zIndex] + 1;
169         positions[gid][zIndex][box] = starId;
170     }
171 
172     function setStarNameMessage(uint256 starId, string name, string message) internal {
173         stars[starId].name    = name;
174         stars[starId].message = message;
175     }
176 
177     function setStarNewOwner(uint256 starId, address newOwner) internal {
178         stars[starId].owner = newOwner;
179     }
180 
181     function setStarSellPrice(uint256 starId, uint256 sellPrice) internal {
182         stars[starId].sell = sellPrice;
183     }
184 
185     function setStarDeleted(uint256 starId) internal {
186         stars[starId].deleted = true;
187         setStarSellPrice(starId, 0);
188         setStarNameMessage(starId, "", "");
189         setStarNewOwner(starId, address(0));
190 
191         Star storage _star = stars[starId];
192         zCount[_star.gid][_star.zIndex]               = zCount[_star.gid][_star.zIndex] - 1;
193         positions[_star.gid][_star.zIndex][_star.box] = 0;
194     }
195 
196 
197     /**
198      * Get star by id
199      */
200     function getStar(uint256 starId) external view returns(address owner, uint8 gid, uint8 zIndex, uint16 box, uint8 inbox,
201                                                            uint8 stype, uint8 color,
202                                                            uint256 price, uint256 sell, bool deleted,
203                                                            string name, string message) {
204         Star storage _star = stars[starId];
205         owner      = _star.owner;
206         gid        = _star.gid;
207         zIndex     = _star.zIndex;
208         box        = _star.box;
209         inbox      = _star.inbox;
210         stype      = _star.stype;
211         color      = _star.color;
212         price      = _star.price;
213         sell       = _star.sell;
214         deleted    = _star.deleted;
215         name       = _star.name;
216         message    = _star.message;
217     }
218 
219     function getStarIdAtPosition(uint8 gid, uint8 zIndex, uint16 box) internal view returns(uint256) {
220         return positions[gid][zIndex][box];
221     }
222 
223     function starExists(uint256 starId) internal view returns(bool) {
224         return starId > 0 && starId < stars.length && stars[starId].deleted == false;
225     }
226 
227     function isStarOwner(uint256 starId, address owner) internal view returns(bool) {
228         return stars[starId].owner == owner;
229     }
230 }
231 
232 
233 /***********************************************
234  ***************
235  * Validation contract
236  ***************
237  **********************************************/
238 contract Validation is Priced, Storage {
239     uint8   private gidMax     = 5;
240     uint16  private zMin       = 100;
241     uint16  private zMax       = 1600;
242     uint8   private lName      = 25;
243     uint8   private lMessage   = 140;
244     uint8   private maxCT      = 255; // Max color, types
245     uint256 private nonce      = 1;
246     uint8   private maxIRandom = 4;
247     uint16  private boxSize    = 20;  // Universe box size
248     uint8   private inboxXY    = 100;
249 
250     // Available box count in each z index (zIndex => count)
251     mapping(uint8 => uint16) private boxes;
252 
253 
254     /**
255      * Set validation data
256      */
257     function setValidationData(uint16 _zMin, uint16 _zMax, uint8 _lName, uint8 _lMessage, uint8 _maxCT, uint8 _maxIR, uint16 _boxSize) external onlyOwner {
258         zMin       = _zMin;
259         zMax       = _zMax;
260         lName      = _lName;
261         lMessage   = _lMessage;
262         maxCT      = _maxCT;
263         maxIRandom = _maxIR;
264         boxSize    = _boxSize;
265         inboxXY    = uint8((boxSize * boxSize) / 4);
266     }
267 
268     function setGidMax(uint8 _gidMax) external onlyOwner {
269         gidMax = _gidMax;
270     }
271 
272 
273     /**
274      * Get set boxes
275      */
276     function setBoxCount(uint16 z, uint16 count) external onlyOwner {
277         require(isValidZ(z));
278         boxes[getZIndex(z)] = count;
279     }
280 
281     function getBoxCount(uint16 z) external view returns(uint16 count) {
282         require(isValidZ(z));
283         return boxes[getZIndex(z)];
284     }
285 
286     function getBoxCountZIndex(uint8 zIndex) private view returns(uint16 count) {
287         return boxes[zIndex];
288     }
289 
290 
291     /**
292      * Get z index and z count
293      */
294     function getZIndex(uint16 z) internal view returns(uint8 zIndex) {
295         return uint8(z / boxSize);
296     }
297 
298     function getZCount(uint8 gid, uint8 zIndex) public view returns(uint16 count) {
299         return zCount[gid][zIndex];
300     }
301 
302     
303     /**
304      * Validate star parameters
305      */
306     function isValidGid(uint8 gid) internal view returns(bool) {
307         return gid > 0 && gid <= gidMax;
308     }
309 
310     function isValidZ(uint16 z) internal view returns(bool) {
311         return z >= zMin && z <= zMax;
312     }
313 
314     function isValidBox(uint8 gid, uint8 zIndex, uint16 box) internal view returns(bool) {
315         return getStarIdAtPosition(gid, zIndex, box) == 0;
316     }
317 
318 
319     /**
320      * Check name and message length
321      */
322     function isValidNameLength(string name) internal view returns(bool) {
323         return UTF8.getStringLength(name) <= lName;
324     }
325 
326     function isValidMessageLength(string message) internal view returns(bool) {
327         return UTF8.getStringLength(message) <= lMessage;
328     }
329 
330 
331     /**
332      * Check is valid msg value
333      */
334     function isValidMsgValue(uint256 price) internal returns(bool) {
335         if (msg.value < price) return false;
336         if (msg.value > price)
337             msg.sender.transfer(msg.value - price);
338         return true;
339     }
340 
341 
342     /**
343      * Get random number
344      */
345     function getRandom16(uint16 min, uint16 max) private returns(uint16) {
346         nonce++;
347         return Math.rand16(nonce, min, max);
348     }
349 
350     function getRandom8(uint8 min, uint8 max) private returns(uint8) {
351         nonce++;
352         return Math.rand8(nonce, min, max);
353     }
354 
355     function getRandomColorType() internal returns(uint8) {
356         return getRandom8(0, maxCT);
357     }
358 
359 
360     /**
361      * Get random star position
362      */
363     function getRandomPosition(uint8 gid, uint8 zIndex) internal returns(uint16 box, uint8 inbox) {
364         uint16 boxCount = getBoxCountZIndex(zIndex);
365         uint16 randBox  = 0;
366         if (boxCount == 0) revert();
367 
368         uint8 ii   = maxIRandom;
369         bool valid = false;
370         while (!valid && ii > 0) {
371             randBox = getRandom16(0, boxCount);
372             valid   = isValidBox(gid, zIndex, randBox);
373             ii--;
374         }
375 
376         if (!valid) revert();
377         return(randBox, getRandom8(0, inboxXY));
378     }
379 }
380 
381 
382 /***********************************************
383  ***************
384  * Stars general contract
385  ***************
386  **********************************************/
387 contract Stars is Control, Validation {
388     // Contrac events
389     event StarCreated(uint256 starId);
390     event StarUpdated(uint256 starId, uint8 reason);
391     event StarDeleted(uint256 starId, address owner);
392     event StarSold   (uint256 starId, address seller, address buyer, uint256 price);
393     event StarGifted (uint256 starId, address sender, address recipient);
394 
395 
396     /**
397      * Constructor
398      */
399     function Stars() public {
400         // Add star with zero index
401         uint256 starId = addStar(address(0), 0, 0, 0, 0, 0, 0, 0);
402         setStarNameMessage(starId, "Universe", "Big Bang!");
403     }
404 
405 
406     /**
407      * Create star
408      */
409     function createStar(uint8 gid, uint16 z, string name, string message) external payable {
410         // Check basic requires
411         require(isValidGid(gid));
412         require(isValidZ(z));
413         require(isValidNameLength(name));
414         require(isValidMessageLength(message));
415 
416         // Get zIndex
417         uint8   zIndex    = getZIndex(z);
418         uint256 starPrice = getCreatePrice(z, getZCount(gid, zIndex));
419         require(isValidMsgValue(starPrice));
420 
421         // Create star (need to split method into two because solidity got error - to deep stack)
422         uint256 starId = newStar(gid, zIndex, starPrice);
423         setStarNameMessage(starId, name, message);
424 
425         // Event and returns data
426         emit StarCreated(starId);
427     }
428 
429     function newStar(uint8 gid, uint8 zIndex, uint256 price) private returns(uint256 starId) {
430         uint16 box; uint8 inbox;
431         uint8   stype  = getRandomColorType();
432         uint8   color  = getRandomColorType();
433         (box, inbox)   = getRandomPosition(gid, zIndex);
434         starId         = addStar(msg.sender, gid, zIndex, box, inbox, stype, color, price);
435     }
436 
437 
438     /**
439      * Update start method
440      */
441     function updateStar(uint256 starId, string name, string message) external payable {
442         // Exists and owned star
443         require(starExists(starId));
444         require(isStarOwner(starId, msg.sender));
445 
446         // Check basic requires
447         require(isValidNameLength(name));
448         require(isValidMessageLength(message));        
449 
450         // Get star update price
451         uint256 commission = getCommission(stars[starId].price);
452         require(isValidMsgValue(commission));
453 
454         // Update star
455         setStarNameMessage(starId, name, message);
456         emit StarUpdated(starId, 1);
457     }    
458 
459 
460     /**
461      * Delete star
462      */
463     function deleteStar(uint256 starId) external payable {
464         // Exists and owned star
465         require(starExists(starId));
466         require(isStarOwner(starId, msg.sender));
467 
468         // Get star update price
469         uint256 commission = getCommission(stars[starId].price);
470         require(isValidMsgValue(commission));
471 
472         // Update star data
473         setStarDeleted(starId);
474         emit StarDeleted(starId, msg.sender);
475     }    
476 
477 
478     /**
479      * Set star sell price
480      */
481     function sellStar(uint256 starId, uint256 sellPrice) external {
482         // Exists and owned star
483         require(starExists(starId));
484         require(isStarOwner(starId, msg.sender));
485         require(sellPrice < 10**28);
486 
487         // Set star sell price
488         setStarSellPrice(starId, sellPrice);
489         emit StarUpdated(starId, 2);
490     }    
491 
492 
493     /**
494      * Gift star
495      */
496     function giftStar(uint256 starId, address recipient) external payable {
497         // Check star exists owned
498         require(starExists(starId));
499         require(recipient != address(0));
500         require(isStarOwner(starId, msg.sender));
501         require(!isStarOwner(starId, recipient));
502 
503         // Get gift commission
504         uint256 commission = getCommission(stars[starId].price);
505         require(isValidMsgValue(commission));
506 
507         // Update star
508         setStarNewOwner(starId, recipient);
509         setStarSellPrice(starId, 0);
510         emit StarGifted(starId, msg.sender, recipient);
511         emit StarUpdated(starId, 3);
512     }    
513 
514 
515     /**
516      * Buy star
517      */
518     function buyStar(uint256 starId, string name, string message) external payable {
519         // Exists and NOT owner
520         require(starExists(starId));
521         require(!isStarOwner(starId, msg.sender));
522         require(stars[starId].sell > 0);
523 
524         // Get sell commission and check value
525         uint256 commission = getCommission(stars[starId].price);
526         uint256 starPrice  = stars[starId].sell;
527         uint256 totalPrice = starPrice + commission;
528         require(isValidMsgValue(totalPrice));
529 
530         // Transfer money to seller
531         address seller = stars[starId].owner;
532         seller.transfer(starPrice);
533 
534         // Update star data
535         setStarNewOwner(starId, msg.sender);
536         setStarSellPrice(starId, 0);
537         setStarNameMessage(starId, name, message);
538         emit StarSold(starId, seller, msg.sender, starPrice);
539         emit StarUpdated(starId, 4);
540     }        
541 }