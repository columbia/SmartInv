1 pragma solidity 0.4.25;
2 
3 contract PantheonEcoSystemReboot {
4 
5     struct UserRecord {
6         address referrer;
7         uint tokens;
8         uint gained_funds;
9         uint ref_funds;
10         // this field can be negative
11         int funds_correction;
12     }
13 
14     using SafeMath for uint;
15     using SafeMathInt for int;
16     using Fee for Fee.fee;
17     using ToAddress for bytes;
18 
19     // ERC20
20     string constant public name = "Pantheon Ecosystem";
21     string constant public symbol = "PAN";
22     uint8 constant public decimals = 18;
23 
24     // Fees
25     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
26     Fee.fee private fee_selling  = Fee.fee(1, 20); // 5%
27     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
28     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
29 
30     // Minimal amount of tokens to be an participant of referral program
31     uint constant private minimal_stake = 10e18;
32 
33     // Factor for converting eth <-> tokens with required precision of calculations
34     uint constant private precision_factor = 1e18;
35 
36     // Pricing policy
37     //  - if user buy 1 token, price will be increased by "price_offset" value
38     //  - if user sell 1 token, price will be decreased by "price_offset" value
39     // For details see methods "fundsToTokens" and "tokensToFunds"
40     uint private price = 1e29; // 100 Gwei * precision_factor
41     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
42 
43     // Total amount of tokens
44     uint private total_supply = 0;
45 
46     // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter
47     // can be modified to keep the real user's dividends when total supply is changed
48     // For details see method "dividendsOf" and using "funds_correction" in the code
49     uint private shared_profit = 0;
50 
51     // Map of the users data
52     mapping(address => UserRecord) private user_data;
53 
54     // ==== Modifiers ==== //
55 
56     modifier onlyValidTokenAmount(uint tokens) {
57         require(tokens > 0, "Amount of tokens must be greater than zero");
58         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
59         _;
60     }
61 
62     // ==== Public API ==== //
63 
64     // ---- Write methods ---- //
65 
66     function () public payable {
67         buy(msg.data.toAddr());
68     }
69 
70     /*
71     * @dev Buy tokens from incoming funds
72     */
73     function buy(address referrer) public payable {
74 
75         // apply fee
76         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
77         require(fee_funds != 0, "Incoming funds is too small");
78 
79         // update user's referrer
80         //  - you cannot be a referrer for yourself
81         //  - user and his referrer will be together all the life
82         UserRecord storage user = user_data[msg.sender];
83         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
84             user.referrer = referrer;
85         }
86 
87         // apply referral bonus
88         if (user.referrer != 0x0) {
89             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
90             require(fee_funds != 0, "Incoming funds is too small");
91         }
92 
93         // calculate amount of tokens and change price
94         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
95         require(tokens != 0, "Incoming funds is too small");
96         price = _price;
97 
98         // mint tokens and increase shared profit
99         mintTokens(msg.sender, tokens);
100         shared_profit = shared_profit.add(fee_funds);
101 
102         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
103     }
104 
105     /*
106     * @dev Sell given amount of tokens and get funds
107     */
108     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
109 
110         // calculate amount of funds and change price
111         (uint funds, uint _price) = tokensToFunds(tokens);
112         require(funds != 0, "Insufficient tokens to do that");
113         price = _price;
114 
115         // apply fee
116         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
117         require(fee_funds != 0, "Insufficient tokens to do that");
118 
119         // burn tokens and add funds to user's dividends
120         burnTokens(msg.sender, tokens);
121         UserRecord storage user = user_data[msg.sender];
122         user.gained_funds = user.gained_funds.add(taxed_funds);
123 
124         // increase shared profit
125         shared_profit = shared_profit.add(fee_funds);
126 
127         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
128     }
129 
130     /*
131     * @dev Transfer given amount of tokens from sender to another user
132     * ERC20
133     */
134     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
135 
136         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
137 
138         // apply fee
139         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
140         require(fee_tokens != 0, "Insufficient tokens to do that");
141 
142         // calculate amount of funds and change price
143         (uint funds, uint _price) = tokensToFunds(fee_tokens);
144         require(funds != 0, "Insufficient tokens to do that");
145         price = _price;
146 
147         // burn and mint tokens excluding fee
148         burnTokens(msg.sender, tokens);
149         mintTokens(to_addr, taxed_tokens);
150 
151         // increase shared profit
152         shared_profit = shared_profit.add(funds);
153 
154         emit Transfer(msg.sender, to_addr, tokens);
155         return true;
156     }
157 
158     /*
159     * @dev Reinvest all dividends
160     */
161     function reinvest() public {
162 
163         // get all dividends
164         uint funds = dividendsOf(msg.sender);
165         require(funds > 0, "You have no dividends");
166 
167         // make correction, dividents will be 0 after that
168         UserRecord storage user = user_data[msg.sender];
169         user.funds_correction = user.funds_correction.add(int(funds));
170 
171         // apply fee
172         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
173         require(fee_funds != 0, "Insufficient dividends to do that");
174 
175         // apply referral bonus
176         if (user.referrer != 0x0) {
177             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
178             require(fee_funds != 0, "Insufficient dividends to do that");
179         }
180 
181         // calculate amount of tokens and change price
182         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
183         require(tokens != 0, "Insufficient dividends to do that");
184         price = _price;
185 
186         // mint tokens and increase shared profit
187         mintTokens(msg.sender, tokens);
188         shared_profit = shared_profit.add(fee_funds);
189 
190         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
191     }
192 
193     /*
194     * @dev Withdraw all dividends
195     */
196     function withdraw() public {
197 
198         // get all dividends
199         uint funds = dividendsOf(msg.sender);
200         require(funds > 0, "You have no dividends");
201 
202         // make correction, dividents will be 0 after that
203         UserRecord storage user = user_data[msg.sender];
204         user.funds_correction = user.funds_correction.add(int(funds));
205 
206         // send funds
207         msg.sender.transfer(funds);
208 
209         emit Withdrawal(msg.sender, funds, now);
210     }
211 
212     /*
213     * @dev Sell all tokens and withraw dividends
214     */
215     function exit() public {
216 
217         // sell all tokens
218         uint tokens = user_data[msg.sender].tokens;
219         if (tokens > 0) {
220             sell(tokens);
221         }
222 
223         withdraw();
224     }
225 
226     /*
227     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
228     * It will be used by another contracts/addresses from our ecosystem in future
229     * But if you want to donate, you're welcome :)
230     */
231     function donate() public payable {
232         shared_profit = shared_profit.add(msg.value);
233         emit Donation(msg.sender, msg.value, now);
234     }
235 
236     // ---- Read methods ---- //
237 
238     /*
239     * @dev Total amount of tokens
240     * ERC20
241     */
242     function totalSupply() public view returns (uint) {
243         return total_supply;
244     }
245 
246     /*
247     * @dev Amount of user's tokens
248     * ERC20
249     */
250     function balanceOf(address addr) public view returns (uint) {
251         return user_data[addr].tokens;
252     }
253 
254     /*
255     * @dev Amount of user's dividends
256     */
257     function dividendsOf(address addr) public view returns (uint) {
258 
259         UserRecord memory user = user_data[addr];
260 
261         // gained funds from selling tokens + bonus funds from referrals
262         // int because "user.funds_correction" can be negative
263         int d = int(user.gained_funds.add(user.ref_funds));
264         require(d >= 0);
265 
266         // avoid zero divizion
267         if (total_supply > 0) {
268             // profit is proportional to stake
269             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
270         }
271 
272         // correction
273         // d -= user.funds_correction
274         if (user.funds_correction > 0) {
275             d = d.sub(user.funds_correction);
276         }
277         else if (user.funds_correction < 0) {
278             d = d.add(-user.funds_correction);
279         }
280 
281         // just in case
282         require(d >= 0);
283 
284         // total sum must be positive uint
285         return uint(d);
286     }
287 
288     /*
289     * @dev Amount of tokens can be gained from given amount of funds
290     */
291     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
292         if (funds == 0) {
293             return 0;
294         }
295         if (apply_fee) {
296             (,uint _funds) = fee_purchase.split(funds);
297             funds = _funds;
298         }
299         (uint tokens,) = fundsToTokens(funds);
300         return tokens;
301     }
302 
303     /*
304     * @dev Amount of funds can be gained from given amount of tokens
305     */
306     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
307         // empty tokens in total OR no tokens was sold
308         if (tokens == 0 || total_supply == 0) {
309             return 0;
310         }
311         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
312         else if (tokens > total_supply) {
313             tokens = total_supply;
314         }
315         (uint funds,) = tokensToFunds(tokens);
316         if (apply_fee) {
317             (,uint _funds) = fee_selling.split(funds);
318             funds = _funds;
319         }
320         return funds;
321     }
322 
323     /*
324     * @dev Purchase price of next 1 token
325     */
326     function buyPrice() public view returns (uint) {
327         return price / precision_factor;
328     }
329 
330     /*
331     * @dev Selling price of next 1 token
332     */
333     function sellPrice() public view returns (uint) {
334         return price.sub(price_offset) / precision_factor;
335     }
336 
337     // ==== Private API ==== //
338 
339     /*
340     * @dev Mint given amount of tokens to given user
341     */
342     function mintTokens(address addr, uint tokens) internal {
343 
344         UserRecord storage user = user_data[addr];
345 
346         bool not_first_minting = total_supply > 0;
347 
348         // make correction to keep dividends the rest of the users
349         if (not_first_minting) {
350             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
351         }
352 
353         // add tokens
354         total_supply = total_supply.add(tokens);
355         user.tokens = user.tokens.add(tokens);
356 
357         // make correction to keep dividends of user
358         if (not_first_minting) {
359             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
360         }
361     }
362 
363     /*
364     * @dev Burn given amout of tokens from given user
365     */
366     function burnTokens(address addr, uint tokens) internal {
367 
368         UserRecord storage user = user_data[addr];
369 
370         // keep current dividents of user if last tokens will be burned
371         uint dividends_from_tokens = 0;
372         if (total_supply == tokens) {
373             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
374         }
375 
376         // make correction to keep dividends the rest of the users
377         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
378 
379         // sub tokens
380         total_supply = total_supply.sub(tokens);
381         user.tokens = user.tokens.sub(tokens);
382 
383         // make correction to keep dividends of the user
384         // if burned not last tokens
385         if (total_supply > 0) {
386             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
387         }
388         // if burned last tokens
389         else if (dividends_from_tokens != 0) {
390             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
391         }
392     }
393 
394     /*
395      * @dev Rewards the referrer from given amount of funds
396      */
397     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
398         UserRecord storage referrer = user_data[referrer_addr];
399         if (referrer.tokens >= minimal_stake) {
400             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
401             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
402             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
403             return taxed_funds;
404         }
405         else {
406             return funds;
407         }
408     }
409 
410     /*
411     * @dev Calculate tokens from funds
412     *
413     * Given:
414     *   a[1] = price
415     *   d = price_offset
416     *   sum(n) = funds
417     * Here is used arithmetic progression's equation transformed to a quadratic equation:
418     *   a * n^2 + b * n + c = 0
419     * Where:
420     *   a = d
421     *   b = 2 * a[1] - d
422     *   c = -2 * sum(n)
423     * Solve it and first root is what we need - amount of tokens
424     * So:
425     *   tokens = n
426     *   price = a[n+1]
427     *
428     * For details see method below
429     */
430     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
431         uint b = price.mul(2).sub(price_offset);
432         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
433         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
434         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
435         return (n, anp1);
436     }
437 
438     /*
439     * @dev Calculate funds from tokens
440     *
441     * Given:
442     *   a[1] = sell_price
443     *   d = price_offset
444     *   n = tokens
445     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
446     *   a[n] = a[1] - d * (n - 1)
447     *   sum(n) = (a[1] + a[n]) * n / 2
448     * So:
449     *   funds = sum(n)
450     *   price = a[n]
451     *
452     * For details see method above
453     */
454     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
455         uint sell_price = price.sub(price_offset);
456         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
457         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
458         return (sn / precision_factor, an);
459     }
460 
461     // ==== Events ==== //
462 
463     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
464     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
465     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
466     event Withdrawal(address indexed addr, uint funds, uint time);
467     event Donation(address indexed addr, uint funds, uint time);
468     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
469 
470     //ERC20
471     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
472 
473 }
474 
475 library SafeMath {
476 
477     /**
478     * @dev Multiplies two numbers
479     */
480     function mul(uint a, uint b) internal pure returns (uint) {
481         if (a == 0) {
482             return 0;
483         }
484         uint c = a * b;
485         require(c / a == b, "mul failed");
486         return c;
487     }
488 
489     /**
490     * @dev Subtracts two numbers
491     */
492     function sub(uint a, uint b) internal pure returns (uint) {
493         require(b <= a, "sub failed");
494         return a - b;
495     }
496 
497     /**
498     * @dev Adds two numbers
499     */
500     function add(uint a, uint b) internal pure returns (uint) {
501         uint c = a + b;
502         require(c >= a, "add failed");
503         return c;
504     }
505 
506     /**
507      * @dev Gives square root from number
508      */
509     function sqrt(uint x) internal pure returns (uint y) {
510         uint z = add(x, 1) / 2;
511         y = x;
512         while (z < y) {
513             y = z;
514             z = add(x / z, z) / 2;
515         }
516     }
517 }
518 
519 library SafeMathInt {
520 
521     /**
522     * @dev Subtracts two numbers
523     */
524     function sub(int a, int b) internal pure returns (int) {
525         int c = a - b;
526         require(c <= a, "sub failed");
527         return c;
528     }
529 
530     /**
531     * @dev Adds two numbers
532     */
533     function add(int a, int b) internal pure returns (int) {
534         int c = a + b;
535         require(c >= a, "add failed");
536         return c;
537     }
538 }
539 
540 library Fee {
541 
542     using SafeMath for uint;
543 
544     struct fee {
545         uint num;
546         uint den;
547     }
548 
549     /*
550     * @dev Splits given value to two parts: tax itself and taxed value
551     */
552     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
553         if (value == 0) {
554             return (0, 0);
555         }
556         tax = value.mul(f.num) / f.den;
557         taxed_value = value.sub(tax);
558     }
559 
560     /*
561     * @dev Returns only tax part
562     */
563     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
564         if (value == 0) {
565             return 0;
566         }
567         tax = value.mul(f.num) / f.den;
568     }
569 }
570 
571 library ToAddress {
572 
573     /*
574     * @dev Transforms bytes to address
575     */
576     function toAddr(bytes source) internal pure returns (address addr) {
577         assembly {
578             addr := mload(add(source, 0x14))
579         }
580         return addr;
581     }
582 }