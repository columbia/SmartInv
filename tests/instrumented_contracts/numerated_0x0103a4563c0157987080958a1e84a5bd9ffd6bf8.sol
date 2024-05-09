1 pragma solidity 0.4.25;
2 
3 /*
4 
5 
6   _____            _   _                      
7  |  __ \          | | | |                     
8  | |__) |_ _ _ __ | |_| |__   ___  ___  _ __  
9  |  ___/ _` | '_ \| __| '_ \ / _ \/ _ \| '_ \ 
10  | |  | (_| | | | | |_| | | |  __/ (_) | | | |
11  |_| __\__,_|_| |_|\__|_| |_|\___|\___/|_| |_|
12     / ____|     | |   | |                     
13    | |  __  ___ | | __| |                     
14    | | |_ |/ _ \| |/ _` |                     
15    | |__| | (_) | | (_| |                     
16     \_____|\___/|_|\__,_|                     
17 
18 
19 
20 Exchange:   https://pantheon.gold                                            
21                                               
22 Discord:    https://discord.gg/zMZ6MmA
23 
24 
25 */
26 
27 contract PantheonGold {
28 
29     struct UserRecord {
30         address referrer;
31         uint tokens;
32         uint gained_funds;
33         uint ref_funds;
34         // this field can be negative
35         int funds_correction;
36     }
37 
38     using SafeMath for uint;
39     using SafeMathInt for int;
40     using Fee for Fee.fee;
41     using ToAddress for bytes;
42 
43     // ERC20
44     string constant public name = "Pantheon GOLD";
45     string constant public symbol = "PAN";
46     uint8 constant public decimals = 18;
47 
48     // Fees
49     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
50     Fee.fee private fee_selling  = Fee.fee(1, 20); // 5%
51     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
52     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
53 
54     // Minimal amount of tokens to be an participant of referral program
55     uint constant private minimal_stake = 10e18;
56 
57     // Factor for converting eth <-> tokens with required precision of calculations
58     uint constant private precision_factor = 1e18;
59 
60     // Pricing policy
61     //  - if user buy 1 token, price will be increased by "price_offset" value
62     //  - if user sell 1 token, price will be decreased by "price_offset" value
63     // For details see methods "fundsToTokens" and "tokensToFunds"
64     uint private price = 1e29; // 100 Gwei * precision_factor
65     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
66 
67     // Total amount of tokens
68     uint private total_supply = 0;
69 
70     // Total profit shared between token's holders. It's not reflect exactly sum of funds because this parameter
71     // can be modified to keep the real user's dividends when total supply is changed
72     // For details see method "dividendsOf" and using "funds_correction" in the code
73     uint private shared_profit = 0;
74 
75     // Map of the users data
76     mapping(address => UserRecord) private user_data;
77 
78     // ==== Modifiers ==== //
79 
80     modifier onlyValidTokenAmount(uint tokens) {
81         require(tokens > 0, "Amount of tokens must be greater than zero");
82         require(tokens <= user_data[msg.sender].tokens, "You have not enough tokens");
83         _;
84     }
85 
86     // ==== Public API ==== //
87 
88     // ---- Write methods ---- //
89 
90     function () public payable {
91         buy(msg.data.toAddr());
92     }
93 
94     /*
95     * @dev Buy tokens from incoming funds
96     */
97     function buy(address referrer) public payable {
98 
99         // apply fee
100         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
101         require(fee_funds != 0, "Incoming funds is too small");
102 
103         // update user's referrer
104         //  - you cannot be a referrer for yourself
105         //  - user and his referrer will be together all the life
106         UserRecord storage user = user_data[msg.sender];
107         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
108             user.referrer = referrer;
109         }
110 
111         // apply referral bonus
112         if (user.referrer != 0x0) {
113             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
114             require(fee_funds != 0, "Incoming funds is too small");
115         }
116 
117         // calculate amount of tokens and change price
118         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
119         require(tokens != 0, "Incoming funds is too small");
120         price = _price;
121 
122         // mint tokens and increase shared profit
123         mintTokens(msg.sender, tokens);
124         shared_profit = shared_profit.add(fee_funds);
125 
126         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
127     }
128 
129     /*
130     * @dev Sell given amount of tokens and get funds
131     */
132     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
133 
134         // calculate amount of funds and change price
135         (uint funds, uint _price) = tokensToFunds(tokens);
136         require(funds != 0, "Insufficient tokens to do that");
137         price = _price;
138 
139         // apply fee
140         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
141         require(fee_funds != 0, "Insufficient tokens to do that");
142 
143         // burn tokens and add funds to user's dividends
144         burnTokens(msg.sender, tokens);
145         UserRecord storage user = user_data[msg.sender];
146         user.gained_funds = user.gained_funds.add(taxed_funds);
147 
148         // increase shared profit
149         shared_profit = shared_profit.add(fee_funds);
150 
151         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
152     }
153 
154     /*
155     * @dev Transfer given amount of tokens from sender to another user
156     * ERC20
157     */
158     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
159 
160         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
161 
162         // apply fee
163         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
164         require(fee_tokens != 0, "Insufficient tokens to do that");
165 
166         // calculate amount of funds and change price
167         (uint funds, uint _price) = tokensToFunds(fee_tokens);
168         require(funds != 0, "Insufficient tokens to do that");
169         price = _price;
170 
171         // burn and mint tokens excluding fee
172         burnTokens(msg.sender, tokens);
173         mintTokens(to_addr, taxed_tokens);
174 
175         // increase shared profit
176         shared_profit = shared_profit.add(funds);
177 
178         emit Transfer(msg.sender, to_addr, tokens);
179         return true;
180     }
181 
182     /*
183     * @dev Reinvest all dividends
184     */
185     function reinvest() public {
186 
187         // get all dividends
188         uint funds = dividendsOf(msg.sender);
189         require(funds > 0, "You have no dividends");
190 
191         // make correction, dividents will be 0 after that
192         UserRecord storage user = user_data[msg.sender];
193         user.funds_correction = user.funds_correction.add(int(funds));
194 
195         // apply fee
196         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
197         require(fee_funds != 0, "Insufficient dividends to do that");
198 
199         // apply referral bonus
200         if (user.referrer != 0x0) {
201             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
202             require(fee_funds != 0, "Insufficient dividends to do that");
203         }
204 
205         // calculate amount of tokens and change price
206         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
207         require(tokens != 0, "Insufficient dividends to do that");
208         price = _price;
209 
210         // mint tokens and increase shared profit
211         mintTokens(msg.sender, tokens);
212         shared_profit = shared_profit.add(fee_funds);
213 
214         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
215     }
216 
217     /*
218     * @dev Withdraw all dividends
219     */
220     function withdraw() public {
221 
222         // get all dividends
223         uint funds = dividendsOf(msg.sender);
224         require(funds > 0, "You have no dividends");
225 
226         // make correction, dividents will be 0 after that
227         UserRecord storage user = user_data[msg.sender];
228         user.funds_correction = user.funds_correction.add(int(funds));
229 
230         // send funds
231         msg.sender.transfer(funds);
232 
233         emit Withdrawal(msg.sender, funds, now);
234     }
235 
236     /*
237     * @dev Sell all tokens and withraw dividends
238     */
239     function exit() public {
240 
241         // sell all tokens
242         uint tokens = user_data[msg.sender].tokens;
243         if (tokens > 0) {
244             sell(tokens);
245         }
246 
247         withdraw();
248     }
249 
250     /*
251     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
252     * It will be used by another contracts/addresses from our ecosystem in future
253     * But if you want to donate, you're welcome :)
254     */
255     function donate() public payable {
256         shared_profit = shared_profit.add(msg.value);
257         emit Donation(msg.sender, msg.value, now);
258     }
259 
260     // ---- Read methods ---- //
261 
262     /*
263     * @dev Total amount of tokens
264     * ERC20
265     */
266     function totalSupply() public view returns (uint) {
267         return total_supply;
268     }
269 
270     /*
271     * @dev Amount of user's tokens
272     * ERC20
273     */
274     function balanceOf(address addr) public view returns (uint) {
275         return user_data[addr].tokens;
276     }
277 
278     /*
279     * @dev Amount of user's dividends
280     */
281     function dividendsOf(address addr) public view returns (uint) {
282 
283         UserRecord memory user = user_data[addr];
284 
285         // gained funds from selling tokens + bonus funds from referrals
286         // int because "user.funds_correction" can be negative
287         int d = int(user.gained_funds.add(user.ref_funds));
288         require(d >= 0);
289 
290         // avoid zero divizion
291         if (total_supply > 0) {
292             // profit is proportional to stake
293             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
294         }
295 
296         // correction
297         // d -= user.funds_correction
298         if (user.funds_correction > 0) {
299             d = d.sub(user.funds_correction);
300         }
301         else if (user.funds_correction < 0) {
302             d = d.add(-user.funds_correction);
303         }
304 
305         // just in case
306         require(d >= 0);
307 
308         // total sum must be positive uint
309         return uint(d);
310     }
311 
312     /*
313     * @dev Amount of tokens can be gained from given amount of funds
314     */
315     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
316         if (funds == 0) {
317             return 0;
318         }
319         if (apply_fee) {
320             (,uint _funds) = fee_purchase.split(funds);
321             funds = _funds;
322         }
323         (uint tokens,) = fundsToTokens(funds);
324         return tokens;
325     }
326 
327     /*
328     * @dev Amount of funds can be gained from given amount of tokens
329     */
330     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
331         // empty tokens in total OR no tokens was sold
332         if (tokens == 0 || total_supply == 0) {
333             return 0;
334         }
335         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
336         else if (tokens > total_supply) {
337             tokens = total_supply;
338         }
339         (uint funds,) = tokensToFunds(tokens);
340         if (apply_fee) {
341             (,uint _funds) = fee_selling.split(funds);
342             funds = _funds;
343         }
344         return funds;
345     }
346 
347     /*
348     * @dev Purchase price of next 1 token
349     */
350     function buyPrice() public view returns (uint) {
351         return price / precision_factor;
352     }
353 
354     /*
355     * @dev Selling price of next 1 token
356     */
357     function sellPrice() public view returns (uint) {
358         return price.sub(price_offset) / precision_factor;
359     }
360 
361     // ==== Private API ==== //
362 
363     /*
364     * @dev Mint given amount of tokens to given user
365     */
366     function mintTokens(address addr, uint tokens) internal {
367 
368         UserRecord storage user = user_data[addr];
369 
370         bool not_first_minting = total_supply > 0;
371 
372         // make correction to keep dividends the rest of the users
373         if (not_first_minting) {
374             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
375         }
376 
377         // add tokens
378         total_supply = total_supply.add(tokens);
379         user.tokens = user.tokens.add(tokens);
380 
381         // make correction to keep dividends of user
382         if (not_first_minting) {
383             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
384         }
385     }
386 
387     /*
388     * @dev Burn given amout of tokens from given user
389     */
390     function burnTokens(address addr, uint tokens) internal {
391 
392         UserRecord storage user = user_data[addr];
393 
394         // keep current dividents of user if last tokens will be burned
395         uint dividends_from_tokens = 0;
396         if (total_supply == tokens) {
397             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
398         }
399 
400         // make correction to keep dividends the rest of the users
401         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
402 
403         // sub tokens
404         total_supply = total_supply.sub(tokens);
405         user.tokens = user.tokens.sub(tokens);
406 
407         // make correction to keep dividends of the user
408         // if burned not last tokens
409         if (total_supply > 0) {
410             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
411         }
412         // if burned last tokens
413         else if (dividends_from_tokens != 0) {
414             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
415         }
416     }
417 
418     /*
419      * @dev Rewards the referrer from given amount of funds
420      */
421     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
422         UserRecord storage referrer = user_data[referrer_addr];
423         if (referrer.tokens >= minimal_stake) {
424             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
425             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
426             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
427             return taxed_funds;
428         }
429         else {
430             return funds;
431         }
432     }
433 
434     /*
435     * @dev Calculate tokens from funds
436     *
437     * Given:
438     *   a[1] = price
439     *   d = price_offset
440     *   sum(n) = funds
441     * Here is used arithmetic progression's equation transformed to a quadratic equation:
442     *   a * n^2 + b * n + c = 0
443     * Where:
444     *   a = d
445     *   b = 2 * a[1] - d
446     *   c = -2 * sum(n)
447     * Solve it and first root is what we need - amount of tokens
448     * So:
449     *   tokens = n
450     *   price = a[n+1]
451     *
452     * For details see method below
453     */
454     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
455         uint b = price.mul(2).sub(price_offset);
456         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
457         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
458         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
459         return (n, anp1);
460     }
461 
462     /*
463     * @dev Calculate funds from tokens
464     *
465     * Given:
466     *   a[1] = sell_price
467     *   d = price_offset
468     *   n = tokens
469     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
470     *   a[n] = a[1] - d * (n - 1)
471     *   sum(n) = (a[1] + a[n]) * n / 2
472     * So:
473     *   funds = sum(n)
474     *   price = a[n]
475     *
476     * For details see method above
477     */
478     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
479         uint sell_price = price.sub(price_offset);
480         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
481         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
482         return (sn / precision_factor, an);
483     }
484 
485     // ==== Events ==== //
486 
487     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
488     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
489     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
490     event Withdrawal(address indexed addr, uint funds, uint time);
491     event Donation(address indexed addr, uint funds, uint time);
492     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
493 
494     //ERC20
495     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
496 
497 }
498 
499 library SafeMath {
500 
501     /**
502     * @dev Multiplies two numbers
503     */
504     function mul(uint a, uint b) internal pure returns (uint) {
505         if (a == 0) {
506             return 0;
507         }
508         uint c = a * b;
509         require(c / a == b, "mul failed");
510         return c;
511     }
512 
513     /**
514     * @dev Subtracts two numbers
515     */
516     function sub(uint a, uint b) internal pure returns (uint) {
517         require(b <= a, "sub failed");
518         return a - b;
519     }
520 
521     /**
522     * @dev Adds two numbers
523     */
524     function add(uint a, uint b) internal pure returns (uint) {
525         uint c = a + b;
526         require(c >= a, "add failed");
527         return c;
528     }
529 
530     /**
531      * @dev Gives square root from number
532      */
533     function sqrt(uint x) internal pure returns (uint y) {
534         uint z = add(x, 1) / 2;
535         y = x;
536         while (z < y) {
537             y = z;
538             z = add(x / z, z) / 2;
539         }
540     }
541 }
542 
543 library SafeMathInt {
544 
545     /**
546     * @dev Subtracts two numbers
547     */
548     function sub(int a, int b) internal pure returns (int) {
549         int c = a - b;
550         require(c <= a, "sub failed");
551         return c;
552     }
553 
554     /**
555     * @dev Adds two numbers
556     */
557     function add(int a, int b) internal pure returns (int) {
558         int c = a + b;
559         require(c >= a, "add failed");
560         return c;
561     }
562 }
563 
564 library Fee {
565 
566     using SafeMath for uint;
567 
568     struct fee {
569         uint num;
570         uint den;
571     }
572 
573     /*
574     * @dev Splits given value to two parts: tax itself and taxed value
575     */
576     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
577         if (value == 0) {
578             return (0, 0);
579         }
580         tax = value.mul(f.num) / f.den;
581         taxed_value = value.sub(tax);
582     }
583 
584     /*
585     * @dev Returns only tax part
586     */
587     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
588         if (value == 0) {
589             return 0;
590         }
591         tax = value.mul(f.num) / f.den;
592     }
593 }
594 
595 library ToAddress {
596 
597     /*
598     * @dev Transforms bytes to address
599     */
600     function toAddr(bytes source) internal pure returns (address addr) {
601         assembly {
602             addr := mload(add(source, 0x14))
603         }
604         return addr;
605     }
606 }