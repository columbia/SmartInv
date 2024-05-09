1 pragma solidity ^0.4.12;
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
109         Transfer(0x0, owner, 5);
110 
111         balanceOf[msg.sender] = 5;
112 
113     }
114 
115 
116     function reserveStarsForOwner(uint maxForThisRun) {              //Assign groups of stars to the owner
117         if (msg.sender != owner) throw;
118         if (numberOfStarsReserved >= numberOfStarsToReserve) throw;
119         uint numberStarsReservedThisRun = 0;
120         while (numberOfStarsReserved < numberOfStarsToReserve && numberStarsReservedThisRun < maxForThisRun) {
121             starIndexToAddress[nextStarIndexToAssign] = msg.sender;
122             Assign(msg.sender, nextStarIndexToAssign,starIndexToSTRZName[nextStarIndexToAssign], starIndexToSTRZMasterName[nextStarIndexToAssign]);
123             Transfer(0x0, msg.sender, 1);
124             numberStarsReservedThisRun++;
125             nextStarIndexToAssign++;
126         }
127         starsRemainingToAssign -= numberStarsReservedThisRun;
128         numberOfStarsReserved += numberStarsReservedThisRun;
129         balanceOf[msg.sender] += numberStarsReservedThisRun;
130     }
131 
132     function setGivenName(uint starIndex, string name) {
133         if (starIndexToAddress[starIndex] != msg.sender) throw;     //Only allow star owner to change GivenName
134         starIndexToSTRZName[starIndex] = name;
135         Assign(msg.sender, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);  //Update Info
136     }
137 
138     function setMasterName(uint starIndex, string name) {
139         if (msg.sender != owner) throw;                             //Only allow contract owner to change MasterName
140         if (starIndexToAddress[starIndex] != owner) throw;          //Only allow contract owner to change MasterName if they are owner of the star
141        
142         starIndexToSTRZMasterName[starIndex] = name;
143         Assign(msg.sender, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);  //Update Info
144     }
145 
146     function getMinMax(){
147         StarMinMax(MinStarIndexAvailable,MaxStarIndexAvailable, initialPrice);
148     }
149 
150     function setMinMax(uint256 MaxStarIndexHolder, uint256 MinStarIndexHolder) {
151         if (msg.sender != owner) throw;
152         MaxStarIndexAvailable = MaxStarIndexHolder;
153         MinStarIndexAvailable = MinStarIndexHolder;
154         StarMinMax(MinStarIndexAvailable,MaxStarIndexAvailable, initialPrice);
155     }
156 
157     function setStarInitialPrice(uint256 initialPriceHolder) {
158         if (msg.sender != owner) throw;
159         initialPrice = initialPriceHolder;
160         StarMinMax(MinStarIndexAvailable,MaxStarIndexAvailable, initialPrice);
161     }
162 
163     function setTransferPrice(uint256 transferPriceHolder){
164         if (msg.sender != owner) throw;
165         transferPrice = transferPriceHolder;
166     }
167 
168     function getStar(uint starIndex, string strSTRZName, string strSTRZMasterName) {
169         if (msg.sender != owner) throw;
170        
171         if (starIndexToAddress[starIndex] != 0x0) throw;
172 
173         starIndexToSTRZName[starIndex] = strSTRZName;
174         starIndexToSTRZMasterName[starIndex] = strSTRZMasterName;
175 
176         starIndexToAddress[starIndex] = msg.sender;
177     
178         balanceOf[msg.sender]++;
179         Assign(msg.sender, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);
180         Transfer(0x0, msg.sender, 1);
181 
182     }
183 
184     
185     function transferStar(address to, uint starIndex) payable {
186         if (starIndexToAddress[starIndex] != msg.sender) throw;
187         if (msg.value < transferPrice) throw;                       // Didn't send enough ETH
188 
189         starIndexToAddress[starIndex] = to;
190         balanceOf[msg.sender]--;
191         balanceOf[to]++;
192         StarTransfer(msg.sender, to, starIndex);
193         Assign(to, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);
194         Transfer(msg.sender, to, 1);
195         pendingWithdrawals[owner] += msg.value;
196         //kill any bids and refund bid
197         Bid bid = starBids[starIndex];
198         if (bid.hasBid) {
199             pendingWithdrawals[bid.bidder] += bid.value;
200             starBids[starIndex] = Bid(false, starIndex, 0x0, 0);
201             StarBidWithdrawn(starIndex, bid.value, to);
202         }
203         
204         //Remove any offers
205         Offer offer = starsOfferedForSale[starIndex];
206         if (offer.isForSale) {
207              starsOfferedForSale[starIndex] = Offer(false, starIndex, msg.sender, 0, 0x0);
208         }
209 
210     }
211 
212     function starNoLongerForSale(uint starIndex) {
213         if (starIndexToAddress[starIndex] != msg.sender) throw;
214         starsOfferedForSale[starIndex] = Offer(false, starIndex, msg.sender, 0, 0x0);
215         StarNoLongerForSale(starIndex);
216         Bid bid = starBids[starIndex];
217         if (bid.bidder == msg.sender ) {
218             // Kill bid and refund value
219             pendingWithdrawals[msg.sender] += bid.value;
220             starBids[starIndex] = Bid(false, starIndex, 0x0, 0);
221             StarBidWithdrawn(starIndex, bid.value, msg.sender);
222         }
223     }
224 
225     function offerStarForSale(uint starIndex, uint minSalePriceInWei) {
226         if (starIndexToAddress[starIndex] != msg.sender) throw;
227         starsOfferedForSale[starIndex] = Offer(true, starIndex, msg.sender, minSalePriceInWei, 0x0);
228         StarOffered(starIndex, minSalePriceInWei, msg.sender, 0x0);
229     }
230 
231     function offerStarForSaleToAddress(uint starIndex, uint minSalePriceInWei, address toAddress) {
232         if (starIndexToAddress[starIndex] != msg.sender) throw;
233         starsOfferedForSale[starIndex] = Offer(true, starIndex, msg.sender, minSalePriceInWei, toAddress);
234         StarOffered(starIndex, minSalePriceInWei, msg.sender, toAddress);
235     }
236 
237     //New owner buys a star that has been offered
238     function buyStar(uint starIndex) payable {
239         Offer offer = starsOfferedForSale[starIndex];
240         if (!offer.isForSale) throw;                                            // star not actually for sale
241         if (offer.onlySellTo != 0x0 && offer.onlySellTo != msg.sender) throw;   // star not supposed to be sold to this user
242         if (msg.value < offer.minValue) throw;                                  // Didn't send enough ETH
243         if (offer.seller != starIndexToAddress[starIndex]) throw;               // Seller no longer owner of star
244 
245         address seller = offer.seller;
246         
247         balanceOf[seller]--;
248         balanceOf[msg.sender]++;
249 
250         Assign(msg.sender, starIndex,starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);
251 
252         Transfer(seller, msg.sender, 1);
253 
254         uint amountseller = msg.value*97/100;
255         uint amountowner = msg.value*3/100;           //Owner of contract receives 3% registration fee
256 
257         pendingWithdrawals[owner] += amountowner;    
258         pendingWithdrawals[seller] += amountseller;
259 
260         starIndexToAddress[starIndex] = msg.sender;
261  
262         starNoLongerForSale(starIndex);
263     
264         string STRZName = starIndexToSTRZName[starIndex];
265         string STRZMasterName = starIndexToSTRZMasterName[starIndex];
266 
267         StarBought(starIndex, msg.value, offer.seller, msg.sender, STRZName, STRZMasterName, MinStarIndexAvailable, MaxStarIndexAvailable);
268 
269         Bid bid = starBids[starIndex];
270         if (bid.bidder == msg.sender) {
271             // Kill bid and refund value
272             pendingWithdrawals[msg.sender] += bid.value;
273             starBids[starIndex] = Bid(false, starIndex, 0x0, 0);
274             StarBidWithdrawn(starIndex, bid.value, msg.sender);
275         }
276 
277     }
278 
279     function buyStarInitial(uint starIndex, string strSTRZName) payable {
280          
281     // We only allow the Nextavailable star to be sold 
282         if (starIndex > MaxStarIndexAvailable) throw;     //Above Current Offering Range
283         if (starIndex < MinStarIndexAvailable) throw;       //Below Current Offering Range
284         if (starIndexToAddress[starIndex] != 0x0) throw;    //Star is already owned
285         if (msg.value < initialPrice) throw;               // Didn't send enough ETH
286         
287         starIndexToAddress[starIndex] = msg.sender;   
288         starIndexToSTRZName[starIndex] = strSTRZName;      //Assign the star to new owner
289         
290         balanceOf[msg.sender]++;                            //Update the STRZ token balance for the new owner
291         pendingWithdrawals[owner] += msg.value;
292 
293         string STRZMasterName = starIndexToSTRZMasterName[starIndex];
294         StarBought(starIndex, msg.value, owner, msg.sender, strSTRZName, STRZMasterName ,MinStarIndexAvailable, MaxStarIndexAvailable);
295 
296         Assign(msg.sender, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);
297         Transfer(0x0, msg.sender, 1);
298         //Assign(msg.sender, starIndex);
299     }
300 
301     function enterBidForStar(uint starIndex) payable {
302 
303         if (starIndex >= totalSupply) throw;             
304         if (starIndexToAddress[starIndex] == 0x0) throw;
305         if (starIndexToAddress[starIndex] == msg.sender) throw;
306         if (msg.value == 0) throw;
307 
308         Bid existing = starBids[starIndex];
309         if (msg.value <= existing.value) throw;
310         if (existing.value > 0) {
311             // Refund the failing bid
312             pendingWithdrawals[existing.bidder] += existing.value;
313         }
314 
315         starBids[starIndex] = Bid(true, starIndex, msg.sender, msg.value);
316         StarBidEntered(starIndex, msg.value, msg.sender);
317     }
318 
319     function acceptBidForStar(uint starIndex, uint minPrice) {
320         if (starIndex >= totalSupply) throw;
321         //if (!allStarsAssigned) throw;                
322         if (starIndexToAddress[starIndex] != msg.sender) throw;
323         address seller = msg.sender;
324         Bid bid = starBids[starIndex];
325         if (bid.value == 0) throw;
326         if (bid.value < minPrice) throw;
327 
328         starIndexToAddress[starIndex] = bid.bidder;
329         balanceOf[seller]--;
330         balanceOf[bid.bidder]++;
331         Transfer(seller, bid.bidder, 1);
332 
333         starsOfferedForSale[starIndex] = Offer(false, starIndex, bid.bidder, 0, 0x0);
334         
335         uint amount = bid.value;
336         uint amountseller = amount*97/100;
337         uint amountowner = amount*3/100;
338         
339         pendingWithdrawals[seller] += amountseller;
340         pendingWithdrawals[owner] += amountowner;               //Registration Fee 3%
341 
342         string STRZGivenName = starIndexToSTRZName[starIndex];
343         string STRZMasterName = starIndexToSTRZMasterName[starIndex];
344         StarBought(starIndex, bid.value, seller, bid.bidder, STRZGivenName, STRZMasterName, MinStarIndexAvailable, MaxStarIndexAvailable);
345         StarBidWithdrawn(starIndex, bid.value, bid.bidder);
346         Assign(bid.bidder, starIndex, starIndexToSTRZName[starIndex], starIndexToSTRZMasterName[starIndex]);
347         StarNoLongerForSale(starIndex);
348 
349         starBids[starIndex] = Bid(false, starIndex, 0x0, 0);
350     }
351 
352     function withdrawBidForStar(uint starIndex) {
353         if (starIndex >= totalSupply) throw;            
354         if (starIndexToAddress[starIndex] == 0x0) throw;
355         if (starIndexToAddress[starIndex] == msg.sender) throw;
356 
357         Bid bid = starBids[starIndex];
358         if (bid.bidder != msg.sender) throw;
359         StarBidWithdrawn(starIndex, bid.value, msg.sender);
360         uint amount = bid.value;
361         starBids[starIndex] = Bid(false, starIndex, 0x0, 0);
362         // Refund the bid money
363         pendingWithdrawals[msg.sender] += amount;
364     
365     }
366 
367     function withdraw() {
368         //if (!allStarsAssigned) throw;
369         uint amount = pendingWithdrawals[msg.sender];
370         // Remember to zero the pending refund before
371         // sending to prevent re-entrancy attacks
372         pendingWithdrawals[msg.sender] = 0;
373         msg.sender.send(amount);
374     }
375 
376     function withdrawPartial(uint withdrawAmount) {
377         //Only available to owner
378         //Withdraw partial amount of the pending withdrawal
379         if (msg.sender != owner) throw;
380         if (withdrawAmount > pendingWithdrawals[msg.sender]) throw;
381 
382         pendingWithdrawals[msg.sender] -= withdrawAmount;
383         msg.sender.send(withdrawAmount);
384     }
385 }