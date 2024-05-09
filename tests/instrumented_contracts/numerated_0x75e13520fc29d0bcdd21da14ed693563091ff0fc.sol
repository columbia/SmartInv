1 pragma solidity ^0.4.8;
2 
3 //import "./ConvertLib.sol";
4 
5 contract CryptoStars {
6 
7     address owner;
8     string public standard = "STRZ";     
9     string public name;                     
10     string public symbol;  
11     uint8 public decimals;                         //Zero for this type of token
12     uint256 public totalSupply;                    //Total Supply of STRZ tokens 
13     uint256 public initialPrice;                  //Price to buy an offered star for sale
14     uint256 public transferPrice;                 //Minimum price to transfer star to another address
15     uint256 public MaxStarIndexAvailable;         //Set a maximum for range of offered stars for sale
16     uint256 public MinStarIndexAvailable;        //Set a minimum for range of offered stars for sale
17     uint public nextStarIndexToAssign = 0;
18     uint public starsRemainingToAssign = 0;
19     uint public numberOfStarsToReserve;
20     uint public numberOfStarsReserved = 0;
21 
22     mapping (uint => address) public starIndexToAddress;    
23     mapping (uint => string) public starIndexToSTRZName;        //Allowed to be set or changed by STRZ token owner
24     mapping (uint => string) public starIndexToSTRZMasterName;  //Only allowed to be set or changed by contract owner
25 
26     /* This creates an array with all balances */
27     mapping (address => uint256) public balanceOf;
28 
29     struct Offer {
30         bool isForSale;
31         uint starIndex;
32         address seller;
33         uint minValue;          // In Wei
34         address onlySellTo;     // specify to sell only to a specific person
35     }
36 
37     struct Bid {
38         bool hasBid;
39         uint starIndex;
40         address bidder;        
41         uint value;              //In Wei
42     }
43 
44     
45 
46     // A record of stars that are offered for sale at a specific minimum value, and perhaps to a specific person
47     mapping (uint => Offer) public starsOfferedForSale;
48 
49     // A record of the highest star bid
50     mapping (uint => Bid) public starBids;
51 
52     // Accounts may have credit that can be withdrawn.   Credit can be from withdrawn bids or losing bids.
53     // Credits also occur when STRZ tokens are sold.   
54     mapping (address => uint) public pendingWithdrawals;
55 
56 
57     event Assign(address indexed to, uint256 starIndex, string GivenName, string MasterName);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event StarTransfer(address indexed from, address indexed to, uint256 starIndex);
60     event StarOffered(uint indexed starIndex, uint minValue, address indexed fromAddress, address indexed toAddress);
61     event StarBidEntered(uint indexed starIndex, uint value, address indexed fromAddress);
62     event StarBidWithdrawn(uint indexed starIndex, uint value, address indexed fromAddress);
63     event StarBidAccepted(uint indexed starIndex, uint value, address indexed fromAddress);
64     event StarBought(uint indexed starIndex, uint value, address indexed fromAddress, address indexed toAddress, string GivenName, string MasterName, uint MinStarAvailable, uint MaxStarAvailable);
65     event StarNoLongerForSale(uint indexed starIndex);
66     event StarMinMax(uint MinStarAvailable, uint MaxStarAvailable, uint256 Price);
67     event NewOwner(uint indexed starIndex, address indexed toAddress);
68 
69    
70     function CryptoStars() payable {
71         
72         owner = msg.sender;
73         totalSupply = 119614;                        // Update total supply
74         starsRemainingToAssign = totalSupply;
75         numberOfStarsToReserve = 1000;
76         name = "CRYPTOSTARS";                        // Set the name for display purposes
77         symbol = "STRZ";                             // Set the symbol for display purposes
78         decimals = 0;                                // Amount of decimals for display purposes
79         initialPrice = 99000000000000000;          // Initial price when tokens are first sold 0.099 ETH
80         transferPrice = 10000000000000000;          //Set min transfer price to 0.01 ETH
81         MinStarIndexAvailable = 11500;               //Min Available Star Index for range of current offer group                                           
82         MaxStarIndexAvailable = 12000;               //Max Available Star Index for range of current offer group
83 
84         //Sol - 0
85         starIndexToSTRZMasterName[0] = "Sol";
86         starIndexToAddress[0] = owner;
87         Assign(owner, 0, starIndexToSTRZName[0], starIndexToSTRZMasterName[0]);
88 
89         //Odyssey 2001
90         starIndexToSTRZMasterName[2001] = "Odyssey";
91         starIndexToAddress[2001] = owner;
92         Assign(owner, 2001, starIndexToSTRZName[2001], starIndexToSTRZMasterName[2001]);
93 
94         //Delta Velorum - 119006
95         starIndexToSTRZMasterName[119006] = "Delta Velorum";
96         starIndexToAddress[119006] = owner;
97         Assign(owner, 119006, starIndexToSTRZName[119006], starIndexToSTRZMasterName[119006]);
98 
99         //Gamma Camelopardalis - 119088
100         starIndexToSTRZMasterName[119088] = "Gamma Camelopardalis";
101         starIndexToAddress[119088] = owner;
102         Assign(owner, 119088, starIndexToSTRZName[119088], starIndexToSTRZMasterName[119088]);
103 
104         //Capella - 119514
105         starIndexToSTRZMasterName[119514] = "Capella";
106         starIndexToAddress[119514] = owner;
107         Assign(owner, 119514, starIndexToSTRZName[119514], starIndexToSTRZMasterName[119514]);
108 
109     }
110 
111 
112     function reserveStarsForOwner(uint maxForThisRun) {              //Assign groups of stars to the owner
113         if (msg.sender != owner) throw;
114         if (numberOfStarsReserved >= numberOfStarsToReserve) throw;
115         uint numberStarsReservedThisRun = 0;
116         while (numberOfStarsReserved < numberOfStarsToReserve && numberStarsReservedThisRun < maxForThisRun) {
117             starIndexToAddress[nextStarIndexToAssign] = msg.sender;
118             Assign(msg.sender, nextStarIndexToAssign,starIndexToSTRZName[nextStarIndexToAssign], starIndexToSTRZMasterName[nextStarIndexToAssign]);
119             numberStarsReservedThisRun++;
120             nextStarIndexToAssign++;
121         }
122         starsRemainingToAssign -= numberStarsReservedThisRun;
123         numberOfStarsReserved += numberStarsReservedThisRun;
124         balanceOf[msg.sender] += numberStarsReservedThisRun;
125     }
126 
127     function setGivenName(uint starIndex, string name) {
128         if (starIndexToAddress[starIndex] != msg.sender) throw;     //Only allow star owner to change GivenName
129         starIndexToSTRZName[starIndex] = name;
130         Assign(msg.sender, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);  //Update Info
131     }
132 
133     function setMasterName(uint starIndex, string name) {
134         if (msg.sender != owner) throw;                             //Only allow contract owner to change MasterName
135         if (starIndexToAddress[starIndex] != owner) throw;          //Only allow contract owner to change MasterName if they are owner of the star
136        
137         starIndexToSTRZMasterName[starIndex] = name;
138         Assign(msg.sender, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);  //Update Info
139     }
140 
141     function getMinMax(){
142         StarMinMax(MinStarIndexAvailable,MaxStarIndexAvailable, initialPrice);
143     }
144 
145     function setMinMax(uint256 MaxStarIndexHolder, uint256 MinStarIndexHolder) {
146         if (msg.sender != owner) throw;
147         MaxStarIndexAvailable = MaxStarIndexHolder;
148         MinStarIndexAvailable = MinStarIndexHolder;
149         StarMinMax(MinStarIndexAvailable,MaxStarIndexAvailable, initialPrice);
150     }
151 
152     function setStarInitialPrice(uint256 initialPriceHolder) {
153         if (msg.sender != owner) throw;
154         initialPrice = initialPriceHolder;
155         StarMinMax(MinStarIndexAvailable,MaxStarIndexAvailable, initialPrice);
156     }
157 
158     function setTransferPrice(uint256 transferPriceHolder){
159         if (msg.sender != owner) throw;
160         transferPrice = transferPriceHolder;
161     }
162 
163     function getStar(uint starIndex, string strSTRZName, string strSTRZMasterName) {
164         if (msg.sender != owner) throw;
165        
166         if (starIndexToAddress[starIndex] != 0x0) throw;
167 
168         starIndexToSTRZName[starIndex] = strSTRZName;
169         starIndexToSTRZMasterName[starIndex] = strSTRZMasterName;
170 
171         starIndexToAddress[starIndex] = msg.sender;
172     
173         balanceOf[msg.sender]++;
174         Assign(msg.sender, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);
175     }
176 
177     
178     function transferStar(address to, uint starIndex) payable {
179         if (starIndexToAddress[starIndex] != msg.sender) throw;
180         if (msg.value < transferPrice) throw;                       // Didn't send enough ETH
181 
182         starIndexToAddress[starIndex] = to;
183         balanceOf[msg.sender]--;
184         balanceOf[to]++;
185         StarTransfer(msg.sender, to, starIndex);
186         Assign(to, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);
187         pendingWithdrawals[owner] += msg.value;
188         //kill any bids and refund bid
189         Bid bid = starBids[starIndex];
190         if (bid.hasBid) {
191             pendingWithdrawals[bid.bidder] += bid.value;
192             starBids[starIndex] = Bid(false, starIndex, 0x0, 0);
193             StarBidWithdrawn(starIndex, bid.value, to);
194         }
195         
196         //Remove any offers
197         Offer offer = starsOfferedForSale[starIndex];
198         if (offer.isForSale) {
199              starsOfferedForSale[starIndex] = Offer(false, starIndex, msg.sender, 0, 0x0);
200         }
201 
202     }
203 
204     function starNoLongerForSale(uint starIndex) {
205         if (starIndexToAddress[starIndex] != msg.sender) throw;
206         starsOfferedForSale[starIndex] = Offer(false, starIndex, msg.sender, 0, 0x0);
207         StarNoLongerForSale(starIndex);
208         Bid bid = starBids[starIndex];
209         if (bid.bidder == msg.sender ) {
210             // Kill bid and refund value
211             pendingWithdrawals[msg.sender] += bid.value;
212             starBids[starIndex] = Bid(false, starIndex, 0x0, 0);
213             StarBidWithdrawn(starIndex, bid.value, msg.sender);
214         }
215     }
216 
217     function offerStarForSale(uint starIndex, uint minSalePriceInWei) {
218         if (starIndexToAddress[starIndex] != msg.sender) throw;
219         starsOfferedForSale[starIndex] = Offer(true, starIndex, msg.sender, minSalePriceInWei, 0x0);
220         StarOffered(starIndex, minSalePriceInWei, msg.sender, 0x0);
221     }
222 
223     function offerStarForSaleToAddress(uint starIndex, uint minSalePriceInWei, address toAddress) {
224         if (starIndexToAddress[starIndex] != msg.sender) throw;
225         starsOfferedForSale[starIndex] = Offer(true, starIndex, msg.sender, minSalePriceInWei, toAddress);
226         StarOffered(starIndex, minSalePriceInWei, msg.sender, toAddress);
227     }
228 
229     //New owner buys a star that has been offered
230     function buyStar(uint starIndex) payable {
231         Offer offer = starsOfferedForSale[starIndex];
232         if (!offer.isForSale) throw;                                            // star not actually for sale
233         if (offer.onlySellTo != 0x0 && offer.onlySellTo != msg.sender) throw;   // star not supposed to be sold to this user
234         if (msg.value < offer.minValue) throw;                                  // Didn't send enough ETH
235         if (offer.seller != starIndexToAddress[starIndex]) throw;               // Seller no longer owner of star
236 
237         address seller = offer.seller;
238         
239         balanceOf[seller]--;
240         balanceOf[msg.sender]++;
241 
242         Assign(msg.sender, starIndex,starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);
243 
244         uint amountseller = msg.value*97/100;
245         uint amountowner = msg.value*3/100;           //Owner of contract receives 3% registration fee
246 
247         pendingWithdrawals[owner] += amountowner;    
248         pendingWithdrawals[seller] += amountseller;
249 
250         starIndexToAddress[starIndex] = msg.sender;
251  
252         starNoLongerForSale(starIndex);
253     
254         string STRZName = starIndexToSTRZName[starIndex];
255         string STRZMasterName = starIndexToSTRZMasterName[starIndex];
256 
257         StarBought(starIndex, msg.value, offer.seller, msg.sender, STRZName, STRZMasterName, MinStarIndexAvailable, MaxStarIndexAvailable);
258 
259         Bid bid = starBids[starIndex];
260         if (bid.bidder == msg.sender) {
261             // Kill bid and refund value
262             pendingWithdrawals[msg.sender] += bid.value;
263             starBids[starIndex] = Bid(false, starIndex, 0x0, 0);
264             StarBidWithdrawn(starIndex, bid.value, msg.sender);
265         }
266 
267     }
268 
269     function buyStarInitial(uint starIndex, string strSTRZName) payable {
270          
271     // We only allow the Nextavailable star to be sold 
272         if (starIndex > MaxStarIndexAvailable) throw;     //Above Current Offering Range
273         if (starIndex < MinStarIndexAvailable) throw;       //Below Current Offering Range
274         if (starIndexToAddress[starIndex] != 0x0) throw;    //Star is already owned
275         if (msg.value < initialPrice) throw;               // Didn't send enough ETH
276         
277         starIndexToAddress[starIndex] = msg.sender;   
278         starIndexToSTRZName[starIndex] = strSTRZName;      //Assign the star to new owner
279         
280         balanceOf[msg.sender]++;                            //Update the STRZ token balance for the new owner
281         pendingWithdrawals[owner] += msg.value;
282 
283         string STRZMasterName = starIndexToSTRZMasterName[starIndex];
284         StarBought(starIndex, msg.value, owner, msg.sender, strSTRZName, STRZMasterName ,MinStarIndexAvailable, MaxStarIndexAvailable);
285 
286         Assign(msg.sender, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);
287         //Assign(msg.sender, starIndex);
288     }
289 
290     function enterBidForStar(uint starIndex) payable {
291 
292         if (starIndex >= totalSupply) throw;             
293         if (starIndexToAddress[starIndex] == 0x0) throw;
294         if (starIndexToAddress[starIndex] == msg.sender) throw;
295         if (msg.value == 0) throw;
296 
297         Bid existing = starBids[starIndex];
298         if (msg.value <= existing.value) throw;
299         if (existing.value > 0) {
300             // Refund the failing bid
301             pendingWithdrawals[existing.bidder] += existing.value;
302         }
303 
304         starBids[starIndex] = Bid(true, starIndex, msg.sender, msg.value);
305         StarBidEntered(starIndex, msg.value, msg.sender);
306     }
307 
308     function acceptBidForStar(uint starIndex, uint minPrice) {
309         if (starIndex >= totalSupply) throw;
310         //if (!allStarsAssigned) throw;                
311         if (starIndexToAddress[starIndex] != msg.sender) throw;
312         address seller = msg.sender;
313         Bid bid = starBids[starIndex];
314         if (bid.value == 0) throw;
315         if (bid.value < minPrice) throw;
316 
317         starIndexToAddress[starIndex] = bid.bidder;
318         balanceOf[seller]--;
319         balanceOf[bid.bidder]++;
320         Transfer(seller, bid.bidder, 1);
321 
322         starsOfferedForSale[starIndex] = Offer(false, starIndex, bid.bidder, 0, 0x0);
323         
324         uint amount = bid.value;
325         uint amountseller = amount*97/100;
326         uint amountowner = amount*3/100;
327         
328         pendingWithdrawals[seller] += amountseller;
329         pendingWithdrawals[owner] += amountowner;               //Registration Fee 3%
330 
331         string STRZGivenName = starIndexToSTRZName[starIndex];
332         string STRZMasterName = starIndexToSTRZMasterName[starIndex];
333         StarBought(starIndex, bid.value, seller, bid.bidder, STRZGivenName, STRZMasterName, MinStarIndexAvailable, MaxStarIndexAvailable);
334         StarBidWithdrawn(starIndex, bid.value, bid.bidder);
335         Assign(bid.bidder, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);
336         StarNoLongerForSale(starIndex);
337 
338         starBids[starIndex] = Bid(false, starIndex, 0x0, 0);
339     }
340 
341     function withdrawBidForStar(uint starIndex) {
342         if (starIndex >= totalSupply) throw;            
343         if (starIndexToAddress[starIndex] == 0x0) throw;
344         if (starIndexToAddress[starIndex] == msg.sender) throw;
345 
346         Bid bid = starBids[starIndex];
347         if (bid.bidder != msg.sender) throw;
348         StarBidWithdrawn(starIndex, bid.value, msg.sender);
349         uint amount = bid.value;
350         starBids[starIndex] = Bid(false, starIndex, 0x0, 0);
351         // Refund the bid money
352         pendingWithdrawals[msg.sender] += amount;
353     
354     }
355 
356     function withdraw() {
357         //if (!allStarsAssigned) throw;
358         uint amount = pendingWithdrawals[msg.sender];
359         // Remember to zero the pending refund before
360         // sending to prevent re-entrancy attacks
361         pendingWithdrawals[msg.sender] = 0;
362         msg.sender.send(amount);
363     }
364 
365     function withdrawPartial(uint withdrawAmount) {
366         //Only available to owner
367         //Withdraw partial amount of the pending withdrawal
368         if (msg.sender != owner) throw;
369         if (withdrawAmount > pendingWithdrawals[msg.sender]) throw;
370 
371         pendingWithdrawals[msg.sender] -= withdrawAmount;
372         msg.sender.send(withdrawAmount);
373     }
374 }