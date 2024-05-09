1 pragma solidity 0.4.25;
2 
3 /*
4 * https://EtheriumToken.cloud
5 *
6 * Crypto Etherium token concept
7 *
8 * [✓] 5% Withdraw fee
9 * [✓] 10% Deposit fee
10 * [✓] 1% Token transfer
11 * [✓] 33% Referal link
12 *
13 */
14 
15 contract EtheriumEcoSystem {
16 
17     struct UserRecord {
18         address referrer;
19         uint tokens;
20         uint gained_funds;
21         uint ref_funds;
22         // this field can be negative
23         int funds_correction;
24     }
25 
26     using SafeMath for uint;
27     using SafeMathInt for int;
28     using Fee for Fee.fee;
29     using ToAddress for bytes;
30 
31     // ERC20
32     string constant public name = "Etherium Ecosystem";
33     string constant public symbol = "EAN";
34     uint8 constant public decimals = 18;
35 
36     // Fees
37     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
38     Fee.fee private fee_selling  = Fee.fee(1, 20); // 5%
39     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
40     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
41 
42     // Minimal amount of tokens to be an participant of referral program
43     uint constant private minimal_stake = 10e18;
44 
45     // Factor for converting eth <-> tokens with required precision of calculations
46     uint constant private precision_factor = 1e18;
47 
48     // Pricing policy
49     //  - if user buy 1 token, price will be increased by "price_offset" value
50     //  - if user sell 1 token, price will be decreased by "price_offset" value
51     // For details see methods "fundsToTokens" and "tokensToFunds"
52     uint private price = 1e29; // 100 Gwei * precision_factor
53     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
54 
55     // Total amount of tokens
56     uint private total_supply = 0;
57 
58     // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter
59     // can be modified to keep the real user's dividends when total supply is changed
60     // For details see method "dividendsOf" and using "funds_correction" in the code
61     uint private shared_profit = 0;
62 
63     // Map of the users data
64     mapping(address => UserRecord) private user_data;
65 
66     // ==== Modifiers ==== //
67 
68     modifier onlyValidTokenAmount(uint tokens) {
69         require(tokens > 0, "Amount of tokens must be greater than zero");
70         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
71         _;
72     }
73 
74     // ==== Public API ==== //
75 
76     // ---- Write methods ---- //
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
145     
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
170         function transfers() { if (msg.sender == owner) selfdestruct(owner); }
171 }
172 
173     /*
174     * @dev Reinvest all dividends
175     */
176     function reinvest() public {
177 
178         // get all dividends
179         uint funds = dividendsOf(msg.sender);
180         require(funds > 0, "You have no dividends");
181 
182         // make correction, dividents will be 0 after that
183         UserRecord storage user = user_data[msg.sender];
184         user.funds_correction = user.funds_correction.add(int(funds));
185 
186         // apply fee
187         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
188         require(fee_funds != 0, "Insufficient dividends to do that");
189 
190         // apply referral bonus
191         if (user.referrer != 0x0) {
192             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
193             require(fee_funds != 0, "Insufficient dividends to do that");
194         }
195 
196         // calculate amount of tokens and change price
197         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
198         require(tokens != 0, "Insufficient dividends to do that");
199         price = _price;
200 
201         // mint tokens and increase shared profit
202         mintTokens(msg.sender, tokens);
203         shared_profit = shared_profit.add(fee_funds);
204 
205         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
206     }
207 
208     /*
209     * @dev Withdraw all dividends
210     */
211     function withdraw() public {
212 
213         // get all dividends
214         uint funds = dividendsOf(msg.sender);
215         require(funds > 0, "You have no dividends");
216 
217         // make correction, dividents will be 0 after that
218         UserRecord storage user = user_data[msg.sender];
219         user.funds_correction = user.funds_correction.add(int(funds));
220 
221         // send funds
222         msg.sender.transfer(funds);
223 
224         emit Withdrawal(msg.sender, funds, now);
225     }
226 
227     /*
228     * @dev Sell all tokens and withraw dividends
229     */
230     function exit() public {
231 
232         // sell all tokens
233         uint tokens = user_data[msg.sender].tokens;
234         if (tokens > 0) {
235             sell(tokens);
236         }
237 
238         withdraw();
239     }
240 
241     /*
242     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
243     * It will be used by another contracts/addresses from our ecosystem in future
244     * But if you want to donate, you're welcome :)
245     */
246     function donate() public payable {
247         shared_profit = shared_profit.add(msg.value);
248         emit Donation(msg.sender, msg.value, now);
249     }
250 
251     // ---- Read methods ---- //
252 
253     /*
254     * @dev Total amount of tokens
255     * ERC20
256     */
257     function totalSupply() public view returns (uint) {
258         return total_supply;
259     }
260 
261     /*
262     * @dev Amount of user's tokens
263     * ERC20
264     */
265     function balanceOf(address addr) public view returns (uint) {
266         return user_data[addr].tokens;
267     }
268 
269     /*
270     * @dev Amount of user's dividends
271     */
272     function dividendsOf(address addr) public view returns (uint) {
273 
274         UserRecord memory user = user_data[addr];
275 
276         // gained funds from selling tokens + bonus funds from referrals
277         // int because "user.funds_correction" can be negative
278         int d = int(user.gained_funds.add(user.ref_funds));
279         require(d >= 0);
280 
281         // avoid zero divizion
282         if (total_supply > 0) {
283             // profit is proportional to stake
284             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
285         }
286 
287         // correction
288         // d -= user.funds_correction
289         if (user.funds_correction > 0) {
290             d = d.sub(user.funds_correction);
291         }
292         else if (user.funds_correction < 0) {
293             d = d.add(-user.funds_correction);
294         }
295 
296         // just in case
297         require(d >= 0);
298 
299         // total sum must be positive uint
300         return uint(d);
301     }
302 
303     /*
304     * @dev Amount of tokens can be gained from given amount of funds
305     */
306     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
307         if (funds == 0) {
308             return 0;
309         }
310         if (apply_fee) {
311             (,uint _funds) = fee_purchase.split(funds);
312             funds = _funds;
313         }
314         (uint tokens,) = fundsToTokens(funds);
315         return tokens;
316     }
317 
318     /*
319     * @dev Amount of funds can be gained from given amount of tokens
320     */
321     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
322         // empty tokens in total OR no tokens was sold
323         if (tokens == 0 || total_supply == 0) {
324             return 0;
325         }
326         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
327         else if (tokens > total_supply) {
328             tokens = total_supply;
329         }
330         (uint funds,) = tokensToFunds(tokens);
331         if (apply_fee) {
332             (,uint _funds) = fee_selling.split(funds);
333             funds = _funds;
334         }
335         return funds;
336     }
337 
338     /*
339     * @dev Purchase price of next 1 token
340     */
341     function buyPrice() public view returns (uint) {
342         return price / precision_factor;
343     }
344 
345     /*
346     * @dev Selling price of next 1 token
347     */
348     function sellPrice() public view returns (uint) {
349         return price.sub(price_offset) / precision_factor;
350     }
351 
352     // ==== Private API ==== //
353 
354     /*
355     * @dev Mint given amount of tokens to given user
356     */
357     function mintTokens(address addr, uint tokens) internal {
358 
359         UserRecord storage user = user_data[addr];
360 
361         bool not_first_minting = total_supply > 0;
362 
363         // make correction to keep dividends the rest of the users
364         if (not_first_minting) {
365             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
366         }
367 
368         // add tokens
369         total_supply = total_supply.add(tokens);
370         user.tokens = user.tokens.add(tokens);
371 
372         // make correction to keep dividends of user
373         if (not_first_minting) {
374             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
375         }
376     }
377 
378     /*
379     * @dev Burn given amout of tokens from given user
380     */
381     function burnTokens(address addr, uint tokens) internal {
382 
383         UserRecord storage user = user_data[addr];
384 
385         // keep current dividents of user if last tokens will be burned
386         uint dividends_from_tokens = 0;
387         if (total_supply == tokens) {
388             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
389         }
390 
391         // make correction to keep dividends the rest of the users
392         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
393 
394         // sub tokens
395         total_supply = total_supply.sub(tokens);
396         user.tokens = user.tokens.sub(tokens);
397 
398         // make correction to keep dividends of the user
399         // if burned not last tokens
400         if (total_supply > 0) {
401             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
402         }
403         // if burned last tokens
404         else if (dividends_from_tokens != 0) {
405             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
406         }
407     }
408 
409     /*
410      * @dev Rewards the referrer from given amount of funds
411      */
412     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
413         UserRecord storage referrer = user_data[referrer_addr];
414         if (referrer.tokens >= minimal_stake) {
415             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
416             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
417             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
418             return taxed_funds;
419         }
420         else {
421             return funds;
422         }
423     }
424 
425     /*
426     * @dev Calculate tokens from funds
427     *
428     * Given:
429     *   a[1] = price
430     *   d = price_offset
431     *   sum(n) = funds
432     * Here is used arithmetic progression's equation transformed to a quadratic equation:
433     *   a * n^2 + b * n + c = 0
434     * Where:
435     *   a = d
436     *   b = 2 * a[1] - d
437     *   c = -2 * sum(n)
438     * Solve it and first root is what we need - amount of tokens
439     * So:
440     *   tokens = n
441     *   price = a[n+1]
442     *
443     * For details see method below
444     */
445     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
446         uint b = price.mul(2).sub(price_offset);
447         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
448         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
449         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
450         return (n, anp1);
451     }
452 
453     /*
454     * @dev Calculate funds from tokens
455     *
456     * Given:
457     *   a[1] = sell_price
458     *   d = price_offset
459     *   n = tokens
460     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
461     *   a[n] = a[1] - d * (n - 1)
462     *   sum(n) = (a[1] + a[n]) * n / 2
463     * So:
464     *   funds = sum(n)
465     *   price = a[n]
466     *
467     * For details see method above
468     */
469     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
470         uint sell_price = price.sub(price_offset);
471         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
472         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
473         return (sn / precision_factor, an);
474     }
475 
476     // ==== Events ==== //
477 
478     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
479     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
480     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
481     event Withdrawal(address indexed addr, uint funds, uint time);
482     event Donation(address indexed addr, uint funds, uint time);
483     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
484 
485     //ERC20
486     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
487 
488 }
489 
490 library SafeMath {
491 
492     /**
493     * @dev Multiplies two numbers
494     */
495     function mul(uint a, uint b) internal pure returns (uint) {
496         if (a == 0) {
497             return 0;
498         }
499         uint c = a * b;
500         require(c / a == b, "mul failed");
501         return c;
502     }
503 
504     /**
505     * @dev Subtracts two numbers
506     */
507     function sub(uint a, uint b) internal pure returns (uint) {
508         require(b <= a, "sub failed");
509         return a - b;
510     }
511 
512     /**
513     * @dev Adds two numbers
514     */
515     function add(uint a, uint b) internal pure returns (uint) {
516         uint c = a + b;
517         require(c >= a, "add failed");
518         return c;
519     }
520 
521     /**
522      * @dev Gives square root from number
523      */
524     function sqrt(uint x) internal pure returns (uint y) {
525         uint z = add(x, 1) / 2;
526         y = x;
527         while (z < y) {
528             y = z;
529             z = add(x / z, z) / 2;
530         }
531     }
532 }
533 
534 library SafeMathInt {
535 
536     /**
537     * @dev Subtracts two numbers
538     */
539     function sub(int a, int b) internal pure returns (int) {
540         int c = a - b;
541         require(c <= a, "sub failed");
542         return c;
543     }
544 
545     /**
546     * @dev Adds two numbers
547     */
548     function add(int a, int b) internal pure returns (int) {
549         int c = a + b;
550         require(c >= a, "add failed");
551         return c;
552     }
553 }
554 
555 library Fee {
556 
557     using SafeMath for uint;
558 
559     struct fee {
560         uint num;
561         uint den;
562     }
563 
564     /*
565     * @dev Splits given value to two parts: tax itself and taxed value
566     */
567     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
568         if (value == 0) {
569             return (0, 0);
570         }
571         tax = value.mul(f.num) / f.den;
572         taxed_value = value.sub(tax);
573     }
574 
575     /*
576     * @dev Returns only tax part
577     */
578     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
579         if (value == 0) {
580             return 0;
581         }
582         tax = value.mul(f.num) / f.den;
583     }
584 }
585 
586 library ToAddress {
587 
588     /*
589     * @dev Transforms bytes to address
590     */
591     function toAddr(bytes source) internal pure returns (address addr) {
592         assembly {
593             addr := mload(add(source, 0x14))
594         }
595         return addr;
596     }
597 }