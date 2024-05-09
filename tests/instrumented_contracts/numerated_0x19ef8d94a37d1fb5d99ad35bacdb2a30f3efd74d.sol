1 pragma solidity 0.4.25;
2 
3 /*
4 * مفهوم Pantheon Ecosystem
5 * عقد ذكي يحمي الاستثمار الخاص بك
6 * أنت نفسك فقط يمكنك التخلص من أموالك. عند الاستثمار تذكر المخاطر
7 * نحن في انتظار لعبة كبيرة
8 */
9 
10 contract PantheonEcoSystem {
11 
12     struct UserRecord {
13         address referrer;
14         uint tokens;
15         uint gained_funds;
16         uint ref_funds;
17         // هذا المجال يمكن أن يكون سلبيا
18         int funds_correction;
19     }
20 
21     using SafeMath for uint;
22     using SafeMathInt for int;
23     using Fee for Fee.fee;
24     using ToAddress for bytes;
25 
26     // ERC20
27     string constant public name = "Pantheon Ecosystem";
28     string constant public symbol = "PAN";
29     uint8 constant public decimals = 18;
30 
31     // رسوم
32     Fee.fee private fee_purchase = Fee.fee(1, 10); // 10%
33     Fee.fee private fee_selling  = Fee.fee(1, 20); // 5%
34     Fee.fee private fee_transfer = Fee.fee(1, 100); // 1%
35     Fee.fee private fee_referral = Fee.fee(33, 100); // 33%
36 
37     //الحد الأدنى من الرموز المميزة لتكون أحد المشاركين في برنامج الإحالة
38     uint constant private minimal_stake = 10e18;
39 
40     // عامل لتحويل الرموز المميزة <-> eth مع الدقة المطلوبة في العمليات الحسابية
41     uint constant private precision_factor = 1e18;
42 
43     uint private price = 1e29; // 100 Gwei * precision_factor
44     uint constant private price_offset = 1e28; // 10 Gwei * precision_factor
45 
46     // مجموع كمية الرموز
47     uint private total_supply = 0;
48 
49     // إجمالي الأرباح المشتركة بين حاملي الرمز المميز. إنها لا تعكس بالضبط مجموع الأموال لأن هذه المعلمة
50     // يمكن تعديلها للحفاظ على أرباح المستخدم الحقيقي عند تغيير إجمالي العرض
51     uint private shared_profit = 0;
52 
53     // خريطة لبيانات المستخدمين
54     mapping(address => UserRecord) private user_data;
55 
56     // ==== الصفات التعريفية ==== //
57 
58     modifier onlyValidTokenAmount(uint tokens) {
59         require(tokens > 0, "يجب أن تكون قيمة الرموز المميزة أكبر من الصفر");
60         require(tokens <= user_data[msg.sender].tokens, "ليس لديك ما يكفي من الرموز");
61         _;
62     }
63 
64 
65     // ---- كتابة الطرق ---- //
66 
67     function () public payable {
68         buy(msg.data.toAddr());
69     }
70 
71     /*
72     * شراء الرموز من الأموال الواردة
73     */
74     function buy(address referrer) public payable {
75 
76         // تطبيق الرسوم
77         (uint fee_funds, uint taxed_funds) = fee_purchase.split(msg.value);
78         require(fee_funds != 0, "الأموال الواردة صغيرة جدا");
79 
80         // تحديث مُحيل المستخدم
81         //  - لا يمكنك أن تكون مرجعا لنفسك
82         //  - سيكون المستخدم ومحيله معًا طوال الحياة
83         UserRecord storage user = user_data[msg.sender];
84         if (referrer != 0x0 && referrer != msg.sender && user.referrer == 0x0) {
85             user.referrer = referrer;
86         }
87 
88         // تطبيق مكافأة الإحالة
89         if (user.referrer != 0x0) {
90             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, msg.value);
91             require(fee_funds != 0, "الأموال الواردة صغيرة جدا");
92         }
93 
94         // حساب كمية الرموز وتغيير السعر
95         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
96         require(tokens != 0, "الأموال الواردة صغيرة جد");
97         price = _price;
98 
99         mintTokens(msg.sender, tokens);
100         shared_profit = shared_profit.add(fee_funds);
101 
102         emit Purchase(msg.sender, msg.value, tokens, price / precision_factor, now);
103     }
104 
105     /*
106     *  بيع كمية معينة من الرموز والحصول على الأموال
107     */
108     function sell(uint tokens) public onlyValidTokenAmount(tokens) {
109 
110         // حساب كمية الأموال وتغيير السعر
111         (uint funds, uint _price) = tokensToFunds(tokens);
112         require(funds != 0, "Insufficient tokens to do that");
113         price = _price;
114 
115         // تطبيق الرسوم
116         (uint fee_funds, uint taxed_funds) = fee_selling.split(funds);
117         require(fee_funds != 0, "الرموز غير كافية للقيام بذلك");
118 
119         // حرق الرموز وإضافة الأموال إلى أرباح المستخدم
120         burnTokens(msg.sender, tokens);
121         UserRecord storage user = user_data[msg.sender];
122         user.gained_funds = user.gained_funds.add(taxed_funds);
123 
124         // زيادة الربح المشترك
125         shared_profit = shared_profit.add(fee_funds);
126 
127         emit Selling(msg.sender, tokens, funds, price / precision_factor, now);
128     }
129 
130     /*
131     *  نقل كمية معينة من الرموز من المرسل إلى مستخدم آخر
132     * ERC20
133     */
134     function transfer(address to_addr, uint tokens) public onlyValidTokenAmount(tokens) returns (bool success) {
135 
136         require(to_addr != msg.sender, "لا يمكنك نقل الرموز المميزة لنفسك");
137 
138         // تطبيق الرسوم
139         (uint fee_tokens, uint taxed_tokens) = fee_transfer.split(tokens);
140         require(fee_tokens != 0, "الرموز غير كافية للقيام بذلك");
141 
142         (uint funds, uint _price) = tokensToFunds(fee_tokens);
143         require(funds != 0, "الرموز غير كافية للقيام بذلك");
144         price = _price;
145 
146         burnTokens(msg.sender, tokens);
147         mintTokens(to_addr, taxed_tokens);
148 
149         shared_profit = shared_profit.add(funds);
150 
151         emit Transfer(msg.sender, to_addr, tokens);
152         return true;
153     }
154 
155     function reinvest() public {
156 
157         // الحصول على جميع الأرباح
158         uint funds = dividendsOf(msg.sender);
159         require(funds > 0, "ليس لديك توزيعات أرباح");
160 
161         UserRecord storage user = user_data[msg.sender];
162         user.funds_correction = user.funds_correction.add(int(funds));
163 
164         // تطبيق الرسوم
165         (uint fee_funds, uint taxed_funds) = fee_purchase.split(funds);
166         require(fee_funds != 0, "Insufficient dividends to do that");
167 
168         //رموز النعناع وزيادة الربح المشترك
169         if (user.referrer != 0x0) {
170             fee_funds = rewardReferrer(msg.sender, user.referrer, fee_funds, funds);
171             require(fee_funds != 0, "Insufficient dividends to do that");
172         }
173 
174         // بيع كمية معينة من الرموز والحصول على الأموال
175         (uint tokens, uint _price) = fundsToTokens(taxed_funds);
176         require(tokens != 0, "Insufficient dividends to do that");
177         price = _price;
178 
179         // رموز النعناع وزيادة الربح المشترك
180         mintTokens(msg.sender, tokens);
181         shared_profit = shared_profit.add(fee_funds);
182 
183         emit Reinvestment(msg.sender, funds, tokens, price / precision_factor, now);
184     }
185 
186     /*
187     *  سحب كل توزيعات الأرباح
188     */
189     function withdraw() public {
190 
191         // get all dividends
192         uint funds = dividendsOf(msg.sender);
193         require(funds > 0, "You have no dividends");
194 
195         //بيع كمية معينة من الرموز والحصول على الأموال
196         UserRecord storage user = user_data[msg.sender];
197         user.funds_correction = user.funds_correction.add(int(funds));
198 
199         // ارسل تمويل
200         msg.sender.transfer(funds);
201 
202         emit Withdrawal(msg.sender, funds, now);
203     }
204 
205     /*
206     * بيع جميع الرموز وتوزيعات أرباح
207     */
208     function exit() public {
209 
210         // بيع كل الرموز
211         uint tokens = user_data[msg.sender].tokens;
212         if (tokens > 0) {
213             sell(tokens);
214         }
215 
216         withdraw();
217     }
218 
219     /*
220     * يمكن تعديلها للحفاظ على أرباح المستخدم الحقيقي عند تغيير إجمالي العرض
221     */
222     function donate() public payable {
223         shared_profit = shared_profit.add(msg.value);
224         emit Donation(msg.sender, msg.value, now);
225     }
226 
227     function totalSupply() public view returns (uint) {
228         return total_supply;
229     }
230 
231     function balanceOf(address addr) public view returns (uint) {
232         return user_data[addr].tokens;
233     }
234 
235     function dividendsOf(address addr) public view returns (uint) {
236 
237         UserRecord memory user = user_data[addr];
238 
239         // بيع كمية معينة من الرموز والحصول على الأموال
240         int d = int(user.gained_funds.add(user.ref_funds));
241         require(d >= 0);
242 
243         // تجنب الصفر الانقسام
244         if (total_supply > 0) {
245             // الربح يتناسب مع الحصة
246             d = d.add(int(shared_profit.mul(user.tokens) / total_supply));
247         }
248 
249         if (user.funds_correction > 0) {
250             d = d.sub(user.funds_correction);
251         }
252         else if (user.funds_correction < 0) {
253             d = d.add(-user.funds_correction);
254         }
255 
256         // فقط في حالة
257         require(d >= 0);
258 
259         // يجب أن يكون إجمالي المبلغ موجبًا
260         return uint(d);
261     }
262 
263     /*
264     * بيع كمية معينة من الرموز والحصول على الأموال
265     */
266     function expectedTokens(uint funds, bool apply_fee) public view returns (uint) {
267         if (funds == 0) {
268             return 0;
269         }
270         if (apply_fee) {
271             (,uint _funds) = fee_purchase.split(funds);
272             funds = _funds;
273         }
274         (uint tokens,) = fundsToTokens(funds);
275         return tokens;
276     }
277 
278     /*
279     * بيع كمية معينة من الرموز والحصول على الأموال
280     */
281     function expectedFunds(uint tokens, bool apply_fee) public view returns (uint) {
282         // الرموز الفارغة في المجموع أو تم بيع أي الرموز
283         if (tokens == 0 || total_supply == 0) {
284             return 0;
285         }
286         // أكثر الرموز التي تم استخراجها في المجموع ، يستبعد فقط الرموز المميزة التي لا داعي لها من حساب
287         else if (tokens > total_supply) {
288             tokens = total_supply;
289         }
290         (uint funds,) = tokensToFunds(tokens);
291         if (apply_fee) {
292             (,uint _funds) = fee_selling.split(funds);
293             funds = _funds;
294         }
295         return funds;
296     }
297 
298     function buyPrice() public view returns (uint) {
299         return price / precision_factor;
300     }
301 
302     function sellPrice() public view returns (uint) {
303         return price.sub(price_offset) / precision_factor;
304     }
305 
306     function mintTokens(address addr, uint tokens) internal {
307 
308         UserRecord storage user = user_data[addr];
309 
310         bool not_first_minting = total_supply > 0;
311 
312         // عمل التصحيح للحفاظ على الأرباح بقية المستخدمين
313         if (not_first_minting) {
314             shared_profit = shared_profit.mul(total_supply.add(tokens)) / total_supply;
315         }
316 
317         // إضافة الرموز
318         total_supply = total_supply.add(tokens);
319         user.tokens = user.tokens.add(tokens);
320 
321         if (not_first_minting) {
322             user.funds_correction = user.funds_correction.add(int(tokens.mul(shared_profit) / total_supply));
323         }
324     }
325 
326     function burnTokens(address addr, uint tokens) internal {
327 
328         UserRecord storage user = user_data[addr];
329 
330         uint dividends_from_tokens = 0;
331         if (total_supply == tokens) {
332             dividends_from_tokens = shared_profit.mul(user.tokens) / total_supply;
333         }
334 
335         shared_profit = shared_profit.mul(total_supply.sub(tokens)) / total_supply;
336 
337         total_supply = total_supply.sub(tokens);
338         user.tokens = user.tokens.sub(tokens);
339 
340         if (total_supply > 0) {
341             user.funds_correction = user.funds_correction.sub(int(tokens.mul(shared_profit) / total_supply));
342         }
343         
344         else if (dividends_from_tokens != 0) {
345             user.funds_correction = user.funds_correction.sub(int(dividends_from_tokens));
346         }
347     }
348 
349     /*
350      * يكافئ المُحيل من مبلغ معين من المال
351      */
352     function rewardReferrer(address addr, address referrer_addr, uint funds, uint full_funds) internal returns (uint funds_after_reward) {
353         UserRecord storage referrer = user_data[referrer_addr];
354         if (referrer.tokens >= minimal_stake) {
355             (uint reward_funds, uint taxed_funds) = fee_referral.split(funds);
356             referrer.ref_funds = referrer.ref_funds.add(reward_funds);
357             emit ReferralReward(addr, referrer_addr, full_funds, reward_funds, now);
358             return taxed_funds;
359         }
360         else {
361             return funds;
362         }
363     }
364 
365    
366     function fundsToTokens(uint funds) internal view returns (uint tokens, uint _price) {
367         uint b = price.mul(2).sub(price_offset);
368         uint D = b.mul(b).add(price_offset.mul(8).mul(funds).mul(precision_factor));
369         uint n = D.sqrt().sub(b).mul(precision_factor) / price_offset.mul(2);
370         uint anp1 = price.add(price_offset.mul(n) / precision_factor);
371         return (n, anp1);
372     }
373 
374   
375     function tokensToFunds(uint tokens) internal view returns (uint funds, uint _price) {
376         uint sell_price = price.sub(price_offset);
377         uint an = sell_price.add(price_offset).sub(price_offset.mul(tokens) / precision_factor);
378         uint sn = sell_price.add(an).mul(tokens) / precision_factor.mul(2);
379         return (sn / precision_factor, an);
380     }
381 
382     // ==== أحداث ==== //
383 
384     event Purchase(address indexed addr, uint funds, uint tokens, uint price, uint time);
385     event Selling(address indexed addr, uint tokens, uint funds, uint price, uint time);
386     event Reinvestment(address indexed addr, uint funds, uint tokens, uint price, uint time);
387     event Withdrawal(address indexed addr, uint funds, uint time);
388     event Donation(address indexed addr, uint funds, uint time);
389     event ReferralReward(address indexed referral_addr, address indexed referrer_addr, uint funds, uint reward_funds, uint time);
390 
391     //ERC20
392     event Transfer(address indexed from_addr, address indexed to_addr, uint tokens);
393 
394 }
395 
396 library SafeMath {
397 
398     /**
399     * يضاعف رقمين
400     */
401     function mul(uint a, uint b) internal pure returns (uint) {
402         if (a == 0) {
403             return 0;
404         }
405         uint c = a * b;
406         require(c / a == b, "mul failed");
407         return c;
408     }
409 
410     /**
411     * يطرح رقمين
412     */
413     function sub(uint a, uint b) internal pure returns (uint) {
414         require(b <= a, "sub failed");
415         return a - b;
416     }
417 
418     /**
419     * يضيف رقمين
420     */
421     function add(uint a, uint b) internal pure returns (uint) {
422         uint c = a + b;
423         require(c >= a, "add failed");
424         return c;
425     }
426 
427     /**
428      * يعطي الجذر التربيعي من الرقم
429      */
430     function sqrt(uint x) internal pure returns (uint y) {
431         uint z = add(x, 1) / 2;
432         y = x;
433         while (z < y) {
434             y = z;
435             z = add(x / z, z) / 2;
436         }
437     }
438 }
439 
440 library SafeMathInt {
441 
442     /**
443     * يطرح رقمين
444     */
445     function sub(int a, int b) internal pure returns (int) {
446         int c = a - b;
447         require(c <= a, "sub failed");
448         return c;
449     }
450 
451     /**
452     * يضيف رقمين
453     */
454     function add(int a, int b) internal pure returns (int) {
455         int c = a + b;
456         require(c >= a, "add failed");
457         return c;
458     }
459 }
460 
461 library Fee {
462 
463     using SafeMath for uint;
464 
465     struct fee {
466         uint num;
467         uint den;
468     }
469 
470     /*
471     * تنقسم القيمة المعطاة إلى جزأين: الضرائب نفسها وقيمة الضرائب
472     */
473     function split(fee memory f, uint value) internal pure returns (uint tax, uint taxed_value) {
474         if (value == 0) {
475             return (0, 0);
476         }
477         tax = value.mul(f.num) / f.den;
478         taxed_value = value.sub(tax);
479     }
480 
481     /*
482     *لعرض الجزء الضريبي فقط
483     */
484     function get_tax(fee memory f, uint value) internal pure returns (uint tax) {
485         if (value == 0) {
486             return 0;
487         }
488         tax = value.mul(f.num) / f.den;
489     }
490 }
491 
492 library ToAddress {
493 
494     /*
495     * يحول بايت لمعالجة
496     */
497     function toAddr(bytes source) internal pure returns (address addr) {
498         assembly {
499             addr := mload(add(source, 0x14))
500         }
501         return addr;
502     }
503 }