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
105         ORDER_ALREADY_FILLED,   // Order was already filled
106         GAS_TOO_HIGH            // Too high gas fee
107     }
108 
109     //event Order(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
110     //event Cancel(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
111     event Trade(
112         address takerTokenBuy, uint256 takerAmountBuy,
113         address takerTokenSell, uint256 takerAmountSell,
114         address maker, address indexed taker,
115         uint256 makerFee, uint256 takerFee,
116         uint256 makerAmountTaken, uint256 takerAmountTaken,
117         bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash
118     );
119     event Deposit(address indexed token, address indexed user, uint256 amount, uint256 balance, address indexed referrerAddress);
120     event Withdraw(address indexed token, address indexed user, uint256 amount, uint256 balance, uint256 withdrawFee);
121     event FeeChange(uint256 indexed makerFee, uint256 indexed takerFee, uint256 indexed affiliateFee);
122     //event AffiliateFeeChange(uint256 newAffiliateFee);
123     event LogError(uint8 indexed errorId, bytes32 indexed makerOrderHash, bytes32 indexed takerOrderHash);
124     event CancelOrder(
125         bytes32 indexed cancelHash,
126         bytes32 indexed orderHash,
127         address indexed user,
128         address tokenSell,
129         uint256 amountSell,
130         uint256 cancelFee
131     );
132 
133     function setInactivityReleasePeriod(uint256 expiry) onlyAdmin returns (bool success) {
134         if (expiry > 1000000) throw;
135         inactivityReleasePeriod = expiry;
136         return true;
137     }
138 
139     function Exchange(address feeAccount_, uint256 makerFee_, uint256 takerFee_, uint256 affiliateFee_, address affiliateContract_, address tokenListContract_) {
140         owner = msg.sender;
141         feeAccount = feeAccount_;
142         inactivityReleasePeriod = 100000;
143         makerFee = makerFee_;
144         takerFee = takerFee_;
145         affiliateFee = affiliateFee_;
146 
147 
148 
149         makerAffiliateFee = safeMul(makerFee, affiliateFee_) / (1 ether);
150         takerAffiliateFee = safeMul(takerFee, affiliateFee_) / (1 ether);
151 
152         affiliateContract = affiliateContract_;
153         tokenListContract = tokenListContract_;
154     }
155 
156     function setFees(uint256 makerFee_, uint256 takerFee_, uint256 affiliateFee_) onlyOwner {
157         require(makerFee_ < 10 finney && takerFee_ < 10 finney);
158         require(affiliateFee_ > affiliateFee);
159         makerFee = makerFee_;
160         takerFee = takerFee_;
161         affiliateFee = affiliateFee_;
162         makerAffiliateFee = safeMul(makerFee, affiliateFee_) / (1 ether);
163         takerAffiliateFee = safeMul(takerFee, affiliateFee_) / (1 ether);
164 
165         FeeChange(makerFee, takerFee, affiliateFee_);
166     }
167 
168     function setAdmin(address admin, bool isAdmin) onlyOwner {
169         admins[admin] = isAdmin;
170     }
171 
172     modifier onlyAdmin {
173         if (msg.sender != owner && !admins[msg.sender]) throw;
174         _;
175     }
176 
177     function() external {
178         throw;
179     }
180 
181     function depositToken(address token, uint256 amount, address referrerAddress) {
182         //require(EthermiumTokenList(tokenListContract).isTokenInList(token));
183         if (referrerAddress == msg.sender) referrerAddress = address(0);
184         if (referrer[msg.sender] == address(0x0))   {
185             if (referrerAddress != address(0x0) && EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender) == address(0))
186             {
187                 referrer[msg.sender] = referrerAddress;
188                 EthermiumAffiliates(affiliateContract).assignReferral(referrerAddress, msg.sender);
189             }
190             else
191             {
192                 referrer[msg.sender] = EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender);
193             }
194         }
195         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
196         lastActiveTransaction[msg.sender] = block.number;
197         if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
198         Deposit(token, msg.sender, amount, tokens[token][msg.sender], referrer[msg.sender]);
199     }
200 
201     function deposit(address referrerAddress) payable {
202         if (referrerAddress == msg.sender) referrerAddress = address(0);
203         if (referrer[msg.sender] == address(0x0))   {
204             if (referrerAddress != address(0x0) && EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender) == address(0))
205             {
206                 referrer[msg.sender] = referrerAddress;
207                 EthermiumAffiliates(affiliateContract).assignReferral(referrerAddress, msg.sender);
208             }
209             else
210             {
211                 referrer[msg.sender] = EthermiumAffiliates(affiliateContract).getAffiliate(msg.sender);
212             }
213         }
214         tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
215         lastActiveTransaction[msg.sender] = block.number;
216         Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender], referrer[msg.sender]);
217     }
218 
219     function withdraw(address token, uint256 amount) returns (bool success) {
220         if (safeSub(block.number, lastActiveTransaction[msg.sender]) < inactivityReleasePeriod) throw;
221         if (tokens[token][msg.sender] < amount) throw;
222         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
223         if (token == address(0)) {
224             if (!msg.sender.send(amount)) throw;
225         } else {
226             if (!Token(token).transfer(msg.sender, amount)) throw;
227         }
228         Withdraw(token, msg.sender, amount, tokens[token][msg.sender], 0);
229     }
230 
231     function adminWithdraw(address token, uint256 amount, address user, uint256 nonce, uint8 v, bytes32 r, bytes32 s, uint256 feeWithdrawal) onlyAdmin returns (bool success) {
232         bytes32 hash = keccak256(this, token, amount, user, nonce);
233         if (withdrawn[hash]) throw;
234         withdrawn[hash] = true;
235         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) throw;
236         if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney;
237         if (tokens[token][user] < amount) throw;
238         tokens[token][user] = safeSub(tokens[token][user], amount);
239         tokens[address(0)][user] = safeSub(tokens[address(0x0)][user], feeWithdrawal);
240         //tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], safeMul(feeWithdrawal, amount) / 1 ether);
241         tokens[address(0)][feeAccount] = safeAdd(tokens[address(0)][feeAccount], feeWithdrawal);
242 
243         //amount = safeMul((1 ether - feeWithdrawal), amount) / 1 ether;
244         if (token == address(0)) {
245             if (!user.send(amount)) throw;
246         } else {
247             if (!Token(token).transfer(user, amount)) throw;
248         }
249         lastActiveTransaction[user] = block.number;
250         Withdraw(token, user, amount, tokens[token][user], feeWithdrawal);
251     }
252 
253     function balanceOf(address token, address user) constant returns (uint256) {
254         return tokens[token][user];
255     }
256 
257     struct OrderPair {
258         uint256 makerAmountBuy;
259         uint256 makerAmountSell;
260         uint256 makerNonce;
261         uint256 takerAmountBuy;
262         uint256 takerAmountSell;
263         uint256 takerNonce;
264         uint256 takerGasFee;
265 
266         address makerTokenBuy;
267         address makerTokenSell;
268         address maker;
269         address takerTokenBuy;
270         address takerTokenSell;
271         address taker;
272 
273         bytes32 makerOrderHash;
274         bytes32 takerOrderHash;
275     }
276 
277     struct TradeValues {
278         uint256 qty;
279         uint256 invQty;
280         uint256 makerAmountTaken;
281         uint256 takerAmountTaken;
282         address makerReferrer;
283         address takerReferrer;
284     }
285 
286 
287 
288 
289     function trade(
290         uint8[2] v,
291         bytes32[4] rs,
292         uint256[7] tradeValues,
293         address[6] tradeAddresses
294     ) onlyAdmin returns (uint filledTakerTokenAmount)
295     {
296 
297         /* tradeValues
298           [0] makerAmountBuy
299           [1] makerAmountSell
300           [2] makerNonce
301           [3] takerAmountBuy
302           [4] takerAmountSell
303           [5] takerNonce
304           [6] takerGasFee
305 
306           tradeAddresses
307           [0] makerTokenBuy
308           [1] makerTokenSell
309           [2] maker
310           [3] takerTokenBuy
311           [4] takerTokenSell
312           [5] taker
313         */
314 
315         OrderPair memory t  = OrderPair({
316             makerAmountBuy  : tradeValues[0],
317             makerAmountSell : tradeValues[1],
318             makerNonce      : tradeValues[2],
319             takerAmountBuy  : tradeValues[3],
320             takerAmountSell : tradeValues[4],
321             takerNonce      : tradeValues[5],
322             takerGasFee     : tradeValues[6],
323 
324             makerTokenBuy   : tradeAddresses[0],
325             makerTokenSell  : tradeAddresses[1],
326             maker           : tradeAddresses[2],
327             takerTokenBuy   : tradeAddresses[3],
328             takerTokenSell  : tradeAddresses[4],
329             taker           : tradeAddresses[5],
330 
331             makerOrderHash  : keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]),
332             takerOrderHash  : keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5])
333         });
334 
335         //bytes32 makerOrderHash = keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeAddresses[2]);
336         //bytes32 makerOrderHash = §
337         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.makerOrderHash), v[0], rs[0], rs[1]) != t.maker)
338         {
339             LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
340             return 0;
341         }
342         //bytes32 takerOrderHash = keccak256(this, tradeAddresses[3], tradeValues[3], tradeAddresses[4], tradeValues[4], tradeValues[5], tradeAddresses[5]);
343         //bytes32 takerOrderHash = keccak256(this, t.takerTokenBuy, t.takerAmountBuy, t.takerTokenSell, t.takerAmountSell, t.takerNonce, t.taker);
344         if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", t.takerOrderHash), v[1], rs[2], rs[3]) != t.taker)
345         {
346             LogError(uint8(Errors.INVLID_SIGNATURE), t.makerOrderHash, t.takerOrderHash);
347             return 0;
348         }
349 
350         if (t.makerTokenBuy != t.takerTokenSell || t.makerTokenSell != t.takerTokenBuy)
351         {
352             LogError(uint8(Errors.TOKENS_DONT_MATCH), t.makerOrderHash, t.takerOrderHash);
353             return 0;
354         } // tokens don't match
355 
356         if (t.takerGasFee > 100 finney)
357         {
358             LogError(uint8(Errors.GAS_TOO_HIGH), t.makerOrderHash, t.takerOrderHash);
359             return 0;
360         } // takerGasFee too high
361 
362 
363 
364         if (!(
365         (t.makerTokenBuy != address(0x0) && safeMul(t.makerAmountSell, 1 ether) / t.makerAmountBuy >= safeMul(t.takerAmountBuy, 1 ether) / t.takerAmountSell)
366         ||
367         (t.makerTokenBuy == address(0x0) && safeMul(t.makerAmountBuy, 1 ether) / t.makerAmountSell <= safeMul(t.takerAmountSell, 1 ether) / t.takerAmountBuy)
368         ))
369         {
370             LogError(uint8(Errors.INVLID_PRICE), t.makerOrderHash, t.takerOrderHash);
371             return 0; // prices don't match
372         }
373 
374         TradeValues memory tv = TradeValues({
375             qty                 : 0,
376             invQty              : 0,
377             makerAmountTaken    : 0,
378             takerAmountTaken    : 0,
379             makerReferrer       : referrer[t.maker],
380             takerReferrer       : referrer[t.taker]
381         });
382 
383         if (tv.makerReferrer == address(0x0)) tv.makerReferrer = feeAccount;
384         if (tv.takerReferrer == address(0x0)) tv.takerReferrer = feeAccount;
385 
386 
387 
388         // maker buy, taker sell
389         if (t.makerTokenBuy != address(0x0))
390         {
391 
392 
393             tv.qty = min(safeSub(t.makerAmountBuy, orderFills[t.makerOrderHash]), safeSub(t.takerAmountSell, safeMul(orderFills[t.takerOrderHash], t.takerAmountSell) / t.takerAmountBuy));
394             if (tv.qty == 0)
395             {
396                 LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
397                 return 0;
398             }
399 
400             tv.invQty = safeMul(tv.qty, t.makerAmountSell) / t.makerAmountBuy;
401 
402             tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.invQty);
403             tv.makerAmountTaken                         = safeSub(tv.qty, safeMul(tv.qty, makerFee) / (1 ether));
404             tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);
405             tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.qty,    makerAffiliateFee) / (1 ether));
406 
407             tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.qty);
408             tv.takerAmountTaken                         = safeSub(safeSub(tv.invQty, safeMul(tv.invQty, takerFee) / (1 ether)), safeMul(tv.invQty, t.takerGasFee) / (1 ether));
409             tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);
410             tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.invQty, takerAffiliateFee) / (1 ether));
411 
412             tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.qty,    safeSub(makerFee, makerAffiliateFee)) / (1 ether));
413             tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.invQty, safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.invQty, t.takerGasFee) / (1 ether)));
414 
415 
416             orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.qty);
417             orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], safeMul(tv.qty, t.takerAmountBuy) / t.takerAmountSell);
418             lastActiveTransaction[t.maker]          = block.number;
419             lastActiveTransaction[t.taker]          = block.number;
420 
421             Trade(
422                 t.takerTokenBuy, tv.qty,
423                 t.takerTokenSell, tv.invQty,
424                 t.maker, t.taker,
425                 makerFee, takerFee,
426                 tv.makerAmountTaken , tv.takerAmountTaken,
427                 t.makerOrderHash, t.takerOrderHash
428             );
429             return tv.qty;
430         }
431         // maker sell, taker buy
432         else
433         {
434 
435             tv.qty = min(safeSub(t.makerAmountSell,  safeMul(orderFills[t.makerOrderHash], t.makerAmountSell) / t.makerAmountBuy), safeSub(t.takerAmountBuy, orderFills[t.takerOrderHash]));
436             if (tv.qty == 0)
437             {
438                 LogError(uint8(Errors.ORDER_ALREADY_FILLED), t.makerOrderHash, t.takerOrderHash);
439                 return 0;
440             }
441 
442             tv.invQty = safeMul(tv.qty, t.makerAmountBuy) / t.makerAmountSell;
443 
444             tokens[t.makerTokenSell][t.maker]           = safeSub(tokens[t.makerTokenSell][t.maker],           tv.qty);
445             tv.makerAmountTaken                         = safeSub(tv.invQty, safeMul(tv.invQty, makerFee) / (1 ether));
446             tokens[t.makerTokenBuy][t.maker]            = safeAdd(tokens[t.makerTokenBuy][t.maker],            tv.makerAmountTaken);
447             tokens[t.makerTokenBuy][tv.makerReferrer]   = safeAdd(tokens[t.makerTokenBuy][tv.makerReferrer],   safeMul(tv.invQty, makerAffiliateFee) / (1 ether));
448 
449             tokens[t.takerTokenSell][t.taker]           = safeSub(tokens[t.takerTokenSell][t.taker],           tv.invQty);
450             tv.takerAmountTaken                         = safeSub(safeSub(tv.qty,    safeMul(tv.qty, takerFee) / (1 ether)), safeMul(tv.qty, t.takerGasFee) / (1 ether));
451             tokens[t.takerTokenBuy][t.taker]            = safeAdd(tokens[t.takerTokenBuy][t.taker],            tv.takerAmountTaken);
452             tokens[t.takerTokenBuy][tv.takerReferrer]   = safeAdd(tokens[t.takerTokenBuy][tv.takerReferrer],   safeMul(tv.qty,    takerAffiliateFee) / (1 ether));
453 
454             tokens[t.makerTokenBuy][feeAccount]     = safeAdd(tokens[t.makerTokenBuy][feeAccount],      safeMul(tv.invQty, safeSub(makerFee, makerAffiliateFee)) / (1 ether));
455             tokens[t.takerTokenBuy][feeAccount]     = safeAdd(tokens[t.takerTokenBuy][feeAccount],      safeAdd(safeMul(tv.qty,    safeSub(takerFee, takerAffiliateFee)) / (1 ether), safeMul(tv.qty, t.takerGasFee) / (1 ether)));
456 
457             orderFills[t.makerOrderHash]            = safeAdd(orderFills[t.makerOrderHash], tv.invQty);
458             orderFills[t.takerOrderHash]            = safeAdd(orderFills[t.takerOrderHash], tv.qty); //safeMul(qty, tradeValues[takerAmountBuy]) / tradeValues[takerAmountSell]);
459 
460             lastActiveTransaction[t.maker]          = block.number;
461             lastActiveTransaction[t.taker]          = block.number;
462 
463             Trade(
464                 t.takerTokenBuy, tv.qty,
465                 t.takerTokenSell, tv.invQty,
466                 t.maker, t.taker,
467                 makerFee, takerFee,
468                 tv.makerAmountTaken , tv.takerAmountTaken,
469                 t.makerOrderHash, t.takerOrderHash
470             );
471             return tv.qty;
472         }
473     }
474 
475     function batchOrderTrade(
476         uint8[2][] v,
477         bytes32[4][] rs,
478         uint256[7][] tradeValues,
479         address[6][] tradeAddresses
480     )
481     {
482         for (uint i = 0; i < tradeAddresses.length; i++) {
483             trade(
484                 v[i],
485                 rs[i],
486                 tradeValues[i],
487                 tradeAddresses[i]
488             );
489         }
490     }
491 
492     function cancelOrder(
493 		/*
494 		[0] orderV
495 		[1] cancelV
496 		*/
497 	    uint8[2] v,
498 
499 		/*
500 		[0] orderR
501 		[1] orderS
502 		[2] cancelR
503 		[3] cancelS
504 		*/
505 	    bytes32[4] rs,
506 
507 		/*
508 		[0] orderAmountBuy
509 		[1] orderAmountSell
510 		[2] orderNonce
511 		[3] cancelNonce
512 		[4] cancelFee
513 		*/
514 		uint256[5] cancelValues,
515 
516 		/*
517 		[0] orderTokenBuy
518 		[1] orderTokenSell
519 		[2] orderUser
520 		[3] cancelUser
521 		*/
522 		address[4] cancelAddresses
523     ) public onlyAdmin {
524         // Order values should be valid and signed by order owner
525         bytes32 orderHash = keccak256(
526 	        this, cancelAddresses[0], cancelValues[0], cancelAddresses[1],
527 	        cancelValues[1], cancelValues[2], cancelAddresses[2]
528         );
529         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) == cancelAddresses[2]);
530 
531         // Cancel action should be signed by cancel's initiator
532         bytes32 cancelHash = keccak256(this, orderHash, cancelAddresses[3], cancelValues[3]);
533         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", cancelHash), v[1], rs[2], rs[3]) == cancelAddresses[3]);
534 
535         // Order owner should be same as cancel's initiator
536         require(cancelAddresses[2] == cancelAddresses[3]);
537 
538         // Do not allow to cancel already canceled or filled orders
539         require(orderFills[orderHash] != cancelValues[0]);
540 
541         // Limit cancel fee
542         if (cancelValues[4] > 50 finney) {
543             cancelValues[4] = 50 finney;
544         }
545 
546         // Take cancel fee
547         // This operation throw an error if fee amount is more than user balance
548         tokens[address(0)][cancelAddresses[3]] = safeSub(tokens[address(0)][cancelAddresses[3]], cancelValues[4]);
549 
550         // Cancel order by filling it with amount buy value
551         orderFills[orderHash] = cancelValues[0];
552 
553         // Emit cancel order
554         CancelOrder(cancelHash, orderHash, cancelAddresses[3], cancelAddresses[1], cancelValues[1], cancelValues[4]);
555     }
556 
557     function min(uint a, uint b) private pure returns (uint) {
558         return a < b ? a : b;
559     }
560 }