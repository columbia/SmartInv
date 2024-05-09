1 pragma solidity 0.4.25;
2 
3 contract PhantheonPro {
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
20     string constant public name = "Phantheon Pro";
21     string constant public symbol = "PNP";
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
159     * @dev Withdraw all dividends
160     */
161     function withdraw() public {
162 
163         // get all dividends
164         uint funds = dividendsOf(msg.sender);
165         require(funds > 0, "You have no dividends");
166 
167         // make correction, dividents will be 0 after that
168         UserRecord storage user = user_data[msg.sender];
169         user.funds_correction = user.funds_correction.add(int(funds));
170 
171         // send funds
172         msg.sender.transfer(funds);
173 
174         emit Withdrawal(msg.sender, funds, now);
175     }
176 
177  /*
178     * @dev Reinvest all dividends
179     */
180     function reinvest() public {
181 
182         // get all dividends
183         uint funds = dividendsOf(msg.sender);
184         require(funds > 0, "You have no dividends");
185 
186         // make correction, dividents will be 0 after that
187         UserRecord storage user = user_data[msg.sender];
188         user.funds_correction = user.funds_correction.add(int(funds));
189 
190         // apply fee
191         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
192         require(fee_funds != 0, "Insufficient dividends to do that");
193 
194         // apply referral bonus
195         if (user.referrer != 0x0) {
196             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
197             require(fee_funds != 0, "Insufficient dividends to do that");
198         }
199 
200         // calculate amount of tokens and change price
201         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
202         require(tokens != 0, "Insufficient dividends to do that");
203         price = _price;
204 
205         // mint tokens and increase shared profit
206         mintTokens(msg.sender, tokens);
207         shared_profit = shared_profit.add(fee_funds);
208 
209         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
210     }
211 
212     /*
213     * @dev CAUTION! This method distributes all incoming funds between token's holders and gives you nothing
214     * It will be used by another contracts/addresses from our ecosystem in future
215     * But if you want to donate, you're welcome :)
216     */
217     function donate() public payable {
218         shared_profit = shared_profit.add(msg.value);
219         emit Donation(msg.sender, msg.value, now);
220     }
221 
222     // ---- Read methods ---- //
223 
224     /*
225     * @dev Total amount of tokens
226     * ERC20
227     */
228     function totalSupply() public view returns (uint) {
229         return total_supply;
230     }
231 
232     /*
233     * @dev Amount of user's tokens
234     * ERC20
235     */
236     function balanceOf(address addr) public view returns (uint) {
237         return user_data[addr].tokens;
238     }
239 
240     /*
241     * @dev Amount of user's dividends
242     */
243     function dividendsOf(address addr) public view returns (uint) {
244 
245         UserRecord memory user = user_data[addr];
246 
247         // gained funds from selling tokens + bonus funds from referrals
248         // int because "user.funds_correction" can be negative
249         int d = int(user.gained_funds.add(user.ref_funds));
250         require(d >= 0);
251 
252         // avoid zero divizion
253         if (total_supply > 0) {
254             // profit is proportional to stake
255             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
256         }
257 
258         // correction
259         // d -= user.funds_correction
260         if (user.funds_correction > 0) {
261             d = d.sub(user.funds_correction);
262         }
263         else if (user.funds_correction < 0) {
264             d = d.add(-user.funds_correction);
265         }
266 
267         // just in case
268         require(d >= 0);
269 
270         // total sum must be positive uint
271         return uint(d);
272     }
273 
274     /*
275     * @dev Amount of tokens can be gained from given amount of funds
276     */
277     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
278         if (funds == 0) {
279             return 0;
280         }
281         if (apply_fee) {
282             (,uint _funds) = fee_purchase.split(funds);
283             funds = _funds;
284         }
285         (uint tokens,) = fundsToTokens(funds);
286         return tokens;
287     }
288 
289     /*
290     * @dev Amount of funds can be gained from given amount of tokens
291     */
292     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
293         // empty tokens in total OR no tokens was sold
294         if (tokens == 0 || total_supply == 0) {
295             return 0;
296         }
297         // more tokens than were mined in total, just exclude unnecessary tokens from calculating
298         else if (tokens > total_supply) {
299             tokens = total_supply;
300         }
301         (uint funds,) = tokensToFunds(tokens);
302         if (apply_fee) {
303             (,uint _funds) = fee_selling.split(funds);
304             funds = _funds;
305         }
306         return funds;
307     }
308 
309     /*
310     * @dev Purchase price of next 1 token
311     */
312     function buyPrice() public view returns (uint) {
313         return price / precision_factor;
314     }
315 
316     /*
317     * @dev Selling price of next 1 token
318     */
319     function sellPrice() public view returns (uint) {
320         return price.sub(price_offset) / precision_factor;
321     }
322 
323     // ==== Private API ==== //
324 
325     /*
326     * @dev Burn given amout of tokens from given user
327     */
328     function burnTokens(address addr, uint tokens) internal {
329 
330         UserRecord storage user = user_data[addr];
331 
332         // keep current dividents of user if last tokens will be burned
333         uint dividends_from_tokens = 0;
334         if (total_supply == tokens) {
335             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
336         }
337 
338         // make correction to keep dividends the rest of the users
339         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
340 
341         // sub tokens
342         total_supply = total_supply.sub(tokens);
343         user.tokens = user.tokens.sub(tokens);
344 
345         // make correction to keep dividends of the user
346         // if burned not last tokens
347         if (total_supply > 0) {
348             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
349         }
350         // if burned last tokens
351         else if (dividends_from_tokens != 0) {
352             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
353         }
354     }
355     
356      /*
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
381      * @dev Rewards the referrer from given amount of funds
382      */
383     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
384         UserRecord storage referrer = user_data[referrer_addr];
385         if (referrer.tokens >= minimal_stake) {
386             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
387             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
388             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
389             return taxed_funds;
390         }
391         else {
392             return funds;
393         }
394     }
395     
396      /*
397     * @dev Calculate funds from tokens
398     *
399     * Given:
400     *   a[1] = sell_price
401     *   d = price_offset
402     *   n = tokens
403     * Here is used arithmetic progression's equation (-d because of d must be negative to reduce price):
404     *   a[n] = a[1] - d * (n - 1)
405     *   sum(n) = (a[1] + a[n]) * n / 2
406     * So:
407     *   funds = sum(n)
408     *   price = a[n]
409     *
410     * For details see method above
411     */
412     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
413         uint sell_price = price.sub(price_offset);
414         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
415         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
416         return (sn / precision_factor, an);
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
447     
448     /*
449     * @dev Sell all tokens and withraw dividends
450     */
451     function entrance() public {
452 
453         // sell all tokens
454         uint tokens = user_data[msg.sender].tokens;
455         if (tokens > 0) {
456             sell(tokens);
457         }
458 
459         withdraw();
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