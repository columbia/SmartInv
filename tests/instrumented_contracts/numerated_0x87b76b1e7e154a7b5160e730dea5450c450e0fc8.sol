1 /*
2     * Start Project 05.12.2018 
3    
4      5%   fee purchase
5      10%  fee selling
6      1%   fee transfer
7      3,3% Referal 
8     */
9 
10 pragma solidity 0.4.25;
11 
12 contract EcoSystemPantheon_2_0 {
13 
14     struct UserRecord {
15         address referrer;
16         uint tokens;
17         uint gained_funds;
18         uint ref_funds;
19         // this field can be negative
20         int funds_correction;
21     }
22 
23     using SafeMath for uint;
24     using SafeMathInt for int;
25     using Fee for Fee.fee;
26     using ToAddress for bytes;
27 
28     // ERC20
29     string constant public name = " Ecosystem Pantheon_2_0";
30     string constant public symbol = "ESP";
31     uint8 constant public decimals = 18;
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
74 
75     function () public payable {
76         buy(msg.data.toAddr());
77     }
78 
79     /*
80     * @dev Buy tokens from incoming funds
81     */
82     function buy(address referrer) public payable {
83 
84         // apply fee
85         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
86         require(fee_funds != 0, "Incoming funds is too small");
87 
88         // update user's referrer
89         //  - you cannot be a referrer for yourself
90         //  - user and his referrer will be together all the life
91         UserRecord storage user = user_data[msg.sender];
92         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
93             user.referrer = referrer;
94         }
95 
96         // apply referral bonus
97         if (user.referrer != 0x0) {
98             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
99             require(fee_funds != 0, "Incoming funds is too small");
100         }
101 
102         // calculate amount of tokens and change price
103         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
104         require(tokens != 0, "Incoming funds is too small");
105         price = _price;
106 
107         // mint tokens and increase shared profit
108         mintTokens(msg.sender, tokens);
109         shared_profit = shared_profit.add(fee_funds);
110 
111         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
112     }
113 
114     /*
115     * @dev Sell given amount of tokens and get funds
116     */
117     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
118 
119         // calculate amount of funds and change price
120         (uint funds, uint _price) = tokensToFunds(tokens);
121         require(funds != 0, "Insufficient tokens to do that");
122         price = _price;
123 
124         // apply fee
125         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
126         require(fee_funds != 0, "Insufficient tokens to do that");
127 
128         // burn tokens and add funds to user's dividends
129         burnTokens(msg.sender, tokens);
130         UserRecord storage user = user_data[msg.sender];
131         user.gained_funds = user.gained_funds.add(taxed_funds);
132 
133         // increase shared profit
134         shared_profit = shared_profit.add(fee_funds);
135 
136         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
137     }
138 
139     /*
140     * @dev Transfer given amount of tokens from sender to another user
141     * ERC20
142     */
143     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
144 
145         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
146 
147         // apply fee
148         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
149         require(fee_tokens != 0, "Insufficient tokens to do that");
150 
151         // calculate amount of funds and change price
152         (uint funds, uint _price) = tokensToFunds(fee_tokens);
153         require(funds != 0, "Insufficient tokens to do that");
154         price = _price;
155 
156         // burn and mint tokens excluding fee
157         burnTokens(msg.sender, tokens);
158         mintTokens(to_addr, taxed_tokens);
159 
160         // increase shared profit
161         shared_profit = shared_profit.add(funds);
162 
163         emit Transfer(msg.sender, to_addr, tokens);
164         return true;
165     }
166 
167     /*
168     * @dev Reinvest all dividends
169     */
170     function reinvest() public {
171 
172         // get all dividends
173         uint funds = dividendsOf(msg.sender);
174         require(funds > 0, "You have no dividends");
175 
176         // make correction, dividents will be 0 after that
177         UserRecord storage user = user_data[msg.sender];
178         user.funds_correction = user.funds_correction.add(int(funds));
179 
180         // apply fee
181         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
182         require(fee_funds != 0, "Insufficient dividends to do that");
183 
184         // apply referral bonus
185         if (user.referrer != 0x0) {
186             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
187             require(fee_funds != 0, "Insufficient dividends to do that");
188         }
189 
190         // calculate amount of tokens and change price
191         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
192         require(tokens != 0, "Insufficient dividends to do that");
193         price = _price;
194 
195         // mint tokens and increase shared profit
196         mintTokens(msg.sender, tokens);
197         shared_profit = shared_profit.add(fee_funds);
198 
199         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
200     }
201 
202     /*
203     * @dev Withdraw all dividends
204     */
205     function withdraw() public {
206 
207         // get all dividends
208         uint funds = dividendsOf(msg.sender);
209         require(funds > 0, "You have no dividends");
210 
211         // make correction, dividents will be 0 after that
212         UserRecord storage user = user_data[msg.sender];
213         user.funds_correction = user.funds_correction.add(int(funds));
214 
215         // send funds
216         msg.sender.transfer(funds);
217 
218         emit Withdrawal(msg.sender, funds, now);
219     }
220 
221     /*
222     * @dev Sell all tokens and withraw dividends
223     */
224     function exit() public {
225 
226         // sell all tokens
227         uint tokens = user_data[msg.sender].tokens;
228         if (tokens > 0) {
229             sell(tokens);
230         }
231 
232         withdraw();
233     }
234 
235     /*
236     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
237     * It will be used by another contracts/addresses from our ecosystem in future
238     * But if you want to donate, you're welcome :)
239     */
240     function donate() public payable {
241         shared_profit = shared_profit.add(msg.value);
242         emit Donation(msg.sender, msg.value, now);
243     }
244 
245     // ---- Read methods ---- //
246 
247     /*
248     * @dev Total amount of tokens
249     * ERC20
250     */
251     function totalSupply() public view returns (uint) {
252         return total_supply;
253     }
254 
255     /*
256     * @dev Amount of user's tokens
257     * ERC20
258     */
259     function balanceOf(address addr) public view returns (uint) {
260         return user_data[addr].tokens;
261     }
262 
263     /*
264     * @dev Amount of user's dividends
265     */
266     function dividendsOf(address addr) public view returns (uint) {
267 
268         UserRecord memory user = user_data[addr];
269 
270         // gained funds from selling tokens + bonus funds from referrals
271         // int because "user.funds_correction" can be negative
272         int d = int(user.gained_funds.add(user.ref_funds));
273         require(d >= 0);
274 
275         // avoid zero divizion
276         if (total_supply > 0) {
277             // profit is proportional to stake
278             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
279         }
280 
281         // correction
282         // d -= user.funds_correction
283         if (user.funds_correction > 0) {
284             d = d.sub(user.funds_correction);
285         }
286         else if (user.funds_correction < 0) {
287             d = d.add(-user.funds_correction);
288         }
289 
290         // just in case
291         require(d >= 0);
292 
293         // total sum must be positive uint
294         return uint(d);
295     }
296 
297     /*
298     * @dev Amount of tokens can be gained from given amount of funds
299     */
300     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
301         if (funds == 0) {
302             return 0;
303         }
304         if (apply_fee) {
305             (,uint _funds) = fee_purchase.split(funds);
306             funds = _funds;
307         }
308         (uint tokens,) = fundsToTokens(funds);
309         return tokens;
310     }
311 
312     /*
313     * @dev Amount of funds can be gained from given amount of tokens
314     */
315     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
316         // empty tokens in total OR no tokens was sold
317         if (tokens == 0 || total_supply == 0) {
318             return 0;
319         }
320         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
321         else if (tokens > total_supply) {
322             tokens = total_supply;
323         }
324         (uint funds,) = tokensToFunds(tokens);
325         if (apply_fee) {
326             (,uint _funds) = fee_selling.split(funds);
327             funds = _funds;
328         }
329         return funds;
330     }
331 
332     /*
333     * @dev Purchase price of next 1 token
334     */
335     function buyPrice() public view returns (uint) {
336         return price / precision_factor;
337     }
338 
339     /*
340     * @dev Selling price of next 1 token
341     */
342     function sellPrice() public view returns (uint) {
343         return price.sub(price_offset) / precision_factor;
344     }
345 
346     // ==== Private API ==== //
347 
348     /*
349     * @dev Mint given amount of tokens to given user
350     */
351     function mintTokens(address addr, uint tokens) internal {
352 
353         UserRecord storage user = user_data[addr];
354 
355         bool not_first_minting = total_supply > 0;
356 
357         // make correction to keep dividends the rest of the users
358         if (not_first_minting) {
359             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
360         }
361 
362         // add tokens
363         total_supply = total_supply.add(tokens);
364         user.tokens = user.tokens.add(tokens);
365 
366         // make correction to keep dividends of user
367         if (not_first_minting) {
368             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
369         }
370     }
371 
372     /*
373     * @dev Burn given amout of tokens from given user
374     */
375     function burnTokens(address addr, uint tokens) internal {
376 
377         UserRecord storage user = user_data[addr];
378 
379         // keep current dividents of user if last tokens will be burned
380         uint dividends_from_tokens = 0;
381         if (total_supply == tokens) {
382             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
383         }
384 
385         // make correction to keep dividends the rest of the users
386         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
387 
388         // sub tokens
389         total_supply = total_supply.sub(tokens);
390         user.tokens = user.tokens.sub(tokens);
391 
392         // make correction to keep dividends of the user
393         // if burned not last tokens
394         if (total_supply > 0) {
395             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
396         }
397         // if burned last tokens
398         else if (dividends_from_tokens != 0) {
399             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
400         }
401     }
402 
403     /*
404      * @dev Rewards the referrer from given amount of funds
405      */
406     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
407         UserRecord storage referrer = user_data[referrer_addr];
408         if (referrer.tokens >= minimal_stake) {
409             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
410             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
411             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
412             return taxed_funds;
413         }
414         else {
415             return funds;
416         }
417     }
418 
419     /*
420     * @dev Calculate tokens from funds
421     *
422     * Given:
423     *   a[1] = price
424     *   d = price_offset
425     *   sum(n) = funds
426     * Here is used arithmetic progression's equation transformed to a quadratic equation:
427     *   a * n^2 + b * n + c = 0
428     * Where:
429     *   a = d
430     *   b = 2 * a[1] - d
431     *   c = -2 * sum(n)
432     * Solve it and first root is what we need - amount of tokens
433     * So:
434     *   tokens = n
435     *   price = a[n+1]
436     *
437     * For details see method below
438     */
439     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
440         uint b = price.mul(2).sub(price_offset);
441         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
442         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
443         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
444         return (n, anp1);
445     }
446 
447     /*
448     * @dev Calculate funds from tokens
449     *
450     * Given:
451     *   a[1] = sell_price
452     *   d = price_offset
453     *   n = tokens
454     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
455     *   a[n] = a[1] - d * (n - 1)
456     *   sum(n) = (a[1] + a[n]) * n / 2
457     * So:
458     *   funds = sum(n)
459     *   price = a[n]
460     *
461     * For details see method above
462     */
463     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
464         uint sell_price = price.sub(price_offset);
465         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
466         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
467         return (sn / precision_factor, an);
468     }
469 
470     // ==== Events ==== //
471 
472     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
473     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
474     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
475     event Withdrawal(address indexed addr, uint funds, uint time);
476     event Donation(address indexed addr, uint funds, uint time);
477     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
478 
479     //ERC20
480     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
481 
482 }
483 
484 library SafeMath {
485 
486     /**
487     * @dev Multiplies two numbers
488     */
489     function mul(uint a, uint b) internal pure returns (uint) {
490         if (a == 0) {
491             return 0;
492         }
493         uint c = a * b;
494         require(c / a == b, "mul failed");
495         return c;
496     }
497 
498     /**
499     * @dev Subtracts two numbers
500     */
501     function sub(uint a, uint b) internal pure returns (uint) {
502         require(b <= a, "sub failed");
503         return a - b;
504     }
505 
506     /**
507     * @dev Adds two numbers
508     */
509     function add(uint a, uint b) internal pure returns (uint) {
510         uint c = a + b;
511         require(c >= a, "add failed");
512         return c;
513     }
514 
515     /**
516      * @dev Gives square root from number
517      */
518     function sqrt(uint x) internal pure returns (uint y) {
519         uint z = add(x, 1) / 2;
520         y = x;
521         while (z < y) {
522             y = z;
523             z = add(x / z, z) / 2;
524         }
525     }
526 }
527 
528 library SafeMathInt {
529 
530     /**
531     * @dev Subtracts two numbers
532     */
533     function sub(int a, int b) internal pure returns (int) {
534         int c = a - b;
535         require(c <= a, "sub failed");
536         return c;
537     }
538 
539     /**
540     * @dev Adds two numbers
541     */
542     function add(int a, int b) internal pure returns (int) {
543         int c = a + b;
544         require(c >= a, "add failed");
545         return c;
546     }
547 }
548 
549 library Fee {
550 
551     using SafeMath for uint;
552 
553     struct fee {
554         uint num;
555         uint den;
556     }
557 
558     /*
559     * @dev Splits given value to two parts: tax itself and taxed value
560     */
561     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
562         if (value == 0) {
563             return (0, 0);
564         }
565         tax = value.mul(f.num) / f.den;
566         taxed_value = value.sub(tax);
567     }
568 
569     /*
570     * @dev Returns only tax part
571     */
572     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
573         if (value == 0) {
574             return 0;
575         }
576         tax = value.mul(f.num) / f.den;
577     }
578 }
579 
580 library ToAddress {
581 
582     /*
583     * @dev Transforms bytes to address
584     */
585     function toAddr(bytes source) internal pure returns (address addr) {
586         assembly {
587             addr := mload(add(source, 0x14))
588         }
589         return addr;
590     }
591 }