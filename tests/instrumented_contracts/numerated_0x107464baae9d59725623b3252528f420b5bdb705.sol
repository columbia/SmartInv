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
108 // File: contracts/KingOfEthReferencer.sol
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
124 /// @title King of Eth Referencer
125 /// @author Anthony Burzillo <burz@burznest.com>
126 /// @dev Functionality to allow contracts to reference the king contract
127 contract KingOfEthReferencer is GodMode {
128     /// @dev The address of the king contract
129     address public kingOfEthContract;
130 
131     /// @dev Only the king contract can run this
132     modifier onlyKingOfEthContract()
133     {
134         require(kingOfEthContract == msg.sender);
135         _;
136     }
137 
138     /// @dev God can change the king contract
139     /// @param _kingOfEthContract The new address
140     function godSetKingOfEthContract(address _kingOfEthContract)
141         public
142         onlyGod
143     {
144         kingOfEthContract = _kingOfEthContract;
145     }
146 }
147 
148 // File: contracts/KingOfEthRoadsAbstractInterface.sol
149 
150 /****************************************************
151  *
152  * Copyright 2018 BurzNest LLC. All rights reserved.
153  *
154  * The contents of this file are provided for review
155  * and educational purposes ONLY. You MAY NOT use,
156  * copy, distribute, or modify this software without
157  * explicit written permission from BurzNest LLC.
158  *
159  ****************************************************/
160 
161 pragma solidity ^0.4.24;
162 
163 /// @title King of Eth: Roads Abstract Interface
164 /// @author Anthony Burzillo <burz@burznest.com>
165 /// @dev Abstract interface contract for roads
166 contract KingOfEthRoadsAbstractInterface {
167     /// @dev Get the owner of the road at some location
168     /// @param _x The x coordinate of the road
169     /// @param _y The y coordinate of the road
170     /// @param _direction The direction of the road (either
171     ///  0 for right or 1 for down)
172     /// @return The address of the owner
173     function ownerOf(uint _x, uint _y, uint8 _direction) public view returns(address);
174 
175     /// @dev The road realty contract can transfer road ownership
176     /// @param _x The x coordinate of the road
177     /// @param _y The y coordinate of the road
178     /// @param _direction The direction of the road
179     /// @param _from The previous owner of road
180     /// @param _to The new owner of road
181     function roadRealtyTransferOwnership(
182           uint _x
183         , uint _y
184         , uint8 _direction
185         , address _from
186         , address _to
187     ) public;
188 }
189 
190 // File: contracts/KingOfEthRoadsReferencer.sol
191 
192 /****************************************************
193  *
194  * Copyright 2018 BurzNest LLC. All rights reserved.
195  *
196  * The contents of this file are provided for review
197  * and educational purposes ONLY. You MAY NOT use,
198  * copy, distribute, or modify this software without
199  * explicit written permission from BurzNest LLC.
200  *
201  ****************************************************/
202 
203 pragma solidity ^0.4.24;
204 
205 
206 /// @title King of Eth: Roads Referencer
207 /// @author Anthony Burzillo <burz@burznest.com>
208 /// @dev Provides functionality to reference the roads contract
209 contract KingOfEthRoadsReferencer is GodMode {
210     /// @dev The roads contract's address
211     address public roadsContract;
212 
213     /// @dev Only the roads contract can run this function
214     modifier onlyRoadsContract()
215     {
216         require(roadsContract == msg.sender);
217         _;
218     }
219 
220     /// @dev God can set the realty contract
221     /// @param _roadsContract The new address
222     function godSetRoadsContract(address _roadsContract)
223         public
224         onlyGod
225     {
226         roadsContract = _roadsContract;
227     }
228 }
229 
230 // File: contracts/KingOfEthRoadRealty.sol
231 
232 /****************************************************
233  *
234  * Copyright 2018 BurzNest LLC. All rights reserved.
235  *
236  * The contents of this file are provided for review
237  * and educational purposes ONLY. You MAY NOT use,
238  * copy, distribute, or modify this software without
239  * explicit written permission from BurzNest LLC.
240  *
241  ****************************************************/
242 
243 pragma solidity ^0.4.24;
244 
245 
246 
247 
248 
249 
250 /// @title King of Eth: Road Realty
251 /// @author Anthony Burzillo <burz@burznest.com>
252 /// @dev Contract for controlling sales of roads
253 contract KingOfEthRoadRealty is
254       GodMode
255     , KingOfEthReferencer
256     , KingOfEthRoadsReferencer
257 {
258     /// @dev The number that divides the amount payed for any sale to produce
259     ///  the amount payed in taxes
260     uint public constant taxDivisor = 25;
261 
262     /// @dev Mapping from the x, y coordinates and the direction (0 for right and
263     ///  1 for down) of a road to the  current sale price (0 if there is no sale)
264     mapping (uint => mapping (uint => uint[2])) roadPrices;
265 
266     /// @dev Fired when there is a new road for sale
267     event RoadForSale(
268           uint x
269         , uint y
270         , uint8 direction
271         , address owner
272         , uint amount
273     );
274 
275     /// @dev Fired when the owner changes the price of a road
276     event RoadPriceChanged(
277           uint x
278         , uint y
279         , uint8 direction
280         , uint amount
281     );
282 
283     /// @dev Fired when a road is sold
284     event RoadSold(
285           uint x
286         , uint y
287         , uint8 direction
288         , address from
289         , address to
290         , uint amount
291     );
292 
293     /// @dev Fired when the sale for a road is cancelled by the owner
294     event RoadSaleCancelled(
295           uint x
296         , uint y
297         , uint8 direction
298         , address owner
299     );
300 
301     /// @dev Only the owner of the road at a location can run this
302     /// @param _x The x coordinate of the road
303     /// @param _y The y coordinate of the road
304     /// @param _direction The direction of the road
305     modifier onlyRoadOwner(uint _x, uint _y, uint8 _direction)
306     {
307         require(KingOfEthRoadsAbstractInterface(roadsContract).ownerOf(_x, _y, _direction) == msg.sender);
308         _;
309     }
310 
311     /// @dev This can only be run if there is *not* an existing sale for a road
312     ///  at a location
313     /// @param _x The x coordinate of the road
314     /// @param _y The y coordinate of the road
315     /// @param _direction The direction of the road
316     modifier noExistingRoadSale(uint _x, uint _y, uint8 _direction)
317     {
318         require(0 == roadPrices[_x][_y][_direction]);
319         _;
320     }
321 
322     /// @dev This can only be run if there is an existing sale for a house
323     ///  at a location
324     /// @param _x The x coordinate of the road
325     /// @param _y The y coordinate of the road
326     /// @param _direction The direction of the road
327     modifier existingRoadSale(uint _x, uint _y, uint8 _direction)
328     {
329         require(0 != roadPrices[_x][_y][_direction]);
330         _;
331     }
332 
333     /// @param _kingOfEthContract The address of the king contract
334     constructor(address _kingOfEthContract) public
335     {
336         kingOfEthContract = _kingOfEthContract;
337     }
338 
339     /// @dev The roads contract can cancel a sale when a road is transfered
340     ///  to another player
341     /// @param _x The x coordinate of the road
342     /// @param _y The y coordinate of the road
343     /// @param _direction The direction of the road
344     function roadsCancelRoadSale(uint _x, uint _y, uint8 _direction)
345         public
346         onlyRoadsContract
347     {
348         // If there is indeed a sale
349         if(0 != roadPrices[_x][_y][_direction])
350         {
351             // Cancel the sale
352             roadPrices[_x][_y][_direction] = 0;
353 
354             emit RoadSaleCancelled(_x, _y, _direction, msg.sender);
355         }
356     }
357 
358     /// @dev The owner of a road can start a sale
359     /// @param _x The x coordinate of the road
360     /// @param _y The y coordinate of the road
361     /// @param _direction The direction of the road
362     /// @param _askingPrice The price that must be payed by another player
363     ///  to purchase the road
364     function startRoadSale(
365           uint _x
366         , uint _y
367         , uint8 _direction
368         , uint _askingPrice
369     )
370         public
371         notPaused
372         onlyRoadOwner(_x, _y, _direction)
373         noExistingRoadSale(_x, _y, _direction)
374     {
375         // Require that the price is at least 0
376         require(0 != _askingPrice);
377 
378         // Record the price
379         roadPrices[_x][_y][_direction] = _askingPrice;
380 
381         emit RoadForSale(_x, _y, _direction, msg.sender, _askingPrice);
382     }
383 
384     /// @dev The owner of a road can change the price of a sale
385     /// @param _x The x coordinate of the road
386     /// @param _y The y coordinate of the road
387     /// @param _direction The direction of the road
388     /// @param _askingPrice The new price that must be payed by another
389     ///  player to purchase the road
390     function changeRoadPrice(
391           uint _x
392         , uint _y
393         , uint8 _direction
394         , uint _askingPrice
395     )
396         public
397         notPaused
398         onlyRoadOwner(_x, _y, _direction)
399         existingRoadSale(_x, _y, _direction)
400     {
401         // Require that the price is at least 0
402         require(0 != _askingPrice);
403 
404         // Record the price
405         roadPrices[_x][_y][_direction] = _askingPrice;
406 
407         emit RoadPriceChanged(_x, _y, _direction, _askingPrice);
408     }
409 
410     /// @dev Anyone can purchase a road as long as the sale exists
411     /// @param _x The x coordinate of the road
412     /// @param _y The y coordinate of the road
413     /// @param _direction The direction of the road
414     function purchaseRoad(uint _x, uint _y, uint8 _direction)
415         public
416         payable
417         notPaused
418         existingRoadSale(_x, _y, _direction)
419     {
420         // Require that the exact price was paid
421         require(roadPrices[_x][_y][_direction] == msg.value);
422 
423         // End the sale
424         roadPrices[_x][_y][_direction] = 0;
425 
426         // Calculate the taxes to be paid
427         uint taxCut = msg.value / taxDivisor;
428 
429         // Pay the taxes
430         KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(taxCut)();
431 
432         KingOfEthRoadsAbstractInterface _roadsContract = KingOfEthRoadsAbstractInterface(roadsContract);
433 
434         // Determine the previous owner
435         address _oldOwner = _roadsContract.ownerOf(_x, _y, _direction);
436 
437         // Send the buyer the house
438         _roadsContract.roadRealtyTransferOwnership(
439               _x
440             , _y
441             , _direction
442             , _oldOwner
443             , msg.sender
444         );
445 
446         // Send the previous owner his share
447         _oldOwner.transfer(msg.value - taxCut);
448 
449         emit RoadSold(
450               _x
451             , _y
452             , _direction
453             , _oldOwner
454             , msg.sender
455             , msg.value
456         );
457     }
458 
459     /// @dev The owner of a road can cancel a sale
460     /// @param _x The x coordinate of the road
461     /// @param _y The y coordinate of the road
462     /// @param _direction The direction of the road
463     function cancelRoadSale(uint _x, uint _y, uint8 _direction)
464         public
465         notPaused
466         onlyRoadOwner(_x, _y, _direction)
467         existingRoadSale(_x, _y, _direction)
468     {
469         // Cancel the sale
470         roadPrices[_x][_y][_direction] = 0;
471 
472         emit RoadSaleCancelled(_x, _y, _direction, msg.sender);
473     }
474 }