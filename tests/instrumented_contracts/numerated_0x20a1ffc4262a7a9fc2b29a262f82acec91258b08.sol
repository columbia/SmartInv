1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) internal pure returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) internal pure returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) internal pure returns (uint) {
16         uint c = a + b;
17         assert(c>=a && c>=b);
18         return c;
19     }
20 
21     function is112bit(uint x) internal pure returns (bool) {
22         if (x < 1 << 112) {
23             return true;
24         } else {
25             return false;
26         }
27     }
28 
29     function is32bit(uint x) internal pure returns (bool) {
30         if (x < 1 << 32) {
31             return true;
32         } else {
33             return false;
34         }
35     }
36 }
37 
38 contract Token {
39     function totalSupply() constant returns (uint256 supply) {}
40     function balanceOf(address _owner) constant returns (uint256 balance) {}
41     function transfer(address _to, uint256 _value) returns (bool success) {}
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
43     function approve(address _spender, uint256 _value) returns (bool success) {}
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 
49     uint public decimals;
50     string public name;
51 }
52 
53 // ERC-20 token contract with no return value for transfer(), approve() and transferFrom()
54 contract NoReturnToken {
55     function totalSupply() constant returns (uint256 supply) {}
56     function balanceOf(address _owner) constant returns (uint256 balance) {}
57     function transfer(address _to, uint256 _value) {}
58     function transferFrom(address _from, address _to, uint256 _value) {}
59     function approve(address _spender, uint256 _value) {}
60     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
61 
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 
65     uint public decimals;
66     string public name;
67 }
68 
69 // Allows smoother migration to a new version of the auction smart contract via migrate()
70 contract NewAuction {
71     function depositForUser(address _user) payable {}
72     function depositTokenForUser(address _user, address _token, uint _amount) {}
73 }
74 
75 
76 
77 contract Auction is SafeMath {
78     // ALl the data relevant to the auctions for one specific token
79     struct TokenAuction {
80         mapping (uint => uint) buyOrders;
81         uint buyCount;
82         mapping (uint => uint) sellOrders;
83         uint sellCount;
84 
85         uint maxVolume; // The maximum volume of orders that can be filled in the current auction
86         uint maxVolumePrice; // The price at which orders will be filled in the current auction
87         uint maxVolumePriceB; // Buy orders below this price cannot be filled as orders are first prioritised by price
88         uint maxVolumePriceS; // Sell orders above this price cannot be filled as orders are first prioritised by price
89         bool toBeExecuted; // The auction is ready for execution
90         bool activeAuction; // There is an ongoing auction for the token
91         uint executionIndex; // The index for the next order that needs to be executed in the auction, using storage is necessary to allow batches in separate transactions
92         uint executionBuyVolume; // The volume filled so far on the buy side in the current auction
93         uint executionSellVolume; // The volume filled so far on the sell side in the current auction
94         uint auctionIndex; // The index for the current auction
95 
96         mapping (uint => mapping (uint => uint)) checkAuctionIndex; // The auction index when checkVolume() was last called with the given price limits
97         mapping (uint => mapping (uint => uint)) checkIndex; // The index for the next order to be processed in checkVolume() for the given price limits
98         mapping (uint => mapping (uint => uint)) checkBuyVolume; // The volume of buy orders that can be filled so far in checkVolume() for the given price limits
99         mapping (uint => mapping (uint => uint)) checkSellVolume; // The volume of sell orders that can be filled so far in checkVolume() for the given price limits
100 
101         uint minimumOrder;
102 
103         bool supported;
104         bool lastAuction; // Whether token is to be removed after the next auction
105         bool everSupported; // Whether the token has ever been supported by this contract
106 
107         uint nextAuctionTime;
108         uint checkDuration;
109         bool startedReveal;
110         bool startedCheck;
111         bool startedExecute;
112 
113         uint onchainBuyCount; // Orders after this index are offchain and have tier 2/3 fees
114         uint onchainSellCount; // Orders after this index are offchain and have tier 2/3 fees
115         uint publicBuyCount; // Orders after this index are hidden and have tier 3 fees
116         uint publicSellCount; // Orders after this index are hidden and have tier 3 fees
117         uint revealDuration;
118 
119         uint decimals;
120         uint unit;
121 
122         uint lastPrice;
123 
124         bool noReturnTransfer; // Whether the token implementation is missing the return value in transfer()
125         bool noReturnApprove; // Whether the token implementation is missing the return value in approve()
126         bool noReturnTransferFrom; // Whether the token implementation is missing the return value in transferFrom()
127         bool autoWithdrawDisabled;
128     }
129 
130     mapping (address => TokenAuction) token;
131 
132     address[] indexToAddress; // List of user IDs for more efficient storage
133     mapping (address => uint32) public addressToIndex;
134     address admin;
135     address operator;
136     mapping (address => mapping (address => uint)) public balances; // Address 0 represents the Ether balance
137     bool constant developmentTiming = false; // Timing checks are disabled when true, to make testing easier during development
138     uint[] public fees; // Multiplied by (1 ether). Three tiers: On-chain, Off-Chain Public, Off-Chain Hidden
139     address feeAccount;
140     bool feeAccountFinalised; // If true, the fee account can no longer be changed
141     address[] tokenList;
142     uint public activeAuctionCount = 0; // The number of auctions that are currently active (either running or in the check/reveal/execute period)
143     uint public revealingAuctionCount = 0; // The number of auctions that are currently in their reveal period
144     mapping (address => uint) public signedWithdrawalNonce;
145     mapping (address => bool) public autoWithdraw;
146     mapping (address => bool) public staticAutoWithdraw;
147     mapping (address => bool) public verifiedContract;
148 
149     uint[] reserve; // An array used as a gas reserve
150 
151     event BuyOrderPosted(address indexed tokenAddress, uint indexed auctionIndex, address indexed userAddress, uint orderIndex, uint price, uint amount);
152     event BuyOrderRemoved(address indexed tokenAddress, uint indexed auctionIndex, address indexed userAddress, uint orderIndex);
153     event SellOrderPosted(address indexed tokenAddress, uint indexed auctionIndex, address indexed userAddress, uint orderIndex, uint price, uint amount);
154     event SellOrderRemoved(address indexed tokenAddress, uint indexed auctionIndex, address indexed userAddress, uint orderIndex);
155     event Deposit(address indexed tokenAddress, address indexed userAddress, uint amount);
156     event Withdrawal(address indexed tokenAddress, address indexed userAddress, uint amount);
157     event AuctionHistory(address indexed tokenAddress, uint indexed auctionIndex, uint auctionTime, uint price, uint volume);
158 
159     function Auction(address a) {
160         admin = a;
161         indexToAddress.push(0);
162         operator = a;
163         feeAccount = a;
164         fees.push(0);
165         fees.push(0);
166         fees.push(0);
167     }
168 
169     function addToken(address t, uint min) external {
170         require(msg.sender == operator);
171         require(t > 0);
172         if (!token[t].everSupported) {
173             tokenList.push(t);
174         }
175         token[t].supported = true;
176         token[t].everSupported = true;
177         token[t].lastAuction = false;
178         token[t].minimumOrder = min;
179         if (token[t].unit == 0) {
180             token[t].decimals = Token(t).decimals();
181             token[t].unit = 10**token[t].decimals;
182         }
183     }
184 
185     function setNoReturnToken(address t, bool nrt, bool nra, bool nrtf) external {
186         require(msg.sender == operator);
187         token[t].noReturnTransfer = nrt;
188         token[t].noReturnApprove = nra;
189         token[t].noReturnTransferFrom = nrtf;
190     }
191 
192     function removeToken(address t) external {
193         require(msg.sender == operator);
194         token[t].lastAuction = true;
195     }
196 
197     function changeAdmin(address a) external {
198         require(msg.sender == admin);
199         admin = a;
200     }
201 
202     function changeOperator(address a) external {
203         require(msg.sender == admin);
204         operator = a;
205     }
206 
207     function changeFeeAccount(address a) external {
208         require(msg.sender == admin);
209         // Check if there are any ongoing auctions, otherwise the feeAccountBalance could cause problems
210         require(activeAuctionCount == 0);
211         require(!feeAccountFinalised);
212         feeAccount = a;
213     }
214 
215     // Finalising the fee account allows giving the fees to a smart contract with no ability to change it
216     function finaliseFeeAccount() external {
217         require(msg.sender == admin);
218         feeAccountFinalised = true;
219     }
220 
221     function changeMinimumOrder(address t, uint x) external {
222         require(msg.sender == operator);
223         require(token[t].supported);
224         token[t].minimumOrder = x;
225     }
226 
227     function changeFees(uint[] f) external {
228         require(msg.sender == operator);
229         // Check if there are any ongoing auctions
230         require(activeAuctionCount == 0);
231         // Check that all fees are at most 1%
232         for (uint i=0; i < f.length; i++) {
233             require(f[i] < (10 finney));
234         }
235         fees = f;
236     }
237 
238     // There are three tiers of fees: On-Chain, Off-Chain Public and Off-Chain Hidden
239     function feeForBuyOrder(address t, uint i) public view returns (uint) {
240         if (i < token[t].onchainBuyCount) {
241             return fees[0];
242         } else {
243             if (i < token[t].publicBuyCount) {
244                 return fees[1];
245             } else {
246                 return fees[2];
247             }
248         }
249     }
250 
251     function feeForSellOrder(address t, uint i) public view returns (uint) {
252         if (i < token[t].onchainSellCount) {
253             return fees[0];
254         } else {
255             if (i < token[t].publicSellCount) {
256                 return fees[1];
257             } else {
258                 return fees[2];
259             }
260         }
261     }
262 
263     function isAuctionTime(address t) public view returns (bool) {
264         if (developmentTiming) { return true; }
265         return (block.timestamp < token[t].nextAuctionTime) && (!token[t].startedReveal);
266     }
267 
268     function isRevealTime(address t) public view returns (bool) {
269         if (developmentTiming) { return true; }
270         return (block.timestamp >= token[t].nextAuctionTime || token[t].startedReveal) && (block.timestamp < token[t].nextAuctionTime + token[t].revealDuration && !token[t].startedCheck);
271     }
272 
273     function isCheckingTime(address t) public view returns (bool) {
274         if (developmentTiming) { return true; }
275         return (block.timestamp >= token[t].nextAuctionTime + token[t].revealDuration || token[t].startedCheck) && (block.timestamp < token[t].nextAuctionTime + token[t].revealDuration + token[t].checkDuration && !token[t].startedExecute);
276     }
277 
278     function isExecutionTime(address t) public view returns (bool) {
279         if (developmentTiming) { return true; }
280         return (block.timestamp >= token[t].nextAuctionTime + token[t].revealDuration + token[t].checkDuration || token[t].startedExecute);
281     }
282 
283     function setDecimals(address t, uint x) public {
284         require(msg.sender == operator);
285         require(token[t].unit == 0);
286         token[t].decimals = x;
287         token[t].unit = 10**x;
288     }
289 
290     function addReserve(uint x) external {
291         uint maxUInt = 0;
292         maxUInt = maxUInt - 1;
293         for (uint i=0; i < x; i++) {
294             reserve.push(maxUInt);
295         }
296     }
297 
298     function useReserve(uint x) private {
299         require(x <= reserve.length);
300         reserve.length = reserve.length - x;
301     }
302 
303 
304 
305     function startAuction(address t, uint auctionTime, uint revealDuration, uint checkDuration) external {
306         require(msg.sender == operator);
307         require(token[t].supported);
308         // Disabling startAuction() during Reveal periods ensures that there will always be a time when withdrawals are allowed, even with a malicious operator
309         require(revealingAuctionCount == 0);
310         require(isExecutionTime(t) || token[t].nextAuctionTime == 0);
311         require(!token[t].toBeExecuted);
312         require(!token[t].activeAuction);
313         require(auctionTime > block.timestamp || developmentTiming);
314         require(auctionTime <= block.timestamp + 7 * 24 * 3600 || developmentTiming);
315         require(revealDuration <= 24 * 3600);
316         require(checkDuration <= 24 * 3600);
317         require(checkDuration >= 5 * 60);
318         token[t].nextAuctionTime = auctionTime;
319         token[t].revealDuration = revealDuration;
320         token[t].checkDuration = checkDuration;
321         token[t].startedReveal = false;
322         token[t].startedCheck = false;
323         token[t].startedExecute = false;
324         uint maxUInt = 0;
325         maxUInt = maxUInt - 1;
326         token[t].onchainBuyCount = maxUInt;
327         token[t].onchainSellCount = maxUInt;
328         token[t].publicBuyCount = maxUInt;
329         token[t].publicSellCount = maxUInt;
330         token[t].activeAuction = true;
331         activeAuctionCount++;
332     }
333 
334     function buy_(address t, address u, uint p, uint a, uint buyCount) private {
335         require(is112bit(p));
336         require(is112bit(a));
337         require(token[t].supported);
338         require(t != address(0));
339         require(u != feeAccount); // Fee account balance is handled separately in executeAuction()
340         // Appropriate timing constraints are in buy() and revealBuy() methods
341         uint index = addressToIndex[u];
342         require(index != 0);
343         uint balance = balances[0][u];
344         uint cost = safeMul(p, a) / (token[t].unit);
345         require(safeMul(cost, token[t].unit) == safeMul(p, a));
346         uint fee = feeForBuyOrder(t, buyCount);
347         uint totalCost = safeAdd(cost, safeMul(cost, fee) / (1 ether));
348         require(balance >= totalCost);
349         require(cost >= token[0].minimumOrder);
350         require(a >= token[t].minimumOrder);
351         balances[0][u] = safeSub(balance, totalCost);
352         token[t].buyOrders[buyCount] = (((index << 112) | p) << 112) | a;
353         emit BuyOrderPosted(t, token[t].auctionIndex, u, buyCount, p, a);
354     }
355 
356     function sell_(address t, address u, uint p, uint a, uint sellCount) private {
357         require(is112bit(p));
358         require(is112bit(a));
359         require(token[t].supported);
360         require(t != address(0));
361         require(u != feeAccount);
362         // Appropriate timing constraints are in sell() and revealSell() methods
363         uint index = addressToIndex[u];
364         require(index != 0);
365         uint balance = balances[t][u];
366         require(balance >= a);
367         uint cost = safeMul(p, a) / (token[t].unit);
368         require(safeMul(cost, token[t].unit) == safeMul(p, a));
369         require(cost >= token[0].minimumOrder);
370         require(a >= token[t].minimumOrder);
371         balances[t][u] = safeSub(balance, a);
372         token[t].sellOrders[sellCount] = (((index << 112) | p) << 112) | a;
373         emit SellOrderPosted(t, token[t].auctionIndex, u, sellCount, p, a);
374     }
375 
376     function buy(address t, uint p, uint a) public {
377         require(isAuctionTime(t));
378         uint buyCount = token[t].buyCount;
379         buy_(t, msg.sender, p, a, buyCount);
380         token[t].buyCount = buyCount + 1;
381     }
382 
383     function sell(address t, uint p, uint a) public {
384         require(isAuctionTime(t));
385         uint sellCount = token[t].sellCount;
386         sell_(t, msg.sender, p, a, sellCount);
387         token[t].sellCount = sellCount + 1;
388     }
389 
390     function depositAndBuy(address t, uint p, uint a) external payable {
391         deposit();
392         buy(t, p, a);
393         if (!staticAutoWithdraw[msg.sender] && !autoWithdraw[msg.sender]) {
394             autoWithdraw[msg.sender] = true;
395         }
396     }
397 
398     function depositAndSell(address t, uint p, uint a, uint depositAmount) external {
399         depositToken(t, depositAmount);
400         sell(t, p, a);
401         if (!staticAutoWithdraw[msg.sender] && !autoWithdraw[msg.sender]) {
402             autoWithdraw[msg.sender] = true;
403         }
404     }
405 
406     function removeBuy(address t, uint i) external {
407         require(token[t].supported);
408         require(isAuctionTime(t));
409         uint index = addressToIndex[msg.sender];
410         require(index != 0);
411         uint order = token[t].buyOrders[i];
412         require(order >> 224 == index);
413         uint cost = safeMul(((order << 32) >> 144), ((order << 144) >> 144)) / (token[t].unit);
414         uint totalCost = safeAdd(cost, safeMul(cost, feeForBuyOrder(t, i)) / (1 ether));
415         balances[0][msg.sender] = safeAdd(balances[0][msg.sender], totalCost);
416         token[t].buyOrders[i] &= (((1 << 144) - 1) << 112);
417         emit BuyOrderRemoved(t, token[t].auctionIndex, msg.sender, i);
418     }
419 
420     function removeSell(address t, uint i) external {
421         require(token[t].supported);
422         require(isAuctionTime(t));
423         uint index = addressToIndex[msg.sender];
424         require(index != 0);
425         uint order = token[t].sellOrders[i];
426         require(order >> 224 == index);
427         balances[t][msg.sender] = safeAdd(balances[t][msg.sender], (order << 144) >> 144);
428         token[t].sellOrders[i] &= (((1 << 144) - 1) << 112);
429         emit SellOrderRemoved(t, token[t].auctionIndex, msg.sender, i);
430     }
431 
432     // The operator needs to finalise the on-chain orders by calling this function so that the optimal price can be calculated and the operator can filter the off-chain orders based on that price (off-chain orders that would not get filled are not submitted to the blockchain to reduce transaction fees)
433     function startReveal(address t) external {
434         require(msg.sender == operator);
435         require(isRevealTime(t));
436         require(!token[t].startedReveal);
437         revealingAuctionCount++;
438         token[t].startedReveal = true;
439     }
440 
441     // The smart contract needs to know in advance which off-chain orders are visible and which are hidden, since they can have different fees
442     // Off-chain orders are sorted so that all visible orders come before the hidden orders and submitting the count for the total number of visible orders is enough to tell which off-chain orders are visible and hidden
443     function revealPublicOrdersCount(address t, uint pbc, uint psc) external {
444         require(msg.sender == operator);
445         require(isRevealTime(t));
446         require(token[t].startedReveal);
447         require(pbc >= token[t].buyCount);
448         require(psc >= token[t].sellCount);
449         require(token[t].onchainBuyCount > token[t].buyCount); // This ensures the function can only be called once per auction
450         require(token[t].onchainSellCount > token[t].sellCount); // This ensures the function can only be called once per auction
451         token[t].onchainBuyCount = token[t].buyCount;
452         token[t].onchainSellCount = token[t].sellCount;
453         token[t].publicBuyCount = pbc;
454         token[t].publicSellCount = psc;
455     }
456 
457     function recoverHashSignatory(address t, bytes type_, uint price, uint amount, uint id, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {
458         bytes32 hash = keccak256(abi.encodePacked(type_, amount, t, price, id));
459         address signatory = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s);
460         require(signatory != address(0));
461         return signatory;
462     }
463 
464     function recoverTypedSignatory(address t, bytes type_, uint price, uint amount, uint id, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {
465         bytes32 hash = keccak256(abi.encodePacked(
466           keccak256(abi.encodePacked('string Order type', 'address Token address', 'uint256 Price', 'uint256 Amount', 'uint256 Auction index')),
467           keccak256(abi.encodePacked(type_, t, price, amount, id))
468         ));
469         address signatory = ecrecover(hash, v, r, s);
470         require(signatory != address(0));
471         return signatory;
472     }
473 
474     // Allows the operator to reveal off-chain orders (which have two benefits: they only need to be submitted if they get filled and cost no gas otherwise, and they can optionally be hidden from other users until filled)
475     function revealBuy_(address t, uint order, uint8 v, bytes32 r, bytes32 s, uint buyCount) private {
476         require(msg.sender == operator);
477         require(isRevealTime(t));
478         require(token[t].startedReveal);
479         if (buyCount > token[t].onchainBuyCount && buyCount != token[t].publicBuyCount) {
480             require(order > token[t].buyOrders[buyCount - 1]); // Enforces the ordering to prevent double submission
481         }
482         address userAddress = indexToAddress[order >> 224];
483         uint price = (order << 32) >> 144;
484         uint amount = (order << 144) >> 144;
485         uint id = token[t].auctionIndex;
486         address signedUserAddress;
487         if (buyCount < token[t].publicBuyCount) {
488             signedUserAddress = recoverTypedSignatory(t, "Public buy", price, amount, id, v, r, s);
489         } else {
490             signedUserAddress = recoverTypedSignatory(t, "Hidden buy", price, amount, id, v, r, s);
491         }
492         if (signedUserAddress != userAddress) {
493             if (buyCount < token[t].publicBuyCount) {
494                 signedUserAddress = recoverHashSignatory(t, "Public buy", price, amount, id, v, r, s);
495             } else {
496                 signedUserAddress = recoverHashSignatory(t, "Hidden buy", price, amount, id, v, r, s);
497             }
498             require(signedUserAddress == userAddress);
499         }
500         buy_(t, userAddress, price, amount, buyCount);
501     }
502 
503     function revealSell_(address t, uint order, uint8 v, bytes32 r, bytes32 s, uint sellCount) private {
504         require(msg.sender == operator);
505         require(isRevealTime(t));
506         require(token[t].startedReveal);
507         if (sellCount > token[t].onchainSellCount && sellCount != token[t].publicSellCount) {
508             require(order > token[t].sellOrders[sellCount - 1]); // Enforces the ordering to prevent double submission
509         }
510         address userAddress = indexToAddress[order >> 224];
511         uint price = (order << 32) >> 144;
512         uint amount = (order << 144) >> 144;
513         uint id = token[t].auctionIndex;
514         address signedUserAddress;
515         if (sellCount < token[t].publicSellCount) {
516             signedUserAddress = recoverTypedSignatory(t, "Public sell", price, amount, id, v, r, s);
517         } else {
518             signedUserAddress = recoverTypedSignatory(t, "Hidden sell", price, amount, id, v, r, s);
519         }
520         if (signedUserAddress != userAddress) {
521             if (sellCount < token[t].publicSellCount) {
522                 signedUserAddress = recoverHashSignatory(t, "Public sell", price, amount, id, v, r, s);
523             } else {
524                 signedUserAddress = recoverHashSignatory(t, "Hidden sell", price, amount, id, v, r, s);
525             }
526             require(signedUserAddress == userAddress);
527         }
528         sell_(t, userAddress, price, amount, sellCount);
529     }
530 
531     // The operator can submit off-chain orders in batches to reduce gas use
532     function revealBuys(address t, uint[] order, uint8[] v, bytes32[] r, bytes32[] s, uint reserveUsage) external {
533         uint buyCount = token[t].buyCount;
534         for (uint i = 0; i < order.length; i++) {
535             revealBuy_(t, order[i], v[i], r[i], s[i], buyCount);
536             buyCount++;
537         }
538         token[t].buyCount = buyCount;
539         useReserve(reserveUsage);
540     }
541 
542     function revealSells(address t, uint[] order, uint8[] v, bytes32[] r, bytes32[] s, uint reserveUsage) external {
543         uint sellCount = token[t].sellCount;
544         for (uint i = 0; i < order.length; i++) {
545             revealSell_(t, order[i], v[i], r[i], s[i], sellCount);
546             sellCount++;
547         }
548         token[t].sellCount = sellCount;
549         useReserve(reserveUsage);
550     }
551 
552 
553 
554     // Note: Excluding the tokenAddress parameter is necessary to prevent stack overflow when executing a successful sell order
555     function addEtherBalance_(address userAddress, uint amount) private {
556         bool withdrawn = false;
557         if (amount > 0) {
558             if (autoWithdraw[userAddress] && !token[0].autoWithdrawDisabled) {
559                 uint size;
560                 assembly {size := extcodesize(userAddress)}
561                 if (size == 0) {
562                     withdrawn = userAddress.send(amount);
563                 }
564             }
565             if (!withdrawn) {
566                 balances[0][userAddress] = safeAdd(balances[0][userAddress], amount);
567             }
568         }
569     }
570 
571     function addTokenBalance_(address tokenAddress, address userAddress, uint amount) private {
572         require(tokenAddress != address(0));
573         bool withdrawn = false;
574         if (amount > 0) {
575             if (autoWithdraw[userAddress] && !token[tokenAddress].autoWithdrawDisabled) {
576                 if (!token[tokenAddress].noReturnTransfer) {
577                     withdrawn = Token(tokenAddress).transfer(userAddress, amount);
578                 }
579             }
580             if (!withdrawn) {
581                 balances[tokenAddress][userAddress] = safeAdd(balances[tokenAddress][userAddress], amount);
582             }
583         }
584     }
585 
586     // Checks the volume for the given limit prices for buy and sell orders
587     function checkVolume(address t, uint pb, uint ps, uint limit, uint reserveUsage) external {
588         require(is112bit(pb));
589         require(is112bit(ps));
590         require(ps <= pb);
591         require(token[t].supported);
592         require(isCheckingTime(t));
593         require(token[t].startedReveal);
594         if (!token[t].startedCheck) {
595             revealingAuctionCount = safeSub(revealingAuctionCount, 1);
596             token[t].startedCheck = true;
597         }
598         if (token[t].checkAuctionIndex[pb][ps] < token[t].auctionIndex) {
599             token[t].checkIndex[pb][ps] = 0;
600             token[t].checkBuyVolume[pb][ps] = 0;
601             token[t].checkSellVolume[pb][ps] = 0;
602             token[t].checkAuctionIndex[pb][ps] = token[t].auctionIndex;
603         }
604         uint buyVolume = token[t].checkBuyVolume[pb][ps];
605         uint order;
606         for (uint i = token[t].checkIndex[pb][ps]; (i < safeAdd(token[t].checkIndex[pb][ps], limit)) && (i < token[t].buyCount); i++) {
607             order = token[t].buyOrders[i];
608             if ((order << 32) >> 144 >= pb) {
609                 buyVolume += (order << 144) >> 144;
610             }
611         }
612         uint sellVolume = token[t].checkSellVolume[pb][ps];
613         for (i = token[t].checkIndex[pb][ps]; (i < safeAdd(token[t].checkIndex[pb][ps], limit)) && (i < token[t].sellCount); i++) {
614             order = token[t].sellOrders[i];
615             if ((order << 32) >> 144 <= ps) {
616                 sellVolume += (order << 144) >> 144;
617             }
618         }
619         token[t].checkIndex[pb][ps] = safeAdd(token[t].checkIndex[pb][ps], limit);
620         if ((token[t].checkIndex[pb][ps] >= token[t].buyCount) && (token[t].checkIndex[pb][ps] >= token[t].sellCount)) {
621             uint volume;
622             if (buyVolume < sellVolume) {
623                 volume = buyVolume;
624             } else {
625                 volume = sellVolume;
626             }
627             if (volume > token[t].maxVolume || (volume == token[t].maxVolume && pb > token[t].maxVolumePriceB) || (volume == token[t].maxVolume && pb == token[t].maxVolumePriceB && ps < token[t].maxVolumePriceS)) {
628                 token[t].maxVolume = volume;
629                 if (buyVolume > sellVolume) {
630                     token[t].maxVolumePrice = pb;
631                 } else {
632                     if (sellVolume > buyVolume) {
633                         token[t].maxVolumePrice = ps;
634                     } else {
635                         token[t].maxVolumePrice = ps;
636                         token[t].maxVolumePrice += (pb - ps) / 2;
637                     }
638                 }
639                 token[t].maxVolumePriceB = pb;
640                 token[t].maxVolumePriceS = ps;
641             }
642             // Requires a final call from the operator to confirm the auction, in order to prevent potential spam attacks
643             // The optimal price from the received submissions will still be chosen, but this ensures that the operator's price suggestion is always considered
644             if (msg.sender == operator) {
645                 token[t].toBeExecuted = true;
646             }
647         } else {
648             token[t].checkBuyVolume[pb][ps] = buyVolume;
649             token[t].checkSellVolume[pb][ps] = sellVolume;
650         }
651         if (msg.sender == operator) {
652             useReserve(reserveUsage);
653         }
654     }
655 
656     function executeAuction(address t, uint limit, uint reserveUsage) external {
657         require(isExecutionTime(t));
658         require(token[t].supported);
659         require(token[t].activeAuction);
660         // Set flags that allow withdrawal even if no checkVolume() call was made in the Check period
661         if (!token[t].startedCheck) {
662             // Only decrement revealingAuctionCount if it was incremented by startReveal()
663             if (token[t].startedReveal) {
664                 revealingAuctionCount = safeSub(revealingAuctionCount, 1);
665             }
666             token[t].startedCheck = true;
667         }
668         // If the auction could not be confirmed, execution is avoided by setting the volume to zero
669         if (!token[t].toBeExecuted) {
670             token[t].maxVolume = 0;
671         }
672         if (!token[t].startedExecute) {
673             token[t].startedExecute = true;
674         }
675         uint amount;
676         uint volume = token[t].executionBuyVolume;
677         uint[6] memory current; // A memory array is required to avoid stack overflow, index descriptions below:
678         // [0] - currentOrder
679         // [1] - currentCost
680         // [2] - currentTotalCost
681         // [3] - currentNewCost
682         // [4] - currentNewTotalCost
683         // [5] - currentFee
684         uint feeAccountBalance = balances[0][feeAccount];
685         address currentAddress;
686         for (uint i = token[t].executionIndex; (i < safeAdd(token[t].executionIndex, limit)) && (i < token[t].buyCount); i++) {
687             current[0] = token[t].buyOrders[i];
688             currentAddress = indexToAddress[current[0] >> 224];
689             if ((current[0] << 32) >> 144 >= token[t].maxVolumePriceB && volume < token[t].maxVolume) {
690                 // If the order gets filled
691                 amount = (current[0] << 144) >> 144;
692                 volume += amount;
693                 if (volume > token[t].maxVolume) {
694                     // If the volume overflows, return the difference
695                     current[1] = safeMul((current[0] << 32) >> 144, amount) / (token[t].unit);
696                     current[2] = safeAdd(current[1], safeMul(current[1], feeForBuyOrder(t, i)) / (1 ether));
697                     amount = safeSub(amount, safeSub(volume, token[t].maxVolume));
698                     current[3] = safeMul((current[0] << 32) >> 144, amount) / (token[t].unit);
699                     current[4] = safeAdd(current[3], safeMul(current[3], feeForBuyOrder(t, i)) / (1 ether));
700                     addEtherBalance_(currentAddress, safeSub(current[2], current[4]));
701                 }
702                 if ((current[0] << 32) >> 144 > token[t].maxVolumePrice) {
703                     // If the price is different, return the difference
704                     current[1] = safeMul((current[0] << 32) >> 144, amount) / (token[t].unit);
705                     current[2] = safeAdd(current[1], safeMul(current[1], feeForBuyOrder(t, i)) / (1 ether));
706                     current[3] = safeMul(token[t].maxVolumePrice, amount) / (token[t].unit);
707                     current[4] = safeAdd(current[3], safeMul(current[3], feeForBuyOrder(t, i)) / (1 ether));
708                     addEtherBalance_(currentAddress, safeSub(current[2], current[4]));
709                 }
710                 // Add the correct amount of tokens
711                 addTokenBalance_(t, currentAddress, amount);
712                 current[5] = safeMul(safeMul(token[t].maxVolumePrice, amount) / (token[t].unit), feeForBuyOrder(t, i)) / (1 ether);
713                 feeAccountBalance += current[5];
714             } else {
715                 // If there is no liquidity left to fill the order, return the whole amount
716                 current[1] = safeMul((current[0] << 32) >> 144, (current[0] << 144) >> 144) / (token[t].unit);
717                 current[2] = safeAdd(current[1], safeMul(current[1], feeForBuyOrder(t, i)) / (1 ether));
718                 addEtherBalance_(currentAddress, current[2]);
719             }
720         }
721         token[t].executionBuyVolume = volume;
722         volume = token[t].executionSellVolume;
723         for (i = token[t].executionIndex; (i < safeAdd(token[t].executionIndex, limit)) && (i < token[t].sellCount); i++) {
724             current[0] = token[t].sellOrders[i];
725             currentAddress = indexToAddress[current[0] >> 224];
726             if ((current[0] << 32) >> 144 <= token[t].maxVolumePriceS && volume < token[t].maxVolume) {
727                 // If the order gets filled
728                 amount = (current[0] << 144) >> 144;
729                 volume += amount;
730                 if (volume > token[t].maxVolume) {
731                     // If the volume overflows, return the difference
732                     addTokenBalance_(t, currentAddress, safeSub(volume, token[t].maxVolume));
733                     amount = safeSub(amount, safeSub(volume, token[t].maxVolume));
734                 }
735                 // Add the correct amount of ether
736                 current[5] = safeMul(safeMul(token[t].maxVolumePrice, amount) / (token[t].unit), feeForSellOrder(t, i)) / (1 ether);
737                 addEtherBalance_(currentAddress, safeSub(safeMul(token[t].maxVolumePrice, amount) / (token[t].unit), current[5]));
738                 feeAccountBalance += current[5];
739             } else {
740                 // If there is no liquidity left to fill the order, return the whole amount
741                 addTokenBalance_(t, currentAddress, (current[0] << 144) >> 144);
742             }
743         }
744         token[t].executionSellVolume = volume;
745         balances[0][feeAccount] = feeAccountBalance;
746         token[t].executionIndex = safeAdd(token[t].executionIndex, limit);
747         if ((token[t].executionIndex >= token[t].buyCount) && (token[t].executionIndex >= token[t].sellCount)) {
748             if (token[t].maxVolume > 0) {
749                 token[t].lastPrice = token[t].maxVolumePrice;
750                 emit AuctionHistory(t, token[t].auctionIndex, token[t].nextAuctionTime, token[t].maxVolumePrice, token[t].maxVolume);
751             }
752             token[t].buyCount = 0;
753             token[t].sellCount = 0;
754             token[t].maxVolume = 0;
755             token[t].executionIndex = 0;
756             token[t].executionBuyVolume = 0;
757             token[t].executionSellVolume = 0;
758             token[t].toBeExecuted = false;
759             token[t].activeAuction = false;
760             token[t].auctionIndex++;
761             activeAuctionCount = safeSub(activeAuctionCount, 1);
762             if (token[t].lastAuction) {
763                 token[t].supported = false;
764             }
765         }
766         useReserve(reserveUsage);
767     }
768 
769 
770 
771     function register_() private returns (uint32) {
772         require(is32bit(indexToAddress.length + 1));
773         require(addressToIndex[msg.sender] == 0);
774         uint32 index = uint32(indexToAddress.length);
775         addressToIndex[msg.sender] = index;
776         indexToAddress.push(msg.sender);
777         return index;
778     }
779 
780     function deposit() public payable {
781         address index = addressToIndex[msg.sender];
782         if (index == 0) {
783             index = register_();
784         }
785         balances[0][msg.sender] = safeAdd(balances[0][msg.sender], msg.value);
786         emit Deposit(0, msg.sender, msg.value);
787         if (!staticAutoWithdraw[msg.sender] && autoWithdraw[msg.sender]) {
788             autoWithdraw[msg.sender] = false;
789         }
790     }
791 
792     function withdraw(uint a) external {
793         require(balances[0][msg.sender] >= a);
794         // Withdrawals are not allowed while any auction is in the Reveal period
795         require(revealingAuctionCount == 0);
796         balances[0][msg.sender] = safeSub(balances[0][msg.sender], a);
797         emit Withdrawal(0, msg.sender, a);
798         require(msg.sender.send(a));
799     }
800 
801     function depositToken_(address t, uint a, address u) private {
802         require(t > 0);
803         require(token[t].supported);
804         uint32 index = addressToIndex[u];
805         if (index == 0) {
806             index = register_();
807         }
808         if (!token[t].noReturnTransferFrom) {
809             require(Token(t).transferFrom(u, this, a));
810         } else {
811             NoReturnToken(t).transferFrom(u, this, a);
812         }
813         balances[t][u] = safeAdd(balances[t][u], a);
814         emit Deposit(t, u, a);
815         if (!staticAutoWithdraw[u] && autoWithdraw[u]) {
816             autoWithdraw[u] = false;
817         }
818     }
819 
820     // It is necessary to call Token(t).approve(this, a) before depositToken() can complete the transfer
821     function depositToken(address t, uint a) public {
822         depositToken_(t, a, msg.sender);
823     }
824 
825     // Automatically runs depositToken() or depositAndSell() on Token(t).approveAndCall(this, a, d)
826     // Sell order is placed if the extraData in d is 64 bytes long, with the first half being the price and the second the amount
827     function receiveApproval(address u, uint256 a, address t, bytes d) external {
828         require(t == msg.sender);
829         require(token[t].supported);
830         if (d.length < 64) {
831             depositToken_(t, a, u);
832         } else {
833             require(d.length == 64);
834             uint price;
835             uint amount;
836             assembly { price := calldataload(164) } // Skip 4 bytes for the function identifier, 3×32 for the other parameters and 2×32 for the dynamically-sized byte array's length
837             assembly { amount := calldataload(196) }
838             // depositAndSell() with custom userAddress
839             depositToken_(t, a, u);
840             // sell() with custom userAddress
841             require(isAuctionTime(t));
842             uint sellCount = token[t].sellCount;
843             sell_(t, u, price, amount, sellCount);
844             token[t].sellCount = sellCount + 1;
845             if (!staticAutoWithdraw[u] && !autoWithdraw[u]) {
846                 autoWithdraw[u] = true;
847             }
848         }
849     }
850 
851     function withdrawToken(address t, uint a) external {
852         require(t > 0);
853         require(balances[t][msg.sender] >= a);
854         // Withdrawals are not allowed while the specified token's auction is in the Reveal period
855         require((!token[t].startedReveal) || (token[t].startedCheck));
856         balances[t][msg.sender] = safeSub(balances[t][msg.sender], a);
857         emit Withdrawal(t, msg.sender, a);
858         if (!token[t].noReturnTransfer) {
859             require(Token(t).transfer(msg.sender, a));
860         } else {
861             NoReturnToken(t).transfer(msg.sender, a);
862         }
863     }
864 
865     // Allows the operator to withdraw on behalf of the user when authorised by signature
866     // This is a bonus feature for convenience so that the user can pay the transaction fee for withdrawal from their auction balance if they have no Ether left on their account
867     function withdrawForUser(address u, address t, uint a, address feeAddress, uint fee, uint8 v, bytes32 r, bytes32 s) external {
868         require(msg.sender == operator);
869         require(u != address(0));
870         bytes32 hash = keccak256(abi.encodePacked(t, a, feeAddress, fee, signedWithdrawalNonce[u]));
871         address signatory = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", hash)), v, r, s);
872         require(signatory == u);
873         signedWithdrawalNonce[u]++;
874         balances[feeAddress][u] = safeSub(balances[feeAddress][u], fee);
875         balances[feeAddress][feeAccount] = safeAdd(balances[feeAddress][feeAccount], fee);
876         require(balances[t][u] >= a);
877         if (t == address(0)) {
878             balances[t][u] = safeSub(balances[t][u], a);
879             emit Withdrawal(t, u, a);
880             require(u.call.value(a)());
881         } else {
882             balances[t][u] = safeSub(balances[t][u], a);
883             emit Withdrawal(t, u, a);
884             if (!token[t].noReturnTransfer) {
885                 require(Token(t).transfer(u, a));
886             } else {
887                 NoReturnToken(t).transfer(u, a);
888             }
889         }
890     }
891 
892     function setStaticAutoWithdraw(bool b) external {
893         staticAutoWithdraw[msg.sender] = b;
894     }
895 
896     function setAutoWithdrawDisabled(address t, bool b) external {
897         require(msg.sender == operator);
898         token[t].autoWithdrawDisabled = b;
899     }
900 
901     function setVerifiedContract(address c, bool b) external {
902         require(msg.sender == admin);
903         verifiedContract[c] = b;
904     }
905 
906     // Allows the admin to claim tokens that had never been supported (and therefore could never have been deposited directly by a user, only transferred)
907     // This may allow us to distribute tokens to users from large airdrops or tokens with a new smart contract
908     function claimNeverSupportedToken(address t, uint a) external {
909         require(!token[t].everSupported);
910         require(msg.sender == admin);
911         require(Token(t).balanceOf(this) >= a);
912         balances[t][msg.sender] = safeAdd(balances[t][msg.sender], a);
913     }
914 
915     // Allows migrating all the user's funds to an upgraded smart contract
916     function migrate(address contractAddress, uint low, uint high) external {
917         require(verifiedContract[contractAddress]);
918         require(tokenList.length > 0);
919         // Withdrawals are not allowed while any auction is in the Reveal period
920         require(revealingAuctionCount == 0);
921         uint amount = 0;
922         if (balances[0][msg.sender] > 0) {
923             amount = balances[0][msg.sender];
924             balances[0][msg.sender] = 0;
925             NewAuction(contractAddress).depositForUser.value(amount)(msg.sender);
926         }
927         uint to;
928         if (high >= tokenList.length) {
929             to = safeSub(tokenList.length, 1);
930         } else {
931             to = high;
932         }
933         for (uint i=low; i <= to; i++) {
934             if (balances[tokenList[i]][msg.sender] > 0) {
935                 amount = balances[tokenList[i]][msg.sender];
936                 balances[tokenList[i]][msg.sender] = 0;
937                 if (!token[tokenList[i]].noReturnApprove) {
938                     require(Token(tokenList[i]).approve(contractAddress, balances[tokenList[i]][msg.sender]));
939                 } else {
940                     NoReturnToken(tokenList[i]).approve(contractAddress, balances[tokenList[i]][msg.sender]);
941                 }
942                 NewAuction(contractAddress).depositTokenForUser(msg.sender, tokenList[i], amount);
943             }
944         }
945     }
946 
947 
948 
949     function getBalance(address t, address a) external constant returns (uint) {
950         return balances[t][a];
951     }
952 
953     function getBuyCount(address t) external constant returns (uint) {
954         return token[t].buyCount;
955     }
956 
957     function getBuyAddress(address t, uint i) external constant returns (address) {
958         return indexToAddress[token[t].buyOrders[i] >> 224];
959     }
960 
961     function getBuyPrice(address t, uint i) external constant returns (uint) {
962         return (token[t].buyOrders[i] << 32) >> 144;
963     }
964 
965     function getBuyAmount(address t, uint i) external constant returns (uint) {
966         return (token[t].buyOrders[i] << 144) >> 144;
967     }
968 
969     function getSellCount(address t) external constant returns (uint) {
970         return token[t].sellCount;
971     }
972 
973     function getSellAddress(address t, uint i) external constant returns (address) {
974         return indexToAddress[token[t].sellOrders[i] >> 224];
975     }
976 
977     function getSellPrice(address t, uint i) external constant returns (uint) {
978         return (token[t].sellOrders[i] << 32) >> 144;
979     }
980 
981     function getSellAmount(address t, uint i) external constant returns (uint) {
982         return (token[t].sellOrders[i] << 144) >> 144;
983     }
984 
985     function getMaxVolume(address t) external constant returns (uint) {
986         return token[t].maxVolume;
987     }
988 
989     function getMaxVolumePriceB(address t) external constant returns (uint) {
990         return token[t].maxVolumePriceB;
991     }
992 
993     function getMaxVolumePriceS(address t) external constant returns (uint) {
994         return token[t].maxVolumePriceS;
995     }
996 
997     function getMaxVolumePrice(address t) external constant returns (uint) {
998         return token[t].maxVolumePrice;
999     }
1000 
1001     function getUserIndex(address u) external constant returns (uint) {
1002         return addressToIndex[u];
1003     }
1004 
1005     function getAuctionIndex(address t) external constant returns (uint) {
1006         return token[t].auctionIndex;
1007     }
1008 
1009     function getNextAuctionTime(address t) external constant returns (uint) {
1010         return token[t].nextAuctionTime;
1011     }
1012 
1013     function getLastPrice(address t) external constant returns (uint) {
1014         return token[t].lastPrice;
1015     }
1016 }