1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract EthPlot is Ownable {
81 
82     /// @dev Represents a single plot (rectangle) which is owned by someone. Additionally, it contains an array
83     /// of holes which point to other PlotOwnership structs which overlap this one (and purchased a chunk of this one)
84     /// 4 24 bit numbers for + 1 address = 256 bits for storage efficiency
85     struct PlotOwnership {
86 
87         // Coordinates of the plot rectangle
88         uint24 x;
89         uint24 y;
90         uint24 w;
91         uint24 h;
92 
93         // The owner of the plot
94         address owner;
95     }
96 
97     /// @dev Represents the data which a specific plot ownership has
98     struct PlotData {
99         string ipfsHash;
100         string url;
101     }
102 
103     //----------------------State---------------------//
104 
105     // The actual coordinates and owners of plots. This array will contain all of the owned plots, with the more recent (and valid)
106     // ownership plots at the top. The other state variables point to indexes in this array
107     PlotOwnership[] private ownership;
108 
109     // Maps from the index in the ownership array to the data for this particular plot (its image and website)
110     mapping(uint256 => PlotData) private data;
111 
112     // Maps plot ID to a boolean that represents whether or not
113     // the image of the plot might be illegal and need to be blocked
114     // in the UI of Eth Plot. Defaults to false.
115     mapping (uint256 => bool) private plotBlockedTags;
116 
117     // Maps plot ID to the plot's current price price. If price is 0, the plot is not for sale. Price is Wei per pixel.
118     mapping(uint256 => uint256) private plotIdToPrice;
119 
120     // Maps plot ID to other plots IDs which which have purchased sections of this plot (a hole).
121     // Once a plot has been completely re-purchased, these holes will completely tile over the plot.
122     mapping(uint256 => uint256[]) private holes;
123     
124     //----------------------Constants---------------------//
125     uint24 constant private GRID_WIDTH = 250;
126     uint24 constant private GRID_HEIGHT = 250;
127     uint256 constant private INITIAL_PLOT_PRICE = 20000 * 1000000000; // 20000 gwei (approx. $0.01)
128 
129     // This is the maximum area of a single purchase block. This needs to be limited for the
130     // algorithm which figures out payment to function
131     uint256 constant private MAXIMUM_PURCHASE_AREA = 1000;
132       
133     //----------------------Events---------------------//
134 
135     /// @notice Inicates that a user has updated the price of their plot
136     /// @param plotId The index in the ownership array which was updated
137     /// @param newPriceInWeiPerPixel The new price of the plotId
138     /// @param owner The current owner of the plot
139     event PlotPriceUpdated(uint256 plotId, uint256 newPriceInWeiPerPixel, address indexed owner);
140 
141     /// @notice Indicates that a new plot has been purchased and added to the ownership array
142     /// @param newPlotId The id (index in the ownership array) of the new plot
143     /// @param totalPrice The total price paid in wei to all the plots which used to own this area
144     /// @param buyer The account which made the purchase 
145     event PlotPurchased(uint256 newPlotId, uint256 totalPrice, address indexed buyer);
146 
147     /// @notice Indicates that a section of a plot was purchased. Multiple PlotSectionSold events could be emitted from
148     /// a single purchase transaction
149     /// @param plotId The id (index in the ownership array) of the plot which had a section of it purchased
150     /// @param totalPrice The total price which was paid for this section
151     /// @param buyer The buyer of the section of the plot
152     /// @param seller The owner of the plot which was purchased. This is who will receive totalPrice in their account
153     event PlotSectionSold(uint256 plotId, uint256 totalPrice, address indexed buyer, address indexed seller);
154 
155     /// @notice Creates a new instance of the EthPlot contract. It assigns an initial ownership plot consisting of the entire grid
156     /// to the creator of the contract who will also receive any transaction fees.
157     constructor() public payable {
158         // Initialize the contract with a single block which the admin owns
159         ownership.push(PlotOwnership(0, 0, GRID_WIDTH, GRID_HEIGHT, owner));
160         data[0] = PlotData("Qmb51AikiN8p6JsEcCZgrV4d7C6d6uZnCmfmaT15VooUyv/img.svg", "https://www.ethplot.com/");
161         plotIdToPrice[0] = INITIAL_PLOT_PRICE;
162     }
163 
164     //---------------------- External  and Public Functions ---------------------//
165 
166     /// @notice Purchases a new plot with at the location (`purchase[0]`,`purchase[1]`) and dimensions `purchase[2]`x`purchase[2]`.
167     /// The new plot will have the data stored at ipfs hash `ipfsHash` and a website of `url`
168     /// @dev This function is the way you purchase new plots from the chain. The data is specified in a somewhat unique format to
169     /// make the execution of the contract as efficient as possible. Essentially, the caller needs to send in an array of sub-plots which
170     /// form a complete tiling of the purchased area. These sub-plots represent sections of the already existing plots this purchase is
171     /// happening on top of. The contract will validate all of this data before allowing the purchase to proceed.
172     /// @param purchase An array of exactly 4 values which represent the [x,y,width,height] of the plot to purchase
173     /// @param purchasedAreas An array of at least 4 values. Each set of 4 values represents a sub-plot which must be purchased for this
174     /// plot to be created. If the new plot to purchase overlaps in a non-rectangle pattern, multiple rectangular sub-plots from that
175     /// plot can be specified. The sub-plots must be from existing plots in descending order of that plot's index
176     /// @param areaIndices An area of indices into the ownership array which represent which plot the rectangles in purchasedAreas are
177     /// coming from. Must be equal to 1/4 the length of purchasedAreas
178     /// @param ipfsHash The hash of the image data for this plot stored in ipfs
179     /// @param url The website / url which should be associated with this plot
180     /// @param initialBuyoutPriceInWeiPerPixel The price per pixel a future buyer would have to pay to purchase an area of this plot.
181     /// Set a price of 0 to mark that this plot is not for sale
182     function purchaseAreaWithData(
183         uint24[] purchase,
184         uint24[] purchasedAreas,
185         uint256[] areaIndices,
186         string ipfsHash,
187         string url,
188         uint256 initialBuyoutPriceInWeiPerPixel) external payable {
189         
190         // Validate that all of the data makes sense and is valid, then payout the plot sellers
191         uint256 initialPurchasePrice = validatePurchaseAndDistributeFunds(purchase, purchasedAreas, areaIndices);
192 
193         // After we've validated that this purchase is valid, actually put the new plot and info in storage locations
194         uint256 newPlotIndex = addPlotAndData(purchase, ipfsHash, url, initialBuyoutPriceInWeiPerPixel);
195 
196         // Now that purchase is completed, update plots that have new holes due to this purchase
197         for (uint256 i = 0; i < areaIndices.length; i++) {
198             holes[areaIndices[i]].push(newPlotIndex);
199         }
200 
201         // Finally, emit an event to indicate that this purchase happened
202         emit PlotPurchased(newPlotIndex, initialPurchasePrice, msg.sender);
203     }
204 
205     /// @notice Updates the price per pixel of a plot which the message sender owns. A price of 0 means the plot is not for sale
206     /// @param plotIndex The index in the ownership array which we are updating. msg.sender must be the owner of this plot
207     /// @param newPriceInWeiPerPixel The new price of the plot
208     function updatePlotPrice(uint256 plotIndex, uint256 newPriceInWeiPerPixel) external {
209         require(plotIndex >= 0);
210         require(plotIndex < ownership.length);
211         require(msg.sender == ownership[plotIndex].owner);
212 
213         plotIdToPrice[plotIndex] = newPriceInWeiPerPixel;
214         emit PlotPriceUpdated(plotIndex, newPriceInWeiPerPixel, msg.sender);
215     }
216 
217     /// @notice Updates the data for a specific plot. This is only allowed by the plot's owner
218     /// @param plotIndex The index in the ownership array which we are updating. msg.sender must be the owner of this plot
219     /// @param ipfsHash The hash of the image data for this plot stored in ipfs
220     /// @param url The website / url which should be associated with this plot
221     function updatePlotData(uint256 plotIndex, string ipfsHash, string url) external {
222         require(plotIndex >= 0);
223         require(plotIndex < ownership.length);
224         require(msg.sender == ownership[plotIndex].owner);
225 
226         data[plotIndex] = PlotData(ipfsHash, url);
227     }
228 
229     // ---------------------- Public Admin Functions ---------------------//
230     
231     /// @notice Withdraws the fees which have been collected back to the contract owner, who is the only person that can call this
232     /// @param transferTo Who the transfer should go to. This must be the admin, but we pass it as a parameter to prevent a frontrunning
233     /// issue if we change ownership of the contract.
234     function withdraw(address transferTo) onlyOwner external {
235         // Prevent https://consensys.github.io/smart-contract-best-practices/known_attacks/#transaction-ordering-dependence-tod-front-running
236         require(transferTo == owner);
237 
238         uint256 currentBalance = address(this).balance;
239         owner.transfer(currentBalance);
240     }
241 
242     /// @notice Sets whether or not the image data in a plot should be blocked from the EthPlot UI. This is used to take down
243     /// illegal content if needed. The image data is not actually deleted, just no longer visible in the UI
244     /// @param plotIndex The index in the ownership array where the illegal data is located
245     /// @param plotBlocked Whether or not this data should be blocked
246     function togglePlotBlockedTag(uint256 plotIndex, bool plotBlocked) onlyOwner external {
247         require(plotIndex >= 0);
248         require(plotIndex < ownership.length);
249         plotBlockedTags[plotIndex] = plotBlocked;
250     }
251 
252     // ---------------------- Public View Functions ---------------------//
253 
254     /// @notice Gets the information for a specific plot based on its index.
255     /// @dev Due to stack too deep issues, to get all the info about a plot, you must also call getPlotData in conjunction with this
256     /// @param plotIndex The index in the ownership array to get the plot info for
257     /// @return The coordinates of this plot, the owner address, and the current buyout price of it (0 if not for sale)
258     function getPlotInfo(uint256 plotIndex) public view returns (uint24 x, uint24 y, uint24 w , uint24 h, address owner, uint256 price) {
259         require(plotIndex < ownership.length);
260         return (
261             ownership[plotIndex].x,
262             ownership[plotIndex].y,
263             ownership[plotIndex].w,
264             ownership[plotIndex].h,
265             ownership[plotIndex].owner,
266             plotIdToPrice[plotIndex]);
267     }
268 
269     /// @notice Gets the data stored with a specific plot. This includes the website, ipfs hash, and the blocked status of the image
270     /// @dev Due to stack too deep issues, to get all the info about a plot, you must also call getPlotInfo in conjunction with this
271     /// @param plotIndex The index in the ownership array to get the plot data for
272     /// @return The ipfsHash of the plot's image, the website associated with the plot, and whether or not its image is blocked
273     function getPlotData(uint256 plotIndex) public view returns (string ipfsHash, string url, bool plotBlocked) {
274         require(plotIndex < ownership.length);
275         return (data[plotIndex].url, data[plotIndex].ipfsHash, plotBlockedTags[plotIndex]);
276     }
277     
278     /// @notice Gets the length of the ownership array which represents the number of owned plots which exist
279     /// @return The number of plots which are owned on the grid
280     function ownershipLength() public view returns (uint256) {
281         return ownership.length;
282     }
283     
284     //---------------------- Private Functions ---------------------//
285 
286     /// @notice This function does a lot of the heavy lifting for validating that all of the data passed in to the purchase function is ok.
287     /// @dev It works by first validating all of the inputs and converting purchase and purchasedAreas into rectangles for easier manipulation.
288     /// Next, it validates that all of the rectangles in purchasedArea are within the area to purchase, and that they form a complete tiling of
289     /// the purchase we are making with zero overlap. Next, to prevent stack too deep errors, it delegates the work of validating that these sub-plots
290     /// are actually for sale, are valid, and pays out the previous owners of the area.
291     /// @param purchase An array of exactly 4 values which represent the [x,y,width,height] of the plot to purchase
292     /// @param purchasedAreas An array of at least 4 values. Each set of 4 values represents a sub-plot which must be purchased for this
293     /// plot to be created.
294     /// @param areaIndices An area of indices into the ownership array which represent which plot the rectangles in purchasedAreas are from
295     /// @return The amount spent to purchase all of the subplots specified in purchasedAreas
296     function validatePurchaseAndDistributeFunds(uint24[] purchase, uint24[] purchasedAreas, uint256[] areaIndices) private returns (uint256) {
297         // Validate that we were given a valid area to purchase
298         require(purchase.length == 4);
299         Geometry.Rect memory plotToPurchase = Geometry.Rect(purchase[0], purchase[1], purchase[2], purchase[3]);
300         
301         require(plotToPurchase.x < GRID_WIDTH && plotToPurchase.x >= 0);
302         require(plotToPurchase.y < GRID_HEIGHT && plotToPurchase.y >= 0);
303 
304         // No need for SafeMath here because we know plotToPurchase.x & plotToPurchase.y are less than 250 (~2^8)
305         require(plotToPurchase.w > 0 && plotToPurchase.w + plotToPurchase.x <= GRID_WIDTH);
306         require(plotToPurchase.h > 0 && plotToPurchase.h + plotToPurchase.y <= GRID_HEIGHT);
307         require(plotToPurchase.w * plotToPurchase.h < MAXIMUM_PURCHASE_AREA);
308 
309         // Validate the purchasedAreas and the purchasedArea's indices
310         require(purchasedAreas.length >= 4);
311         require(areaIndices.length > 0);
312         require(purchasedAreas.length % 4 == 0);
313         require(purchasedAreas.length / 4 == areaIndices.length);
314 
315         // Build up an array of subPlots which represent all of the sub-plots we are purchasing
316         Geometry.Rect[] memory subPlots = new Geometry.Rect[](areaIndices.length);
317 
318         uint256 totalArea = 0;
319         uint256 i = 0;
320         uint256 j = 0;
321         for (i = 0; i < areaIndices.length; i++) {
322             // Define the rectangle and add it to our collection of them
323             Geometry.Rect memory rect = Geometry.Rect(
324                 purchasedAreas[(i * 4)], purchasedAreas[(i * 4) + 1], purchasedAreas[(i * 4) + 2], purchasedAreas[(i * 4) + 3]);
325             subPlots[i] = rect;
326 
327             require(rect.w > 0);
328             require(rect.h > 0);
329 
330             // Compute the area of this rect and add it to the total area
331             totalArea = SafeMath.add(totalArea, SafeMath.mul(rect.w,rect.h));
332 
333             // Verify that this rectangle is within the bounds of the area we are trying to purchase
334             require(Geometry.rectContainedInside(rect, plotToPurchase));
335         }
336 
337         require(totalArea == plotToPurchase.w * plotToPurchase.h);
338 
339         // Next, make sure all of these do not overlap
340         for (i = 0; i < subPlots.length; i++) {
341             for (j = i + 1; j < subPlots.length; j++) {
342                 require(!Geometry.doRectanglesOverlap(subPlots[i], subPlots[j]));
343             }
344         }
345 
346         // If we have a matching area, the subPlots are all contained within what we're purchasing, and none of them overlap,
347         // we know we have a complete tiling of the plotToPurchase. Next, validate we can purchase all of these and distribute funds
348         uint256 remainingBalance = checkHolesAndDistributePurchaseFunds(subPlots, areaIndices);
349         uint256 purchasePrice = SafeMath.sub(msg.value, remainingBalance);
350         return purchasePrice;
351     }
352 
353     /// @notice Checks that the sub-plots which we are purchasing are all valid and then distributes funds to the owners of those sub-plots
354     /// @dev Since we know that the subPlots are contained within plotToPurchase, and that they don't overlap, we just need go through each one
355     /// and make sure that it is for sale and owned by the appropriate person as specified in areaIndices. We then can calculate how much to
356     /// pay out for the sub-plot as well.
357     /// @param subPlots Array of sub-plots which tiles the plotToPurchase completely
358     /// @param areaIndices Array of indices into the ownership array which correspond to who owns the subPlot at the same index of subPlots.
359     /// The array must be the same length as subPlots and go in descending order
360     /// @return The balance still remaining from the original msg.value after paying out all of the owners of the subPlots
361     function checkHolesAndDistributePurchaseFunds(Geometry.Rect[] memory subPlots, uint256[] memory areaIndices) private returns (uint256) {
362 
363         // Initialize the remaining balance to the value which was passed in here
364         uint256 remainingBalance = msg.value;
365 
366         // In order to minimize calls to transfer(), aggregate how much is owed to a single plot owner for all of their subPlots (this is 
367         // useful in the case that the buyer is overlaping with a single plot in a non-rectangular manner)
368         uint256 owedToSeller = 0;
369 
370         for (uint256 areaIndicesIndex = 0; areaIndicesIndex < areaIndices.length; areaIndicesIndex++) {
371 
372             // Get information about the plot at this index
373             uint256 ownershipIndex = areaIndices[areaIndicesIndex];
374             Geometry.Rect memory currentOwnershipRect = Geometry.Rect(
375                 ownership[ownershipIndex].x, ownership[ownershipIndex].y, ownership[ownershipIndex].w, ownership[ownershipIndex].h);
376 
377             // This is a plot the caller has declared they were going to buy. We need to verify that the subPlot is fully contained inside 
378             // the current ownership plot we are dealing with (we already know the subPlot is inside the plot to purchase)
379             require(Geometry.rectContainedInside(subPlots[areaIndicesIndex], currentOwnershipRect));
380 
381             // Next, verify that none of the holes of this plot ownership overlap with what we are trying to purchase
382             for (uint256 holeIndex = 0; holeIndex < holes[ownershipIndex].length; holeIndex++) {
383                 PlotOwnership memory holePlot = ownership[holes[ownershipIndex][holeIndex]];
384                 Geometry.Rect memory holeRect = Geometry.Rect(holePlot.x, holePlot.y, holePlot.w, holePlot.h);
385 
386                 require(!Geometry.doRectanglesOverlap(subPlots[areaIndicesIndex], holeRect));
387             }
388 
389             // Finally, add the price of this rect to the totalPrice computation
390             uint256 sectionPrice = getPriceOfPlot(subPlots[areaIndicesIndex], ownershipIndex);
391             remainingBalance = SafeMath.sub(remainingBalance, sectionPrice);
392             owedToSeller = SafeMath.add(owedToSeller, sectionPrice);
393 
394             // If this is the last one to look at, or if the next ownership index is different, payout this owner
395             if (areaIndicesIndex == areaIndices.length - 1 || ownershipIndex != areaIndices[areaIndicesIndex + 1]) {
396 
397                 // Update the balances and emit an event to indicate the chunks of this plot which were sold
398                 address(ownership[ownershipIndex].owner).transfer(owedToSeller);
399                 emit PlotSectionSold(ownershipIndex, owedToSeller, msg.sender, ownership[ownershipIndex].owner);
400                 owedToSeller = 0;
401             }
402         }
403         
404         return remainingBalance;
405     }
406 
407     /// @notice Given a rect to purchase and the plot index, return the total price to be paid. Requires that the plot is for sale
408     /// @param subPlotToPurchase The subplot of plotIndex which we want to compute the price of
409     /// @param plotIndex The index in the ownership array for this plot
410     /// @return The price that must be paid for this subPlot
411     function getPriceOfPlot(Geometry.Rect memory subPlotToPurchase, uint256 plotIndex) private view returns (uint256) {
412 
413         // Verify that this plot exists in the plot price mapping with a price.
414         uint256 plotPricePerPixel = plotIdToPrice[plotIndex];
415         require(plotPricePerPixel > 0);
416 
417         return SafeMath.mul(SafeMath.mul(subPlotToPurchase.w, subPlotToPurchase.h), plotPricePerPixel);
418     }
419 
420     /// @notice Stores the plot information and data for a newly purchased plot.
421     /// @dev All parameters are assumed to be validated before calling
422     /// @param purchase The coordinates of the plot to purchase
423     /// @param ipfsHash The hash of the image data for this plot stored in ipfs
424     /// @param url The website / url which should be associated with this plot
425     /// @param initialBuyoutPriceInWeiPerPixel The price per pixel a future buyer would have to pay to purchase an area of this plot.
426     /// @return The index in the plotOwnership array where this plot was placed
427     function addPlotAndData(uint24[] purchase, string ipfsHash, string url, uint256 initialBuyoutPriceInWeiPerPixel) private returns (uint256) {
428         uint256 newPlotIndex = ownership.length;
429 
430         // Add the new ownership to the array
431         ownership.push(PlotOwnership(purchase[0], purchase[1], purchase[2], purchase[3], msg.sender));
432 
433         // Take in the input data for the actual grid!
434         data[newPlotIndex] = PlotData(ipfsHash, url);
435 
436         // Set an initial purchase price for the new plot if it's greater than 0
437         if (initialBuyoutPriceInWeiPerPixel > 0) {
438             plotIdToPrice[newPlotIndex] = initialBuyoutPriceInWeiPerPixel;
439         }
440 
441         return newPlotIndex;
442     }
443 }
444 
445 library Geometry {
446     struct Rect {
447         uint24 x;
448         uint24 y;
449         uint24 w;
450         uint24 h;
451     }
452 
453     function doRectanglesOverlap(Rect memory a, Rect memory b) internal pure returns (bool) {
454         return a.x < b.x + b.w && a.x + a.w > b.x && a.y < b.y + b.h && a.y + a.h > b.y;
455     }
456 
457     // It is assumed that we will have called doRectanglesOverlap before calling this method and we will know they overlap
458     function computeRectOverlap(Rect memory a, Rect memory b) internal pure returns (Rect memory) {
459         Rect memory result = Rect(0, 0, 0, 0);
460 
461         // Take the greater of the x and y values;
462         result.x = a.x > b.x ? a.x : b.x;
463         result.y = a.y > b.y ? a.y : b.y;
464 
465         // Take the lesser of the x2 and y2 values
466         uint24 resultX2 = a.x + a.w < b.x + b.w ? a.x + a.w : b.x + b.w;
467         uint24 resultY2 = a.y + a.h < b.y + b.h ? a.y + a.h : b.y + b.h;
468 
469         // Set our width and height here
470         result.w = resultX2 - result.x;
471         result.h = resultY2 - result.y;
472 
473         return result;
474     }
475 
476     function rectContainedInside(Rect memory inner, Rect memory outer) internal pure returns (bool) {
477         return inner.x >= outer.x && inner.y >= outer.y && inner.x + inner.w <= outer.x + outer.w && inner.y + inner.h <= outer.y + outer.h;
478     }
479 }