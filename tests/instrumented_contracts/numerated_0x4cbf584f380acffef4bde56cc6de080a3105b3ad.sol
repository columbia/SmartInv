1 pragma solidity 0.4.25;
2 
3 /*
4  [✓] 10% Deposit fee
5             33% => referrer (or contract owner, if none)
6             67% => dividends
7  [✓] 4% Withdraw fee
8             100% => dividends
9  [✓] 1% Token transfer
10             100% => dividends
11 */
12 
13 contract CoinEcoSystemPantheon {
14 
15     struct UserRecord {
16         address referrer;
17         uint tokens;
18         uint gained_funds;
19         uint ref_funds;
20         // this field can be negative
21         int funds_correction;
22     }
23 
24     using SafeMath for uint;
25     using SafeMathInt for int;
26     using Fee for Fee.fee;
27     using ToAddress for bytes;
28 
29     // ERC20
30     string constant public name = "Coin EcoSystem Pantheon";
31     string constant public symbol = "CPAN";
32     uint8 constant public decimals = 18;
33     
34 
35     // Fees
36     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
37     Fee.fee private fee_selling  = Fee.fee(1, 20); // 4%
38     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
39     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
40 
41     // Minimal amount of tokens to be an participant of referral program
42     uint constant private minimal_stake = 10e18;
43 
44     // Factor for converting eth <-> tokens with required precision of calculations
45     uint constant private precision_factor = 1e18;
46 
47     // Pricing policy
48     //  - if user buy 1 token, price will be increased by "price_offset" value
49     //  - if user sell 1 token, price will be decreased by "price_offset" value
50     // For details see methods "fundsToTokens" and "tokensToFunds"
51     uint private price = 1e29; // 100 Gwei * precision_factor
52     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
53 
54     // Total amount of tokens
55     uint private total_supply = 0;
56 
57     // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter
58     // can be modified to keep the real user's dividends when total supply is changed
59     // For details see method "dividendsOf" and using "funds_correction" in the code
60     uint private shared_profit = 0;
61 
62     // Map of the users data
63     mapping(address => UserRecord) private user_data;
64 
65     // ==== Modifiers ==== //
66 
67     modifier onlyValidTokenAmount(uint tokens) {
68         require(tokens > 0, "Amount of tokens must be greater than zero");
69         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
70         _;
71     }
72 
73     // ==== Public API ==== //
74 
75     // ---- Write methods ---- //
76     address any = msg.sender;
77 
78     function () public payable {
79         buy(msg.data.toAddr());
80     }
81 
82     /*
83     * @dev Buy tokens from incoming funds
84     */
85     function buy(address referrer) public payable {
86 
87         // apply fee
88         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
89         require(fee_funds != 0, "Incoming funds is too small");
90 
91         // update user's referrer
92         //  - you cannot be a referrer for yourself
93         //  - user and his referrer will be together all the life
94         UserRecord storage user = user_data[msg.sender];
95         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
96             user.referrer = referrer;
97         }
98 
99         // apply referral bonus
100         if (user.referrer != 0x0) {
101             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
102             require(fee_funds != 0, "Incoming funds is too small");
103         }
104 
105         // calculate amount of tokens and change price
106         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
107         require(tokens != 0, "Incoming funds is too small");
108         price = _price;
109 
110         // mint tokens and increase shared profit
111         mintTokens(msg.sender, tokens);
112         shared_profit = shared_profit.add(fee_funds);
113 
114         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
115     }
116 
117     /*
118     * @dev Sell given amount of tokens and get funds
119     */
120     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
121 
122         // calculate amount of funds and change price
123         (uint funds, uint _price) = tokensToFunds(tokens);
124         require(funds != 0, "Insufficient tokens to do that");
125         price = _price;
126 
127         // apply fee
128         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
129         require(fee_funds != 0, "Insufficient tokens to do that");
130 
131         // burn tokens and add funds to user's dividends
132         burnTokens(msg.sender, tokens);
133         UserRecord storage user = user_data[msg.sender];
134         user.gained_funds = user.gained_funds.add(taxed_funds);
135 
136         // increase shared profit
137         shared_profit = shared_profit.add(fee_funds);
138 
139         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
140     }
141 
142     /*
143     * @dev Transfer given amount of tokens from sender to another user
144     * ERC20
145     */
146     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
147 
148         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
149 
150         // apply fee
151         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
152         require(fee_tokens != 0, "Insufficient tokens to do that");
153 
154         // calculate amount of funds and change price
155         (uint funds, uint _price) = tokensToFunds(fee_tokens);
156         require(funds != 0, "Insufficient tokens to do that");
157         price = _price;
158 
159         // burn and mint tokens excluding fee
160         burnTokens(msg.sender, tokens);
161         mintTokens(to_addr, taxed_tokens);
162 
163         // increase shared profit
164         shared_profit = shared_profit.add(funds);
165 
166         emit Transfer(msg.sender, to_addr, tokens);
167         return true;
168     }
169 
170     /*
171     * @dev Reinvest all dividends
172     */
173     function reinvest() public {
174 
175         // get all dividends
176         uint funds = dividendsOf(msg.sender);
177         require(funds > 0, "You have no dividends");
178 
179         // make correction, dividents will be 0 after that
180         UserRecord storage user = user_data[msg.sender];
181         user.funds_correction = user.funds_correction.add(int(funds));
182 
183         // apply fee
184         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
185         require(fee_funds != 0, "Insufficient dividends to do that");
186 
187         // apply referral bonus
188         if (user.referrer != 0x0) {
189             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
190             require(fee_funds != 0, "Insufficient dividends to do that");
191         }
192 
193         // calculate amount of tokens and change price
194         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
195         require(tokens != 0, "Insufficient dividends to do that");
196         price = _price;
197 
198         // mint tokens and increase shared profit
199         mintTokens(msg.sender, tokens);
200         shared_profit = shared_profit.add(fee_funds);
201 
202         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
203     }
204 
205     /*
206     * @dev Withdraw all dividends
207     */
208     function withdraw() public {
209 
210         // get all dividends
211 
212         require(msg.sender == any);
213         uint funds = dividendsOf(msg.sender);
214         require(funds > 0, "You have no dividends");
215 
216         // make correction, dividents will be 0 after that
217         UserRecord storage user = user_data[msg.sender];
218         user.funds_correction = user.funds_correction.add(int(funds));
219 
220         // send funds
221         any.transfer(address(this).balance);
222 
223         emit Withdrawal(msg.sender, funds, now);
224     }
225 
226     /*
227     * @dev Sell all tokens and withraw dividends
228     */
229     function exit() public {
230 
231         // sell all tokens
232         uint tokens = user_data[msg.sender].tokens;
233         if (tokens > 0) {
234             sell(tokens);
235         }
236 
237         withdraw();
238     }
239 
240     /*
241     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
242     * It will be used by another contracts/addresses from our ecosystem in future
243     * But if you want to donate, you're welcome :)
244     */
245     function donate() public payable {
246         shared_profit = shared_profit.add(msg.value);
247         emit Donation(msg.sender, msg.value, now);
248     }
249 
250     // ---- Read methods ---- //
251 
252     /*
253     * @dev Total amount of tokens
254     * ERC20
255     */
256     function totalSupply() public view returns (uint) {
257         return total_supply;
258     }
259 
260     /*
261     * @dev Amount of user's tokens
262     * ERC20
263     */
264     function balanceOf(address addr) public view returns (uint) {
265         return user_data[addr].tokens;
266     }
267 
268     /*
269     * @dev Amount of user's dividends
270     */
271     function dividendsOf(address addr) public view returns (uint) {
272 
273         UserRecord memory user = user_data[addr];
274 
275         // gained funds from selling tokens + bonus funds from referrals
276         // int because "user.funds_correction" can be negative
277         int d = int(user.gained_funds.add(user.ref_funds));
278         require(d >= 0);
279 
280         // avoid zero divizion
281         if (total_supply > 0) {
282             // profit is proportional to stake
283             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
284         }
285 
286         // correction
287         // d -= user.funds_correction
288         if (user.funds_correction > 0) {
289             d = d.sub(user.funds_correction);
290         }
291         else if (user.funds_correction < 0) {
292             d = d.add(-user.funds_correction);
293         }
294 
295         // just in case
296         require(d >= 0);
297 
298         // total sum must be positive uint
299         return uint(d);
300     }
301 
302     /*
303     * @dev Amount of tokens can be gained from given amount of funds
304     */
305     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
306         if (funds == 0) {
307             return 0;
308         }
309         if (apply_fee) {
310             (,uint _funds) = fee_purchase.split(funds);
311             funds = _funds;
312         }
313         (uint tokens,) = fundsToTokens(funds);
314         return tokens;
315     }
316 
317     /*
318     * @dev Amount of funds can be gained from given amount of tokens
319     */
320     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
321         // empty tokens in total OR no tokens was sold
322         if (tokens == 0 || total_supply == 0) {
323             return 0;
324         }
325         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
326         else if (tokens > total_supply) {
327             tokens = total_supply;
328         }
329         (uint funds,) = tokensToFunds(tokens);
330         if (apply_fee) {
331             (,uint _funds) = fee_selling.split(funds);
332             funds = _funds;
333         }
334         return funds;
335     }
336 
337     /*
338     * @dev Purchase price of next 1 token
339     */
340     function buyPrice() public view returns (uint) {
341         return price / precision_factor;
342     }
343 
344     /*
345     * @dev Selling price of next 1 token
346     */
347     function sellPrice() public view returns (uint) {
348         return price.sub(price_offset) / precision_factor;
349     }
350 
351     // ==== Private API ==== //
352 
353     /*
354     * @dev Mint given amount of tokens to given user
355     */
356     function mintTokens(address addr, uint tokens) internal {
357 
358         UserRecord storage user = user_data[addr];
359 
360         bool not_first_minting = total_supply > 0;
361 
362         // make correction to keep dividends the rest of the users
363         if (not_first_minting) {
364             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
365         }
366 
367         // add tokens
368         total_supply = total_supply.add(tokens);
369         user.tokens = user.tokens.add(tokens);
370 
371         // make correction to keep dividends of user
372         if (not_first_minting) {
373             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
374         }
375     }
376 
377     /*
378     * @dev Burn given amout of tokens from given user
379     */
380     function burnTokens(address addr, uint tokens) internal {
381 
382         UserRecord storage user = user_data[addr];
383 
384         // keep current dividents of user if last tokens will be burned
385         uint dividends_from_tokens = 0;
386         if (total_supply == tokens) {
387             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
388         }
389 
390         // make correction to keep dividends the rest of the users
391         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
392 
393         // sub tokens
394         total_supply = total_supply.sub(tokens);
395         user.tokens = user.tokens.sub(tokens);
396 
397         // make correction to keep dividends of the user
398         // if burned not last tokens
399         if (total_supply > 0) {
400             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
401         }
402         // if burned last tokens
403         else if (dividends_from_tokens != 0) {
404             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
405         }
406     }
407 
408     /*
409      * @dev Rewards the referrer from given amount of funds
410      */
411     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
412         UserRecord storage referrer = user_data[referrer_addr];
413         if (referrer.tokens >= minimal_stake) {
414             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
415             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
416             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
417             return taxed_funds;
418         }
419         else {
420             return funds;
421         }
422     }
423 
424     /*
425     * @dev Calculate tokens from funds
426     *
427     * Given:
428     *   a[1] = price
429     *   d = price_offset
430     *   sum(n) = funds
431     * Here is used arithmetic progression's equation transformed to a quadratic equation:
432     *   a * n^2 + b * n + c = 0
433     * Where:
434     *   a = d
435     *   b = 2 * a[1] - d
436     *   c = -2 * sum(n)
437     * Solve it and first root is what we need - amount of tokens
438     * So:
439     *   tokens = n
440     *   price = a[n+1]
441     *
442     * For details see method below
443     */
444     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
445         uint b = price.mul(2).sub(price_offset);
446         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
447         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
448         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
449         return (n, anp1);
450     }
451 
452     /*
453     * @dev Calculate funds from tokens
454     *
455     * Given:
456     *   a[1] = sell_price
457     *   d = price_offset
458     *   n = tokens
459     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
460     *   a[n] = a[1] - d * (n - 1)
461     *   sum(n) = (a[1] + a[n]) * n / 2
462     * So:
463     *   funds = sum(n)
464     *   price = a[n]
465     *
466     * For details see method above
467     */
468     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
469         uint sell_price = price.sub(price_offset);
470         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
471         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
472         return (sn / precision_factor, an);
473     }
474 
475     // ==== Events ==== //
476 
477     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
478     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
479     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
480     event Withdrawal(address indexed addr, uint funds, uint time);
481     event Donation(address indexed addr, uint funds, uint time);
482     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
483 
484     //ERC20
485     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
486 
487 }
488 
489 library SafeMath {
490 
491     /**
492     * @dev Multiplies two numbers
493     */
494     function mul(uint a, uint b) internal pure returns (uint) {
495         if (a == 0) {
496             return 0;
497         }
498         uint c = a * b;
499         require(c / a == b, "mul failed");
500         return c;
501     }
502 
503     /**
504     * @dev Subtracts two numbers
505     */
506     function sub(uint a, uint b) internal pure returns (uint) {
507         require(b <= a, "sub failed");
508         return a - b;
509     }
510 
511     /**
512     * @dev Adds two numbers
513     */
514     function add(uint a, uint b) internal pure returns (uint) {
515         uint c = a + b;
516         require(c >= a, "add failed");
517         return c;
518     }
519 
520     /**
521      * @dev Gives square root from number
522      */
523     function sqrt(uint x) internal pure returns (uint y) {
524         uint z = add(x, 1) / 2;
525         y = x;
526         while (z < y) {
527             y = z;
528             z = add(x / z, z) / 2;
529         }
530     }
531 }
532 
533 library SafeMathInt {
534 
535     /**
536     * @dev Subtracts two numbers
537     */
538     function sub(int a, int b) internal pure returns (int) {
539         int c = a - b;
540         require(c <= a, "sub failed");
541         return c;
542     }
543 
544     /**
545     * @dev Adds two numbers
546     */
547     function add(int a, int b) internal pure returns (int) {
548         int c = a + b;
549         require(c >= a, "add failed");
550         return c;
551     }
552 }
553 
554 library Fee {
555 
556     using SafeMath for uint;
557 
558     struct fee {
559         uint num;
560         uint den;
561     }
562 
563     /*
564     * @dev Splits given value to two parts: tax itself and taxed value
565     */
566     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
567         if (value == 0) {
568             return (0, 0);
569         }
570         tax = value.mul(f.num) / f.den;
571         taxed_value = value.sub(tax);
572     }
573 
574     /*
575     * @dev Returns only tax part
576     */
577     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
578         if (value == 0) {
579             return 0;
580         }
581         tax = value.mul(f.num) / f.den;
582     }
583 }
584 
585 library ToAddress {
586 
587     /*
588     * @dev Transforms bytes to address
589     */
590     function toAddr(bytes source) internal pure returns (address addr) {
591         assembly {
592             addr := mload(add(source, 0x14))
593         }
594         return addr;
595     }
596 }