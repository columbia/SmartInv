1 pragma solidity ^0.4.19;
2 
3 contract Token {
4     bytes32 public standard;
5     bytes32 public name;
6     bytes32 public symbol;
7     uint256 public totalSupply;
8     uint8 public decimals;
9     bool public allowTransactions;
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12     function transfer(address _to, uint256 _value) returns (bool success);
13     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
14     function approve(address _spender, uint256 _value) returns (bool success);
15     function transferFrom(address _from, address _to, uint256 _value) returns (bool success); 
16 }
17 
18 contract EthermiumAffiliates {
19     mapping(address => address[]) public referrals; // mapping of affiliate address to referral addresses
20     mapping(address => address) public affiliates; // mapping of referrals addresses to affiliate addresses
21     mapping(address => bool) public admins; // mapping of admin accounts
22     string[] public affiliateList;
23     address public owner;
24 
25     function setOwner(address newOwner);
26     function setAdmin(address admin, bool isAdmin) public;
27     function assignReferral (address affiliate, address referral) public;    
28 
29     function getAffiliateCount() returns (uint);
30     function getAffiliate(address refferal) public returns (address);
31     function getReferrals(address affiliate) public returns (address[]);
32 }
33 
34 contract EthermiumTokenList {
35     function isTokenInList(address tokenAddress) public constant returns (bool);
36 }
37 
38 
39 contract Exchange {
40     function assert(bool assertion) {
41         if (!assertion) throw;
42     }
43     function safeMul(uint a, uint b) returns (uint) {
44         uint c = a * b;
45         assert(a == 0 || c / a == b);
46         return c;
47     }
48 
49     function safeSub(uint a, uint b) returns (uint) {
50         assert(b <= a);
51         return a - b;
52     }
53 
54     function safeAdd(uint a, uint b) returns (uint) {
55         uint c = a + b;
56         assert(c>=a && c>=b);
57         return c;
58     }
59     address public owner;
60     mapping (address => uint256) public invalidOrder;
61 
62     event SetOwner(address indexed previousOwner, address indexed newOwner);
63     modifier onlyOwner {
64         assert(msg.sender == owner);
65         _;
66     }
67     function setOwner(address newOwner) onlyOwner {
68         SetOwner(owner, newOwner);
69         owner = newOwner;
70     }
71     function getOwner() returns (address out) {
72         return owner;
73     }
74     function invalidateOrdersBefore(address user, uint256 nonce) onlyAdmin {
75         if (nonce < invalidOrder[user]) throw;
76         invalidOrder[user] = nonce;
77     }
78 
79     mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances
80 
81     mapping (address => bool) public admins;
82     mapping (address => uint256) public lastActiveTransaction;
83     mapping (bytes32 => uint256) public orderFills;
84     address public feeAccount;
85     uint256 public feeAffiliate; // percentage times (1 ether)
86     uint256 public inactivityReleasePeriod;
87     mapping (bytes32 => bool) public traded;
88     mapping (bytes32 => bool) public withdrawn;
89     uint256 public makerFee; // fraction * 1 ether
90     uint256 public takerFee; // fraction * 1 ether
91     uint256 public affiliateFee; // fraction as proportion of 1 ether
92     uint256 public makerAffiliateFee; // wei deductible from makerFee
93     uint256 public takerAffiliateFee; // wei deductible form takerFee
94 
95     mapping (address => address) public referrer;  // mapping of user addresses to their referrer addresses
96 
97     address public affiliateContract;
98     address public tokenListContract;
99 
100 
101     enum Errors {
102         INVLID_PRICE,           // Order prices don't match
103         INVLID_SIGNATURE,       // Signature is invalid
104         TOKENS_DONT_MATCH,      // Maker/taker tokens don't match
105         ORDER_ALREADY_FILLED,    // Order was already filled
106         GAS_TOO_HIGH    // Order was already filled
107     }
108   
109     event Order(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
110     event Cancel(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
111     event Trade(
112         address takerTokenBuy, uint256 takerAmountBuy,
113         address takerTokenSell, uint256 takerAmountSell,
114         address maker, address taker,
115         uint256 makerFee, uint256 takerFee,
116         uint256 makerAmountTaken, uint256 takerAmountTaken,
117         bytes32 makerOrderHash, bytes32 takerOrderHash
118     );
119     event Deposit(address token, address user, uint256 amount, uint256 balance, address referrerAddress);
120     event Withdraw(address token, address user, uint256 amount, uint256 balance);
121     event FeeChange(uint256 makerFee, uint256 takerFee, uint256 affiliateFee);
122     event AffiliateFeeChange(uint256 newAffiliateFee);
123     event LogError(uint8 indexed errorId, bytes32 indexed orderHash);
124     event CancelOrder(bytes32 cancelHash, bytes32 orderHash, address user, address tokenSell, uint256 amountSell, uint256 cancelFee);
125 
126     function setInactivityReleasePeriod(uint256 expiry) onlyAdmin returns (bool success) {
127         if (expiry > 1000000) throw;
128         inactivityReleasePeriod = expiry;
129         return true;
130     }
131 
132     function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_, uint256 affiliateFee_, address affiliateContract_, address tokenListContract_) {
133         owner = msg.sender;
134         feeAccount = feeAccount_;
135         inactivityReleasePeriod = 100000;
136         makerFee = makerFee_;
137         takerFee = takerFee_;
138         affiliateFee = affiliateFee_;
139 
140 
141 
142         makerAffiliateFee = safeMul(makerFee, affiliateFee_) / (1 ether);
143         takerAffiliateFee = safeMul(takerFee, affiliateFee_) / (1 ether);
144 
145         affiliateContract = affiliateContract_;
146         tokenListContract = tokenListContract_;
147     }
148 
149     function setFees(uint256 makerFee_, uint256 takerFee_, uint256 affiliateFee_) onlyOwner {
150         require(makerFee_ < 10 finney && takerFee_ < 10 finney);
151         require(affiliateFee_ > affiliateFee);
152         makerFee = makerFee_;
153         takerFee = takerFee_;
154         affiliateFee = affiliateFee_;
155         makerAffiliateFee = safeMul(makerFee, affiliateFee_) / (1 ether);
156         takerAffiliateFee = safeMul(takerFee, affiliateFee_) / (1 ether);
157 
158         FeeChange(makerFee, takerFee, affiliateFee_);
159     }
160 
161     function setAdmin(address admin, bool isAdmin) onlyOwner {
162         admins[admin] = isAdmin;
163     }
164 
165     modifier onlyAdmin {
166         if (msg.sender != owner && !admins[msg.sender]) throw;
167         _;
168     }
169 
170     function() external {
171         throw;
172     }
173 
174     function depositToken(address token, uint256 amount, address referrerAddress) {
175         //require(EthermiumTokenList(tokenListContract).isTokenInList(token));
176         if (referrerAddress == msg.sender) referrerAddress = address(0);
177         if (referrer[msg.sender] == address(0x0))   {
178             if (referrerAddress != address(0x0) && EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender) == address(0))
179             {
180                 referrer[msg.sender] = referrerAddress;
181                 EthermiumAffiliates(affiliateContract).assignReferral(referrerAddress, msg.sender);
182             }
183             else
184             {
185                 referrer[msg.sender] = EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender);
186             }
187         } 
188         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
189         lastActiveTransaction[msg.sender] = block.number;
190         if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
191         Deposit(token, msg.sender, amount, tokens[token][msg.sender], referrer[msg.sender]);
192     }
193 
194     function deposit(address referrerAddress) payable {
195         if (referrerAddress == msg.sender) referrerAddress = address(0);
196         if (referrer[msg.sender] == address(0x0))   {
197             if (referrerAddress != address(0x0) && EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender) == address(0))
198             {
199                 referrer[msg.sender] = referrerAddress;
200                 EthermiumAffiliates(affiliateContract).assignReferral(referrerAddress, msg.sender);
201             }
202             else
203             {
204                 referrer[msg.sender] = EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender);
205             }
206         } 
207         tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
208         lastActiveTransaction[msg.sender] = block.number;
209         Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender], referrer[msg.sender]);
210     }
211 
212     function withdraw(address token, uint256 amount) returns (bool success) {
213         if (safeSub(block.number, lastActiveTransaction[msg.sender]) < inactivityReleasePeriod) throw;
214         if (tokens[token][msg.sender] < amount) throw;
215         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
216         if (token == address(0)) {
217             if (!msg.sender.send(amount)) throw;
218         } else {
219             if (!Token(token).transfer(msg.sender, amount)) throw;
220         }
221         Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
222     }
223 
224     function adminWithdraw(address token, uint256 amount, address user, uint256 nonce, uint8 v, bytes32 r, bytes32 s, uint256 feeWithdrawal) onlyAdmin returns (bool success) {
225         bytes32 hash = keccak256(this, token, amount, user, nonce);
226         if (withdrawn[hash]) throw;
227         withdrawn[hash] = true;
228         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) throw;
229         if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney;
230         if (tokens[token][user] < amount) throw;
231         tokens[token][user] = safeSub(tokens[token][user], amount);
232         tokens[address(0)][user] = safeSub(tokens[address(0x0)][user], feeWithdrawal);
233         //tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], safeMul(feeWithdrawal, amount) / 1 ether);
234         tokens[address(0)][feeAccount] = safeAdd(tokens[address(0)][feeAccount], feeWithdrawal);
235 
236         //amount = safeMul((1 ether - feeWithdrawal), amount) / 1 ether;
237         if (token == address(0)) {
238             if (!user.send(amount)) throw;
239         } else {
240             if (!Token(token).transfer(user, amount)) throw;
241         }
242         lastActiveTransaction[user] = block.number;
243         Withdraw(token, user, amount, tokens[token][user]);
244     }
245 
246     function balanceOf(address token, address user) constant returns (uint256) {
247         return tokens[token][user];
248     }
249 
250     struct OrderPair {
251         uint256 makerAmountBuy;
252         uint256 makerAmountSell;
253         uint256 makerNonce;
254         uint256 takerAmountBuy;
255         uint256 takerAmountSell;
256         uint256 takerNonce;
257         uint256 takerGasFee;
258 
259         address makerTokenBuy;
260         address makerTokenSell;
261         address maker;
262         address takerTokenBuy;
263         address takerTokenSell;
264         address taker;
265 
266         bytes32 makerOrderHash;
267         bytes32 takerOrderHash;
268     }
269 
270     struct TradeValues {
271         uint256 qty;
272         uint256 invQty;
273         uint256 makerAmountTaken;
274         uint256 takerAmountTaken;
275         address makerReferrer;
276         address takerReferrer;
277     }
278 
279 
280 
281   
282     function trade(
283         uint8[2] v,
284         bytes32[4] rs,
285         uint256[7] tradeValues,
286         address[6] tradeAddresses
287     ) onlyAdmin returns (uint filledTakerTokenAmount) 
288     {
289     
290         /* tradeValues
291           [0] makerAmountBuy
292           [1] makerAmountSell
293           [2] makerNonce
294           [3] takerAmountBuy
295           [4] takerAmountSell
296           [5] takerNonce
297           [6] takerGasFee
298 
299           tradeAddresses
300           [0] makerTokenBuy
301           [1] makerTokenSell
302           [2] maker
303           [3] takerTokenBuy
304           [4] takerTokenSell
305           [5] taker
306         */
307 
308         OrderPair memory t  = OrderPair({
309             makerAmountBuy  : tradeValues[0],
310             makerAmountSell : tradeValues[1],
311             makerNonce      : tradeValues[2],
312             takerAmountBuy  : tradeValues[3],
313             takerAmountSell : tradeValues[4],
314             takerNonce      : tradeValues[5],
315             takerGasFee     : tradeValues[6],
316 
317             makerTokenBuy   : tradeAddresses[0],
318             makerTokenSell  : tradeAddresses[1],
319             maker           : tradeAddresses[2],
320             takerTokenBuy   : tradeAddresses[3],
321             takerTokenSell  : tradeAddresses[4],
322             taker           : tradeAddresses[5],
323 
324             makerOrderHash  : keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]),
325             takerOrderHash  : keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5])
326         });
327 
328         //bytes32 makerOrderHash = keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]);
329         //bytes32 makerOrderHash = §
330         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker) 
331         {
332             LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash);
333             return 0;
334         }
335         //bytes32 takerOrderHash = keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5]);
336         //bytes32 takerOrderHash = keccak256(this, t.takerTokenBuy, t.takerAmountBuy, t.takerTokenSell, t.takerAmountSell, t.takerNonce, t.taker);
337         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
338         {
339             LogError(uint8(Errors.INVLID_SIGNATURE), t.takerOrderHash);
340             return 0;
341         }
342 
343         if (t.makerTokenBuy != t.takerTokenSell || t.makerTokenSell != t.takerTokenBuy) 
344         {
345             LogError(uint8(Errors.TOKENS_DONT_MATCH), t.takerOrderHash);
346             return 0;
347         } // tokens don't match
348 
349         if (t.takerGasFee > 100 finney)
350         {
351             LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash);
352             return 0;
353         } // takerGasFee too high
354 
355 
356 
357         if (!(
358         (t.makerTokenBuy != address(0x0) && safeMul(t.makerAmountSell, 1 ether) / t.makerAmountBuy >= safeMul(t.takerAmountBuy, 1 ether) / t.takerAmountSell)
359         ||
360         (t.makerTokenBuy == address(0x0) && safeMul(t.makerAmountBuy, 1 ether) / t.makerAmountSell <= safeMul(t.takerAmountSell, 1 ether) / t.takerAmountBuy)
361         )) 
362         {
363             LogError(uint8(Errors.INVLID_PRICE), t.makerOrderHash);
364             return 0; // prices don't match
365         }
366 
367         TradeValues memory tv = TradeValues({
368             qty                 : 0,
369             invQty              : 0,
370             makerAmountTaken    : 0,
371             takerAmountTaken    : 0,
372             makerReferrer       : referrer[t.maker],
373             takerReferrer       : referrer[t.taker]
374         });
375 
376         if (tv.makerReferrer == address(0x0)) tv.makerReferrer = feeAccount;
377         if (tv.takerReferrer == address(0x0)) tv.takerReferrer = feeAccount;
378 
379         
380 
381         // maker buy, taker sell
382         if (t.makerTokenBuy != address(0x0)) 
383         {
384             
385 
386             tv.qty = min(safeSub(t.makerAmountBuy, orderFills[t.makerOrderHash]), safeSub(t.takerAmountSell, safeMul(orderFills[t.takerOrderHash], t.takerAmountSell) / t.takerAmountBuy));
387             if (tv.qty == 0)
388             {
389                 LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash);
390                 return 0;
391             }
392 
393             tv.invQty = safeMul(tv.qty, t.makerAmountSell) / t.makerAmountBuy;
394 
395             tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.invQty);
396             tv.makerAmountTaken                         = safeSub(tv.qty, safeMul(tv.qty, makerFee) / (1 ether));
397             tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);
398             tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.qty,    makerAffiliateFee) / (1 ether));
399             
400             tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.qty);
401             tv.takerAmountTaken                         = safeSub(safeSub(tv.invQty, safeMul(tv.invQty, takerFee) / (1 ether)), safeMul(tv.invQty, t.takerGasFee) / (1 ether));
402             tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);
403             tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.invQty, takerAffiliateFee) / (1 ether));
404 
405             tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.qty,    safeSub(makerFee, makerAffiliateFee)) / (1 ether));
406             tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.invQty, safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.invQty, t.takerGasFee) / (1 ether)));
407 
408            
409             orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.qty);
410             orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], safeMul(tv.qty, t.takerAmountBuy) / t.takerAmountSell);
411             lastActiveTransaction[t.maker]          = block.number;
412             lastActiveTransaction[t.taker]          = block.number;
413 
414             Trade(
415                 t.takerTokenBuy, tv.qty,
416                 t.takerTokenSell, tv.invQty,
417                 t.maker, t.taker,
418                 makerFee, takerFee,
419                 tv.makerAmountTaken , tv.takerAmountTaken,
420                 t.makerOrderHash, t.takerOrderHash
421             );
422             return tv.qty;
423         }
424         // maker sell, taker buy
425         else
426         {
427 
428             tv.qty = min(safeSub(t.makerAmountSell,  safeMul(orderFills[t.makerOrderHash], t.makerAmountSell) / t.makerAmountBuy), safeSub(t.takerAmountBuy, orderFills[t.takerOrderHash]));
429             if (tv.qty == 0)
430             {
431                 LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash);
432                 return 0;
433             }
434 
435             tv.invQty = safeMul(tv.qty, t.makerAmountBuy) / t.makerAmountSell;
436 
437             tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.qty);
438             tv.makerAmountTaken                         = safeSub(tv.invQty, safeMul(tv.invQty, makerFee) / (1 ether));
439             tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);
440             tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.invQty, makerAffiliateFee) / (1 ether));
441             
442             tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.invQty);
443             tv.takerAmountTaken                         = safeSub(safeSub(tv.qty,    safeMul(tv.qty, takerFee) / (1 ether)), safeMul(tv.qty, t.takerGasFee) / (1 ether));
444             tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);
445             tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.qty,    takerAffiliateFee) / (1 ether));
446 
447             tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.invQty, safeSub(makerFee, makerAffiliateFee)) / (1 ether));
448             tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.qty,    safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether)));
449 
450             orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.invQty);
451             orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty); //safeMul(qty, tradeValues[takerAmountBuy]) / tradeValues[takerAmountSell]);
452 
453             lastActiveTransaction[t.maker]          = block.number;
454             lastActiveTransaction[t.taker]          = block.number;
455 
456             Trade(
457                 t.takerTokenBuy, tv.qty,
458                 t.takerTokenSell, tv.invQty,
459                 t.maker, t.taker,
460                 makerFee, takerFee,
461                 tv.makerAmountTaken , tv.takerAmountTaken,
462                 t.makerOrderHash, t.takerOrderHash
463             );
464             return tv.qty;
465         }
466     }
467     
468     function batchOrderTrade(
469         uint8[2][] v,
470         bytes32[4][] rs,
471         uint256[7][] tradeValues,
472         address[6][] tradeAddresses
473     )
474     {
475         for (uint i = 0; i < tradeAddresses.length; i++) {
476             trade(
477                 v[i],
478                 rs[i],
479                 tradeValues[i],
480                 tradeAddresses[i]            
481             );
482         }
483     }
484 
485     function cancelOrder(
486 		/*
487 		[0] orderV
488 		[1] cancelV
489 		*/
490 	    uint8[2] v,
491 
492 		/*
493 		[0] orderR
494 		[1] orderS
495 		[2] cancelR
496 		[3] cancelS
497 		*/
498 	    bytes32[4] rs,
499 
500 		/*
501 		[0] orderAmountBuy
502 		[1] orderAmountSell
503 		[2] orderNonce
504 		[3] cancelNonce
505 		[4] cancelFee
506 		*/
507 		uint256[5] cancelValues,
508 
509 		/*
510 		[0] orderTokenBuy
511 		[1] orderTokenSell
512 		[2] orderUser
513 		[3] cancelUser
514 		*/
515 		address[4] cancelAddresses
516     ) public onlyAdmin {
517         // Order values should be valid and signed by order owner
518         bytes32 orderHash = keccak256(
519 	        this, cancelAddresses[0], cancelValues[0], cancelAddresses[1],
520 	        cancelValues[1], cancelValues[2], cancelAddresses[2]
521         );
522         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) == cancelAddresses[2]);
523 
524         // Cancel action should be signed by cancel's initiator
525         bytes32 cancelHash = keccak256(this, orderHash, cancelAddresses[3], cancelValues[3]);
526         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", cancelHash), v[1], rs[2], rs[3]) == cancelAddresses[3]);
527 
528         // Order owner should be same as cancel's initiator
529         require(cancelAddresses[2] == cancelAddresses[3]);
530 
531         // Do not allow to cancel already canceled or filled orders
532         require(orderFills[orderHash] != cancelValues[0]);
533 
534         // Limit cancel fee
535         if (cancelValues[4] > 50 finney) {
536             cancelValues[4] = 50 finney;
537         }
538 
539         // Take cancel fee
540         // This operation throw an error if fee amount is more than user balance
541         tokens[address(0)][cancelAddresses[3]] = safeSub(tokens[address(0)][cancelAddresses[3]], cancelValues[4]);
542 
543         // Cancel order by filling it with amount buy value
544         orderFills[orderHash] = cancelValues[0];
545 
546         // Emit cancel order
547         CancelOrder(cancelHash, orderHash, cancelAddresses[3], cancelAddresses[1], cancelValues[1], cancelValues[4]);
548     }
549 
550     function min(uint a, uint b) private pure returns (uint) {
551         return a < b ? a : b;
552     }
553 }