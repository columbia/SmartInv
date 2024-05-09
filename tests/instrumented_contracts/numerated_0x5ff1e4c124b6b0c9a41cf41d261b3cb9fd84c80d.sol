1 // File: contracts/GodMode.sol
2 
3 /****************************************************
4  *
5  * Copyright 2018 BurzNest LLC. All rights reserved.
6  *
7  * The contents of this file are provided for review
8  * and educational purposes ONLY. You MAY NOT use,
9  * copy, distribute, or modify this software without
10  * explicit written permission from BurzNest LLC.
11  *
12  ****************************************************/
13 
14 pragma solidity ^0.4.24;
15 
16 /// @title God Mode
17 /// @author Anthony Burzillo <burz@burznest.com>
18 /// @dev This contract provides a basic interface for God
19 ///  in a contract as well as the ability for God to pause
20 ///  the contract
21 contract GodMode {
22     /// @dev Is the contract paused?
23     bool public isPaused;
24 
25     /// @dev God's address
26     address public god;
27 
28     /// @dev Only God can run this function
29     modifier onlyGod()
30     {
31         require(god == msg.sender);
32         _;
33     }
34 
35     /// @dev This function can only be run while the contract
36     ///  is not paused
37     modifier notPaused()
38     {
39         require(!isPaused);
40         _;
41     }
42 
43     /// @dev This event is fired when the contract is paused
44     event GodPaused();
45 
46     /// @dev This event is fired when the contract is unpaused
47     event GodUnpaused();
48 
49     constructor() public
50     {
51         // Make the creator of the contract God
52         god = msg.sender;
53     }
54 
55     /// @dev God can change the address of God
56     /// @param _newGod The new address for God
57     function godChangeGod(address _newGod) public onlyGod
58     {
59         god = _newGod;
60     }
61 
62     /// @dev God can pause the game
63     function godPause() public onlyGod
64     {
65         isPaused = true;
66 
67         emit GodPaused();
68     }
69 
70     /// @dev God can unpause the game
71     function godUnpause() public onlyGod
72     {
73         isPaused = false;
74 
75         emit GodUnpaused();
76     }
77 }
78 
79 // File: contracts/KingOfEthAbstractInterface.sol
80 
81 /****************************************************
82  *
83  * Copyright 2018 BurzNest LLC. All rights reserved.
84  *
85  * The contents of this file are provided for review
86  * and educational purposes ONLY. You MAY NOT use,
87  * copy, distribute, or modify this software without
88  * explicit written permission from BurzNest LLC.
89  *
90  ****************************************************/
91 
92 pragma solidity ^0.4.24;
93 
94 /// @title King of Eth Abstract Interface
95 /// @author Anthony Burzillo <burz@burznest.com>
96 /// @dev Abstract interface contract for titles and taxes
97 contract KingOfEthAbstractInterface {
98     /// @dev The address of the current King
99     address public king;
100 
101     /// @dev The address of the current Wayfarer
102     address public wayfarer;
103 
104     /// @dev Anyone can pay taxes
105     function payTaxes() public payable;
106 }
107 
108 // File: contracts/KingOfEthBlindAuctionsReferencer.sol
109 
110 /****************************************************
111  *
112  * Copyright 2018 BurzNest LLC. All rights reserved.
113  *
114  * The contents of this file are provided for review
115  * and educational purposes ONLY. You MAY NOT use,
116  * copy, distribute, or modify this software without
117  * explicit written permission from BurzNest LLC.
118  *
119  ****************************************************/
120 
121 pragma solidity ^0.4.24;
122 
123 
124 /// @title King of Eth: Blind Auctions Referencer
125 /// @author Anthony Burzillo <burz@burznest.com>
126 /// @dev This contract provides a reference to the blind auctions contract
127 contract KingOfEthBlindAuctionsReferencer is GodMode {
128     /// @dev The address of the blind auctions contract
129     address public blindAuctionsContract;
130 
131     /// @dev Only the blind auctions contract can run this
132     modifier onlyBlindAuctionsContract()
133     {
134         require(blindAuctionsContract == msg.sender);
135         _;
136     }
137 
138     /// @dev God can set a new blind auctions contract
139     /// @param _blindAuctionsContract the address of the blind auctions
140     ///  contract
141     function godSetBlindAuctionsContract(address _blindAuctionsContract)
142         public
143         onlyGod
144     {
145         blindAuctionsContract = _blindAuctionsContract;
146     }
147 }
148 
149 // File: contracts/KingOfEthOpenAuctionsReferencer.sol
150 
151 /****************************************************
152  *
153  * Copyright 2018 BurzNest LLC. All rights reserved.
154  *
155  * The contents of this file are provided for review
156  * and educational purposes ONLY. You MAY NOT use,
157  * copy, distribute, or modify this software without
158  * explicit written permission from BurzNest LLC.
159  *
160  ****************************************************/
161 
162 pragma solidity ^0.4.24;
163 
164 
165 /// @title King of Eth: Open Auctions Referencer
166 /// @author Anthony Burzillo <burz@burznest.com>
167 /// @dev This contract provides a reference to the open auctions contract
168 contract KingOfEthOpenAuctionsReferencer is GodMode {
169     /// @dev The address of the auctions contract
170     address public openAuctionsContract;
171 
172     /// @dev Only the open auctions contract can run this
173     modifier onlyOpenAuctionsContract()
174     {
175         require(openAuctionsContract == msg.sender);
176         _;
177     }
178 
179     /// @dev God can set a new auctions contract
180     function godSetOpenAuctionsContract(address _openAuctionsContract)
181         public
182         onlyGod
183     {
184         openAuctionsContract = _openAuctionsContract;
185     }
186 }
187 
188 // File: contracts/KingOfEthAuctionsReferencer.sol
189 
190 /****************************************************
191  *
192  * Copyright 2018 BurzNest LLC. All rights reserved.
193  *
194  * The contents of this file are provided for review
195  * and educational purposes ONLY. You MAY NOT use,
196  * copy, distribute, or modify this software without
197  * explicit written permission from BurzNest LLC.
198  *
199  ****************************************************/
200 
201 pragma solidity ^0.4.24;
202 
203 
204 
205 /// @title King of Eth: Auctions Referencer
206 /// @author Anthony Burzillo <burz@burznest.com>
207 /// @dev This contract provides a reference to the auctions contracts
208 contract KingOfEthAuctionsReferencer is
209       KingOfEthBlindAuctionsReferencer
210     , KingOfEthOpenAuctionsReferencer
211 {
212     /// @dev Only an auctions contract can run this
213     modifier onlyAuctionsContract()
214     {
215         require(blindAuctionsContract == msg.sender
216              || openAuctionsContract == msg.sender);
217         _;
218     }
219 }
220 
221 // File: contracts/KingOfEthReferencer.sol
222 
223 /****************************************************
224  *
225  * Copyright 2018 BurzNest LLC. All rights reserved.
226  *
227  * The contents of this file are provided for review
228  * and educational purposes ONLY. You MAY NOT use,
229  * copy, distribute, or modify this software without
230  * explicit written permission from BurzNest LLC.
231  *
232  ****************************************************/
233 
234 pragma solidity ^0.4.24;
235 
236 
237 /// @title King of Eth Referencer
238 /// @author Anthony Burzillo <burz@burznest.com>
239 /// @dev Functionality to allow contracts to reference the king contract
240 contract KingOfEthReferencer is GodMode {
241     /// @dev The address of the king contract
242     address public kingOfEthContract;
243 
244     /// @dev Only the king contract can run this
245     modifier onlyKingOfEthContract()
246     {
247         require(kingOfEthContract == msg.sender);
248         _;
249     }
250 
251     /// @dev God can change the king contract
252     /// @param _kingOfEthContract The new address
253     function godSetKingOfEthContract(address _kingOfEthContract)
254         public
255         onlyGod
256     {
257         kingOfEthContract = _kingOfEthContract;
258     }
259 }
260 
261 // File: contracts/KingOfEthBoard.sol
262 
263 /****************************************************
264  *
265  * Copyright 2018 BurzNest LLC. All rights reserved.
266  *
267  * The contents of this file are provided for review
268  * and educational purposes ONLY. You MAY NOT use,
269  * copy, distribute, or modify this software without
270  * explicit written permission from BurzNest LLC.
271  *
272  ****************************************************/
273 
274 pragma solidity ^0.4.24;
275 
276 
277 
278 
279 
280 /// @title King of Eth: Board
281 /// @author Anthony Burzillo <burz@burznest.com>
282 /// @dev Contract for board
283 contract KingOfEthBoard is
284       GodMode
285     , KingOfEthAuctionsReferencer
286     , KingOfEthReferencer
287 {
288     /// @dev x coordinate of the top left corner of the boundary
289     uint public boundX1 = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffef;
290 
291     /// @dev y coordinate of the top left corner of the boundary
292     uint public boundY1 = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffef;
293 
294     /// @dev x coordinate of the bottom right corner of the boundary
295     uint public boundX2 = 0x800000000000000000000000000000000000000000000000000000000000000f;
296 
297     /// @dev y coordinate of the bottom right corner of the boundary
298     uint public boundY2 = 0x800000000000000000000000000000000000000000000000000000000000000f;
299 
300     /// @dev Number used to divide the total number of house locations
301     /// after any expansion to yield the number of auctions that  will be
302     /// available to start for the expansion's duration
303     uint public constant auctionsAvailableDivisor = 10;
304 
305     /// @dev Amount of time the King must wait between increasing the board
306     uint public constant kingTimeBetweenIncrease = 2 weeks;
307 
308     /// @dev Amount of time the Wayfarer must wait between increasing the board
309     uint public constant wayfarerTimeBetweenIncrease = 3 weeks;
310 
311     /// @dev Amount of time that anyone but the King or Wayfarer must wait
312     ///  before increasing the board
313     uint public constant plebTimeBetweenIncrease = 4 weeks;
314 
315     /// @dev The last time the board was increased in size
316     uint public lastIncreaseTime;
317 
318     /// @dev The direction of the next increase
319     uint8 public nextIncreaseDirection;
320 
321     /// @dev The number of auctions that players may choose to start
322     ///  for this expansion
323     uint public auctionsRemaining;
324 
325     constructor() public
326     {
327         // Game is paused as God must start it
328         isPaused = true;
329 
330         // Set the auctions remaining
331         setAuctionsAvailableForBounds();
332     }
333 
334     /// @dev Fired when the board is increased in size
335     event BoardSizeIncreased(
336           address initiator
337         , uint newBoundX1
338         , uint newBoundY1
339         , uint newBoundX2
340         , uint newBoundY2
341         , uint lastIncreaseTime
342         , uint nextIncreaseDirection
343         , uint auctionsRemaining
344     );
345 
346     /// @dev Only the King can run this
347     modifier onlyKing()
348     {
349         require(KingOfEthAbstractInterface(kingOfEthContract).king() == msg.sender);
350         _;
351     }
352 
353     /// @dev Only the Wayfarer can run this
354     modifier onlyWayfarer()
355     {
356         require(KingOfEthAbstractInterface(kingOfEthContract).wayfarer() == msg.sender);
357         _;
358     }
359 
360     /// @dev Set the total auctions available
361     function setAuctionsAvailableForBounds() private
362     {
363         uint boundDiffX = boundX2 - boundX1;
364         uint boundDiffY = boundY2 - boundY1;
365 
366         auctionsRemaining = boundDiffX * boundDiffY / 2 / auctionsAvailableDivisor;
367     }
368 
369     /// @dev Increase the board's size making sure to keep steady at
370     ///  the maximum outer bounds
371     function increaseBoard() private
372     {
373         // The length of increase
374         uint _increaseLength;
375 
376         // If this increase direction is right
377         if(0 == nextIncreaseDirection)
378         {
379             _increaseLength = boundX2 - boundX1;
380             uint _updatedX2 = boundX2 + _increaseLength;
381 
382             // Stay within bounds
383             if(_updatedX2 <= boundX2 || _updatedX2 <= _increaseLength)
384             {
385                 boundX2 = ~uint(0);
386             }
387             else
388             {
389                 boundX2 = _updatedX2;
390             }
391         }
392         // If this increase direction is down
393         else if(1 == nextIncreaseDirection)
394         {
395             _increaseLength = boundY2 - boundY1;
396             uint _updatedY2 = boundY2 + _increaseLength;
397 
398             // Stay within bounds
399             if(_updatedY2 <= boundY2 || _updatedY2 <= _increaseLength)
400             {
401                 boundY2 = ~uint(0);
402             }
403             else
404             {
405                 boundY2 = _updatedY2;
406             }
407         }
408         // If this increase direction is left
409         else if(2 == nextIncreaseDirection)
410         {
411             _increaseLength = boundX2 - boundX1;
412 
413             // Stay within bounds
414             if(boundX1 <= _increaseLength)
415             {
416                 boundX1 = 0;
417             }
418             else
419             {
420                 boundX1 -= _increaseLength;
421             }
422         }
423         // If this increase direction is up
424         else if(3 == nextIncreaseDirection)
425         {
426             _increaseLength = boundY2 - boundY1;
427 
428             // Stay within bounds
429             if(boundY1 <= _increaseLength)
430             {
431                 boundY1 = 0;
432             }
433             else
434             {
435                 boundY1 -= _increaseLength;
436             }
437         }
438 
439         // The last increase time is now
440         lastIncreaseTime = now;
441 
442         // Set the next increase direction
443         nextIncreaseDirection = (nextIncreaseDirection + 1) % 4;
444 
445         // Reset the auctions available
446         setAuctionsAvailableForBounds();
447 
448         emit BoardSizeIncreased(
449               msg.sender
450             , boundX1
451             , boundY1
452             , boundX2
453             , boundY2
454             , now
455             , nextIncreaseDirection
456             , auctionsRemaining
457         );
458     }
459 
460     /// @dev God can start the game
461     function godStartGame() public onlyGod
462     {
463         // Reset increase times
464         lastIncreaseTime = now;
465 
466         // Unpause the game
467         godUnpause();
468     }
469 
470     /// @dev The auctions contracts can decrement the number
471     ///  of auctions that are available to be started
472     function auctionsDecrementAuctionsRemaining()
473         public
474         onlyAuctionsContract
475     {
476         auctionsRemaining -= 1;
477     }
478 
479     /// @dev The auctions contracts can increment the number
480     ///  of auctions that are available to be started when
481     ///  an auction ends wihout a winner
482     function auctionsIncrementAuctionsRemaining()
483         public
484         onlyAuctionsContract
485     {
486         auctionsRemaining += 1;
487     }
488 
489     /// @dev The King can increase the board much faster than the plebs
490     function kingIncreaseBoard()
491         public
492         onlyKing
493     {
494         // Require enough time has passed since the last increase
495         require(lastIncreaseTime + kingTimeBetweenIncrease < now);
496 
497         increaseBoard();
498     }
499 
500     /// @dev The Wayfarer can increase the board faster than the plebs
501     function wayfarerIncreaseBoard()
502         public
503         onlyWayfarer
504     {
505         // Require enough time has passed since the last increase
506         require(lastIncreaseTime + wayfarerTimeBetweenIncrease < now);
507 
508         increaseBoard();
509     }
510 
511     /// @dev Any old pleb can increase the board
512     function plebIncreaseBoard() public
513     {
514         // Require enough time has passed since the last increase
515         require(lastIncreaseTime + plebTimeBetweenIncrease < now);
516 
517         increaseBoard();
518     }
519 }