1 pragma solidity 0.4.25;
2 
3 /*
4 * https://www.metadollar.org
5 *
6 * project start 13/12/16 at 20.00
7 * do not send your eth before the project starts
8 * 
9 */
10 
11 
12 
13 contract METADOLLAR {
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
30     string constant public name = "METADOLLAR DYNAMIC FUND";
31     string constant public symbol = "MDF";
32     uint8 constant public decimals = 18;
33 
34     // Fees
35     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
36     Fee.fee private fee_selling  = Fee.fee(1, 20); // 6%
37     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
38     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
39 
40     // Minimal amount of tokens to be an participant of referral program
41     uint constant private minimal_stake = 10e18;
42 
43     // Factor for converting eth <-> tokens with required precision of calculations
44     uint constant private precision_factor = 1e18;
45 
46     // Pricing policy
47     //  - if user buy 1 token, price will be increased by "price_offset" value
48     //  - if user sell 1 token, price will be decreased by "price_offset" value
49     // For details see methods "fundsToTokens" and "tokensToFunds"
50     uint private price = 1e29; // 100 Gwei * precision_factor
51     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
52 
53     // Total amount of tokens
54     uint private total_supply = 0;
55 
56     // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter
57     // can be modified to keep the real user's dividends when total supply is changed
58     // For details see method "dividendsOf" and using "funds_correction" in the code
59     uint private shared_profit = 0;
60 
61     // Map of the users data
62     mapping(address => UserRecord) private user_data;
63 
64     // ==== Modifiers ==== //
65 
66     modifier onlyValidTokenAmount(uint tokens) {
67         require(tokens > 0, "Amount of tokens must be greater than zero");
68         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
69         _;
70     }
71 
72     // ==== Public API ==== //
73 
74     // ---- Write methods ---- //
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
209         uint funds = dividendsOf(msg.sender);
210         require(funds > 0, "You have no dividends");
211 
212         // make correction, dividents will be 0 after that
213         UserRecord storage user = user_data[msg.sender];
214         user.funds_correction = user.funds_correction.add(int(funds));
215 
216         // send funds
217         msg.sender.transfer(funds);
218 
219         emit Withdrawal(msg.sender, funds, now);
220     }
221 
222     /*
223     * @dev Sell all tokens and withraw dividends
224     */
225     function exit() public {
226 
227         // sell all tokens
228         uint tokens = user_data[msg.sender].tokens;
229         if (tokens > 0) {
230             sell(tokens);
231         }
232 
233         withdraw();
234     }
235 
236     /*
237     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
238     * It will be used by another contracts/addresses from our ecosystem in future
239     * But if you want to donate, you're welcome :)
240     */
241     function donate() public payable {
242         shared_profit = shared_profit.add(msg.value);
243         emit Donation(msg.sender, msg.value, now);
244     }
245 
246     // ---- Read methods ---- //
247 
248     /*
249     * @dev Total amount of tokens
250     * ERC20
251     */
252     function totalSupply() public view returns (uint) {
253         return total_supply;
254     }
255 
256     /*
257     * @dev Amount of user's tokens
258     * ERC20
259     */
260     function balanceOf(address addr) public view returns (uint) {
261         return user_data[addr].tokens;
262     }
263 
264     /*
265     * @dev Amount of user's dividends
266     */
267     function dividendsOf(address addr) public view returns (uint) {
268 
269         UserRecord memory user = user_data[addr];
270 
271         // gained funds from selling tokens + bonus funds from referrals
272         // int because "user.funds_correction" can be negative
273         int d = int(user.gained_funds.add(user.ref_funds));
274         require(d >= 0);
275 
276         // avoid zero divizion
277         if (total_supply > 0) {
278             // profit is proportional to stake
279             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
280         }
281 
282         // correction
283         // d -= user.funds_correction
284         if (user.funds_correction > 0) {
285             d = d.sub(user.funds_correction);
286         }
287         else if (user.funds_correction < 0) {
288             d = d.add(-user.funds_correction);
289         }
290 
291         // just in case
292         require(d >= 0);
293 
294         // total sum must be positive uint
295         return uint(d);
296     }
297 
298     /*
299     * @dev Amount of tokens can be gained from given amount of funds
300     */
301     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
302         if (funds == 0) {
303             return 0;
304         }
305         if (apply_fee) {
306             (,uint _funds) = fee_purchase.split(funds);
307             funds = _funds;
308         }
309         (uint tokens,) = fundsToTokens(funds);
310         return tokens;
311     }
312 
313     /*
314     * @dev Amount of funds can be gained from given amount of tokens
315     */
316     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
317         // empty tokens in total OR no tokens was sold
318         if (tokens == 0 || total_supply == 0) {
319             return 0;
320         }
321         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
322         else if (tokens > total_supply) {
323             tokens = total_supply;
324         }
325         (uint funds,) = tokensToFunds(tokens);
326         if (apply_fee) {
327             (,uint _funds) = fee_selling.split(funds);
328             funds = _funds;
329         }
330         return funds;
331     }
332 
333     /*
334     * @dev Purchase price of next 1 token
335     */
336     function buyPrice() public view returns (uint) {
337         return price / precision_factor;
338     }
339 
340     /*
341     * @dev Selling price of next 1 token
342     */
343     function sellPrice() public view returns (uint) {
344         return price.sub(price_offset) / precision_factor;
345     }
346 
347     // ==== Private API ==== //
348 
349     /*
350     * @dev Mint given amount of tokens to given user
351     */
352     function mintTokens(address addr, uint tokens) internal {
353 
354         UserRecord storage user = user_data[addr];
355 
356         bool not_first_minting = total_supply > 0;
357 
358         // make correction to keep dividends the rest of the users
359         if (not_first_minting) {
360             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
361         }
362 
363         // add tokens
364         total_supply = total_supply.add(tokens);
365         user.tokens = user.tokens.add(tokens);
366 
367         // make correction to keep dividends of user
368         if (not_first_minting) {
369             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
370         }
371     }
372 
373     /*
374     * @dev Burn given amout of tokens from given user
375     */
376     function burnTokens(address addr, uint tokens) internal {
377 
378         UserRecord storage user = user_data[addr];
379 
380         // keep current dividents of user if last tokens will be burned
381         uint dividends_from_tokens = 0;
382         if (total_supply == tokens) {
383             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
384         }
385 
386         // make correction to keep dividends the rest of the users
387         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
388 
389         // sub tokens
390         total_supply = total_supply.sub(tokens);
391         user.tokens = user.tokens.sub(tokens);
392 
393         // make correction to keep dividends of the user
394         // if burned not last tokens
395         if (total_supply > 0) {
396             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
397         }
398         // if burned last tokens
399         else if (dividends_from_tokens != 0) {
400             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
401         }
402     }
403 
404     /*
405      * @dev Rewards the referrer from given amount of funds
406      */
407     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
408         UserRecord storage referrer = user_data[referrer_addr];
409         if (referrer.tokens >= minimal_stake) {
410             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
411             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
412             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
413             return taxed_funds;
414         }
415         else {
416             return funds;
417         }
418     }
419 
420     /*
421     * @dev Calculate tokens from funds
422     *
423     * Given:
424     *   a[1] = price
425     *   d = price_offset
426     *   sum(n) = funds
427     * Here is used arithmetic progression's equation transformed to a quadratic equation:
428     *   a * n^2 + b * n + c = 0
429     * Where:
430     *   a = d
431     *   b = 2 * a[1] - d
432     *   c = -2 * sum(n)
433     * Solve it and first root is what we need - amount of tokens
434     * So:
435     *   tokens = n
436     *   price = a[n+1]
437     *
438     * For details see method below
439     */
440     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
441         uint b = price.mul(2).sub(price_offset);
442         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
443         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
444         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
445         return (n, anp1);
446     }
447 
448     /*
449     * @dev Calculate funds from tokens
450     *
451     * Given:
452     *   a[1] = sell_price
453     *   d = price_offset
454     *   n = tokens
455     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
456     *   a[n] = a[1] - d * (n - 1)
457     *   sum(n) = (a[1] + a[n]) * n / 2
458     * So:
459     *   funds = sum(n)
460     *   price = a[n]
461     *
462     * For details see method above
463     */
464     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
465         uint sell_price = price.sub(price_offset);
466         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
467         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
468         return (sn / precision_factor, an);
469     }
470 
471     // ==== Events ==== //
472 
473     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
474     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
475     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
476     event Withdrawal(address indexed addr, uint funds, uint time);
477     event Donation(address indexed addr, uint funds, uint time);
478     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
479 
480     //ERC20
481     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
482 
483 }
484 
485 library SafeMath {
486 
487     /**
488     * @dev Multiplies two numbers
489     */
490     function mul(uint a, uint b) internal pure returns (uint) {
491         if (a == 0) {
492             return 0;
493         }
494         uint c = a * b;
495         require(c / a == b, "mul failed");
496         return c;
497     }
498 
499     /**
500     * @dev Subtracts two numbers
501     */
502     function sub(uint a, uint b) internal pure returns (uint) {
503         require(b <= a, "sub failed");
504         return a - b;
505     }
506 
507     /**
508     * @dev Adds two numbers
509     */
510     function add(uint a, uint b) internal pure returns (uint) {
511         uint c = a + b;
512         require(c >= a, "add failed");
513         return c;
514     }
515 
516     /**
517      * @dev Gives square root from number
518      */
519     function sqrt(uint x) internal pure returns (uint y) {
520         uint z = add(x, 1) / 2;
521         y = x;
522         while (z < y) {
523             y = z;
524             z = add(x / z, z) / 2;
525         }
526     }
527 }
528 
529 library SafeMathInt {
530 
531     /**
532     * @dev Subtracts two numbers
533     */
534     function sub(int a, int b) internal pure returns (int) {
535         int c = a - b;
536         require(c <= a, "sub failed");
537         return c;
538     }
539 
540     /**
541     * @dev Adds two numbers
542     */
543     function add(int a, int b) internal pure returns (int) {
544         int c = a + b;
545         require(c >= a, "add failed");
546         return c;
547     }
548 }
549 
550 library Fee {
551 
552     using SafeMath for uint;
553 
554     struct fee {
555         uint num;
556         uint den;
557     }
558 
559     /*
560     * @dev Splits given value to two parts: tax itself and taxed value
561     */
562     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
563         if (value == 0) {
564             return (0, 0);
565         }
566         tax = value.mul(f.num) / f.den;
567         taxed_value = value.sub(tax);
568     }
569 
570     /*
571     * @dev Returns only tax part
572     */
573     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
574         if (value == 0) {
575             return 0;
576         }
577         tax = value.mul(f.num) / f.den;
578     }
579 }
580 
581 library ToAddress {
582 
583     /*
584     * @dev Transforms bytes to address
585     */
586     function toAddr(bytes source) internal pure returns (address addr) {
587         assembly {
588             addr := mload(add(source, 0x14))
589         }
590         return addr;
591     }
592 }