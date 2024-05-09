1 pragma solidity ^0.4.18;
2 
3 contract EMPresale {
4     
5     bool inMaintainance;
6     bool isRefundable;
7     
8     // Data -----------------------------
9     
10     struct Player {
11         uint32 id;  // if 0, then player don't exist
12         mapping(uint8 => uint8) bought;
13         uint256 weiSpent;
14         bool hasSpent;
15     }
16     
17     struct Sale {
18         uint8 bought;
19         uint8 maxBought;
20         uint32 cardTypeID;
21         uint256 price;
22         uint256 saleEndTime;
23         
24         bool isAirdrop;     // enables minting (+maxBought per hour until leftToMint==0)
25                             // + each player can only buy once
26                             // + is free
27         uint256 nextMintTime;
28         uint8 leftToMint;
29     }
30     
31     address admin;
32     address[] approverArr; // for display purpose only
33     mapping(address => bool) approvers;
34     
35     address[] playerAddrs;      // 0 index not used
36     uint32[] playerRefCounts;   // 0 index not used
37     
38     mapping(address => Player) players;
39     mapping(uint8 => Sale) sales;   // use from 1 onwards
40     uint256 refPrize;
41     
42     // CONSTRUCTOR =======================
43     
44     function EMPresale() public {
45         admin = msg.sender;
46         approverArr.push(admin);
47         approvers[admin] = true;
48         
49         playerAddrs.push(address(0));
50         playerRefCounts.push(0);
51     }
52     
53     // ADMIN FUNCTIONS =======================
54     
55     function setSaleType_Presale(uint8 saleID, uint8 maxBought, uint32 cardTypeID, uint256 price, uint256 saleEndTime) external onlyAdmin {
56         Sale storage sale = sales[saleID];
57         
58         // assign sale type
59         sale.bought = 0;
60         sale.maxBought = maxBought;
61         sale.cardTypeID = cardTypeID;
62         sale.price = price;
63         sale.saleEndTime = saleEndTime;
64         
65         // airdrop type
66         sale.isAirdrop = false;
67     }
68     
69     function setSaleType_Airdrop(uint8 saleID, uint8 maxBought, uint32 cardTypeID, uint8 leftToMint, uint256 firstMintTime) external onlyAdmin {
70         Sale storage sale = sales[saleID];
71         
72         // assign sale type
73         sale.bought = 0;
74         sale.maxBought = maxBought;
75         sale.cardTypeID = cardTypeID;
76         sale.price = 0;
77         sale.saleEndTime = 2000000000;
78         
79         // airdrop type
80         require(leftToMint >= maxBought);
81         sale.isAirdrop = true;
82         sale.nextMintTime = firstMintTime;
83         sale.leftToMint = leftToMint - maxBought;
84     }
85     
86     function stopSaleType(uint8 saleID) external onlyAdmin {
87         delete sales[saleID].saleEndTime;
88     }
89     
90     function redeemCards(address playerAddr, uint8 saleID) external onlyApprover returns(uint8) {
91         Player storage player = players[playerAddr];
92         uint8 owned = player.bought[saleID];
93         player.bought[saleID] = 0;
94         return owned;
95     }
96     
97     function setRefundable(bool refundable) external onlyAdmin {
98         isRefundable = refundable;
99     }
100     
101     function refund() external {
102         require(isRefundable);
103         Player storage player = players[msg.sender];
104         uint256 spent = player.weiSpent;
105         player.weiSpent = 0;
106         msg.sender.transfer(spent);
107     }
108     
109     // PLAYER FUNCTIONS ========================
110     
111     function buySaleNonReferral(uint8 saleID) external payable {
112         buySale(saleID, address(0));
113     }
114     
115     function buySaleReferred(uint8 saleID, address referral) external payable {
116         buySale(saleID, referral);
117     }
118     
119     function buySale(uint8 saleID, address referral) private {
120         
121         require(!inMaintainance);
122         require(msg.sender != address(0));
123         
124         // check that sale is still on
125         Sale storage sale = sales[saleID];
126         require(sale.saleEndTime > now);
127         
128         bool isAirdrop = sale.isAirdrop;
129         if(isAirdrop) {
130             // airdrop minting
131             if(now >= sale.nextMintTime) {  // hit a cycle
132             
133                 sale.nextMintTime += ((now-sale.nextMintTime)/3600)*3600+3600;   // mint again next hour
134                 if(sale.bought != 0) {
135                     uint8 leftToMint = sale.leftToMint;
136                     if(leftToMint < sale.bought) { // not enough to recover, set maximum left to be bought
137                         sale.maxBought = sale.maxBought + leftToMint - sale.bought;
138                         sale.leftToMint = 0;
139                     } else
140                         sale.leftToMint -= sale.bought;
141                     sale.bought = 0;
142                 }
143             }
144         } else {
145             // check ether is paid
146             require(msg.value >= sale.price);
147         }
148 
149         // check not all is bought
150         require(sale.bought < sale.maxBought);
151         sale.bought++;
152         
153         bool toRegisterPlayer = false;
154         bool toRegisterReferral = false;
155         
156         // register player if unregistered
157         Player storage player = players[msg.sender];
158         if(player.id == 0)
159             toRegisterPlayer = true;
160             
161         // cannot buy more than once if airdrop
162         if(isAirdrop)
163             require(player.bought[saleID] == 0);
164         
165         // give ownership
166         player.bought[saleID]++;
167         if(!isAirdrop)  // is free otherwise
168             player.weiSpent += msg.value;
169         
170         // if hasn't referred, add referral
171         if(!player.hasSpent) {
172             player.hasSpent = true;
173             if(referral != address(0) && referral != msg.sender) {
174                 Player storage referredPlayer = players[referral];
175                 if(referredPlayer.id == 0) {    // add referred player if unregistered
176                     toRegisterReferral = true;
177                 } else {                        // if already registered, just up ref count
178                     playerRefCounts[referredPlayer.id]++;
179                 }
180             }
181         }
182         
183         // register player(s)
184         if(toRegisterPlayer && toRegisterReferral) {
185             uint256 length = (uint32)(playerAddrs.length);
186             player.id = (uint32)(length);
187             referredPlayer.id = (uint32)(length+1);
188             playerAddrs.length = length+2;
189             playerRefCounts.length = length+2;
190             playerAddrs[length] = msg.sender;
191             playerAddrs[length+1] = referral;
192             playerRefCounts[length+1] = 1;
193             
194         } else if(toRegisterPlayer) {
195             player.id = (uint32)(playerAddrs.length);
196             playerAddrs.push(msg.sender);
197             playerRefCounts.push(0);
198             
199         } else if(toRegisterReferral) {
200             referredPlayer.id = (uint32)(playerAddrs.length);
201             playerAddrs.push(referral);
202             playerRefCounts.push(1);
203         }
204         
205         // referral prize
206         refPrize += msg.value/40;    // 2.5% added to prize money
207     }
208     
209     function GetSaleInfo_Presale(uint8 saleID) external view returns (uint8, uint8, uint8, uint32, uint256, uint256) {
210         uint8 playerOwned = 0;
211         if(msg.sender != address(0))
212             playerOwned = players[msg.sender].bought[saleID];
213         
214         Sale storage sale = sales[saleID];
215         return (playerOwned, sale.bought, sale.maxBought, sale.cardTypeID, sale.price, sale.saleEndTime);
216     }
217     
218     function GetSaleInfo_Airdrop(uint8 saleID) external view returns (uint8, uint8, uint8, uint32, uint256, uint8) {
219         uint8 playerOwned = 0;
220         if(msg.sender != address(0))
221             playerOwned = players[msg.sender].bought[saleID];
222         
223         Sale storage sale = sales[saleID];
224         uint8 bought = sale.bought;
225         uint8 maxBought = sale.maxBought;
226         uint256 nextMintTime = sale.nextMintTime;
227         uint8 leftToMintResult = sale.leftToMint;
228     
229         // airdrop minting
230         if(now >= nextMintTime) {  // hit a cycle
231             nextMintTime += ((now-nextMintTime)/3600)*3600+3600;   // mint again next hour
232             if(bought != 0) {
233                 uint8 leftToMint = leftToMintResult;
234                 if(leftToMint < bought) { // not enough to recover, set maximum left to be bought
235                     maxBought = maxBought + leftToMint - bought;
236                     leftToMintResult = 0;
237                 } else
238                     leftToMintResult -= bought;
239                 bought = 0;
240             }
241         }
242         
243         return (playerOwned, bought, maxBought, sale.cardTypeID, nextMintTime, leftToMintResult);
244     }
245     
246     function GetReferralInfo() external view returns(uint256, uint32) {
247         uint32 refCount = 0;
248         uint32 id = players[msg.sender].id;
249         if(id != 0)
250             refCount = playerRefCounts[id];
251         return (refPrize, refCount);
252     }
253     
254     function GetPlayer_FromAddr(address playerAddr, uint8 saleID) external view returns(uint32, uint8, uint256, bool, uint32) {
255         Player storage player = players[playerAddr];
256         return (player.id, player.bought[saleID], player.weiSpent, player.hasSpent, playerRefCounts[player.id]);
257     }
258     
259     function GetPlayer_FromID(uint32 id, uint8 saleID) external view returns(address, uint8, uint256, bool, uint32) {
260         address playerAddr = playerAddrs[id];
261         Player storage player = players[playerAddr];
262         return (playerAddr, player.bought[saleID], player.weiSpent, player.hasSpent, playerRefCounts[id]);
263     }
264     
265     function getAddressesCount() external view returns(uint) {
266         return playerAddrs.length;
267     }
268     
269     function getAddresses() external view returns(address[]) {
270         return playerAddrs;
271     }
272     
273     function getAddress(uint256 id) external view returns(address) {
274         return playerAddrs[id];
275     }
276     
277     function getReferralCounts() external view returns(uint32[]) {
278         return playerRefCounts;
279     }
280     
281     function getReferralCount(uint256 playerID) external view returns(uint32) {
282         return playerRefCounts[playerID];
283     }
284     
285     function GetNow() external view returns (uint256) {
286         return now;
287     }
288 
289     // PAYMENT FUNCTIONS =======================
290     
291     function getEtherBalance() external view returns (uint256) {
292         return address(this).balance;
293     }
294     
295     function depositEtherBalance() external payable {
296     }
297     
298     function withdrawEtherBalance(uint256 amt) external onlyAdmin {
299         admin.transfer(amt);
300     }
301     
302     // RIGHTS FUNCTIONS =======================
303     
304     function setMaintainance(bool maintaining) external onlyAdmin {
305         inMaintainance = maintaining;
306     }
307     
308     function isInMaintainance() external view returns(bool) {
309         return inMaintainance;
310     }
311     
312     function getApprovers() external view returns(address[]) {
313         return approverArr;
314     }
315     
316     // change admin
317     // only admin can perform this function
318     function switchAdmin(address newAdmin) external onlyAdmin {
319         admin = newAdmin;
320     }
321 
322     // add a new approver
323     // only admin can perform this function
324     function addApprover(address newApprover) external onlyAdmin {
325         require(!approvers[newApprover]);
326         approvers[newApprover] = true;
327         approverArr.push(newApprover);
328     }
329 
330     // remove an approver
331     // only admin can perform this function
332     function removeApprover(address oldApprover) external onlyAdmin {
333         require(approvers[oldApprover]);
334         delete approvers[oldApprover];
335         
336         // swap last address with deleted address (for array)
337         uint256 length = approverArr.length;
338         address swapAddr = approverArr[length - 1];
339         for(uint8 i=0; i<length; i++) {
340             if(approverArr[i] == oldApprover) {
341                 approverArr[i] = swapAddr;
342                 break;
343             }
344         }
345         approverArr.length--;
346     }
347     
348     // MODIFIERS =======================
349     
350     modifier onlyAdmin() {
351         require(msg.sender == admin);
352         _;
353     }
354     
355     modifier onlyApprover() {
356         require(approvers[msg.sender]);
357         _;
358     }
359 }