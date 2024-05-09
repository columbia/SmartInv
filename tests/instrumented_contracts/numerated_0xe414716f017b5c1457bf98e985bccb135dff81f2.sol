1 //                                                                                                                                                                                                         
2 contract BlockDefStorage 
3 {
4 	function getOccupies(uint8 which) public returns (int8[24])
5 	{}
6 	function getAttachesto(uint8 which) public returns (int8[48])
7     {}
8 }
9 
10 contract MapElevationRetriever 
11 {
12 	function getElevation(uint8 col, uint8 row) public constant returns (uint8)
13 	{}
14 }
15 
16 contract Etheria 
17 {
18 	// change from v0.9 - event added
19 	event TileChanged(uint8 col, uint8 row);//, address owner, string name, string status, uint lastfarm, address[] offerers, uint[] offers, int8[5][] blocks);
20 	
21     uint8 mapsize = 33;
22     Tile[33][33] tiles;
23     address creator;
24     
25     struct Tile 
26     {
27     	address owner;
28     	string name;
29     	string status;
30     	address[] offerers;
31     	uint[] offers;
32     	int8[5][] blocks; //0 = which,1 = blockx,2 = blocky,3 = blockz, 4 = color
33     	uint lastfarm;
34     	
35     	int8[3][] occupado; // the only one not reported in the //TileChanged event
36     }
37     
38     BlockDefStorage bds;
39     MapElevationRetriever mer;
40     
41     function Etheria() {
42     	creator = msg.sender;
43     	bds = BlockDefStorage(0x782bdf7015b71b64f6750796dd087fde32fd6fdc); 
44     	mer = MapElevationRetriever(0x68549d7dbb7a956f955ec1263f55494f05972a6b);
45     }
46     
47     function getOwner(uint8 col, uint8 row) public constant returns(address)
48     {
49     	return tiles[col][row].owner; // no harm if col,row are invalid
50     }
51     
52     /***
53      *     _   _   ___  ___  ___ _____            _____ _____ ___ _____ _   _ _____ 
54      *    | \ | | / _ \ |  \/  ||  ___|   ___    /  ___|_   _/ _ \_   _| | | /  ___|
55      *    |  \| |/ /_\ \| .  . || |__    ( _ )   \ `--.  | |/ /_\ \| | | | | \ `--. 
56      *    | . ` ||  _  || |\/| ||  __|   / _ \/\  `--. \ | ||  _  || | | | | |`--. \
57      *    | |\  || | | || |  | || |___  | (_>  < /\__/ / | || | | || | | |_| /\__/ /
58      *    \_| \_/\_| |_/\_|  |_/\____/   \___/\/ \____/  \_/\_| |_/\_/  \___/\____/ 
59      *                                                                              
60      *                                                                              
61      */
62     
63     function getName(uint8 col, uint8 row) public constant returns(string)
64     {
65     	return tiles[col][row].name; // no harm if col,row are invalid
66     }
67     
68     // change from v0.9 - event emission added
69     function setName(uint8 col, uint8 row, string _n) public
70     {
71     	if(isOOB(col,row)) // row and/or col was not between 0-mapsize
72     	{
73     		whathappened = 50;  
74     		return;
75     	}
76     	Tile tile = tiles[col][row];
77     	if(tile.owner != msg.sender)
78     	{
79     		whathappened = 51;
80     		return;
81     	}
82     	tile.name = _n;
83     	TileChanged(col,row);
84     	whathappened = 52;
85     	return;
86     }
87     
88     function getStatus(uint8 col, uint8 row) public constant returns(string)
89     {
90     	return tiles[col][row].status; // no harm if col,row are invalid
91     }
92     
93     // change from v0.9 - incoming money sent to creator, event emissions added
94     function setStatus(uint8 col, uint8 row, string _s) public // setting status costs 1 eth to prevent spam
95     {
96     	if(msg.value == 0)	// the only situation where we don't refund money.
97     	{
98     		whathappened = 40;
99     		return;
100     	}
101     	if(msg.value != 1000000000000000000) 
102     	{
103     		msg.sender.send(msg.value); 		// return their money
104     		whathappened = 41;
105     		return;
106     	}
107     	if(isOOB(col,row)) // row and/or col was not between 0-mapsize
108     	{
109     		msg.sender.send(msg.value); 		// return their money
110     		whathappened = 42;
111     		return;
112     	}
113     	Tile tile = tiles[col][row];
114     	if(tile.owner != msg.sender)
115     	{
116     		msg.sender.send(msg.value); 		// return their money
117     		whathappened = 43;
118     		return;
119     	}
120     	tile.status = _s;
121     	creator.send(msg.value);
122     	TileChanged(col,row);
123     	whathappened = 44;
124     	return;
125     }
126     
127     /***
128      *    ______ ___  _________  ________ _   _ _____            ___________ _____ _____ _____ _   _ _____ 
129      *    |  ___/ _ \ | ___ \  \/  |_   _| \ | |  __ \   ___    |  ___|  _  \_   _|_   _|_   _| \ | |  __ \
130      *    | |_ / /_\ \| |_/ / .  . | | | |  \| | |  \/  ( _ )   | |__ | | | | | |   | |   | | |  \| | |  \/
131      *    |  _||  _  ||    /| |\/| | | | | . ` | | __   / _ \/\ |  __|| | | | | |   | |   | | | . ` | | __ 
132      *    | |  | | | || |\ \| |  | |_| |_| |\  | |_\ \ | (_>  < | |___| |/ / _| |_  | |  _| |_| |\  | |_\ \
133      *    \_|  \_| |_/\_| \_\_|  |_/\___/\_| \_/\____/  \___/\/ \____/|___/  \___/  \_/  \___/\_| \_/\____/
134      *                                                                                                     
135      */
136     
137     // change from v0.9 - getLastFarm added
138     function getLastFarm(uint8 col, uint8 row) public constant returns (uint)
139     {
140     	return tiles[col][row].lastfarm;
141     }
142     
143     // changes from v0.9
144     // added ability to pay to farm more often
145     // added event emission
146     // first block farmed will always be a column, rest are randomized
147     function farmTile(uint8 col, uint8 row) public 
148     {
149     	if(isOOB(col,row)) // row and/or col was not between 0-mapsize
150     	{
151     		whathappened = 30;
152     		return;
153     	}
154     	Tile tile = tiles[col][row];
155         if(tile.owner != msg.sender)
156         {
157         	whathappened = 31;
158         	return;
159         }
160         if((block.number - tile.lastfarm) < 2500) // ~12 hours of blocks
161         {
162         	if(msg.value == 0)
163         	{
164         		whathappened = 32;
165         		return;
166         	}	
167         	else if(msg.value != 1000000000000000000)
168         	{	
169         		msg.sender.send(msg.value); // return their money
170         		whathappened = 34;
171         		return;
172         	}
173         	else // they paid 1 ETH
174         	{
175         		creator.send(msg.value);
176         	}	
177         	// If they haven't waited long enough, but they've paid 1 eth, let them farm again.
178         }
179         else
180         {
181         	if(msg.value > 0) // they've waited long enough but also sent money. Return it and continue normally.
182         	{
183         		msg.sender.send(msg.value); // return their money
184         	}
185         }
186         
187         // by this point, they've either waited 2500 blocks or paid 1 ETH
188         bytes32 lastblockhash = block.blockhash(block.number - 1);
189     	for(uint8 i = 0; i < 20; i++)
190     	{
191             tile.blocks.length+=1;
192             if(tile.blocks.length == 1) // The VERY FIRST block, ever for this tile
193             	tile.blocks[tile.blocks.length - 1][0] = 0; // make it a column for easy testing and tutorial
194             else
195             	tile.blocks[tile.blocks.length - 1][0] = int8(getUint8FromByte32(lastblockhash,i) % 32); // which, guaranteed 0-31
196     	    tile.blocks[tile.blocks.length - 1][1] = 0; // x
197     	    tile.blocks[tile.blocks.length - 1][2] = 0; // y
198     	    tile.blocks[tile.blocks.length - 1][3] = -1; // z
199     	    tile.blocks[tile.blocks.length - 1][4] = 0; // color
200     	}
201     	tile.lastfarm = block.number;
202     	TileChanged(col,row);
203     	whathappened = 33;
204     	return;
205     }
206     
207     // change from v0.9 - event emission added
208     function editBlock(uint8 col, uint8 row, uint index, int8[5] _block)  
209     {
210     	if(isOOB(col,row)) // row and/or col was not between 0-mapsize
211     	{
212     		whathappened = 20;
213     		return;
214     	}
215     	
216     	Tile tile = tiles[col][row];
217         if(tile.owner != msg.sender) // 1. DID THE OWNER SEND THIS MESSAGE?
218         {
219         	whathappened = 21;
220         	return;
221         }
222         if(_block[3] < 0) // 2. IS THE Z LOCATION OF THE BLOCK BELOW ZERO? BLOCKS CANNOT BE HIDDEN
223         {
224         	whathappened = 22;
225         	return;
226         }
227         
228         _block[0] = tile.blocks[index][0]; // can't change the which, so set it to whatever it already was
229 
230         int8[24] memory didoccupy = bds.getOccupies(uint8(_block[0]));
231         int8[24] memory wouldoccupy = bds.getOccupies(uint8(_block[0]));
232         
233         for(uint8 b = 0; b < 24; b+=3) // always 8 hexes, calculate the didoccupy
234  		{
235  			 wouldoccupy[b] = wouldoccupy[b]+_block[1];
236  			 wouldoccupy[b+1] = wouldoccupy[b+1]+_block[2];
237  			 if(wouldoccupy[1] % 2 != 0 && wouldoccupy[b+1] % 2 == 0) // if anchor y is odd and this hex y is even, (SW NE beam goes 11,`2`2,23,`3`4,35,`4`6,47,`5`8  ` = x value incremented by 1. Same applies to SW NE beam from 01,12,13,24,25,36,37,48)
238  				 wouldoccupy[b] = wouldoccupy[b]+1;  			   // then offset x by +1
239  			 wouldoccupy[b+2] = wouldoccupy[b+2]+_block[3];
240  			 
241  			 didoccupy[b] = didoccupy[b]+tile.blocks[index][1];
242  			 didoccupy[b+1] = didoccupy[b+1]+tile.blocks[index][2];
243  			 if(didoccupy[1] % 2 != 0 && didoccupy[b+1] % 2 == 0) // if anchor y and this hex y are both odd,
244  				 didoccupy[b] = didoccupy[b]+1; 					 // then offset x by +1
245        		didoccupy[b+2] = didoccupy[b+2]+tile.blocks[index][3];
246  		}
247         
248         if(!isValidLocation(col,row,_block, wouldoccupy))
249         {
250         	return; // whathappened is already set
251         }
252         
253         // EVERYTHING CHECKED OUT, WRITE OR OVERWRITE THE HEXES IN OCCUPADO
254         
255       	if(tile.blocks[index][3] >= 0) // If the previous z was greater than 0 (i.e. not hidden) ...
256      	{
257          	for(uint8 l = 0; l < 24; l+=3) // loop 8 times,find the previous occupado entries and overwrite them
258          	{
259          		for(uint o = 0; o < tile.occupado.length; o++)
260          		{
261          			if(didoccupy[l] == tile.occupado[o][0] && didoccupy[l+1] == tile.occupado[o][1] && didoccupy[l+2] == tile.occupado[o][2]) // x,y,z equal?
262          			{
263          				tile.occupado[o][0] = wouldoccupy[l]; // found it. Overwrite it
264          				tile.occupado[o][1] = wouldoccupy[l+1];
265          				tile.occupado[o][2] = wouldoccupy[l+2];
266          			}
267          		}
268          	}
269      	}
270      	else // previous block was hidden
271      	{
272      		for(uint8 ll = 0; ll < 24; ll+=3) // add the 8 new hexes to occupado
273          	{
274      			tile.occupado.length++;
275      			tile.occupado[tile.occupado.length-1][0] = wouldoccupy[ll];
276      			tile.occupado[tile.occupado.length-1][1] = wouldoccupy[ll+1];
277      			tile.occupado[tile.occupado.length-1][2] = wouldoccupy[ll+2];
278          	}
279      	}
280      	tile.blocks[index] = _block;
281      	TileChanged(col,row);
282     	return;
283     }
284        
285     function getBlocks(uint8 col, uint8 row) public constant returns (int8[5][])
286     {
287     	return tiles[col][row].blocks; // no harm if col,row are invalid
288     }
289    
290     /***
291      *     _________________ ___________  _____ 
292      *    |  _  |  ___|  ___|  ___| ___ \/  ___|
293      *    | | | | |_  | |_  | |__ | |_/ /\ `--. 
294      *    | | | |  _| |  _| |  __||    /  `--. \
295      *    \ \_/ / |   | |   | |___| |\ \ /\__/ /
296      *     \___/\_|   \_|   \____/\_| \_|\____/ 
297      *                                          
298      */
299     // change from v0.9 - event emission added and .push() used instead of array.length++ notation
300     function makeOffer(uint8 col, uint8 row)
301     {
302     	if(msg.value == 0) // checking this first means that we will ALWAYS need to return money on any other failure
303     	{
304     		whathappened = 1;
305     		return;
306     	}	// do nothing, just return
307     	
308     	if(isOOB(col,row)) // row and/or col was not between 0-mapsize
309     	{
310     		whathappened = 2;
311     		msg.sender.send(msg.value); 		// return their money
312     		return;
313     	}
314     	
315     	Tile tile = tiles[col][row];
316     	if(tile.owner == address(0x0000000000000000000000000000000000000000))			// if UNOWNED
317     	{	  
318     		if(msg.value != 1000000000000000000 || mer.getElevation(col,row) < 125)	// 1 ETH is the starting value. If not return; // Also, if below sea level, return. 
319     		{
320     			msg.sender.send(msg.value); 	 									// return their money
321     			whathappened = 3;
322     			return;
323     		}
324     		else
325     		{	
326     			creator.send(msg.value);     		 								// this was a valid offer, send money to contract creator
327     			tile.owner = msg.sender;  								// set tile owner to the buyer
328     			TileChanged(col,row);
329     			whathappened = 4;
330     			return;
331     		}
332     	}	
333     	else 																		// if already OWNED
334     	{
335     		if(tile.owner == msg.sender || msg.value < 10000000000000000 || msg.value > 1000000000000000000000000 || tile.offerers.length >= 10 ) // trying to make an offer on their own tile. or the offer list is full (10 max) or the value is out of range (.01 ETH - 1 mil ETH is range)
336     		{
337     			msg.sender.send(msg.value); 	 									// return the money
338     			whathappened = 5;
339     			return;
340     		}
341     		else
342     		{	
343     			for(uint8 i = 0; i < tile.offerers.length; i++)
344     			{
345     				if(tile.offerers[i] == msg.sender) 						// user has already made an offer. Update it and return;
346     				{
347     					msg.sender.send(tile.offers[i]); 					// return their previous money
348     					tile.offers[i] = msg.value; 							// set the new offer
349     					TileChanged(col,row);
350     					whathappened = 6;
351     					return;
352     				}
353     			}	
354     			// the user has not yet made an offer
355     			tile.offerers.push(msg.sender); // make room for 1 more
356     			tile.offers.push(msg.value); // make room for 1 more
357     			TileChanged(col,row);
358     			whathappened = 7;
359     			return;
360     		}
361     	}
362     }
363     
364     // change from v0.9 - deleteOffer created to combine retractOffer, rejectOffer, and removeOffer
365     function deleteOffer(uint8 col, uint8 row, uint8 i, uint amt) // index 0-10
366     {
367     	if(isOOB(col,row)) // row and/or col was not between 0-mapsize
368     	{
369     		whathappened = 70;
370     		return;
371     	}
372     	Tile tile = tiles[col][row];
373     	if(i < 0 || i > (tile.offers.length - 1)) // index oob
374     	{
375     		whathappened = 72;
376     		return;
377     	}	
378     	if(tile.owner == msg.sender || tile.offerers[i] == msg.sender) // If this is the tile owner OR the offerer of the offer at index i, they can delete the request.
379     	{	
380     		if(amt != tile.offers[i]) // to prevent conflicts of offers and deletions by multiple parties, amt must be specified and match
381     		{
382     			whathappened = 74;
383     			return;
384     		}
385     		
386     		//removeOffer(col,row,i);
387     		tile.offerers[i].send(tile.offers[i]); 				// return the money
388     		delete tile.offerers[i];   							// zero out user
389     		delete tile.offers[i];   							// zero out offer
390     		for(uint8 j = i+1; j < tile.offerers.length; j++) 	// reshape arrays after deletion
391     		{
392     			tile.offerers[j-1] = tile.offerers[j];
393     			tile.offers[j-1] = tile.offers[j];
394     		}
395     		tile.offerers.length--;
396     		tile.offers.length--;
397     		// end removeOffer
398     		
399     		TileChanged(col,row);
400         	whathappened = 73;
401     		return;
402     	}
403     	else // permission to delete denied
404     	{
405     		whathappened = 71;
406     		return;
407     	}
408     	
409     }
410     
411     // change from v0.9 - added amt check and event emission
412     function acceptOffer(uint8 col, uint8 row, uint8 i, uint amt) // accepts the offer at index (1-10)
413     {
414     	if(isOOB(col,row)) // row and/or col was not between 0-mapsize
415     	{
416     		whathappened = 80;
417     		return;
418     	}
419     	
420     	Tile tile = tiles[col][row];
421     	if(tile.owner != msg.sender) // only the owner can reject offers
422     	{
423     		whathappened = 81;
424     		return;
425     	}
426     	if(i < 0 || i > (tile.offers.length - 1)) // index oob
427     	{
428     		whathappened = 82;
429     		return;
430     	}	
431     	uint offeramount = tile.offers[i];
432     	if(amt != offeramount) // to prevent conflicts of offers and deletions by multiple parties, amt must be specified and match
433 		{
434 			whathappened = 84;
435 			return;
436 		}
437     	uint housecut = offeramount / 10;
438     	creator.send(housecut);
439     	tile.owner.send(offeramount-housecut); // send offer money to oldowner
440     	tile.owner = tile.offerers[i]; // new owner is the offerer
441     	for(uint8 j = 0; j < tile.offerers.length; j++) // return all the other offerers' offer money
442     	{
443     		if(j != i) // don't return money for the purchaser
444     			tile.offerers[j].send(tile.offers[j]);
445     	}
446     	delete tile.offerers; // delete all offerers
447     	delete tile.offers; // delete all offers
448     	TileChanged(col,row);
449     	whathappened = 83;
450     	return;
451     }
452     
453     function getOfferers(uint8 col, uint8 row) constant returns (address[])
454     {
455     	return tiles[col][row].offerers; // no harm if col,row are invalid
456     }
457     
458     function getOffers(uint8 col, uint8 row) constant returns (uint[])
459     {
460     	return tiles[col][row].offers; // no harm if col,row are invalid
461     }
462     
463     function isOOB(uint8 col, uint8 row) private constant returns (bool)
464     {
465     	if(col < 0 || col > (mapsize-1) || row < 0 || row > (mapsize-1))
466     		return true; // is out of bounds
467     }
468     
469     /***
470      *     _   _ _____ _____ _     _____ _______   __
471      *    | | | |_   _|_   _| |   |_   _|_   _\ \ / /
472      *    | | | | | |   | | | |     | |   | |  \ V / 
473      *    | | | | | |   | | | |     | |   | |   \ /  
474      *    | |_| | | |  _| |_| |_____| |_  | |   | |  
475      *     \___/  \_/  \___/\_____/\___/  \_/   \_/  
476      *                                               
477      */
478     
479     // changed from v0.9, but unused, irrelevant
480     function blockHexCoordsValid(int8 x, int8 y) private constant returns (bool)
481     {
482     	uint8 absx;
483 		uint8 absy;
484 		if(x < 0)
485 			absx = uint8(x*-1);
486 		else
487 			absx = uint8(x);
488 		if(y < 0)
489 			absy = uint8(y*-1);
490 		else
491 			absy = uint8(y);
492     	
493     	if(absy <= 33) // middle rectangle
494     	{
495     		if(y % 2 != 0 ) // odd
496     		{
497     			if(-50 <= x && x <= 49)
498     				return true;
499     		}
500     		else // even
501     		{
502     			if(absx <= 49)
503     				return true;
504     		}	
505     	}	
506     	else
507     	{	
508     		if((y >= 0 && x >= 0) || (y < 0 && x > 0)) // first or 4th quadrants
509     		{
510     			if(y % 2 != 0 ) // odd
511     			{
512     				if (((absx*2) + (absy*3)) <= 198)
513     					return true;
514     			}	
515     			else	// even
516     			{
517     				if ((((absx+1)*2) + ((absy-1)*3)) <= 198)
518     					return true;
519     			}
520     		}
521     		else
522     		{	
523     			if(y % 2 == 0 ) // even
524     			{
525     				if (((absx*2) + (absy*3)) <= 198)
526     					return true;
527     			}	
528     			else	// odd
529     			{
530     				if ((((absx+1)*2) + ((absy-1)*3)) <= 198)
531     					return true;
532     			}
533     		}
534     	}
535     	return false;
536     }
537     
538     // changed from v0.9, but unused, irrelevant
539     function isValidLocation(uint8 col, uint8 row, int8[5] _block, int8[24] wouldoccupy) private constant returns (bool)
540     {
541     	bool touches;
542     	Tile tile = tiles[col][row]; // since this is a private method, we don't need to check col,row validity
543     	
544         for(uint8 b = 0; b < 24; b+=3) // always 8 hexes, calculate the wouldoccupy and the didoccupy
545        	{
546        		if(!blockHexCoordsValid(wouldoccupy[b], wouldoccupy[b+1])) // 3. DO ANY OF THE PROPOSED HEXES FALL OUTSIDE OF THE TILE? 
547       		{
548        			whathappened = 10;
549       			return false;
550       		}
551        		for(uint o = 0; o < tile.occupado.length; o++)  // 4. DO ANY OF THE PROPOSED HEXES CONFLICT WITH ENTRIES IN OCCUPADO? 
552           	{
553       			if(wouldoccupy[b] == tile.occupado[o][0] && wouldoccupy[b+1] == tile.occupado[o][1] && wouldoccupy[b+2] == tile.occupado[o][2]) // do the x,y,z entries of each match?
554       			{
555       				whathappened = 11;
556       				return false; // this hex conflicts. The proposed block does not avoid overlap. Return false immediately.
557       			}
558           	}
559       		if(touches == false && wouldoccupy[b+2] == 0)  // 5. DO ANY OF THE BLOCKS TOUCH ANOTHER? (GROUND ONLY FOR NOW)
560       		{
561       			touches = true; // once true, always true til the end of this method. We must keep looping to check all the hexes for conflicts and tile boundaries, though, so we can't return true here.
562       		}	
563        	}
564         
565         // now if we're out of the loop and here, there were no conflicts and the block was found to be in the tile boundary.
566         // touches may be true or false, so we need to check 
567           
568         if(touches == false)  // 6. NONE OF THE OCCUPY BLOCKS TOUCHED THE GROUND. BUT MAYBE THEY TOUCH ANOTHER BLOCK?
569   		{
570           	int8[48] memory attachesto = bds.getAttachesto(uint8(_block[0]));
571           	for(uint8 a = 0; a < 48 && !touches; a+=3) // always 8 hexes, calculate the wouldoccupy and the didoccupy
572           	{
573           		if(attachesto[a] == 0 && attachesto[a+1] == 0 && attachesto[a+2] == 0) // there are no more attachestos available, break (0,0,0 signifies end)
574           			break;
575           		//attachesto[a] = attachesto[a]+_block[1];
576           		attachesto[a+1] = attachesto[a+1]+_block[2];
577            		if(attachesto[1] % 2 != 0 && attachesto[a+1] % 2 == 0) // (for attachesto, anchory is the same as for occupies, but the z is different. Nothing to worry about)
578            			attachesto[a] = attachesto[a]+1;  			       // then offset x by +1
579            		//attachesto[a+2] = attachesto[a+2]+_block[3];
580            		for(o = 0; o < tile.occupado.length && !touches; o++)
581            		{
582            			if((attachesto[a]+_block[1]) == tile.occupado[o][0] && attachesto[a+1] == tile.occupado[o][1] && (attachesto[a+2]+_block[3]) == tile.occupado[o][2]) // a valid attachesto found in occupado?
583            			{
584            				whathappened = 12;
585            				return true; // in bounds, didn't conflict and now touches is true. All good. Return.
586            			}
587            		}
588           	}
589           	whathappened = 13;
590           	return false; 
591   		}
592         else // touches was true by virtue of a z = 0 above (touching the ground). Return true;
593         {
594         	whathappened = 14;
595         	return true;
596         }	
597     }  
598 
599     // changed from v0.9, but unused, irrelevant
600     function getUint8FromByte32(bytes32 _b32, uint8 byteindex) public constant returns(uint8) {
601     	uint numdigits = 64;
602     	uint base = 16;
603     	uint digitsperbyte = 2;
604     	uint buint = uint(_b32);
605     	//uint upperpowervar = 16 ** (numdigits - (byteindex*2)); 		// @i=0 upperpowervar=16**64 (SEE EXCEPTION BELOW), @i=1 upperpowervar=16**62, @i upperpowervar=16**60
606     	uint lowerpowervar = base ** (numdigits - digitsperbyte - (byteindex*digitsperbyte));		// @i=0 upperpowervar=16**62, @i=1 upperpowervar=16**60, @i upperpowervar=16**58
607     	uint postheadchop;
608     	if(byteindex == 0)
609     		postheadchop = buint; 										//for byteindex 0, buint is just the input number. 16^64 is out of uint range, so this exception has to be made.
610     	else
611     		postheadchop = buint % (base ** (numdigits - (byteindex*digitsperbyte))); // @i=0 _b32=a1b2c3d4... postheadchop=a1b2c3d4, @i=1 postheadchop=b2c3d4, @i=2 postheadchop=c3d4
612     	return uint8((postheadchop - (postheadchop % lowerpowervar)) / lowerpowervar);
613     }
614     
615     uint8 whathappened;
616     function getWhatHappened() public constant returns (uint8)
617     {
618     	return whathappened;
619     }
620     
621    /**********
622    Standard lock-kill methods // added from v0.9
623    **********/
624    bool locked;
625    function setLocked()
626    {
627 	   locked = true;
628    }
629    function getLocked() public constant returns (bool)
630    {
631 	   return locked;
632    }
633    function kill()
634    { 
635        if (!locked && msg.sender == creator)
636            suicide(creator);  // kills this contract and sends remaining funds back to creator
637    }
638 }
639 //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
640                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
