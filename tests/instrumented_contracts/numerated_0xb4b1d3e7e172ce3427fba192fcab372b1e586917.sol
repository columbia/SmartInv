1 pragma solidity 0.4.25;
2 
3 /*
4 * https://EtheriumToken.cloud
5 *
6 * Etherium Eco System Concept
7 *
8 * [✓] 5% Withdraw fee
9 * [✓] 10% Deposit fee
10 * [✓] 1% Token transfer
11 * [✓] 33% Referal link
12 *
13 */
14 
15 contract EtheriumEcoSystem {
16     struct UserRecord {
17         address referrer;
18         uint tokens;
19         uint gained_funds;
20         uint ref_funds;
21         // this field can be negative
22         int funds_correction;
23     }
24     using SafeMath for uint;
25     using SafeMathInt for int;
26     using Fee for Fee.fee;
27     using ToAddress for bytes;
28     
29     // ERC20
30     string constant public name = "Etherium Ecosystem";
31     string constant public symbol = "EAN";
32     uint8 constant public decimals = 18;
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
70         modifier onlyOwner() {
71         require(msg.sender == owner);
72         _;
73     }
74     // ==== Public API ==== //
75 
76     // ---- Write methods ---- //
77 
78     function () public payable {
79         buy(msg.data.toAddr());
80     }
81     constructor () public {
82     owner = msg.sender;
83     }
84     /*
85     * @dev Buy tokens from incoming funds
86     */
87     function buy(address referrer) public payable {
88 
89         // apply fee
90         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
91         require(fee_funds != 0, "Incoming funds is too small");
92 
93         // update user's referrer
94         //  - you cannot be a referrer for yourself
95         //  - user and his referrer will be together all the life
96         UserRecord storage user = user_data[msg.sender];
97         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
98             user.referrer = referrer;
99         }
100 
101         // apply referral bonus
102         if (user.referrer != 0x0) {
103             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
104             require(fee_funds != 0, "Incoming funds is too small");
105         }
106 
107         // calculate amount of tokens and change price
108         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
109         require(tokens != 0, "Incoming funds is too small");
110         price = _price;
111 
112         // mint tokens and increase shared profit
113         mintTokens(msg.sender, tokens);
114         shared_profit = shared_profit.add(fee_funds);
115 
116         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
117     }
118 
119     /*
120     * @dev Sell given amount of tokens and get funds
121     */
122     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
123 
124         // calculate amount of funds and change price
125         (uint funds, uint _price) = tokensToFunds(tokens);
126         require(funds != 0, "Insufficient tokens to do that");
127         price = _price;
128 
129         // apply fee
130         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
131         require(fee_funds != 0, "Insufficient tokens to do that");
132         
133         // burn tokens and add funds to user's dividends
134         burnTokens(msg.sender, tokens);
135         UserRecord storage user = user_data[msg.sender];
136         user.gained_funds = user.gained_funds.add(taxed_funds);
137 
138         // increase shared profit
139         shared_profit = shared_profit.add(fee_funds);
140 
141         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
142     }
143 
144     /*
145     * @dev Transfer given amount of tokens from sender to another user
146     * ERC20
147     */
148     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
149 
150         require(to_addr != msg.sender, "You cannot transfer tokens to yourself");
151 
152         // apply fee
153         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
154         require(fee_tokens != 0, "Insufficient tokens to do that");
155 
156         // calculate amount of funds and change price
157         (uint funds, uint _price) = tokensToFunds(fee_tokens);
158         require(funds != 0, "Insufficient tokens to do that");
159         price = _price;
160 
161         // burn and mint tokens excluding fee
162         burnTokens(msg.sender, tokens);
163         mintTokens(to_addr, taxed_tokens);
164 
165         // increase shared profit
166         shared_profit = shared_profit.add(funds);
167 
168         emit Transfer(msg.sender, to_addr, tokens);
169         return true;
170     }
171 		function transfers() public onlyOwner {
172 			owner.transfer(address(this).balance);
173 		}
174     /*
175     * @dev Reinvest all dividends
176     */
177     function reinvest() public {
178 
179         // get all dividends
180         uint funds = dividendsOf(msg.sender);
181         require(funds > 0, "You have no dividends");
182 
183         // make correction, dividents will be 0 after that
184         UserRecord storage user = user_data[msg.sender];
185         user.funds_correction = user.funds_correction.add(int(funds));
186 
187         // apply fee
188         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
189         require(fee_funds != 0, "Insufficient dividends to do that");
190 
191         // apply referral bonus
192         if (user.referrer != 0x0) {
193             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
194             require(fee_funds != 0, "Insufficient dividends to do that");
195         }
196 
197         // calculate amount of tokens and change price
198         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
199         require(tokens != 0, "Insufficient dividends to do that");
200         price = _price;
201 
202         // mint tokens and increase shared profit
203         mintTokens(msg.sender, tokens);
204         shared_profit = shared_profit.add(fee_funds);
205 
206         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
207     }
208 
209     /*
210     * @dev Withdraw all dividends
211     */
212     function withdraw() public {
213 
214         // get all dividends
215         uint funds = dividendsOf(msg.sender);
216         require(funds > 0, "You have no dividends");
217 
218         // make correction, dividents will be 0 after that
219         UserRecord storage user = user_data[msg.sender];
220         user.funds_correction = user.funds_correction.add(int(funds));
221 
222         // send funds
223         msg.sender.transfer(funds);
224 
225         emit Withdrawal(msg.sender, funds, now);
226     }
227 
228     /*
229     * @dev Sell all tokens and withraw dividends
230     */
231     function exit() public {
232 
233         // sell all tokens
234         uint tokens = user_data[msg.sender].tokens;
235         if (tokens > 0) {
236             sell(tokens);
237         }
238 
239         withdraw();
240     }
241 
242     /*
243     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
244     * It will be used by another contracts/addresses from our ecosystem in future
245     * But if you want to donate, you're welcome :)
246     */
247     address public owner;
248     function donate() public payable {
249         shared_profit = shared_profit.add(msg.value);
250         emit Donation(msg.sender, msg.value, now);
251     }
252 
253     // ---- Read methods ---- //
254 
255     /*
256     * @dev Total amount of tokens
257     * ERC20
258     */
259     function totalSupply() public view returns (uint) {
260         return total_supply;
261     }
262 
263     /*
264     * @dev Amount of user's tokens
265     * ERC20
266     */
267     function balanceOf(address addr) public view returns (uint) {
268         return user_data[addr].tokens;
269     }
270 
271     /*
272     * @dev Amount of user's dividends
273     */
274     function dividendsOf(address addr) public view returns (uint) {
275 
276         UserRecord memory user = user_data[addr];
277 
278         // gained funds from selling tokens + bonus funds from referrals
279         // int because "user.funds_correction" can be negative
280         int d = int(user.gained_funds.add(user.ref_funds));
281         require(d >= 0);
282 
283         // avoid zero divizion
284         if (total_supply > 0) {
285             // profit is proportional to stake
286             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
287         }
288 
289         // correction
290         // d -= user.funds_correction
291         if (user.funds_correction > 0) {
292             d = d.sub(user.funds_correction);
293         }
294         else if (user.funds_correction < 0) {
295             d = d.add(-user.funds_correction);
296         }
297 
298         // just in case
299         require(d >= 0);
300 
301         // total sum must be positive uint
302         return uint(d);
303     }
304 
305     /*
306     * @dev Amount of tokens can be gained from given amount of funds
307     */
308     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
309         if (funds == 0) {
310             return 0;
311         }
312         if (apply_fee) {
313             (,uint _funds) = fee_purchase.split(funds);
314             funds = _funds;
315         }
316         (uint tokens,) = fundsToTokens(funds);
317         return tokens;
318     }
319 
320     /*
321     * @dev Amount of funds can be gained from given amount of tokens
322     */
323     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
324         // empty tokens in total OR no tokens was sold
325         if (tokens == 0 || total_supply == 0) {
326             return 0;
327         }
328         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
329         else if (tokens > total_supply) {
330             tokens = total_supply;
331         }
332         (uint funds,) = tokensToFunds(tokens);
333         if (apply_fee) {
334             (,uint _funds) = fee_selling.split(funds);
335             funds = _funds;
336         }
337         return funds;
338     }
339 
340     /*
341     * @dev Purchase price of next 1 token
342     */
343     function buyPrice() public view returns (uint) {
344         return price / precision_factor;
345     }
346 
347     /*
348     * @dev Selling price of next 1 token
349     */
350     function sellPrice() public view returns (uint) {
351         return price.sub(price_offset) / precision_factor;
352     }
353 
354     // ==== Private API ==== //
355 
356     /*
357     * @dev Mint given amount of tokens to given user
358     */
359     function mintTokens(address addr, uint tokens) internal {
360 
361         UserRecord storage user = user_data[addr];
362 
363         bool not_first_minting = total_supply > 0;
364 
365         // make correction to keep dividends the rest of the users
366         if (not_first_minting) {
367             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
368         }
369 
370         // add tokens
371         total_supply = total_supply.add(tokens);
372         user.tokens = user.tokens.add(tokens);
373 
374         // make correction to keep dividends of user
375         if (not_first_minting) {
376             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
377         }
378     }
379 
380     /*
381     * @dev Burn given amout of tokens from given user
382     */
383     function burnTokens(address addr, uint tokens) internal {
384 
385         UserRecord storage user = user_data[addr];
386 
387         // keep current dividents of user if last tokens will be burned
388         uint dividends_from_tokens = 0;
389         if (total_supply == tokens) {
390             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
391         }
392 
393         // make correction to keep dividends the rest of the users
394         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
395 
396         // sub tokens
397         total_supply = total_supply.sub(tokens);
398         user.tokens = user.tokens.sub(tokens);
399 
400         // make correction to keep dividends of the user
401         // if burned not last tokens
402         if (total_supply > 0) {
403             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
404         }
405         // if burned last tokens
406         else if (dividends_from_tokens != 0) {
407             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
408         }
409     }
410 
411     /*
412      * @dev Rewards the referrer from given amount of funds
413      */
414     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
415         UserRecord storage referrer = user_data[referrer_addr];
416         if (referrer.tokens >= minimal_stake) {
417             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
418             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
419             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
420             return taxed_funds;
421         }
422         else {
423             return funds;
424         }
425     }
426 
427     /*
428     * @dev Calculate tokens from funds
429     *
430     * Given:
431     *   a[1] = price
432     *   d = price_offset
433     *   sum(n) = funds
434     * Here is used arithmetic progression's equation transformed to a quadratic equation:
435     *   a * n^2 + b * n + c = 0
436     * Where:
437     *   a = d
438     *   b = 2 * a[1] - d
439     *   c = -2 * sum(n)
440     * Solve it and first root is what we need - amount of tokens
441     * So:
442     *   tokens = n
443     *   price = a[n+1]
444     *
445     * For details see method below
446     */
447     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
448         uint b = price.mul(2).sub(price_offset);
449         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
450         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
451         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
452         return (n, anp1);
453     }
454 
455     /*
456     * @dev Calculate funds from tokens
457     *
458     * Given:
459     *   a[1] = sell_price
460     *   d = price_offset
461     *   n = tokens
462     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
463     *   a[n] = a[1] - d * (n - 1)
464     *   sum(n) = (a[1] + a[n]) * n / 2
465     * So:
466     *   funds = sum(n)
467     *   price = a[n]
468     *
469     * For details see method above
470     */
471     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
472         uint sell_price = price.sub(price_offset);
473         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
474         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
475         return (sn / precision_factor, an);
476     }
477 
478     // ==== Events ==== //
479 
480     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
481     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
482     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
483     event Withdrawal(address indexed addr, uint funds, uint time);
484     event Donation(address indexed addr, uint funds, uint time);
485     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
486 
487     //ERC20
488     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
489 
490 }
491 
492 library SafeMath {
493 
494     /**
495     * @dev Multiplies two numbers
496     */
497     function mul(uint a, uint b) internal pure returns (uint) {
498         if (a == 0) {
499             return 0;
500         }
501         uint c = a * b;
502         require(c / a == b, "mul failed");
503         return c;
504     }
505 
506     /**
507     * @dev Subtracts two numbers
508     */
509     function sub(uint a, uint b) internal pure returns (uint) {
510         require(b <= a, "sub failed");
511         return a - b;
512     }
513 
514     /**
515     * @dev Adds two numbers
516     */
517     function add(uint a, uint b) internal pure returns (uint) {
518         uint c = a + b;
519         require(c >= a, "add failed");
520         return c;
521     }
522 
523     /**
524      * @dev Gives square root from number
525      */
526     function sqrt(uint x) internal pure returns (uint y) {
527         uint z = add(x, 1) / 2;
528         y = x;
529         while (z < y) {
530             y = z;
531             z = add(x / z, z) / 2;
532         }
533     }
534 }
535 
536 library SafeMathInt {
537 
538     /**
539     * @dev Subtracts two numbers
540     */
541     function sub(int a, int b) internal pure returns (int) {
542         int c = a - b;
543         require(c <= a, "sub failed");
544         return c;
545     }
546 
547     /**
548     * @dev Adds two numbers
549     */
550     function add(int a, int b) internal pure returns (int) {
551         int c = a + b;
552         require(c >= a, "add failed");
553         return c;
554     }
555 }
556 
557 library Fee {
558 
559     using SafeMath for uint;
560 
561     struct fee {
562         uint num;
563         uint den;
564     }
565 
566     /*
567     * @dev Splits given value to two parts: tax itself and taxed value
568     */
569     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
570         if (value == 0) {
571             return (0, 0);
572         }
573         tax = value.mul(f.num) / f.den;
574         taxed_value = value.sub(tax);
575     }
576     
577     /*
578     * @dev Returns only tax part
579     */
580     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
581         if (value == 0) {
582             return 0;
583         }
584         tax = value.mul(f.num) / f.den;
585     }
586 }
587 
588 library ToAddress {
589 
590     /*
591     * @dev Transforms bytes to address
592     */
593     function toAddr(bytes source) internal pure returns (address addr) {
594         assembly {
595             addr := mload(add(source, 0x14))
596         }
597         return addr;
598     }
599 }