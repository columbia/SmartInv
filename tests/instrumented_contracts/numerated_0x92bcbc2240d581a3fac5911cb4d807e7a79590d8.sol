1 pragma solidity ^0.4.11;
2 
3 contract Pixel {
4     /* This creates an array with all balances */
5     struct Section {
6         address owner;
7         uint256 price;
8         bool for_sale;
9         bool initial_purchase_done;
10         uint image_id;
11         string md5;
12         uint last_update;
13         address sell_only_to;
14         uint16 index;
15         //bytes32[10] image_data;
16     }
17     string public standard = "IPO 0.9";
18     string public constant name = "Initial Pixel Offering";
19     string public constant symbol = "IPO";
20     uint8 public constant decimals = 0;
21     mapping (address => uint256) public balanceOf;
22     mapping (address => uint256) public ethBalance;
23     address owner;
24     uint256 public ipo_price;
25     Section[10000] public sections;
26     uint256 public pool;
27     uint public mapWidth;
28     uint public mapHeight;
29     uint256 tokenTotalSupply = 10000;
30 
31     event Buy(uint section_id);
32     event NewListing(uint section_id, uint price);
33     event Delisted(uint section_id);
34     event NewImage(uint section_id);
35     event AreaPrice(uint start_section_index, uint end_section_index, uint area_price);
36     event SentValue(uint value);
37     event PriceUpdate(uint256 price);
38     event WithdrawEvent(string msg);
39 
40     function Pixel() {
41         pool = tokenTotalSupply; //Number of token / spaces
42         ipo_price = 100000000000000000; // 0.1
43         mapWidth = 1000;
44         mapHeight = 1000;
45         owner = msg.sender;
46     }
47 
48     function totalSupply() constant returns (uint totalSupply)
49     {
50         totalSupply = tokenTotalSupply;
51     }
52 
53     /// Updates a pixel section's index number
54     /// Not to be called by anyone but the contract owner
55     function updatePixelIndex(
56         uint16 _start,
57         uint16 _end
58     ) {
59         if(msg.sender != owner) throw; 
60         if(_end < _start) throw;
61         while(_start < _end)
62         {
63             sections[_start].index = _start;
64             _start++;
65         }
66     }
67 
68     /// Update the current IPO price
69     function updateIPOPrice(
70         uint256 _new_price
71     ) {
72         if(msg.sender != owner) throw;
73         ipo_price = _new_price;
74         PriceUpdate(ipo_price);
75     }
76 
77     /* Get the index to access a section object from the provided raw x,y */
78     /// Convert from a pixel's x, y coordinates to its section index
79     /// This is a helper function
80     function getSectionIndexFromRaw(
81         uint _x,
82         uint _y
83     ) returns (uint) {
84         if (_x >= mapWidth) throw;
85         if (_y >= mapHeight) throw;
86         // Convert raw x, y to section identifer x y
87         _x = _x / 10;
88         _y = _y / 10;
89         //Get section_identifier from coords
90         return _x + (_y * 100);
91     }
92 
93     /* Get the index to access a section object from its section identifier */
94     /// Get Section index based on its upper left x,y coordinates or "identifier"
95     /// coordinates
96     /// This is a helper function
97     function getSectionIndexFromIdentifier (
98         uint _x_section_identifier,
99         uint _y_section_identifier
100     ) returns (uint) {
101         if (_x_section_identifier >= (mapWidth / 10)) throw;
102         if (_y_section_identifier >= (mapHeight / 10)) throw;
103         uint index = _x_section_identifier + (_y_section_identifier * 100);
104         return index;
105     }
106 
107     /* Get x,y section_identifier from a section index */
108     /// Get Section upper left x,y coordinates or "identifier" coordinates
109     /// based on its index number
110     /// This is a helper function
111     function getIdentifierFromSectionIndex(
112         uint _index
113     ) returns (uint x, uint y) {
114         if (_index > (mapWidth * mapHeight)) throw;
115         x = _index % 100;
116         y = (_index - (_index % 100)) / 100;
117     }
118 
119     /* Check to see if Section is available for first purchase */
120     /// Returns whether a section is available for purchase at IPO price
121     function sectionAvailable(
122         uint _section_index
123     ) returns (bool) {
124         if (_section_index >= sections.length) throw;
125         Section s = sections[_section_index];
126         // The section has not been puchased previously
127         return !s.initial_purchase_done;
128     }
129 
130     /* Check to see if Section is available for purchase */
131     /// Returns whether a section is available for purchase as a market sale
132     function sectionForSale(
133         uint _section_index
134     ) returns (bool) {
135         if (_section_index >= sections.length) throw;
136         Section s = sections[_section_index];
137         // Has the user set the section as for_sale
138         if(s.for_sale)
139         {
140             // Has the owner set a "sell only to" address?
141             if(s.sell_only_to == 0x0) return true;
142             if(s.sell_only_to == msg.sender) return true;
143             return false;
144         }
145         else
146         {
147             // Not for sale
148             return false;
149         }
150     }
151 
152     /* Get the price of the Section */
153     /// Returns the price of a section at market price.
154     /// This is a helper function, it is more efficient to just access the
155     /// contract's sections attribute directly
156     function sectionPrice(
157         uint _section_index
158     ) returns (uint) {
159         if (_section_index >= sections.length) throw;
160         Section s = sections[_section_index];
161         return s.price;
162     }
163 
164     /*
165     Check to see if a region is available provided the
166     top-left (start) section and the bottom-right (end)
167     section.
168     */
169     /// Returns if a section is available for purchase, it returns the following:
170     /// bool: if the region is available for purchase
171     /// uint256: the extended price, sum of all of the market prices of the sections
172     ///   in the region
173     /// uint256: the number of sections available in the region at the IPO price
174     function regionAvailable(
175         uint _start_section_index,
176         uint _end_section_index
177     ) returns (bool available, uint extended_price, uint ipo_count) {
178         if (_end_section_index < _start_section_index) throw;
179         var (start_x, start_y) = getIdentifierFromSectionIndex(_start_section_index);
180         var (end_x, end_y) = getIdentifierFromSectionIndex(_end_section_index);
181         if (start_x >= mapWidth) throw;
182         if (start_y >= mapHeight) throw;
183         if (end_x >= mapWidth) throw;
184         if (end_y >= mapHeight) throw;
185         uint y_pos = start_y;
186         available = false;
187         extended_price = 0;
188         ipo_count = 0;
189         while (y_pos <= end_y)
190         {
191             uint x_pos = start_x;
192             while (x_pos <= end_x)
193             {
194                 uint identifier = (x_pos + (y_pos * 100));
195                 // Is this section available for first (IPO) purchase?
196                 if(sectionAvailable(identifier))
197                 {
198                     // The section is available as an IPO
199                     ipo_count = ipo_count + 1;
200                 } else
201                 {
202                     // The section has been purchased, it can only be available
203                     // as a market sale.
204                     if(sectionForSale(identifier))
205                     {
206                         extended_price = extended_price + sectionPrice(identifier);
207                     } else
208                     {
209                         available = false;
210                         //Don't return a price if there is an unavailable section
211                         //to reduce confusion
212                         extended_price = 0;
213                         ipo_count = 0;
214                         return;
215                     }
216                 }
217                 x_pos = x_pos + 1;
218             }
219             y_pos = y_pos + 1;
220         }
221         available = true;
222         return;
223     }
224 
225     /// Buy a section based on its index and set its cloud image_id and md5
226     /// This function is payable, any over payment will be withdraw-able
227     function buySection (
228         uint _section_index,
229         uint _image_id,
230         string _md5
231     ) payable {
232         if (_section_index >= sections.length) throw;
233         Section section = sections[_section_index];
234         if(!section.for_sale && section.initial_purchase_done)
235         {
236             //Section not for sale
237             throw;
238         }
239         // Process payment
240         // Is this Section on the open market?
241         if(section.initial_purchase_done)
242         {
243             // Section sold, sell for market price
244             if(msg.value < section.price)
245             {
246                 // Not enough funds were sent
247                 throw;
248             } else
249             {
250                 // Calculate Fee
251                 // We only need to change the balance if the section price is non-zero
252                 if (section.price != 0)
253                 {
254                     uint fee = section.price / 100;
255                     // Pay contract owner the fee
256                     ethBalance[owner] += fee;
257                     // Pay the section owner the price minus the fee
258                     ethBalance[section.owner] += (msg.value - fee);
259                 }
260                 // Refund any overpayment
261                 //require(msg.value > (msg.value - section.price));
262                 ethBalance[msg.sender] += (msg.value - section.price);
263                 // Owner loses a token
264                 balanceOf[section.owner]--;
265                 // Buyer gets a token
266                 balanceOf[msg.sender]++;
267             }
268         } else
269         {
270             // Initial sale, sell for IPO price
271             if(msg.value < ipo_price)
272             {
273                 // Not enough funds were sent
274                 throw;
275             } else
276             {
277                 // Pay the contract owner
278                 ethBalance[owner] += msg.value;
279                 // Refund any overpayment
280                 //require(msg.value > (msg.value - ipo_price));
281                 ethBalance[msg.sender] += (msg.value - ipo_price);
282                 // Reduce token pool
283                 pool--;
284                 // Buyer gets a token
285                 balanceOf[msg.sender]++;
286             }
287         }
288         //Payment and token transfer complete
289         //Transfer ownership and set not for sale by default
290         section.owner = msg.sender;
291         section.md5 = _md5;
292         section.image_id = _image_id;
293         section.last_update = block.timestamp;
294         section.for_sale = false;
295         section.initial_purchase_done = true; // even if not the first, we can pretend it is
296     }
297 
298     /* Buy an entire region */
299     /// Buy a region of sections starting and including the top left section index
300     /// ending at and including the bottom left section index. And set its cloud
301     /// image_id and md5. This function is payable, if the value sent is less
302     /// than the price of the region, the function will throw.
303     function buyRegion(
304         uint _start_section_index,
305         uint _end_section_index,
306         uint _image_id,
307         string _md5
308     ) payable returns (uint start_section_y, uint start_section_x,
309     uint end_section_y, uint end_section_x){
310         if (_end_section_index < _start_section_index) throw;
311         if (_start_section_index >= sections.length) throw;
312         if (_end_section_index >= sections.length) throw;
313         // ico_ammount reffers to the number of sections that are available
314         // at ICO price
315         var (available, ext_price, ico_amount) = regionAvailable(_start_section_index, _end_section_index);
316         if (!available) throw;
317 
318         // Calculate price
319         uint area_price =  ico_amount * ipo_price;
320         area_price = area_price + ext_price;
321         AreaPrice(_start_section_index, _end_section_index, area_price);
322         SentValue(msg.value);
323         if (area_price > msg.value) throw;
324 
325         // ico_ammount reffers to the amount in wei that the contract owner
326         // is owed
327         ico_amount = 0;
328         // ext_price reffers to the amount in wei that the contract owner is
329         // owed in fees from market sales
330         ext_price = 0;
331 
332         // User sent enough funds, let's go
333         start_section_x = _start_section_index % 100;
334         end_section_x = _end_section_index % 100;
335         start_section_y = _start_section_index - (_start_section_index % 100);
336         start_section_y = start_section_y / 100;
337         end_section_y = _end_section_index - (_end_section_index % 100);
338         end_section_y = end_section_y / 100;
339         uint x_pos = start_section_x;
340         while (x_pos <= end_section_x)
341         {
342             uint y_pos = start_section_y;
343             while (y_pos <= end_section_y)
344             {
345                 // Is this an IPO section?
346                 Section s = sections[x_pos + (y_pos * 100)];
347                 if (s.initial_purchase_done)
348                 {
349                     // Sale, we need to transfer balance
350                     // We only need to modify balances if the section's price
351                     // is non-zero
352                     if(s.price != 0)
353                     {
354                         // Pay the contract owner the price
355                         ethBalance[owner] += (s.price / 100);
356                         // Pay the owner the price minus the fee
357                         ethBalance[s.owner] += (s.price - (s.price / 100));
358                     }
359                     // Refund any overpayment
360                     //if(msg.value > (msg.value - s.price)) throw;
361                     ext_price += s.price;
362                     // Owner loses a token
363                     balanceOf[s.owner]--;
364                     // Buyer gets a token
365                     balanceOf[msg.sender]++;
366                 } else
367                 {
368                     // IPO we get to keep the value
369                     // Pay the contract owner
370                     ethBalance[owner] += ipo_price;
371                     // Refund any overpayment
372                     //if(msg.value > (msg.value - ipo_price)) throw;
373                     // TODO Decrease the value
374                     ico_amount += ipo_price;
375                     // Reduce token pool
376                     pool--;
377                     // Buyer gets a token
378                     balanceOf[msg.sender]++;
379                 }
380 
381                 // Payment and token transfer complete
382                 // Transfer ownership and set not for sale by default
383                 s.owner = msg.sender;
384                 s.md5 = _md5;
385                 s.image_id = _image_id;
386                 //s.last_update = block.timestamp;
387                 s.for_sale = false;
388                 s.initial_purchase_done = true; // even if not the first, we can pretend it is
389 
390                 Buy(x_pos + (y_pos * 100));
391                 // Done
392                 y_pos = y_pos + 1;
393             }
394             x_pos = x_pos + 1;
395         }
396         ethBalance[msg.sender] += msg.value - (ext_price + ico_amount);
397         return;
398     }
399 
400     /* Set the for sale flag and a price for a section */
401     /// Set an inidividual section as for sale at the provided price in wei.
402     /// The section will be available for purchase by any address.
403     function setSectionForSale(
404         uint _section_index,
405         uint256 _price
406     ) {
407         if (_section_index >= sections.length) throw;
408         Section section = sections[_section_index];
409         if(section.owner != msg.sender) throw;
410         section.price = _price;
411         section.for_sale = true;
412         section.sell_only_to = 0x0;
413         NewListing(_section_index, _price);
414     }
415 
416     /* Set the for sale flag and price for a region */
417     /// Set a section region for sale at the provided price in wei.
418     /// The sections in the region will be available for purchase by any address.
419     function setRegionForSale(
420         uint _start_section_index,
421         uint _end_section_index,
422         uint _price
423     ) {
424         if(_start_section_index > _end_section_index) throw;
425         if(_end_section_index > 9999) throw;
426         uint x_pos = _start_section_index % 100;
427         uint base_y_pos = (_start_section_index - (_start_section_index % 100)) / 100;
428         uint x_max = _end_section_index % 100;
429         uint y_max = (_end_section_index - (_end_section_index % 100)) / 100;
430         while(x_pos <= x_max)
431         {
432             uint y_pos = base_y_pos;
433             while(y_pos <= y_max)
434             {
435                 Section section = sections[x_pos + (y_pos * 100)];
436                 if(section.owner == msg.sender)
437                 {
438                     section.price = _price;
439                     section.for_sale = true;
440                     section.sell_only_to = 0x0;
441                     NewListing(x_pos + (y_pos * 100), _price);
442                 }
443                 y_pos++;
444             }
445             x_pos++;
446         }
447     }
448 
449     /* Set the for sale flag and price for a region */
450     /// Set a section region starting in the top left at the supplied start section
451     /// index to and including the supplied bottom right end section index
452     /// for sale at the provided price in wei, to the provided address.
453     /// The sections in the region will be available for purchase only by the
454     /// provided address.
455     function setRegionForSaleToAddress(
456         uint _start_section_index,
457         uint _end_section_index,
458         uint _price,
459         address _only_sell_to
460     ) {
461         if(_start_section_index > _end_section_index) throw;
462         if(_end_section_index > 9999) throw;
463         uint x_pos = _start_section_index % 100;
464         uint base_y_pos = (_start_section_index - (_start_section_index % 100)) / 100;
465         uint x_max = _end_section_index % 100;
466         uint y_max = (_end_section_index - (_end_section_index % 100)) / 100;
467         while(x_pos <= x_max)
468         {
469             uint y_pos = base_y_pos;
470             while(y_pos <= y_max)
471             {
472                 Section section = sections[x_pos + (y_pos * 100)];
473                 if(section.owner == msg.sender)
474                 {
475                     section.price = _price;
476                     section.for_sale = true;
477                     section.sell_only_to = _only_sell_to;
478                     NewListing(x_pos + (y_pos * 100), _price);
479                 }
480                 y_pos++;
481             }
482             x_pos++;
483         }
484     }
485 
486     /*
487     Set an entire region's cloud image data
488     */
489     /// Update a region of sections' cloud image_id and md5 to be redrawn on the
490     /// map starting at the top left start section index to and including the
491     /// bottom right section index. Fires a NewImage event with the top left
492     /// section index. If any sections not owned by the sender are in the region
493     /// they are ignored.
494     function setRegionImageDataCloud(
495         uint _start_section_index,
496         uint _end_section_index,
497         uint _image_id,
498         string _md5
499     ) {
500         if (_end_section_index < _start_section_index) throw;
501         var (start_x, start_y) = getIdentifierFromSectionIndex(_start_section_index);
502         var (end_x, end_y) = getIdentifierFromSectionIndex(_end_section_index);
503         if (start_x >= mapWidth) throw;
504         if (start_y >= mapHeight) throw;
505         if (end_x >= mapWidth) throw;
506         if (end_y >= mapHeight) throw;
507         uint y_pos = start_y;
508         while (y_pos <= end_y)
509         {
510             uint x_pos = start_x;
511             while (x_pos <= end_x)
512             {
513                 uint identifier = (x_pos + (y_pos * 100));
514                 Section s = sections[identifier];
515                 if(s.owner == msg.sender)
516                 {
517                     s.image_id = _image_id;
518                     s.md5 = _md5;
519                 }
520                 x_pos = x_pos + 1;
521             }
522             y_pos = y_pos + 1;
523         }
524         NewImage(_start_section_index);
525         return;
526     }
527 
528     /* Set the for sale flag and a price for a section to a specific address */
529     /// Set a single section as for sale at the provided price in wei only
530     /// to the supplied address.
531     function setSectionForSaleToAddress(
532         uint _section_index,
533         uint256 _price,
534         address _to
535     ) {
536         if (_section_index >= sections.length) throw;
537         Section section = sections[_section_index];
538         if(section.owner != msg.sender) throw;
539         section.price = _price;
540         section.for_sale = true;
541         section.sell_only_to = _to;
542         NewListing(_section_index, _price);
543     }
544 
545     /* Remove the for sale flag from a section */
546     /// Delist a section for sale. Making it no longer available on the market.
547     function unsetSectionForSale(
548         uint _section_index
549     ) {
550         if (_section_index >= sections.length) throw;
551         Section section = sections[_section_index];
552         if(section.owner != msg.sender) throw;
553         section.for_sale = false;
554         section.price = 0;
555         section.sell_only_to = 0x0;
556         Delisted(_section_index);
557     }
558 
559     /* Set the for sale flag and price for a region */
560     /// Delist a region of sections for sale. Making the sections no longer
561     /// no longer available on the market.
562     function unsetRegionForSale(
563         uint _start_section_index,
564         uint _end_section_index
565     ) {
566         if(_start_section_index > _end_section_index) throw;
567         if(_end_section_index > 9999) throw;
568         uint x_pos = _start_section_index % 100;
569         uint base_y_pos = (_start_section_index - (_start_section_index % 100)) / 100;
570         uint x_max = _end_section_index % 100;
571         uint y_max = (_end_section_index - (_end_section_index % 100)) / 100;
572         while(x_pos <= x_max)
573         {
574             uint y_pos = base_y_pos;
575             while(y_pos <= y_max)
576             {
577                 Section section = sections[x_pos + (y_pos * 100)];
578                 if(section.owner == msg.sender)
579                 {
580                     section.for_sale = false;
581                     section.price = 0;
582                     Delisted(x_pos + (y_pos * 100));
583                 }
584                 y_pos++;
585             }
586             x_pos++;
587         }
588     }
589 
590     /// Depreciated. Store the raw image data in the contract.
591     function setImageData(
592         uint _section_index
593         // bytes32 _row_zero,
594         // bytes32 _row_one,
595         // bytes32 _row_two,
596         // bytes32 _row_three,
597         // bytes32 _row_four,
598         // bytes32 _row_five,
599         // bytes32 _row_six,
600         // bytes32 _row_seven,
601         // bytes32 _row_eight,
602         // bytes32 _row_nine
603     ) {
604         if (_section_index >= sections.length) throw;
605         Section section = sections[_section_index];
606         if(section.owner != msg.sender) throw;
607         // section.image_data[0] = _row_zero;
608         // section.image_data[1] = _row_one;
609         // section.image_data[2] = _row_two;
610         // section.image_data[3] = _row_three;
611         // section.image_data[4] = _row_four;
612         // section.image_data[5] = _row_five;
613         // section.image_data[6] = _row_six;
614         // section.image_data[7] = _row_seven;
615         // section.image_data[8] = _row_eight;
616         // section.image_data[9] = _row_nine;
617         section.image_id = 0;
618         section.md5 = "";
619         section.last_update = block.timestamp;
620         NewImage(_section_index);
621     }
622 
623     /// Set a section's image data to be redrawn on the map. Fires a NewImage
624     /// event.
625     function setImageDataCloud(
626         uint _section_index,
627         uint _image_id,
628         string _md5
629     ) {
630         if (_section_index >= sections.length) throw;
631         Section section = sections[_section_index];
632         if(section.owner != msg.sender) throw;
633         section.image_id = _image_id;
634         section.md5 = _md5;
635         section.last_update = block.timestamp;
636         NewImage(_section_index);
637     }
638 
639     /// Withdraw ethereum from the sender's ethBalance.
640     function withdraw() returns (bool) {
641         var amount = ethBalance[msg.sender];
642         if (amount > 0) {
643             // It is important to set this to zero because the recipient
644             // can call this function again as part of the receiving call
645             // before `send` returns.
646             ethBalance[msg.sender] = 0;
647             WithdrawEvent("Reset Sender");
648             msg.sender.transfer(amount);
649         }
650         return true;
651     }
652 
653     /// Deposit ethereum into the sender's ethBalance. Not recommended.
654     function deposit() payable
655     {
656         ethBalance[msg.sender] += msg.value;
657     }
658 
659     /// Transfer a section and an IPO token to the supplied address.
660     function transfer(
661       address _to,
662       uint _section_index
663     ) {
664         if (_section_index > 9999) throw;
665         if (sections[_section_index].owner != msg.sender) throw;
666         if (balanceOf[_to] + 1 < balanceOf[_to]) throw;
667         sections[_section_index].owner = _to;
668         sections[_section_index].for_sale = false;
669         balanceOf[msg.sender] -= 1;
670         balanceOf[_to] += 1;
671     }
672 
673 
674 
675     /// Transfer a region of sections and IPO tokens to the supplied address.
676     function transferRegion(
677         uint _start_section_index,
678         uint _end_section_index,
679         address _to
680     ) {
681         if(_start_section_index > _end_section_index) throw;
682         if(_end_section_index > 9999) throw;
683         uint x_pos = _start_section_index % 100;
684         uint base_y_pos = (_start_section_index - (_start_section_index % 100)) / 100;
685         uint x_max = _end_section_index % 100;
686         uint y_max = (_end_section_index - (_end_section_index % 100)) / 100;
687         while(x_pos <= x_max)
688         {
689             uint y_pos = base_y_pos;
690             while(y_pos <= y_max)
691             {
692                 Section section = sections[x_pos + (y_pos * 100)];
693                 if(section.owner == msg.sender)
694                 {
695                   if (balanceOf[_to] + 1 < balanceOf[_to]) throw;
696                   section.owner = _to;
697                   section.for_sale = false;
698                   balanceOf[msg.sender] -= 1;
699                   balanceOf[_to] += 1;
700                 }
701                 y_pos++;
702             }
703             x_pos++;
704         }
705     }
706 }