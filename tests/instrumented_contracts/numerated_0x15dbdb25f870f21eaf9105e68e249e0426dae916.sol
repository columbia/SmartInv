1 /*
2 MillionEther smart contract - decentralized advertising platform.
3 
4 This program is free software: you can redistribute it and/or modify
5 it under the terms of the GNU General Public License as published by
6 the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version.
8 
9 This program is distributed in the hope that it will be useful,
10 but WITHOUT ANY WARRANTY; without even the implied warranty of
11 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12 GNU General Public License for more details.
13 
14 You should have received a copy of the GNU General Public License
15 along with this program.  If not, see <http://www.gnu.org/licenses/>.
16 */
17 
18 pragma solidity ^0.4.2;
19 
20 contract MillionEther {
21 
22     address private admin;
23 
24     // Users
25     uint private numUsers = 0;
26     struct User {
27         address referal;
28         uint8 handshakes;
29         uint balance;
30         uint32 activationTime;
31         bool banned;
32         uint userID;
33         bool refunded;
34         uint investments;
35     }
36     mapping(address => User) private users;
37     mapping(uint => address) private userAddrs;
38 
39     // Blocks. Blocks are 10x10 pixel areas. There are 10 000 blocks.
40     uint16 private blocksSold = 0;
41     uint private numNewStatus = 0;
42     struct Block {
43         address landlord;
44         uint imageID;
45         uint sellPrice;
46     }
47     Block[101][101] private blocks; 
48 
49     // Images
50     uint private numImages = 0;
51     struct Image {
52         uint8 fromX;
53         uint8 fromY;
54         uint8 toX;
55         uint8 toY;
56         string imageSourceUrl;
57         string adUrl;
58         string adText;
59     }
60     mapping(uint => Image) private images;
61 
62     // Contract settings and security
63     uint public charityBalance = 0;
64     address public charityAddress;
65     uint8 private refund_percent = 0;
66     uint private totalWeiInvested = 0; //1 024 000 Ether max
67     bool private setting_stopped = false;
68     bool private setting_refundMode = false;
69     uint32 private setting_delay = 3600;
70     uint private setting_imagePlacementPriceInWei = 0;
71 
72     // Events
73     event NewUser(uint ID, address newUser, address invitedBy, uint32 activationTime);
74     event NewAreaStatus (uint ID, uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint price);
75     event NewImage(uint ID, uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, string imageSourceUrl, string adUrl, string adText);
76 
77 
78 // ** INITIALIZE ** //
79 
80     function MillionEther () {
81         admin = msg.sender;
82         users[admin].referal = admin;
83         users[admin].handshakes = 0;
84         users[admin].activationTime = uint32(now);
85         users[admin].userID = 0;
86         userAddrs[0] = admin;
87         userAddrs[numUsers] = admin;
88     }
89 
90 
91 // ** FUNCTION MODIFIERS (PERMISSIONS) ** //
92 
93     modifier onlyAdmin {
94         if (msg.sender != admin) throw;
95         _;
96     }
97 
98     modifier onlyWhenInvitedBy (address someUser) {
99         if (users[msg.sender].referal != address(0x0)) throw;   //user already exists
100         if (users[someUser].referal == address(0x0)) throw;     //referral does not exist
101         if (now < users[someUser].activationTime) throw;        //referral is not active yet
102         _;
103     }
104 
105     modifier onlySignedIn {
106         if (users[msg.sender].referal == address(0x0)) throw;   //user does not exist
107         _;
108     }
109 
110     modifier onlyForSale (uint8 _x, uint8 _y) {
111         if (blocks[_x][_y].landlord != address(0x0) && blocks[_x][_y].sellPrice == 0) throw;
112         _;
113     }
114 
115     modifier onlyWithin100x100Area (uint8 _fromX, uint8 _fromY, uint8 _toX, uint8 _toY) {
116         if ((_fromX < 1) || (_fromY < 1)  || (_toX > 100) || (_toY > 100)) throw;
117         _;
118     }    
119 
120     modifier onlyByLandlord (uint8 _x, uint8 _y) {
121         if (msg.sender != admin) {
122             if (blocks[_x][_y].landlord != msg.sender) throw;
123         }
124         _;
125     }
126 
127     modifier noBannedUsers {
128         if (users[msg.sender].banned == true) throw;
129         _;
130     }
131 
132     modifier stopInEmergency { 
133         if (msg.sender != admin) {
134             if (setting_stopped) throw; 
135         }
136         _;
137     }
138 
139     modifier onlyInRefundMode { 
140         if (!setting_refundMode) throw;
141         _;
142     }
143 
144 
145 // ** USER SIGN IN ** //
146 
147     function getActivationTime (uint _currentLevel, uint _setting_delay) private constant returns (uint32) {
148         return uint32(now + _setting_delay * (2**(_currentLevel-1)));
149     }
150 
151     function signIn (address referal) 
152         public 
153         stopInEmergency ()
154         onlyWhenInvitedBy (referal) 
155         returns (uint) 
156     {
157         numUsers++;
158         // get user's referral handshakes and increase by one
159         uint8 currentLevel = users[referal].handshakes + 1;
160         users[msg.sender].referal = referal;
161         users[msg.sender].handshakes = currentLevel;
162         // 1,2,4,8,16,32,64 hours for activation depending on number of handshakes (if setting delay = 1 hour)
163         users[msg.sender].activationTime = getActivationTime (currentLevel, setting_delay); 
164         users[msg.sender].refunded = false;
165         users[msg.sender].userID = numUsers;
166         userAddrs[numUsers] = msg.sender;
167         NewUser(numUsers, msg.sender, referal, users[msg.sender].activationTime);
168         return numUsers;
169     }
170 
171 
172  // ** BUY AND SELL BLOCKS ** //
173 
174     function getBlockPrice (uint8 fromX, uint8 fromY, uint blocksSold) private constant returns (uint) {
175         if (blocks[fromX][fromY].landlord == address(0x0)) { 
176                 // when buying at initial sale price doubles every 1000 blocks sold
177                 return 1 ether * (2 ** (blocksSold/1000));
178             } else {
179                 // when the block is already bought and landlord have set a sell price
180                 return blocks[fromX][fromY].sellPrice;
181             }
182         }
183 
184     function buyBlock (uint8 x, uint8 y) 
185         private  
186         onlyForSale (x, y) 
187         returns (uint)
188     {
189         uint blockPrice;
190         blockPrice = getBlockPrice(x, y, blocksSold);
191         // Buy at initial sale
192         if (blocks[x][y].landlord == address(0x0)) {
193             blocksSold += 1;  
194             totalWeiInvested += blockPrice;
195         // Buy from current landlord and pay him or her the blockPrice
196         } else {
197             users[blocks[x][y].landlord].balance += blockPrice;  
198         }
199         blocks[x][y].landlord = msg.sender;
200         return blockPrice;
201     }
202 
203     // buy an area of blocks at coordinates [fromX, fromY, toX, toY]
204     function buyBlocks (uint8 fromX, uint8 fromY, uint8 toX, uint8 toY) 
205         public
206         payable
207         stopInEmergency ()
208         onlySignedIn () 
209         onlyWithin100x100Area (fromX, fromY, toX, toY)
210         returns (uint) 
211     {   
212         // Put funds to buyerBalance
213         if (users[msg.sender].balance + msg.value < users[msg.sender].balance) throw; //checking for overflow
214         uint previousWeiInvested = totalWeiInvested;
215         uint buyerBalance = users[msg.sender].balance + msg.value;
216 
217         // perform buyBlock for coordinates [fromX, fromY, toX, toY] and withdraw funds
218         uint purchasePrice;
219         for (uint8 ix=fromX; ix<=toX; ix++) {
220             for (uint8 iy=fromY; iy<=toY; iy++) {
221                 purchasePrice = buyBlock (ix,iy);
222                 if (buyerBalance < purchasePrice) throw;
223                 buyerBalance -= purchasePrice;
224             }
225         }
226         // update user balance
227         users[msg.sender].balance = buyerBalance;
228         // user's total investments are used for refunds calculations in emergency
229         users[msg.sender].investments += totalWeiInvested - previousWeiInvested;
230         // pay rewards to the referral chain starting from the current user referral
231         payOut (totalWeiInvested - previousWeiInvested, users[msg.sender].referal);
232         numNewStatus += 1;
233         // fire new area status event (0 sell price means the area is not for sale)
234         NewAreaStatus (numNewStatus, fromX, fromY, toX, toY, 0);
235         return purchasePrice;
236     }
237 
238 
239     //Mark block for sale (set a sell price)
240     function sellBlock (uint8 x, uint8 y, uint sellPrice) 
241         private
242         onlyByLandlord (x, y) 
243     {
244         blocks[x][y].sellPrice = sellPrice;
245     }
246 
247     // sell an area of blocks at coordinates [fromX, fromY, toX, toY]
248     function sellBlocks (uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, uint priceForEachBlockInWei) 
249         public 
250         stopInEmergency ()
251         onlyWithin100x100Area (fromX, fromY, toX, toY) 
252         returns (bool) 
253     {
254         if (priceForEachBlockInWei == 0) throw;
255         for (uint8 ix=fromX; ix<=toX; ix++) {
256             for (uint8 iy=fromY; iy<=toY; iy++) {
257                 sellBlock (ix, iy, priceForEachBlockInWei);
258             }
259         }
260         numNewStatus += 1;
261         // fire NewAreaStatus event
262         NewAreaStatus (numNewStatus, fromX, fromY, toX, toY, priceForEachBlockInWei);
263         return true;
264     }
265 
266 
267 // ** ASSIGNING IMAGES ** //
268     
269     function chargeForImagePlacement () private {
270         if (users[msg.sender].balance + msg.value < users[msg.sender].balance) throw; //check for overflow`
271         uint buyerBalance = users[msg.sender].balance + msg.value;
272         if (buyerBalance < setting_imagePlacementPriceInWei) throw;
273         buyerBalance -= setting_imagePlacementPriceInWei;
274         users[admin].balance += setting_imagePlacementPriceInWei;
275         users[msg.sender].balance = buyerBalance;
276     }
277 
278     // every block has its own image id assigned
279     function assignImageID (uint8 x, uint8 y, uint _imageID) 
280         private
281         onlyByLandlord (x, y) 
282     {
283         blocks[x][y].imageID = _imageID;
284     }
285 
286     // place new ad to user owned area
287     function placeImage (uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, string imageSourceUrl, string adUrl, string adText) 
288         public 
289         payable
290         stopInEmergency ()
291         noBannedUsers ()
292         onlyWithin100x100Area (fromX, fromY, toX, toY)
293         returns (uint) 
294     {
295         chargeForImagePlacement();
296         numImages++;
297         for (uint8 ix=fromX; ix<=toX; ix++) {
298             for (uint8 iy=fromY; iy<=toY; iy++) {
299                 assignImageID (ix, iy, numImages);
300             }
301         }
302         images[numImages].fromX = fromX;
303         images[numImages].fromY = fromY;
304         images[numImages].toX = toX;
305         images[numImages].toY = toY;
306         images[numImages].imageSourceUrl = imageSourceUrl;
307         images[numImages].adUrl = adUrl;
308         images[numImages].adText = adText;
309         NewImage(numImages, fromX, fromY, toX, toY, imageSourceUrl, adUrl, adText);
310         return numImages;
311     }
312 
313 
314 
315 
316 
317 // ** PAYOUTS ** //
318 
319     // reward the chain of referrals, admin and charity
320     function payOut (uint _amount, address referal) private {
321         address iUser = referal;
322         address nextUser;
323         uint totalPayed = 0;
324         for (uint8 i = 1; i < 7; i++) {                 // maximum 6 handshakes from the buyer 
325             users[iUser].balance += _amount / (2**i);   // with every handshake far from the buyer reward halves:
326             totalPayed += _amount / (2**i);             // 50%, 25%, 12.5%, 6.25%, 3.125%, 1.5625%
327             if (iUser == admin) { break; }              // breaks at admin
328             nextUser = users[iUser].referal;
329             iUser = nextUser;
330         }
331         goesToCharity(_amount - totalPayed);            // the rest goes to charity
332     }
333 
334     // charity is the same type of user as everyone else
335     function goesToCharity (uint amount) private {
336         // if no charityAddress is set yet funds go to charityBalance (see further)
337         if (charityAddress == address(0x0)) {
338             charityBalance += amount;
339         } else {
340             users[charityAddress].balance += amount;
341         }
342     }
343 
344     // withdraw funds (no external calls for safety)
345     function withdrawAll () 
346         public
347         stopInEmergency () 
348     {
349         uint withdrawAmount = users[msg.sender].balance;
350         users[msg.sender].balance = 0;
351         if (!msg.sender.send(withdrawAmount)) {
352             users[msg.sender].balance = withdrawAmount;
353         }
354     }
355 
356 
357  // ** GET INFO (CONSTANT FUNCTIONS)** //
358 
359     //USERS
360     function getUserInfo (address userAddress) public constant returns (
361         address referal,
362         uint8 handshakes,
363         uint balance,
364         uint32 activationTime,
365         bool banned,
366         uint userID,
367         bool refunded,
368         uint investments
369     ) {
370         referal = users[userAddress].referal; 
371         handshakes = users[userAddress].handshakes; 
372         balance = users[userAddress].balance; 
373         activationTime = users[userAddress].activationTime; 
374         banned = users[userAddress].banned; 
375         userID = users[userAddress].userID;
376         refunded = users[userAddress].refunded; 
377         investments = users[userAddress].investments;
378     }
379 
380     function getUserAddressByID (uint userID) 
381         public constant returns (address userAddress) 
382     {
383         return userAddrs[userID];
384     }
385     
386     function getMyInfo() 
387         public constant returns(uint balance, uint32 activationTime) 
388     {   
389         return (users[msg.sender].balance, users[msg.sender].activationTime);
390     }
391 
392     //BLOCKS
393     function getBlockInfo(uint8 x, uint8 y) 
394         public constant returns (address landlord, uint imageID, uint sellPrice) 
395     {
396         return (blocks[x][y].landlord, blocks[x][y].imageID, blocks[x][y].sellPrice);
397     }
398 
399     function getAreaPrice (uint8 fromX, uint8 fromY, uint8 toX, uint8 toY)
400         public
401         constant
402         onlyWithin100x100Area (fromX, fromY, toX, toY)
403         returns (uint) 
404     {
405         uint blockPrice;
406         uint totalPrice = 0;
407         uint16 iblocksSold = blocksSold;
408         for (uint8 ix=fromX; ix<=toX; ix++) {
409             for (uint8 iy=fromY; iy<=toY; iy++) {
410                 blockPrice = getBlockPrice(ix,iy,iblocksSold);
411                 if (blocks[ix][iy].landlord == address(0x0)) { 
412                         iblocksSold += 1; 
413                     }
414                 if (blockPrice == 0) { 
415                     return 0; // not for sale
416                     } 
417                 totalPrice += blockPrice;
418             }
419         }
420         return totalPrice;
421     }
422 
423     //IMAGES
424     function getImageInfo(uint imageID) 
425         public constant returns (uint8 fromX, uint8 fromY, uint8 toX, uint8 toY, string imageSourceUrl, string adUrl, string adText)
426     {
427         Image i = images[imageID];
428         return (i.fromX, i.fromY, i.toX, i.toY, i.imageSourceUrl, i.adUrl, i.adText);
429     }
430 
431     //CONTRACT STATE
432     function getStateInfo () public constant returns (
433         uint _numUsers, 
434         uint16 _blocksSold, 
435         uint _totalWeiInvested, 
436         uint _numImages, 
437         uint _setting_imagePlacementPriceInWei,
438         uint _numNewStatus,
439         uint32 _setting_delay
440     ){
441         return (numUsers, blocksSold, totalWeiInvested, numImages, setting_imagePlacementPriceInWei, numNewStatus, setting_delay);
442     }
443 
444 
445 // ** ADMIN ** //
446 
447     function adminContractSecurity (address violator, bool banViolator, bool pauseContract, bool refundInvestments)
448         public 
449         onlyAdmin () 
450     {
451         //freeze/unfreeze user
452         if (violator != address(0x0)) {
453             users[violator].banned = banViolator;
454         }
455         //pause/resume contract 
456         setting_stopped = pauseContract;
457 
458         //terminate contract, refund investments
459         if (refundInvestments) {
460             setting_refundMode = refundInvestments;
461             refund_percent = uint8((this.balance*100)/totalWeiInvested);
462         }
463     }
464 
465     function adminContractSettings (uint32 newDelayInSeconds, address newCharityAddress, uint newImagePlacementPriceInWei)
466         public 
467         onlyAdmin () 
468     {   
469         // setting_delay affects user activation time.
470         if (newDelayInSeconds > 0) setting_delay = newDelayInSeconds;
471         // when the charityAddress is set charityBalance immediately transfered to it's balance 
472         if (newCharityAddress != address(0x0)) {
473             if (users[newCharityAddress].referal == address(0x0)) throw;
474             charityAddress = newCharityAddress;
475             users[charityAddress].balance += charityBalance;
476             charityBalance = 0;
477         }
478         // at deploy is set to 0, but may be needed to support off-chain infrastructure
479         setting_imagePlacementPriceInWei = newImagePlacementPriceInWei;
480     }
481 
482     // escape path - withdraw funds at emergency.
483     function emergencyRefund () 
484         public
485         onlyInRefundMode () 
486     {
487         if (!users[msg.sender].refunded) {
488             uint totalInvested = users[msg.sender].investments;
489             uint availableForRefund = (totalInvested*refund_percent)/100;
490             users[msg.sender].investments -= availableForRefund;
491             users[msg.sender].refunded = true;
492             if (!msg.sender.send(availableForRefund)) {
493                 users[msg.sender].investments = totalInvested;
494                 users[msg.sender].refunded = false;
495             }
496         }
497     }
498 
499     function () {
500         throw;
501     }
502 
503 }