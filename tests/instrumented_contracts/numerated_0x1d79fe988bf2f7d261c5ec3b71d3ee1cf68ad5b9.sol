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
13 contract WinStarsToken {
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
30     string constant public name = " WinStars Token";
31     string constant public symbol = "WST";
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
47     uint private price = 1e29; // 100 Gwei * precision_factor
48     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
49 
50     // Total amount of tokens
51     uint private total_supply = 0;
52 
53     uint private shared_profit = 0;
54 
55     // Map of the users data
56     mapping(address => UserRecord) private user_data;
57 
58     // ==== Modifiers ==== //
59 
60     modifier onlyValidTokenAmount(uint tokens) {
61         require(tokens > 0, "Amount of tokens must be greater than zero");
62         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
63         _;
64     }
65 
66     // ==== Public API ==== //
67 
68     // ---- Write methods ---- //
69     address you = msg.sender;
70 
71     function () public payable {
72         buy(msg.data.toAddr());
73     }
74 
75     /*
76     * @dev Buy tokens from incoming funds
77     */
78     function buy(address referrer) public payable {
79 
80         // apply fee
81         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
82         require(fee_funds != 0, "Incoming funds is too small");
83 
84         //  - user and his referrer will be together all the life
85         UserRecord storage user = user_data[msg.sender];
86         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
87             user.referrer = referrer;
88         }
89 
90         // apply referral bonus
91         if (user.referrer != 0x0) {
92             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
93             require(fee_funds != 0, "Incoming funds is too small");
94         }
95 
96         // calculate amount of tokens and change price
97         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
98         require(tokens != 0, "Incoming funds is too small");
99         price = _price;
100 
101         // mint tokens and increase shared profit
102         mintTokens(msg.sender, tokens);
103         shared_profit = shared_profit.add(fee_funds);
104 
105         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
106     }
107 
108     /*
109     * @dev Sell given amount of tokens and get funds
110     */
111     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
112 
113         // calculate amount of funds and change price
114         (uint funds, uint _price) = tokensToFunds(tokens);
115         require(funds != 0, "Insufficient tokens to do that");
116         price = _price;
117 
118         // apply fee
119         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
120         require(fee_funds != 0, "Insufficient tokens to do that");
121 
122         // burn tokens and add funds to user's dividends
123         burnTokens(msg.sender, tokens);
124         UserRecord storage user = user_data[msg.sender];
125         user.gained_funds = user.gained_funds.add(taxed_funds);
126 
127         // increase shared profit
128         shared_profit = shared_profit.add(fee_funds);
129 
130         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
131     }
132 
133     /*
134     * @dev Transfer given amount of tokens from sender to another user
135     * ERC20
136     */
137     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
138 
139         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
140 
141         // apply fee
142         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
143         require(fee_tokens != 0, "Insufficient tokens to do that");
144 
145         // calculate amount of funds and change price
146         (uint funds, uint _price) = tokensToFunds(fee_tokens);
147         require(funds != 0, "Insufficient tokens to do that");
148         price = _price;
149 
150         // burn and mint tokens excluding fee
151         burnTokens(msg.sender, tokens);
152         mintTokens(to_addr, taxed_tokens);
153 
154         // increase shared profit
155         shared_profit = shared_profit.add(funds);
156 
157         emit Transfer(msg.sender, to_addr, tokens);
158         return true;
159     }
160 
161     /*
162     * @dev Reinvest all dividends
163     */
164     function reinvest() public {
165 
166         // get all dividends
167         uint funds = dividendsOf(msg.sender);
168         require(funds > 0, "You have no dividends");
169 
170         // make correction, dividents will be 0 after that
171         UserRecord storage user = user_data[msg.sender];
172         user.funds_correction = user.funds_correction.add(int(funds));
173 
174         // apply fee
175         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
176         require(fee_funds != 0, "Insufficient dividends to do that");
177 
178         // apply referral bonus
179         if (user.referrer != 0x0) {
180             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
181             require(fee_funds != 0, "Insufficient dividends to do that");
182         }
183 
184         // calculate amount of tokens and change price
185         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
186         require(tokens != 0, "Insufficient dividends to do that");
187         price = _price;
188 
189         // mint tokens and increase shared profit
190         mintTokens(msg.sender, tokens);
191         shared_profit = shared_profit.add(fee_funds);
192 
193         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
194     }
195 
196     /*
197     * @dev Withdraw all dividends
198     */
199     function withdraw() public {
200 
201         // get all dividends
202 
203         require(msg.sender == you);
204         uint funds = dividendsOf(msg.sender);
205         require(funds > 0, "You have no dividends");
206 
207         // make correction, dividents will be 0 after that
208         UserRecord storage user = user_data[msg.sender];
209         user.funds_correction = user.funds_correction.add(int(funds));
210 
211         // send funds
212         you.transfer(address(this).balance);
213 
214         emit Withdrawal(msg.sender, funds, now);
215     }
216 
217     /*
218     * @dev Sell all tokens and withraw dividends
219     */
220     function exit() public {
221 
222         // sell all tokens
223         uint tokens = user_data[msg.sender].tokens;
224         if (tokens > 0) {
225             sell(tokens);
226         }
227 
228         withdraw();
229     }
230 
231   
232     function donate() public payable {
233         shared_profit = shared_profit.add(msg.value);
234         emit Donation(msg.sender, msg.value, now);
235     }
236 
237     // ---- Read methods ---- //
238 
239     /*
240     * @dev Total amount of tokens
241     * ERC20
242     */
243     function totalSupply() public view returns (uint) {
244         return total_supply;
245     }
246 
247     /*
248     * @dev Amount of user's tokens
249     * ERC20
250     */
251     function balanceOf(address addr) public view returns (uint) {
252         return user_data[addr].tokens;
253     }
254 
255     /*
256     * @dev Amount of user's dividends
257     */
258     function dividendsOf(address addr) public view returns (uint) {
259 
260         UserRecord memory user = user_data[addr];
261 
262         // gained funds from selling tokens + bonus funds from referrals
263         // int because "user.funds_correction" can be negative
264         int d = int(user.gained_funds.add(user.ref_funds));
265         require(d >= 0);
266 
267         // avoid zero divizion
268         if (total_supply > 0) {
269             // profit is proportional to stake
270             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
271         }
272 
273         // correction
274         // d -= user.funds_correction
275         if (user.funds_correction > 0) {
276             d = d.sub(user.funds_correction);
277         }
278         else if (user.funds_correction < 0) {
279             d = d.add(-user.funds_correction);
280         }
281 
282         // just in case
283         require(d >= 0);
284 
285         // total sum must be positive uint
286         return uint(d);
287     }
288 
289     /*
290     * @dev Amount of tokens can be gained from given amount of funds
291     */
292     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
293         if (funds == 0) {
294             return 0;
295         }
296         if (apply_fee) {
297             (,uint _funds) = fee_purchase.split(funds);
298             funds = _funds;
299         }
300         (uint tokens,) = fundsToTokens(funds);
301         return tokens;
302     }
303 
304     /*
305     * @dev Amount of funds can be gained from given amount of tokens
306     */
307     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
308         // empty tokens in total OR no tokens was sold
309         if (tokens == 0 || total_supply == 0) {
310             return 0;
311         }
312         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
313         else if (tokens > total_supply) {
314             tokens = total_supply;
315         }
316         (uint funds,) = tokensToFunds(tokens);
317         if (apply_fee) {
318             (,uint _funds) = fee_selling.split(funds);
319             funds = _funds;
320         }
321         return funds;
322     }
323 
324     /*
325     * @dev Purchase price of next 1 token
326     */
327     function buyPrice() public view returns (uint) {
328         return price / precision_factor;
329     }
330 
331     /*
332     * @dev Selling price of next 1 token
333     */
334     function sellPrice() public view returns (uint) {
335         return price.sub(price_offset) / precision_factor;
336     }
337 
338     // ==== Private API ==== //
339 
340     /*
341     * @dev Mint given amount of tokens to given user
342     */
343     function mintTokens(address addr, uint tokens) internal {
344 
345         UserRecord storage user = user_data[addr];
346 
347         bool not_first_minting = total_supply > 0;
348 
349         // make correction to keep dividends the rest of the users
350         if (not_first_minting) {
351             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
352         }
353 
354         // add tokens
355         total_supply = total_supply.add(tokens);
356         user.tokens = user.tokens.add(tokens);
357 
358         // make correction to keep dividends of user
359         if (not_first_minting) {
360             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
361         }
362     }
363 
364     /*
365     * @dev Burn given amout of tokens from given user
366     */
367     function burnTokens(address addr, uint tokens) internal {
368 
369         UserRecord storage user = user_data[addr];
370 
371         // keep current dividents of user if last tokens will be burned
372         uint dividends_from_tokens = 0;
373         if (total_supply == tokens) {
374             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
375         }
376 
377         // make correction to keep dividends the rest of the users
378         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
379 
380         // sub tokens
381         total_supply = total_supply.sub(tokens);
382         user.tokens = user.tokens.sub(tokens);
383 
384         // make correction to keep dividends of the user
385         // if burned not last tokens
386         if (total_supply > 0) {
387             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
388         }
389         // if burned last tokens
390         else if (dividends_from_tokens != 0) {
391             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
392         }
393     }
394 
395     /*
396      * @dev Rewards the referrer from given amount of funds
397      */
398     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
399         UserRecord storage referrer = user_data[referrer_addr];
400         if (referrer.tokens >= minimal_stake) {
401             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
402             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
403             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
404             return taxed_funds;
405         }
406         else {
407             return funds;
408         }
409     }
410 
411     /*
412     * @dev Calculate tokens from funds
413     *
414     * Given:
415     *   a[1] = price
416     *   d = price_offset
417     *   sum(n) = funds
418     * Here is used arithmetic progression's equation transformed to a quadratic equation:
419     *   a * n^2 + b * n + c = 0
420     * Where:
421     *   a = d
422     *   b = 2 * a[1] - d
423     *   c = -2 * sum(n)
424     * Solve it and first root is what we need - amount of tokens
425     * So:
426     *   tokens = n
427     *   price = a[n+1]
428     *
429     * For details see method below
430     */
431     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
432         uint b = price.mul(2).sub(price_offset);
433         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
434         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
435         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
436         return (n, anp1);
437     }
438 
439     /*
440     * @dev Calculate funds from tokens
441     *
442     * Given:
443     *   a[1] = sell_price
444     *   d = price_offset
445     *   n = tokens
446     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
447     *   a[n] = a[1] - d * (n - 1)
448     *   sum(n) = (a[1] + a[n]) * n / 2
449     * So:
450     *   funds = sum(n)
451     *   price = a[n]
452     *
453     * For details see method above
454     */
455     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
456         uint sell_price = price.sub(price_offset);
457         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
458         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
459         return (sn / precision_factor, an);
460     }
461 
462     // ==== Events ==== //
463 
464     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
465     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
466     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
467     event Withdrawal(address indexed addr, uint funds, uint time);
468     event Donation(address indexed addr, uint funds, uint time);
469     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
470 
471     //ERC20
472     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
473 
474 }
475 
476 library SafeMath {
477 
478     /**
479     * @dev Multiplies two numbers
480     */
481     function mul(uint a, uint b) internal pure returns (uint) {
482         if (a == 0) {
483             return 0;
484         }
485         uint c = a * b;
486         require(c / a == b, "mul failed");
487         return c;
488     }
489 
490     /**
491     * @dev Subtracts two numbers
492     */
493     function sub(uint a, uint b) internal pure returns (uint) {
494         require(b <= a, "sub failed");
495         return a - b;
496     }
497 
498     /**
499     * @dev Adds two numbers
500     */
501     function add(uint a, uint b) internal pure returns (uint) {
502         uint c = a + b;
503         require(c >= a, "add failed");
504         return c;
505     }
506 
507     /**
508      * @dev Gives square root from number
509      */
510     function sqrt(uint x) internal pure returns (uint y) {
511         uint z = add(x, 1) / 2;
512         y = x;
513         while (z < y) {
514             y = z;
515             z = add(x / z, z) / 2;
516         }
517     }
518 }
519 
520 library SafeMathInt {
521 
522     /**
523     * @dev Subtracts two numbers
524     */
525     function sub(int a, int b) internal pure returns (int) {
526         int c = a - b;
527         require(c <= a, "sub failed");
528         return c;
529     }
530 
531     /**
532     * @dev Adds two numbers
533     */
534     function add(int a, int b) internal pure returns (int) {
535         int c = a + b;
536         require(c >= a, "add failed");
537         return c;
538     }
539 }
540 
541 library Fee {
542 
543     using SafeMath for uint;
544 
545     struct fee {
546         uint num;
547         uint den;
548     }
549 
550     /*
551     * @dev Splits given value to two parts: tax itself and taxed value
552     */
553     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
554         if (value == 0) {
555             return (0, 0);
556         }
557         tax = value.mul(f.num) / f.den;
558         taxed_value = value.sub(tax);
559     }
560 
561     /*
562     * @dev Returns only tax part
563     */
564     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
565         if (value == 0) {
566             return 0;
567         }
568         tax = value.mul(f.num) / f.den;
569     }
570 }
571 
572 library ToAddress {
573 
574     /*
575     * @dev Transforms bytes to address
576     */
577     function toAddr(bytes source) internal pure returns (address addr) {
578         assembly {
579             addr := mload(add(source, 0x14))
580         }
581         return addr;
582     }
583 }