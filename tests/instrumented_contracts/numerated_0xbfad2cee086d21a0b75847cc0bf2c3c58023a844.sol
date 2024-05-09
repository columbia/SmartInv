1 pragma solidity 0.4.24;
2 
3 /**
4 * CryptoCanvas Terms of Use
5 *
6 * 1. Intro
7 *
8 * CryptoCanvas is a set of collectible artworks (“Canvas”) created by the CryptoCanvas community with proof of ownership stored on the Ethereum blockchain.
9 *
10 * This agreement does a few things. First, it passes copyright ownership of a Canvas from the Canvas Authors to the first Canvas Owner. The first Canvas Owner is then obligated to pass on the copyright ownership along with the Canvas to the next owner, and so on forever, such that each owner of a Canvas is also the copyright owner. Second, it requires each Canvas Owner to allow certain uses of their Canvas image. Third, it limits the rights of Canvas owners to sue The Mindhouse and the prior owners of the Canvas.
11 *
12 * Canvases of CryptoCanvas are not an investment. They are experimental digital art.
13 *
14 * PLEASE READ THESE TERMS CAREFULLY BEFORE USING THE APP, THE SMART CONTRACTS, OR THE SITE. BY USING THE APP, THE SMART CONTRACTS, THE SITE, OR ANY PART OF THEM YOU ARE CONFIRMING THAT YOU UNDERSTAND AND AGREE TO BE BOUND BY ALL OF THESE TERMS. IF YOU ARE ACCEPTING THESE TERMS ON BEHALF OF A COMPANY OR OTHER LEGAL ENTITY, YOU REPRESENT THAT YOU HAVE THE LEGAL AUTHORITY TO ACCEPT THESE TERMS ON THAT ENTITY’S BEHALF, IN WHICH CASE “YOU” WILL MEAN THAT ENTITY. IF YOU DO NOT HAVE SUCH AUTHORITY, OR IF YOU DO NOT ACCEPT ALL OF THESE TERMS, THEN WE ARE UNWILLING TO MAKE THE APP, THE SMART CONTRACTS, OR THE SITE AVAILABLE TO YOU. IF YOU DO NOT AGREE TO THESE TERMS, YOU MAY NOT ACCESS OR USE THE APP, THE SMART CONTRACTS, OR THE SITE.
15 *
16 * 2. Definitions
17 *
18 * “Smart Contract” refers to this smart contract.
19 *
20 * “Canvas” means a collectible artwork created by the CryptoCanvas community with information about the color and author of each pixel of the Canvas, and proof of ownership stored in the Smart Contract. The Canvas is considered finished when all the pixels of the Canvas have their color set. Specifically, the Canvas is considered finished when its “state” field in the Smart Contract equals to STATE_INITIAL_BIDDING or STATE_OWNED constant.
21 *
22 * “Canvas Author” means the person who painted at least one final pixel of the finished Canvas by sending a transaction to the Smart Contract. Specifically, Canvas Author means the person with the private key for at least one address in the “painter” field of the “pixels” field of the applicable Canvas in the Smart Contract.
23 *
24 * “Canvas Owner” means the person that can cryptographically prove ownership of the applicable Canvas. Specifically, Canvas Owner means the person with the private key for the address in the “owner” field of the applicable Canvas in the Smart Contract. The person is the Canvas Owner only after the Initial Bidding phase is finished, that is when the field “state” of the applicable Canvas equals to the STATE_OWNED constant.
25 *
26 * “Initial Bidding” means the state of the Canvas when each of its pixels has been set by Canvas Authors but it does not have the Canvas Owner yet. In this phase any user can claim the ownership of the Canvas by sending a transaction to the Smart Contract (a “Bid”). Other users have 48 hours from the time of making the first Bid on the Canvas to submit their own Bids. After that time, the user who sent the highest Bid becomes the sole Canvas Owner of the applicable Canvas. Users who placed Bids with lower amounts are able to withdraw their Bid amount from their Account Balance.
27 *
28 * “Account Balance” means the value stored in the Smart Contract assigned to an address. The Account Balance can be withdrawn by the person with the private key for the applicable address by sending a transaction to the Smart Contract. Account Balance consists of Rewards for painting, Bids from Initial Bidding which have been overbid, cancelled offers to buy a Canvas and profits from selling a Canvas.
29 *
30 * “The Mindhouse”, “we” or “us” is the group of developers who created and published the CryptoCanvas Smart Contract.
31 *
32 * “The App” means collectively the Smart Contract and the website created by The Mindhouse to interact with the Smart Contract.
33 *
34 * 3. Intellectual Property
35 *
36 * A. First Assignment
37 * The Canvas Authors of the applicable Canvas hereby assign all copyright ownership in the Canvas to the Canvas Owner. In exchange for this copyright ownership, the Canvas Owner agrees to the terms below.
38 *
39 * B. Later Assignments
40 * When the Canvas Owner transfers the Canvas to a new owner, the Canvas Owner hereby agrees to assign all copyright ownership in the Canvas to the new owner of the Canvas. In exchange for these rights, the new owner shall agree to become the Canvas Owner, and shall agree to be subject to this Terms of Use.
41 *
42 * C. No Other Assignments.
43 * The Canvas Owner shall not assign or license the copyright except as set forth in the “Later Assignments” section above.
44 *
45 * D. Third Party Permissions.
46 * The Canvas Owner agrees to allow CryptoCanvas fans to make non-commercial Use of images of the Canvas to discuss CryptoCanvas, digital collectibles and related matters. “Use” means to reproduce, display, transmit, and distribute images of the Canvas. This permission excludes the right to print the Canvas onto physical copies (including, for example, shirts and posters).
47 *
48 * 4. Fees and Payment
49 *
50 * A. If you choose to paint, make a bid or trade any Canvas of CryptoCanvas any financial transactions that you engage in will be conducted solely through the Ethereum network via MetaMask. We will have no insight into or control over these payments or transactions, nor do we have the ability to reverse any transactions. With that in mind, we will have no liability to you or to any third party for any claims or damages that may arise as a result of any transactions that you engage in via the App, or using the Smart Contracts, or any other transactions that you conduct via the Ethereum network or MetaMask.
51 *
52 * B. Ethereum requires the payment of a transaction fee (a “Gas Fee”) for every transaction that occurs on the Ethereum network. The Gas Fee funds the network of computers that run the decentralized Ethereum network. This means that you will need to pay a Gas Fee for each transaction that occurs via the App.
53 *
54 * C. In addition to the Gas Fee, each time you sell a Canvas to another user of the App, you authorize us to collect a fee of 10% of the total value of that transaction. That fee consists of:
55         1) 3.9% of the total value of that transaction (a “Commission”). You acknowledge and agree that the Commission will be transferred to us through the Ethereum network as a part of the payment.
56         2) 6.1% of the total value of that transaction (a “Reward”). You acknowledge and agree that the Reward will be transferred evenly to all painters of the sold canvas through the Ethereum network as a part of the payment.
57 
58 *
59 * D. If you are the Canvas Author you are eligible to receive a reward for painting a Canvas (a “Reward”). A Reward is distributed in these scenarios:
60         1) After the Initial Bidding phase is completed. You acknowledge and agree that the Reward for the Canvas Author will be calculated by dividing the value of the winning Bid, decreased by our commission of 3.9% of the total value of the Bid, by the total number of pixels of the Canvas and multiplied by the number of pixels of the Canvas that have been painted by applicable Canvas Author.
61         2) Each time the Canvas is sold. You acknowledge and agree that the Reward for the Canvas Author will be calculated by dividing 6.1% of the total transaction value by the total number of pixels of the Canvas and multiplied by the number of pixels of the Canvas that have been painted by the applicable Canvas Author.
62 You acknowledge and agree that in order to withdraw the Reward you first need to add the Reward to your Account Balance by sending a transaction to the Smart Contract.
63 
64 *
65 * 5. Disclaimers
66 *
67 * A. YOU EXPRESSLY UNDERSTAND AND AGREE THAT YOUR ACCESS TO AND USE OF THE APP IS AT YOUR SOLE RISK, AND THAT THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED. TO THE FULLEST EXTENT PERMISSIBLE PURSUANT TO APPLICABLE LAW, WE, OUR SUBSIDIARIES, AFFILIATES, AND LICENSORS MAKE NO EXPRESS WARRANTIES AND HEREBY DISCLAIM ALL IMPLIED WARRANTIES REGARDING THE APP AND ANY PART OF IT (INCLUDING, WITHOUT LIMITATION, THE SITE, ANY SMART CONTRACT, OR ANY EXTERNAL WEBSITES), INCLUDING THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT, CORRECTNESS, ACCURACY, OR RELIABILITY. WITHOUT LIMITING THE GENERALITY OF THE FOREGOING, WE, OUR SUBSIDIARIES, AFFILIATES, AND LICENSORS DO NOT REPRESENT OR WARRANT TO YOU THAT: (I) YOUR ACCESS TO OR USE OF THE APP WILL MEET YOUR REQUIREMENTS, (II) YOUR ACCESS TO OR USE OF THE APP WILL BE UNINTERRUPTED, TIMELY, SECURE OR FREE FROM ERROR, (III) USAGE DATA PROVIDED THROUGH THE APP WILL BE ACCURATE, (III) THE APP OR ANY CONTENT, SERVICES, OR FEATURES MADE AVAILABLE ON OR THROUGH THE APP ARE FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS, OR (IV) THAT ANY DATA THAT YOU DISCLOSE WHEN YOU USE THE APP WILL BE SECURE. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OF IMPLIED WARRANTIES IN CONTRACTS WITH CONSUMERS, SO SOME OR ALL OF THE ABOVE EXCLUSIONS MAY NOT APPLY TO YOU.
68 *
69 * B. YOU ACCEPT THE INHERENT SECURITY RISKS OF PROVIDING INFORMATION AND DEALING ONLINE OVER THE INTERNET, AND AGREE THAT WE HAVE NO LIABILITY OR RESPONSIBILITY FOR ANY BREACH OF SECURITY UNLESS IT IS DUE TO OUR GROSS NEGLIGENCE.
70 *
71 * C. WE WILL NOT BE RESPONSIBLE OR LIABLE TO YOU FOR ANY LOSSES YOU INCUR AS THE RESULT OF YOUR USE OF THE ETHEREUM NETWORK OR THE METAMASK ELECTRONIC WALLET, INCLUDING BUT NOT LIMITED TO ANY LOSSES, DAMAGES OR CLAIMS ARISING FROM: (A) USER ERROR, SUCH AS FORGOTTEN PASSWORDS OR INCORRECTLY CONSTRUED SMART CONTRACTS OR OTHER TRANSACTIONS; (B) SERVER FAILURE OR DATA LOSS; (C) CORRUPTED WALLET FILES; (D) UNAUTHORIZED ACCESS OR ACTIVITIES BY THIRD PARTIES, INCLUDING BUT NOT LIMITED TO THE USE OF VIRUSES, PHISHING, BRUTEFORCING OR OTHER MEANS OF ATTACK AGAINST THE APP, ETHEREUM NETWORK, OR THE METAMASK ELECTRONIC WALLET.
72 *
73 * D. THE CANVASES OF CRYPTOCANVAS ARE INTANGIBLE DIGITAL ASSETS THAT EXIST ONLY BY VIRTUE OF THE OWNERSHIP RECORD MAINTAINED IN THE ETHEREUM NETWORK. ALL SMART CONTRACTS ARE CONDUCTED AND OCCUR ON THE DECENTRALIZED LEDGER WITHIN THE ETHEREUM PLATFORM. WE HAVE NO CONTROL OVER AND MAKE NO GUARANTEES OR PROMISES WITH RESPECT TO SMART CONTRACTS.
74 *
75 * E. THE MINDHOUSE IS NOT RESPONSIBLE FOR LOSSES DUE TO BLOCKCHAINS OR ANY OTHER FEATURES OF THE ETHEREUM NETWORK OR THE METAMASK ELECTRONIC WALLET, INCLUDING BUT NOT LIMITED TO LATE REPORT BY DEVELOPERS OR REPRESENTATIVES (OR NO REPORT AT ALL) OF ANY ISSUES WITH THE BLOCKCHAIN SUPPORTING THE ETHEREUM NETWORK, INCLUDING FORKS, TECHNICAL NODE ISSUES, OR ANY OTHER ISSUES HAVING FUND LOSSES AS A RESULT.
76 *
77 * 6. Limitation of Liability
78 * YOU UNDERSTAND AND AGREE THAT WE, OUR SUBSIDIARIES, AFFILIATES, AND LICENSORS WILL NOT BE LIABLE TO YOU OR TO ANY THIRD PARTY FOR ANY CONSEQUENTIAL, INCIDENTAL, INDIRECT, EXEMPLARY, SPECIAL, PUNITIVE, OR ENHANCED DAMAGES, OR FOR ANY LOSS OF ACTUAL OR ANTICIPATED PROFITS (REGARDLESS OF HOW THESE ARE CLASSIFIED AS DAMAGES), WHETHER ARISING OUT OF BREACH OF CONTRACT, TORT (INCLUDING NEGLIGENCE), OR OTHERWISE, REGARDLESS OF WHETHER SUCH DAMAGE WAS FORESEEABLE AND WHETHER EITHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
79 */
80 
81 /**
82  * @title Ownable
83  * @dev The Ownable contract has an owner address, and provides basic authorization control
84  * functions, this simplifies the implementation of "user permissions".
85  */
86 contract Ownable {
87     address public owner;
88 
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     /**
92      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
93      * account.
94      */
95     constructor() public {
96         owner = msg.sender;
97     }
98 
99 
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(msg.sender == owner);
105         _;
106     }
107 
108 
109     /**
110      * @dev Allows the current owner to transfer control of the contract to a newOwner.
111      * @param newOwner The address to transfer ownership to.
112      */
113     function transferOwnership(address newOwner) public onlyOwner {
114         require(newOwner != address(0));
115         emit OwnershipTransferred(owner, newOwner);
116         owner = newOwner;
117     }
118 
119 }
120 
121 /**
122  * @dev Contract that is aware of time. Useful for tests - like this
123  *      we can mock time.
124  */
125 contract TimeAware is Ownable {
126 
127     /**
128     * @dev Returns current time.
129     */
130     function getTime() public view returns (uint) {
131         return now;
132     }
133 
134 }
135 
136 /**
137  * @dev Contract that holds pending withdrawals. Responsible for withdrawals.
138  */
139 contract Withdrawable {
140 
141     mapping(address => uint) private pendingWithdrawals;
142 
143     event Withdrawal(address indexed receiver, uint amount);
144     event BalanceChanged(address indexed _address, uint oldBalance, uint newBalance);
145 
146     /**
147     * Returns amount of wei that given address is able to withdraw.
148     */
149     function getPendingWithdrawal(address _address) public view returns (uint) {
150         return pendingWithdrawals[_address];
151     }
152 
153     /**
154     * Add pending withdrawal for an address.
155     */
156     function addPendingWithdrawal(address _address, uint _amount) internal {
157         require(_address != 0x0);
158 
159         uint oldBalance = pendingWithdrawals[_address];
160         pendingWithdrawals[_address] += _amount;
161 
162         emit BalanceChanged(_address, oldBalance, oldBalance + _amount);
163     }
164 
165     /**
166     * Withdraws all pending withdrawals.
167     */
168     function withdraw() external {
169         uint amount = getPendingWithdrawal(msg.sender);
170         require(amount > 0);
171 
172         pendingWithdrawals[msg.sender] = 0;
173         msg.sender.transfer(amount);
174 
175         emit Withdrawal(msg.sender, amount);
176         emit BalanceChanged(msg.sender, amount, 0);
177     }
178 
179 }
180 
181 /**
182 * @dev This contract takes care of painting on canvases, returning artworks and creating ones.
183 */
184 contract CanvasFactory is TimeAware, Withdrawable {
185 
186     //@dev It means canvas is not finished yet, and bidding is not possible.
187     uint8 public constant STATE_NOT_FINISHED = 0;
188 
189     //@dev  there is ongoing bidding and anybody can bid. If there canvas can have
190     //      assigned owner, but it can change if someone will over-bid him.
191     uint8 public constant STATE_INITIAL_BIDDING = 1;
192 
193     //@dev canvas has been sold, and has the owner
194     uint8 public constant STATE_OWNED = 2;
195 
196     uint8 public constant WIDTH = 48;
197     uint8 public constant HEIGHT = 48;
198     uint32 public constant PIXEL_COUNT = 2304; //WIDTH * HEIGHT doesn't work for some reason
199 
200     uint32 public constant MAX_CANVAS_COUNT = 1000;
201     uint8 public constant MAX_ACTIVE_CANVAS = 12;
202     uint8 public constant MAX_CANVAS_NAME_LENGTH = 24;
203 
204     Canvas[] canvases;
205     uint32 public activeCanvasCount = 0;
206 
207     event PixelPainted(uint32 indexed canvasId, uint32 index, uint8 color, address indexed painter);
208     event CanvasFinished(uint32 indexed canvasId);
209     event CanvasCreated(uint indexed canvasId, address indexed bookedFor);
210     event CanvasNameSet(uint indexed canvasId, string name);
211 
212     modifier notFinished(uint32 _canvasId) {
213         require(!isCanvasFinished(_canvasId));
214         _;
215     }
216 
217     modifier finished(uint32 _canvasId) {
218         require(isCanvasFinished(_canvasId));
219         _;
220     }
221 
222     modifier validPixelIndex(uint32 _pixelIndex) {
223         require(_pixelIndex < PIXEL_COUNT);
224         _;
225     }
226 
227     /**
228     * @notice   Creates new canvas. There can't be more canvases then MAX_CANVAS_COUNT.
229     *           There can't be more unfinished canvases than MAX_ACTIVE_CANVAS.
230     */
231     function createCanvas() external returns (uint canvasId) {
232         return _createCanvasInternal(0x0);
233     }
234 
235     /**
236     * @notice   Similar to createCanvas(). Books it for given address. If address is 0x0 everybody will
237     *           be allowed to paint on a canvas.
238     */
239     function createAndBookCanvas(address _bookFor) external onlyOwner returns (uint canvasId) {
240         return _createCanvasInternal(_bookFor);
241     }
242 
243     /**
244     * @notice   Changes canvas.bookFor variable. Only for the owner of the contract.
245     */
246     function bookCanvasFor(uint32 _canvasId, address _bookFor) external onlyOwner {
247         Canvas storage _canvas = _getCanvas(_canvasId);
248         _canvas.bookedFor = _bookFor;
249     }
250 
251     /**
252     * @notice   Sets pixel. Given canvas can't be yet finished.
253     */
254     function setPixel(uint32 _canvasId, uint32 _index, uint8 _color) external {
255         Canvas storage _canvas = _getCanvas(_canvasId);
256         _setPixelInternal(_canvas, _canvasId, _index, _color);
257         _finishCanvasIfNeeded(_canvas, _canvasId);
258     }
259 
260     /**
261     * Set many pixels with one tx. Be careful though - sending a lot of pixels
262     * to set may cause out of gas error.
263     *
264     * Throws when none of the pixels has been set.
265     *
266     */
267     function setPixels(uint32 _canvasId, uint32[] _indexes, uint8[] _colors) external {
268         require(_indexes.length == _colors.length);
269         Canvas storage _canvas = _getCanvas(_canvasId);
270 
271         bool anySet = false;
272         for (uint32 i = 0; i < _indexes.length; i++) {
273             Pixel storage _pixel = _canvas.pixels[_indexes[i]];
274             if (_pixel.painter == 0x0) {
275                 //only allow when pixel is not set
276                 _setPixelInternal(_canvas, _canvasId, _indexes[i], _colors[i]);
277                 anySet = true;
278             }
279         }
280 
281         if (!anySet) {
282             //If didn't set any pixels - revert to show that transaction failed
283             revert();
284         }
285 
286         _finishCanvasIfNeeded(_canvas, _canvasId);
287     }
288 
289     /**
290     * @notice   Returns full bitmap for given canvas.
291     */
292     function getCanvasBitmap(uint32 _canvasId) external view returns (uint8[]) {
293         Canvas storage canvas = _getCanvas(_canvasId);
294         uint8[] memory result = new uint8[](PIXEL_COUNT);
295 
296         for (uint32 i = 0; i < PIXEL_COUNT; i++) {
297             result[i] = canvas.pixels[i].color;
298         }
299 
300         return result;
301     }
302 
303     /**
304     * @notice   Returns how many pixels has been already set.
305     */
306     function getCanvasPaintedPixelsCount(uint32 _canvasId) public view returns (uint32) {
307         return _getCanvas(_canvasId).paintedPixelsCount;
308     }
309 
310     function getPixelCount() external pure returns (uint) {
311         return PIXEL_COUNT;
312     }
313 
314     /**
315     * @notice   Returns amount of created canvases.
316     */
317     function getCanvasCount() public view returns (uint) {
318         return canvases.length;
319     }
320 
321     /**
322     * @notice   Returns true if the canvas has been already finished.
323     */
324     function isCanvasFinished(uint32 _canvasId) public view returns (bool) {
325         return _isCanvasFinished(_getCanvas(_canvasId));
326     }
327 
328     /**
329     * @notice   Returns the author of given pixel.
330     */
331     function getPixelAuthor(uint32 _canvasId, uint32 _pixelIndex) public view validPixelIndex(_pixelIndex) returns (address) {
332         return _getCanvas(_canvasId).pixels[_pixelIndex].painter;
333     }
334 
335     /**
336     * @notice   Returns number of pixels set by given address.
337     */
338     function getPaintedPixelsCountByAddress(address _address, uint32 _canvasId) public view returns (uint32) {
339         Canvas storage canvas = _getCanvas(_canvasId);
340         return canvas.addressToCount[_address];
341     }
342 
343     function _isCanvasFinished(Canvas canvas) internal pure returns (bool) {
344         return canvas.paintedPixelsCount == PIXEL_COUNT;
345     }
346 
347     function _getCanvas(uint32 _canvasId) internal view returns (Canvas storage) {
348         require(_canvasId < canvases.length);
349         return canvases[_canvasId];
350     }
351 
352     function _createCanvasInternal(address _bookedFor) private returns (uint canvasId) {
353         require(canvases.length < MAX_CANVAS_COUNT);
354         require(activeCanvasCount < MAX_ACTIVE_CANVAS);
355 
356         uint id = canvases.push(Canvas(STATE_NOT_FINISHED, 0x0, _bookedFor, "", 0, 0, false)) - 1;
357 
358         emit CanvasCreated(id, _bookedFor);
359         activeCanvasCount++;
360 
361         _onCanvasCreated(id);
362 
363         return id;
364     }
365 
366     function _onCanvasCreated(uint /* _canvasId */) internal {}
367 
368     /**
369     * Sets the pixel.
370     */
371     function _setPixelInternal(Canvas storage _canvas, uint32 _canvasId, uint32 _index, uint8 _color)
372     private
373     notFinished(_canvasId)
374     validPixelIndex(_index) {
375         require(_color > 0);
376         require(_canvas.bookedFor == 0x0 || _canvas.bookedFor == msg.sender);
377         if (_canvas.pixels[_index].painter != 0x0) {
378             //it means this pixel has been already set!
379             revert();
380         }
381 
382         _canvas.paintedPixelsCount++;
383         _canvas.addressToCount[msg.sender]++;
384         _canvas.pixels[_index] = Pixel(_color, msg.sender);
385 
386         emit PixelPainted(_canvasId, _index, _color, msg.sender);
387     }
388 
389     /**
390     * Marks canvas as finished if all the pixels has been already set.
391     * Starts initial bidding session.
392     */
393     function _finishCanvasIfNeeded(Canvas storage _canvas, uint32 _canvasId) private {
394         if (_isCanvasFinished(_canvas)) {
395             activeCanvasCount--;
396             _canvas.state = STATE_INITIAL_BIDDING;
397             emit CanvasFinished(_canvasId);
398         }
399     }
400 
401     struct Pixel {
402         uint8 color;
403         address painter;
404     }
405 
406     struct Canvas {
407         /**
408         * Map of all pixels.
409         */
410         mapping(uint32 => Pixel) pixels;
411 
412         uint8 state;
413 
414         /**
415         * Owner of canvas. Canvas doesn't have an owner until initial bidding ends.
416         */
417         address owner;
418 
419         /**
420         * Booked by this address. It means that only that address can draw on the canvas.
421         * 0x0 if everybody can paint on the canvas.
422         */
423         address bookedFor;
424 
425         string name;
426 
427         /**
428         * Numbers of pixels set. Canvas will be considered finished when all pixels will be set.
429         * Technically it means that setPixelsCount == PIXEL_COUNT
430         */
431         uint32 paintedPixelsCount;
432 
433         mapping(address => uint32) addressToCount;
434 
435 
436         /**
437         * Initial bidding finish time.
438         */
439         uint initialBiddingFinishTime;
440 
441         /**
442         * If commission from initial bidding has been paid.
443         */
444         bool isCommissionPaid;
445 
446         /**
447         * @dev if address has been paid a reward for drawing.
448         */
449         mapping(address => bool) isAddressPaid;
450     }
451 }
452 
453 /**
454 * @notice   Useful methods to manage canvas' state.
455 */
456 contract CanvasState is CanvasFactory {
457 
458     modifier stateBidding(uint32 _canvasId) {
459         require(getCanvasState(_canvasId) == STATE_INITIAL_BIDDING);
460         _;
461     }
462 
463     modifier stateOwned(uint32 _canvasId) {
464         require(getCanvasState(_canvasId) == STATE_OWNED);
465         _;
466     }
467 
468     /**
469     * Ensures that canvas's saved state is STATE_OWNED.
470     *
471     * Because initial bidding is based on current time, we had to find a way to
472     * trigger saving new canvas state. Every transaction (not a call) that
473     * requires state owned should use it modifier as a last one.
474     *
475     * Thank's to that, we can make sure, that canvas state gets updated.
476     */
477     modifier forceOwned(uint32 _canvasId) {
478         Canvas storage canvas = _getCanvas(_canvasId);
479         if (canvas.state != STATE_OWNED) {
480             canvas.state = STATE_OWNED;
481         }
482         _;
483     }
484 
485     /**
486     * @notice   Returns current canvas state.
487     */
488     function getCanvasState(uint32 _canvasId) public view returns (uint8) {
489         Canvas storage canvas = _getCanvas(_canvasId);
490         if (canvas.state != STATE_INITIAL_BIDDING) {
491             //if state is set to owned, or not finished
492             //it means it doesn't depend on current time -
493             //we don't have to double check
494             return canvas.state;
495         }
496 
497         //state initial bidding - as that state depends on
498         //current time, we have to double check if initial bidding
499         //hasn't finish yet
500         uint finishTime = canvas.initialBiddingFinishTime;
501         if (finishTime == 0 || finishTime > getTime()) {
502             return STATE_INITIAL_BIDDING;
503 
504         } else {
505             return STATE_OWNED;
506         }
507     }
508 
509     /**
510     * @notice   Returns all canvas' id for a given state.
511     */
512     function getCanvasByState(uint8 _state) external view returns (uint32[]) {
513         uint size;
514         if (_state == STATE_NOT_FINISHED) {
515             size = activeCanvasCount;
516         } else {
517             size = getCanvasCount() - activeCanvasCount;
518         }
519 
520         uint32[] memory result = new uint32[](size);
521         uint currentIndex = 0;
522 
523         for (uint32 i = 0; i < canvases.length; i++) {
524             if (getCanvasState(i) == _state) {
525                 result[currentIndex] = i;
526                 currentIndex++;
527             }
528         }
529 
530         return _slice(result, 0, currentIndex);
531     }
532 
533     /**
534     * Sets canvas name. Only for the owner of the canvas. Name can be an empty
535     * string which is the same as lack of the name.
536     */
537     function setCanvasName(uint32 _canvasId, string _name) external
538     stateOwned(_canvasId)
539     forceOwned(_canvasId)
540     {
541         bytes memory _strBytes = bytes(_name);
542         require(_strBytes.length <= MAX_CANVAS_NAME_LENGTH);
543 
544         Canvas storage _canvas = _getCanvas(_canvasId);
545         require(msg.sender == _canvas.owner);
546 
547         _canvas.name = _name;
548         emit CanvasNameSet(_canvasId, _name);
549     }
550 
551     /**
552     * @dev  Slices array from start (inclusive) to end (exclusive).
553     *       Doesn't modify input array.
554     */
555     function _slice(uint32[] memory _array, uint _start, uint _end) internal pure returns (uint32[]) {
556         require(_start <= _end);
557 
558         if (_start == 0 && _end == _array.length) {
559             return _array;
560         }
561 
562         uint size = _end - _start;
563         uint32[] memory sliced = new uint32[](size);
564 
565         for (uint i = 0; i < size; i++) {
566             sliced[i] = _array[i + _start];
567         }
568 
569         return sliced;
570     }
571 
572 }
573 
574 /**
575 * @notice   Keeps track of all rewards and commissions.
576 *           Commission - fee that we charge for using CryptoCanvas.
577 *           Reward - painters cut.
578 */
579 contract RewardableCanvas is CanvasState {
580 
581     /**
582     * As it's hard to operate on floating numbers, each fee will be calculated like this:
583     * PRICE * COMMISSION / COMMISSION_DIVIDER. It's impossible to keep float number here.
584     *
585     * ufixed COMMISSION = 0.039; may seem useful, but it's not possible to multiply ufixed * uint.
586     */
587     uint public constant COMMISSION = 39;
588     uint public constant TRADE_REWARD = 61;
589     uint public constant PERCENT_DIVIDER = 1000;
590 
591     event RewardAddedToWithdrawals(uint32 indexed canvasId, address indexed toAddress, uint amount);
592     event CommissionAddedToWithdrawals(uint32 indexed canvasId, uint amount);
593     event FeesUpdated(uint32 indexed canvasId, uint totalCommissions, uint totalReward);
594 
595     mapping(uint => FeeHistory) private canvasToFeeHistory;
596 
597     /**
598     * @notice   Adds all unpaid commission to the owner's pending withdrawals.
599     *           Ethers to withdraw has to be greater that 0, otherwise transaction
600     *           will be rejected.
601     *           Can be called only by the owner.
602     */
603     function addCommissionToPendingWithdrawals(uint32 _canvasId)
604     public
605     onlyOwner
606     stateOwned(_canvasId)
607     forceOwned(_canvasId) {
608         FeeHistory storage _history = _getFeeHistory(_canvasId);
609         uint _toWithdraw = calculateCommissionToWithdraw(_canvasId);
610         uint _lastIndex = _history.commissionCumulative.length - 1;
611         require(_toWithdraw > 0);
612 
613         _history.paidCommissionIndex = _lastIndex;
614         addPendingWithdrawal(owner, _toWithdraw);
615 
616         emit CommissionAddedToWithdrawals(_canvasId, _toWithdraw);
617     }
618 
619     /**
620     * @notice   Adds all unpaid rewards of the caller to his pending withdrawals.
621     *           Ethers to withdraw has to be greater that 0, otherwise transaction
622     *           will be rejected.
623     */
624     function addRewardToPendingWithdrawals(uint32 _canvasId)
625     public
626     stateOwned(_canvasId)
627     forceOwned(_canvasId) {
628         FeeHistory storage _history = _getFeeHistory(_canvasId);
629         uint _toWithdraw;
630         (_toWithdraw,) = calculateRewardToWithdraw(_canvasId, msg.sender);
631         uint _lastIndex = _history.rewardsCumulative.length - 1;
632         require(_toWithdraw > 0);
633 
634         _history.addressToPaidRewardIndex[msg.sender] = _lastIndex;
635         addPendingWithdrawal(msg.sender, _toWithdraw);
636 
637         emit RewardAddedToWithdrawals(_canvasId, msg.sender, _toWithdraw);
638     }
639 
640     /**
641     * @notice   Calculates how much of commission there is to be paid.
642     */
643     function calculateCommissionToWithdraw(uint32 _canvasId)
644     public
645     view
646     stateOwned(_canvasId)
647     returns (uint)
648     {
649         FeeHistory storage _history = _getFeeHistory(_canvasId);
650         uint _lastIndex = _history.commissionCumulative.length - 1;
651         uint _lastPaidIndex = _history.paidCommissionIndex;
652 
653         if (_lastIndex < 0) {
654             //means that FeeHistory hasn't been created yet
655             return 0;
656         }
657 
658         uint _commissionSum = _history.commissionCumulative[_lastIndex];
659         uint _lastWithdrawn = _history.commissionCumulative[_lastPaidIndex];
660 
661         uint _toWithdraw = _commissionSum - _lastWithdrawn;
662         require(_toWithdraw <= _commissionSum);
663 
664         return _toWithdraw;
665     }
666 
667     /**
668     * @notice   Calculates unpaid rewards of a given address. Returns amount to withdraw
669     *           and amount of pixels owned.
670     */
671     function calculateRewardToWithdraw(uint32 _canvasId, address _address)
672     public
673     view
674     stateOwned(_canvasId)
675     returns (
676         uint reward,
677         uint pixelsOwned
678     )
679     {
680         FeeHistory storage _history = _getFeeHistory(_canvasId);
681         uint _lastIndex = _history.rewardsCumulative.length - 1;
682         uint _lastPaidIndex = _history.addressToPaidRewardIndex[_address];
683         uint _pixelsOwned = getPaintedPixelsCountByAddress(_address, _canvasId);
684 
685         if (_lastIndex < 0) {
686             //means that FeeHistory hasn't been created yet
687             return (0, _pixelsOwned);
688         }
689 
690         uint _rewardsSum = _history.rewardsCumulative[_lastIndex];
691         uint _lastWithdrawn = _history.rewardsCumulative[_lastPaidIndex];
692 
693         // Our data structure guarantees that _commissionSum is greater or equal to _lastWithdrawn
694         uint _toWithdraw = ((_rewardsSum - _lastWithdrawn) / PIXEL_COUNT) * _pixelsOwned;
695 
696         return (_toWithdraw, _pixelsOwned);
697     }
698 
699     /**
700     * @notice   Returns total amount of commission charged for a given canvas.
701     *           It is not a commission to be withdrawn!
702     */
703     function getTotalCommission(uint32 _canvasId) external view returns (uint) {
704         require(_canvasId < canvases.length);
705         FeeHistory storage _history = canvasToFeeHistory[_canvasId];
706         uint _lastIndex = _history.commissionCumulative.length - 1;
707 
708         if (_lastIndex < 0) {
709             //means that FeeHistory hasn't been created yet
710             return 0;
711         }
712 
713         return _history.commissionCumulative[_lastIndex];
714     }
715 
716     /**
717     * @notice   Returns total amount of commission that has been already
718     *           paid (added to pending withdrawals).
719     */
720     function getCommissionWithdrawn(uint32 _canvasId) external view returns (uint) {
721         require(_canvasId < canvases.length);
722         FeeHistory storage _history = canvasToFeeHistory[_canvasId];
723         uint _index = _history.paidCommissionIndex;
724 
725         return _history.commissionCumulative[_index];
726     }
727 
728     /**
729     * @notice   Returns all rewards charged for the given canvas.
730     */
731     function getTotalRewards(uint32 _canvasId) external view returns (uint) {
732         require(_canvasId < canvases.length);
733         FeeHistory storage _history = canvasToFeeHistory[_canvasId];
734         uint _lastIndex = _history.rewardsCumulative.length - 1;
735 
736         if (_lastIndex < 0) {
737             //means that FeeHistory hasn't been created yet
738             return 0;
739         }
740 
741         return _history.rewardsCumulative[_lastIndex];
742     }
743 
744     /**
745     * @notice   Returns total amount of rewards that has been already
746     *           paid (added to pending withdrawals) by a given address.
747     */
748     function getRewardsWithdrawn(uint32 _canvasId, address _address) external view returns (uint) {
749         require(_canvasId < canvases.length);
750         FeeHistory storage _history = canvasToFeeHistory[_canvasId];
751         uint _index = _history.addressToPaidRewardIndex[_address];
752         uint _pixelsOwned = getPaintedPixelsCountByAddress(_address, _canvasId);
753 
754         if (_history.rewardsCumulative.length == 0 || _index == 0) {
755             return 0;
756         }
757 
758         return (_history.rewardsCumulative[_index] / PIXEL_COUNT) * _pixelsOwned;
759     }
760 
761     /**
762     * @notice   Calculates how the initial bidding money will be split.
763     *
764     * @return  Commission and sum of all painter rewards.
765     */
766     function splitBid(uint _amount) public pure returns (
767         uint commission,
768         uint paintersRewards
769     ){
770         uint _rewardPerPixel = ((_amount - _calculatePercent(_amount, COMMISSION))) / PIXEL_COUNT;
771         // Rewards is divisible by PIXEL_COUNT
772         uint _rewards = _rewardPerPixel * PIXEL_COUNT;
773 
774         return (_amount - _rewards, _rewards);
775     }
776 
777     /**
778     * @notice   Calculates how the money from selling canvas will be split.
779     *
780     * @return  Commission, sum of painters' rewards and a seller's profit.
781     */
782     function splitTrade(uint _amount) public pure returns (
783         uint commission,
784         uint paintersRewards,
785         uint sellerProfit
786     ){
787         uint _commission = _calculatePercent(_amount, COMMISSION);
788 
789         // We make sure that painters reward is divisible by PIXEL_COUNT.
790         // It is important to split reward across all the painters equally.
791         uint _rewardPerPixel = _calculatePercent(_amount, TRADE_REWARD) / PIXEL_COUNT;
792         uint _paintersReward = _rewardPerPixel * PIXEL_COUNT;
793 
794         uint _sellerProfit = _amount - _commission - _paintersReward;
795 
796         //check for the underflow
797         require(_sellerProfit < _amount);
798 
799         return (_commission, _paintersReward, _sellerProfit);
800     }
801 
802     /**
803     * @notice   Adds a bid to fee history. Doesn't perform any checks if the bid is valid!
804     * @return  Returns how the bid was split. Same value as _splitBid function.
805     */
806     function _registerBid(uint32 _canvasId, uint _amount) internal stateBidding(_canvasId) returns (
807         uint commission,
808         uint paintersRewards
809     ){
810         uint _commission;
811         uint _rewards;
812         (_commission, _rewards) = splitBid(_amount);
813 
814         FeeHistory storage _history = _getFeeHistory(_canvasId);
815         // We have to save the difference between new bid and a previous one.
816         // Because we save data as cumulative sum, it's enough to save
817         // only the new value.
818 
819         _history.commissionCumulative.push(_commission);
820         _history.rewardsCumulative.push(_rewards);
821 
822         return (_commission, _rewards);
823     }
824 
825     /**
826     * @notice   Adds a bid to fee history. Doesn't perform any checks if the bid is valid!
827     * @return  Returns how the trade ethers were split. Same value as splitTrade function.
828     */
829     function _registerTrade(uint32 _canvasId, uint _amount)
830     internal
831     stateOwned(_canvasId)
832     forceOwned(_canvasId)
833     returns (
834         uint commission,
835         uint paintersRewards,
836         uint sellerProfit
837     ){
838         uint _commission;
839         uint _rewards;
840         uint _sellerProfit;
841         (_commission, _rewards, _sellerProfit) = splitTrade(_amount);
842 
843         FeeHistory storage _history = _getFeeHistory(_canvasId);
844         _pushCumulative(_history.commissionCumulative, _commission);
845         _pushCumulative(_history.rewardsCumulative, _rewards);
846 
847         return (_commission, _rewards, _sellerProfit);
848     }
849 
850     function _onCanvasCreated(uint _canvasId) internal {
851         //we create a fee entrance on the moment canvas is created
852         canvasToFeeHistory[_canvasId] = FeeHistory(new uint[](1), new uint[](1), 0);
853     }
854 
855     /**
856     * @notice   Gets a fee history of a canvas.
857     */
858     function _getFeeHistory(uint32 _canvasId) private view returns (FeeHistory storage) {
859         require(_canvasId < canvases.length);
860         //fee history entry is created in onCanvasCreated() method.
861 
862         FeeHistory storage _history = canvasToFeeHistory[_canvasId];
863         return _history;
864     }
865 
866     function _pushCumulative(uint[] storage _array, uint _value) private returns (uint) {
867         uint _lastValue = _array[_array.length - 1];
868         uint _newValue = _lastValue + _value;
869         //overflow protection
870         require(_newValue >= _lastValue);
871         return _array.push(_newValue);
872     }
873 
874     /**
875     * @param    _percent - percent value mapped to scale [0-1000]
876     */
877     function _calculatePercent(uint _amount, uint _percent) private pure returns (uint) {
878         return (_amount * _percent) / PERCENT_DIVIDER;
879     }
880 
881     struct FeeHistory {
882 
883         /**
884         * @notice   Cumulative sum of all charged commissions.
885         */
886         uint[] commissionCumulative;
887 
888         /**
889         * @notice   Cumulative sum of all charged rewards.
890         */
891         uint[] rewardsCumulative;
892 
893         /**
894         * Index of last paid commission (from commissionCumulative array)
895         */
896         uint paidCommissionIndex;
897 
898         /**
899         * Mapping showing what rewards has been already paid.
900         */
901         mapping(address => uint) addressToPaidRewardIndex;
902 
903     }
904 
905 }
906 
907 /**
908 * @dev This contract takes care of initial bidding.
909 */
910 contract BiddableCanvas is RewardableCanvas {
911 
912     uint public constant BIDDING_DURATION = 48 hours;
913 
914     mapping(uint32 => Bid) bids;
915     mapping(address => uint32) addressToCount;
916 
917     uint public minimumBidAmount = 0.1 ether;
918 
919     event BidPosted(uint32 indexed canvasId, address indexed bidder, uint amount, uint finishTime);
920 
921     /**
922     * Places bid for canvas that is in the state STATE_INITIAL_BIDDING.
923     * If somebody is outbid his pending withdrawals will be to topped up.
924     */
925     function makeBid(uint32 _canvasId) external payable stateBidding(_canvasId) {
926         Canvas storage canvas = _getCanvas(_canvasId);
927         Bid storage oldBid = bids[_canvasId];
928 
929         if (msg.value < minimumBidAmount || msg.value <= oldBid.amount) {
930             revert();
931         }
932 
933         if (oldBid.bidder != 0x0 && oldBid.amount > 0) {
934             //return old bidder his money
935             addPendingWithdrawal(oldBid.bidder, oldBid.amount);
936         }
937 
938         uint finishTime = canvas.initialBiddingFinishTime;
939         if (finishTime == 0) {
940             canvas.initialBiddingFinishTime = getTime() + BIDDING_DURATION;
941         }
942 
943         bids[_canvasId] = Bid(msg.sender, msg.value);
944 
945         if (canvas.owner != 0x0) {
946             addressToCount[canvas.owner]--;
947         }
948         canvas.owner = msg.sender;
949         addressToCount[msg.sender]++;
950 
951         _registerBid(_canvasId, msg.value);
952 
953         emit BidPosted(_canvasId, msg.sender, msg.value, canvas.initialBiddingFinishTime);
954     }
955 
956     /**
957     * @notice   Returns last bid for canvas. If the initial bidding has been
958     *           already finished that will be winning offer.
959     */
960     function getLastBidForCanvas(uint32 _canvasId) external view returns (
961         uint32 canvasId,
962         address bidder,
963         uint amount,
964         uint finishTime
965     ) {
966         Bid storage bid = bids[_canvasId];
967         Canvas storage canvas = _getCanvas(_canvasId);
968 
969         return (_canvasId, bid.bidder, bid.amount, canvas.initialBiddingFinishTime);
970     }
971 
972     /**
973     * @notice   Returns number of canvases owned by the given address.
974     */
975     function balanceOf(address _owner) external view returns (uint) {
976         return addressToCount[_owner];
977     }
978 
979     /**
980     * @notice   Only for the owner of the contract. Sets minimum bid amount.
981     */
982     function setMinimumBidAmount(uint _amount) external onlyOwner {
983         minimumBidAmount = _amount;
984     }
985 
986     struct Bid {
987         address bidder;
988         uint amount;
989     }
990 
991 }
992 
993 /**
994 * @dev  This contract takes trading our artworks. Trading can happen
995 *       if artwork has been initially bought.
996 */
997 contract CanvasMarket is BiddableCanvas {
998 
999     mapping(uint32 => SellOffer) canvasForSale;
1000     mapping(uint32 => BuyOffer) buyOffers;
1001 
1002     event CanvasOfferedForSale(uint32 indexed canvasId, uint minPrice, address indexed from, address indexed to);
1003     event SellOfferCancelled(uint32 indexed canvasId, uint minPrice, address indexed from, address indexed to);
1004     event CanvasSold(uint32 indexed canvasId, uint amount, address indexed from, address indexed to);
1005     event BuyOfferMade(uint32 indexed canvasId, address indexed buyer, uint amount);
1006     event BuyOfferCancelled(uint32 indexed canvasId, address indexed buyer, uint amount);
1007 
1008     struct SellOffer {
1009         bool isForSale;
1010         address seller;
1011         uint minPrice;
1012         address onlySellTo;     // specify to sell only to a specific address
1013     }
1014 
1015     struct BuyOffer {
1016         bool hasOffer;
1017         address buyer;
1018         uint amount;
1019     }
1020 
1021     /**
1022     * @notice   Buy artwork. Artwork has to be put on sale. If buyer has bid before for
1023     *           that artwork, that bid will be canceled.
1024     */
1025     function acceptSellOffer(uint32 _canvasId)
1026     external
1027     payable
1028     stateOwned(_canvasId)
1029     forceOwned(_canvasId) {
1030 
1031         Canvas storage canvas = _getCanvas(_canvasId);
1032         SellOffer memory sellOffer = canvasForSale[_canvasId];
1033 
1034         require(msg.sender != canvas.owner);
1035         //don't sell for the owner
1036         require(sellOffer.isForSale);
1037         require(msg.value >= sellOffer.minPrice);
1038         require(sellOffer.seller == canvas.owner);
1039         //seller is no longer owner
1040         require(sellOffer.onlySellTo == 0x0 || sellOffer.onlySellTo == msg.sender);
1041         //protect from selling to unintended address
1042 
1043         uint toTransfer;
1044         (, ,toTransfer) = _registerTrade(_canvasId, msg.value);
1045 
1046         addPendingWithdrawal(sellOffer.seller, toTransfer);
1047 
1048         addressToCount[canvas.owner]--;
1049         addressToCount[msg.sender]++;
1050 
1051         canvas.owner = msg.sender;
1052         _cancelSellOfferInternal(_canvasId, false);
1053 
1054         emit CanvasSold(_canvasId, msg.value, sellOffer.seller, msg.sender);
1055 
1056         //If the buyer have placed buy offer, refund it
1057         BuyOffer memory offer = buyOffers[_canvasId];
1058         if (offer.buyer == msg.sender) {
1059             buyOffers[_canvasId] = BuyOffer(false, 0x0, 0);
1060             if (offer.amount > 0) {
1061                 //refund offer
1062                 addPendingWithdrawal(offer.buyer, offer.amount);
1063             }
1064         }
1065 
1066     }
1067 
1068     /**
1069     * @notice   Offer canvas for sale for a minimal price.
1070     *           Anybody can buy it for an amount grater or equal to min price.
1071     */
1072     function offerCanvasForSale(uint32 _canvasId, uint _minPrice) external {
1073         _offerCanvasForSaleInternal(_canvasId, _minPrice, 0x0);
1074     }
1075 
1076     /**
1077     * @notice   Offer canvas for sale to a given address. Only that address
1078     *           is allowed to buy canvas for an amount grater or equal
1079     *           to minimal price.
1080     */
1081     function offerCanvasForSaleToAddress(uint32 _canvasId, uint _minPrice, address _receiver) external {
1082         _offerCanvasForSaleInternal(_canvasId, _minPrice, _receiver);
1083     }
1084 
1085     /**
1086     * @notice   Cancels previously made sell offer. Caller has to be an owner
1087     *           of the canvas. Function will fail if there is no sell offer
1088     *           for the canvas.
1089     */
1090     function cancelSellOffer(uint32 _canvasId) external {
1091         _cancelSellOfferInternal(_canvasId, true);
1092     }
1093 
1094     /**
1095     * @notice   Places buy offer for the canvas. It cannot be called by the owner of the canvas.
1096     *           New offer has to be bigger than existing offer. Returns ethers to the previous
1097     *           bidder, if any.
1098     */
1099     function makeBuyOffer(uint32 _canvasId) external payable stateOwned(_canvasId) forceOwned(_canvasId) {
1100         Canvas storage canvas = _getCanvas(_canvasId);
1101         BuyOffer storage existing = buyOffers[_canvasId];
1102 
1103         require(canvas.owner != msg.sender);
1104         require(canvas.owner != 0x0);
1105         require(msg.value > existing.amount);
1106 
1107         if (existing.amount > 0) {
1108             //refund previous buy offer.
1109             addPendingWithdrawal(existing.buyer, existing.amount);
1110         }
1111 
1112         buyOffers[_canvasId] = BuyOffer(true, msg.sender, msg.value);
1113         emit BuyOfferMade(_canvasId, msg.sender, msg.value);
1114     }
1115 
1116     /**
1117     * @notice   Cancels previously made buy offer. Caller has to be an author
1118     *           of the offer.
1119     */
1120     function cancelBuyOffer(uint32 _canvasId) external stateOwned(_canvasId) forceOwned(_canvasId) {
1121         BuyOffer memory offer = buyOffers[_canvasId];
1122         require(offer.buyer == msg.sender);
1123 
1124         buyOffers[_canvasId] = BuyOffer(false, 0x0, 0);
1125         if (offer.amount > 0) {
1126             //refund offer
1127             addPendingWithdrawal(offer.buyer, offer.amount);
1128         }
1129 
1130         emit BuyOfferCancelled(_canvasId, offer.buyer, offer.amount);
1131     }
1132 
1133     /**
1134     * @notice   Accepts buy offer for the canvas. Caller has to be the owner
1135     *           of the canvas. You can specify minimal price, which is the
1136     *           protection against accidental calls.
1137     */
1138     function acceptBuyOffer(uint32 _canvasId, uint _minPrice) external stateOwned(_canvasId) forceOwned(_canvasId) {
1139         Canvas storage canvas = _getCanvas(_canvasId);
1140         require(canvas.owner == msg.sender);
1141 
1142         BuyOffer memory offer = buyOffers[_canvasId];
1143         require(offer.hasOffer);
1144         require(offer.amount > 0);
1145         require(offer.buyer != 0x0);
1146         require(offer.amount >= _minPrice);
1147 
1148         uint toTransfer;
1149         (, ,toTransfer) = _registerTrade(_canvasId, offer.amount);
1150 
1151         addressToCount[canvas.owner]--;
1152         addressToCount[offer.buyer]++;
1153 
1154         canvas.owner = offer.buyer;
1155         addPendingWithdrawal(msg.sender, toTransfer);
1156 
1157         buyOffers[_canvasId] = BuyOffer(false, 0x0, 0);
1158         canvasForSale[_canvasId] = SellOffer(false, 0x0, 0, 0x0);
1159 
1160         emit CanvasSold(_canvasId, offer.amount, msg.sender, offer.buyer);
1161     }
1162 
1163     /**
1164     * @notice   Returns current buy offer for the canvas.
1165     */
1166     function getCurrentBuyOffer(uint32 _canvasId)
1167     external
1168     view
1169     returns (bool hasOffer, address buyer, uint amount) {
1170         BuyOffer storage offer = buyOffers[_canvasId];
1171         return (offer.hasOffer, offer.buyer, offer.amount);
1172     }
1173 
1174     /**
1175     * @notice   Returns current sell offer for the canvas.
1176     */
1177     function getCurrentSellOffer(uint32 _canvasId)
1178     external
1179     view
1180     returns (bool isForSale, address seller, uint minPrice, address onlySellTo) {
1181 
1182         SellOffer storage offer = canvasForSale[_canvasId];
1183         return (offer.isForSale, offer.seller, offer.minPrice, offer.onlySellTo);
1184     }
1185 
1186     function _offerCanvasForSaleInternal(uint32 _canvasId, uint _minPrice, address _receiver)
1187     private
1188     stateOwned(_canvasId)
1189     forceOwned(_canvasId) {
1190 
1191         Canvas storage canvas = _getCanvas(_canvasId);
1192         require(canvas.owner == msg.sender);
1193         require(_receiver != canvas.owner);
1194 
1195         canvasForSale[_canvasId] = SellOffer(true, msg.sender, _minPrice, _receiver);
1196         emit CanvasOfferedForSale(_canvasId, _minPrice, msg.sender, _receiver);
1197     }
1198 
1199     function _cancelSellOfferInternal(uint32 _canvasId, bool emitEvent)
1200     private
1201     stateOwned(_canvasId)
1202     forceOwned(_canvasId) {
1203 
1204         Canvas storage canvas = _getCanvas(_canvasId);
1205         SellOffer memory oldOffer = canvasForSale[_canvasId];
1206 
1207         require(canvas.owner == msg.sender);
1208         require(oldOffer.isForSale);
1209         //don't allow to cancel if there is no offer
1210 
1211         canvasForSale[_canvasId] = SellOffer(false, msg.sender, 0, 0x0);
1212 
1213         if (emitEvent) {
1214             emit SellOfferCancelled(_canvasId, oldOffer.minPrice, oldOffer.seller, oldOffer.onlySellTo);
1215         }
1216     }
1217 
1218 }
1219 
1220 contract CryptoArt is CanvasMarket {
1221 
1222     function getCanvasInfo(uint32 _canvasId) external view returns (
1223         uint32 id,
1224         string name,
1225         uint32 paintedPixels,
1226         uint8 canvasState,
1227         uint initialBiddingFinishTime,
1228         address owner,
1229         address bookedFor
1230     ) {
1231         Canvas storage canvas = _getCanvas(_canvasId);
1232 
1233         return (_canvasId, canvas.name, canvas.paintedPixelsCount, getCanvasState(_canvasId),
1234         canvas.initialBiddingFinishTime, canvas.owner, canvas.bookedFor);
1235     }
1236 
1237     function getCanvasByOwner(address _owner) external view returns (uint32[]) {
1238         uint32[] memory result = new uint32[](canvases.length);
1239         uint currentIndex = 0;
1240 
1241         for (uint32 i = 0; i < canvases.length; i++) {
1242             if (getCanvasState(i) == STATE_OWNED) {
1243                 Canvas storage canvas = _getCanvas(i);
1244                 if (canvas.owner == _owner) {
1245                     result[currentIndex] = i;
1246                     currentIndex++;
1247                 }
1248             }
1249         }
1250 
1251         return _slice(result, 0, currentIndex);
1252     }
1253 
1254     /**
1255     * @notice   Returns array of canvas's ids. Returned canvases have sell offer.
1256     *           If includePrivateOffers is true, includes offers that are targeted
1257     *           only to one specified address.
1258     */
1259     function getCanvasesWithSellOffer(bool includePrivateOffers) external view returns (uint32[]) {
1260         uint32[] memory result = new uint32[](canvases.length);
1261         uint currentIndex = 0;
1262 
1263         for (uint32 i = 0; i < canvases.length; i++) {
1264             SellOffer storage offer = canvasForSale[i];
1265             if (offer.isForSale && (includePrivateOffers || offer.onlySellTo == 0x0)) {
1266                 result[currentIndex] = i;
1267                 currentIndex++;
1268             }
1269         }
1270 
1271         return _slice(result, 0, currentIndex);
1272     }
1273 
1274     /**
1275     * @notice   Returns array of all the owners of all of pixels. If some pixel hasn't
1276     *           been painted yet, 0x0 address will be returned.
1277     */
1278     function getCanvasPainters(uint32 _canvasId) external view returns (address[]) {
1279         Canvas storage canvas = _getCanvas(_canvasId);
1280         address[] memory result = new address[](PIXEL_COUNT);
1281 
1282         for (uint32 i = 0; i < PIXEL_COUNT; i++) {
1283             result[i] = canvas.pixels[i].painter;
1284         }
1285 
1286         return result;
1287     }
1288 
1289 }