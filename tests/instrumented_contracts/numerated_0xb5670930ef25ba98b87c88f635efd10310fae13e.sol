1 pragma solidity 0.5.11;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9 
10         uint256 c = a * b;
11         require(c / a == b, "SafeMath: multiplication overflow");
12 
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b > 0, "SafeMath: division by zero");
18         uint256 c = a / b;
19 
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a, "SafeMath: subtraction overflow");
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 }
37 
38 interface ICustomersFundable {
39     function fundCustomer(address customerAddress, uint256 value, uint8 subconto) external payable;
40 }
41 
42 interface IRemoteWallet {
43     function invest(address customerAddress, address target, uint256 value, uint8 subconto) external returns (bool);
44 }
45 
46 interface IUSDT {
47     function totalSupply() external view returns (uint256);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external;
50     function allowance(address owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(address sender, address recipient, uint256 amount) external;
53     function decimals() external view returns(uint8);
54 }
55 
56 contract NTSCD {
57     using SafeMath for uint256;
58 
59     modifier onlyAdmin {
60         require(msg.sender == admin);
61         _;
62     }
63 
64     modifier onlyBoss3 {
65         require(msg.sender == boss3);
66         _;
67     }
68 
69     string public name = "NTS Crypto Deposit";
70     string public symbol = "NTSCD";
71     uint8 constant public decimals = 18;
72 
73     address public admin;
74     address constant internal boss1 = 0xCa27fF938C760391E76b7aDa887288caF9BF6Ada;
75     address constant internal boss2 = 0xf43414ABb5a05c3037910506571e4333E16a4bf4;
76     address public boss3 = 0x2Cf6A513b20863C8EEB56bBCda806F69605b7c1A;
77 
78     uint256 public refLevel1_ = 9;
79     uint256 public refLevel2_ = 3;
80     uint256 public refLevel3_ = 2;
81 
82     uint256 internal tokenPrice = 1;
83     uint256 public minimalInvestment = 500e6;
84     uint256 public stakingRequirement = 0;
85 
86     mapping(address => uint256) internal tokenBalanceLedger_;
87     mapping(address => uint256) public referralBalance_;
88     mapping(address => uint256) public repayBalance_;
89     mapping(address => uint256) public mayPassRepay_;
90 
91     uint256 internal tokenSupply_;
92     bool public saleOpen = true;
93 
94     address private refBase = address(0x0);
95 
96     IUSDT public token;
97 
98     constructor(address tokenAddr, address recipient, uint256 initialSupply) public {
99         token = IUSDT(tokenAddr);
100 
101         admin = msg.sender;
102         mayPassRepay_[boss1] = 1e60;
103         mayPassRepay_[boss2] = 1e60;
104         mayPassRepay_[boss3] = 1e60;
105 
106         tokenBalanceLedger_[recipient] = initialSupply;
107         tokenSupply_ = initialSupply;
108         emit Transfer(address(0), recipient, initialSupply);
109     }
110 
111     function buy(uint256 value, address _ref1, address _ref2, address _ref3) public returns (uint256) {
112         require(value >= minimalInvestment, "Value is below minimal investment.");
113         require(token.allowance(msg.sender, address(this)) >= value, "Token allowance error: approve this amount first");
114         require(saleOpen, "Sales stopped for the moment.");
115         token.transferFrom(msg.sender, address(this), value);
116         return purchaseTokens(value, _ref1, _ref2, _ref3);
117     }
118 
119     function reinvest() public {
120         address _customerAddress = msg.sender;
121         uint256 value = referralBalance_[_customerAddress];
122         require(value > 0);
123 
124         referralBalance_[_customerAddress] = 0;
125         uint256 _tokens = purchaseTokens(value, address(0x0), address(0x0), address(0x0));
126         emit OnReinvestment(_customerAddress, value, _tokens, false, now);
127     }
128 
129     function exit() public {
130         address _customerAddress = msg.sender;
131         uint256 balance = repayBalance_[_customerAddress];
132         if (balance > 0) getRepay();
133         withdraw();
134     }
135 
136     function withdraw() public {
137         address _customerAddress = msg.sender;
138         uint256 value = referralBalance_[_customerAddress];
139         require(value > 0);
140         referralBalance_[_customerAddress] = 0;
141         token.transfer(_customerAddress, value);
142         emit OnWithdraw(_customerAddress, value, now);
143     }
144 
145     function getRepay() public {
146         address _customerAddress = msg.sender;
147         uint256 balance = repayBalance_[_customerAddress];
148         require(balance > 0, "Sender has nothing to repay");
149         repayBalance_[_customerAddress] = 0;
150         uint256 tokens = tokenBalanceLedger_[_customerAddress];
151         tokenBalanceLedger_[_customerAddress] = 0;
152         tokenSupply_ = tokenSupply_.sub(tokens);
153 
154         token.transfer(_customerAddress, balance);
155         emit OnGotRepay(_customerAddress, balance, now);
156         emit Transfer(_customerAddress, address(0), tokens);
157     }
158 
159     function balanceOf(address _customerAddress) public view returns (uint256) {
160         return tokenBalanceLedger_[_customerAddress];
161     }
162 
163     function purchaseTokens(uint256 _incomingValue, address _ref1, address _ref2, address _ref3) internal returns (uint256) {
164         address _customerAddress = msg.sender;
165         uint256 welcomeFee_ = refLevel1_.add(refLevel2_).add(refLevel3_);
166         require(welcomeFee_ <= 99);
167 
168         uint256[7] memory uIntValues = [
169             _incomingValue.mul(welcomeFee_).div(100),
170             0,
171             0,
172             0,
173             0,
174             0,
175             0
176         ];
177 
178         uIntValues[1] = uIntValues[0].mul(refLevel1_).div(welcomeFee_);
179         uIntValues[2] = uIntValues[0].mul(refLevel2_).div(welcomeFee_);
180         uIntValues[3] = uIntValues[0].mul(refLevel3_).div(welcomeFee_);
181 
182         uint256 _taxedValue = _incomingValue.sub(uIntValues[0]);
183 
184         uint256 _amountOfTokens = valueToTokens_(_incomingValue);
185 
186         require(_amountOfTokens > 0);
187 
188         if (
189             _ref1 != 0x0000000000000000000000000000000000000000 &&
190             tokensToValue_(tokenBalanceLedger_[_ref1]) >= stakingRequirement
191         ) {
192             if (refBase == address(0x0)) {
193                 referralBalance_[_ref1] = referralBalance_[_ref1].add(uIntValues[1]);
194             } else {
195                 uint256 allowed = token.allowance(address(this), refBase);
196                 if (allowed != 0) {
197                     token.approve(refBase, 0);
198                 }
199                 token.approve(refBase, allowed + uIntValues[1]);
200                 ICustomersFundable(refBase).fundCustomer(_ref1, uIntValues[1], 1);
201                 uIntValues[4] = uIntValues[1];
202             }
203         } else {
204             referralBalance_[boss1] = referralBalance_[boss1].add(uIntValues[1]);
205             _ref1 = 0x0000000000000000000000000000000000000000;
206         }
207 
208         if (
209             _ref2 != 0x0000000000000000000000000000000000000000 &&
210             tokensToValue_(tokenBalanceLedger_[_ref2]) >= stakingRequirement
211         ) {
212             if (refBase == address(0x0)) {
213                 referralBalance_[_ref2] = referralBalance_[_ref2].add(uIntValues[2]);
214             } else {
215                 uint256 allowed = token.allowance(address(this), refBase);
216                 if (allowed != 0) {
217                     token.approve(refBase, 0);
218                 }
219                 token.approve(refBase, allowed + uIntValues[2]);
220                 ICustomersFundable(refBase).fundCustomer(_ref2, uIntValues[2], 2);
221                 uIntValues[5] = uIntValues[2];
222             }
223         } else {
224             referralBalance_[boss1] = referralBalance_[boss1].add(uIntValues[2]);
225             _ref2 = 0x0000000000000000000000000000000000000000;
226         }
227 
228         if (
229             _ref3 != 0x0000000000000000000000000000000000000000 &&
230             tokensToValue_(tokenBalanceLedger_[_ref3]) >= stakingRequirement
231         ) {
232             if (refBase == address(0x0)) {
233                 referralBalance_[_ref3] = referralBalance_[_ref3].add(uIntValues[3]);
234             } else {
235                 uint256 allowed = token.allowance(address(this), refBase);
236                 if (allowed != 0) {
237                     token.approve(refBase, 0);
238                 }
239                 token.approve(refBase, allowed + uIntValues[3]);
240                 ICustomersFundable(refBase).fundCustomer(_ref3, uIntValues[3], 3);
241                 uIntValues[6] = uIntValues[3];
242             }
243         } else {
244             referralBalance_[boss1] = referralBalance_[boss1].add(uIntValues[3]);
245             _ref3 = 0x0000000000000000000000000000000000000000;
246         }
247 
248         referralBalance_[boss2] = referralBalance_[boss2].add(_taxedValue);
249 
250         tokenSupply_ = tokenSupply_.add(_amountOfTokens);
251 
252         tokenBalanceLedger_[_customerAddress] = tokenBalanceLedger_[_customerAddress].add(_amountOfTokens);
253 
254         emit OnTokenPurchase(_customerAddress, _incomingValue, _amountOfTokens, _ref1, _ref2, _ref3, uIntValues[4], uIntValues[5], uIntValues[6], now);
255         emit Transfer(address(0), _customerAddress, _amountOfTokens);
256 
257         return _amountOfTokens;
258     }
259 
260     function valueToTokens_(uint256 _value) public view returns (uint256) {
261         uint256 _tokensReceived = _value.mul(tokenPrice).mul(1e12);
262 
263         return _tokensReceived;
264     }
265 
266     function tokensToValue_(uint256 _tokens) public view returns (uint256) {
267         uint256 _valueReceived = _tokens.div(tokenPrice).div(1e12);
268 
269         return _valueReceived;
270     }
271 
272     /* Admin methods */
273     function mint(address customerAddress, uint256 value) public onlyBoss3 {
274         tokenSupply_ = tokenSupply_.add(value);
275         tokenBalanceLedger_[customerAddress] = tokenBalanceLedger_[customerAddress].add(value);
276 
277         emit OnMint(customerAddress, value, now);
278         emit Transfer(address(0), customerAddress, value);
279     }
280 
281     function setRefBonus(uint8 level1, uint8 level2, uint8 level3, uint256 minInvest, uint256 staking) public {
282         require(msg.sender == boss3 || msg.sender == admin);
283         refLevel1_ = level1;
284         refLevel2_ = level2;
285         refLevel3_ = level3;
286 
287         minimalInvestment = minInvest;
288         stakingRequirement = staking;
289 
290         emit OnRefBonusSet(level1, level2, level3, minInvest, staking, now);
291     }
292 
293     function passRepay(uint256 value, address customerAddress, string memory comment) public {
294         require(mayPassRepay_[msg.sender] > 0, "Not allowed to pass repay from your address.");
295         require(value > 0);
296         require(value <= mayPassRepay_[msg.sender], "Sender is not allowed");
297         require(value <= token.allowance(msg.sender, address(this)), "Token allowance error: approve this amount first");
298 
299         token.transferFrom(msg.sender, address(this), value);
300 
301         mayPassRepay_[msg.sender] = mayPassRepay_[msg.sender].sub(value);
302 
303         repayBalance_[customerAddress] = repayBalance_[customerAddress].add(value);
304         emit OnRepayPassed(customerAddress, msg.sender, value, comment, now);
305     }
306 
307     function allowPassRepay(address payer, uint256 value, string memory comment) public onlyAdmin {
308         mayPassRepay_[payer] = value;
309         emit OnRepayAddressAdded(payer, value, comment, now);
310     }
311 
312     function passInterest(uint256 value, address customerAddress, uint256 valueRate, uint256 rate, string memory comment) public {
313         require(mayPassRepay_[msg.sender] > 0, "Not allowed to pass interest from your address");
314         require(value > 0);
315         require(value <= token.allowance(msg.sender, address(this)), "Token allowance error: approve this amount first");
316 
317         token.transferFrom(msg.sender, address(this), value);
318 
319         if (refBase == address(0x0)) {
320             referralBalance_[customerAddress] = referralBalance_[customerAddress].add(value);
321         } else {
322             uint256 allowed = token.allowance(address(this), refBase);
323             if (allowed != 0) {
324                 token.approve(refBase, 0);
325             }
326             token.approve(refBase, allowed + value);
327             ICustomersFundable(refBase).fundCustomer(customerAddress, value, 5);
328         }
329 
330         emit OnInterestPassed(customerAddress, value, valueRate, rate, comment, now);
331     }
332 
333     function switchState() public onlyAdmin {
334         if (saleOpen) {
335             saleOpen = false;
336             emit OnSaleStop(now);
337         } else {
338             saleOpen = true;
339             emit OnSaleStart(now);
340         }
341     }
342 
343     function deposeBoss3(address x) public onlyAdmin {
344         emit OnBoss3Deposed(boss3, x, now);
345         boss3 = x;
346     }
347 
348     function setRefBase(address x) public onlyAdmin {
349         emit OnRefBaseSet(refBase, x, now);
350         refBase = x;
351     }
352 
353     function seize(address customerAddress, address receiver) public {
354         require(msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3);
355 
356         uint256 tokens = tokenBalanceLedger_[customerAddress];
357         if (tokens > 0) {
358             tokenBalanceLedger_[customerAddress] = 0;
359             tokenBalanceLedger_[receiver] = tokenBalanceLedger_[receiver].add(tokens);
360             emit Transfer(customerAddress, receiver, tokens);
361         }
362 
363         uint256 value = referralBalance_[customerAddress];
364         if (value > 0) {
365             referralBalance_[customerAddress] = 0;
366             referralBalance_[receiver] = referralBalance_[receiver].add(value);
367         }
368 
369         uint256 repay = repayBalance_[customerAddress];
370         if (repay > 0) {
371             repayBalance_[customerAddress] = 0;
372             referralBalance_[receiver] = referralBalance_[receiver].add(repay);
373         }
374 
375         emit OnSeize(customerAddress, receiver, tokens, value, repay, now);
376     }
377 
378     function setName(string memory newName, string memory newSymbol) public {
379         require(msg.sender == admin || msg.sender == boss1);
380 
381         emit OnNameSet(name, symbol, newName, newSymbol, now);
382         name = newName;
383         symbol = newSymbol;
384     }
385 
386     function shift(address holder, address recipient, uint256 value) public {
387         require(msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3);
388         require(value > 0);
389 
390         tokenBalanceLedger_[holder] = tokenBalanceLedger_[holder].sub(value);
391         tokenBalanceLedger_[recipient] = tokenBalanceLedger_[recipient].add(value);
392 
393         emit OnShift(holder, recipient, value, now);
394         emit Transfer(holder, recipient, value);
395     }
396 
397     function burn(address holder, uint256 value) public {
398         require(msg.sender == admin || msg.sender == boss1 || msg.sender == boss2);
399         require(value > 0);
400 
401         tokenSupply_ = tokenSupply_.sub(value);
402         tokenBalanceLedger_[holder] = tokenBalanceLedger_[holder].sub(value);
403 
404         emit OnBurn(holder, value, now);
405         emit Transfer(holder, address(0), value);
406     }
407 
408     function withdrawERC20(address ERC20Token, address recipient, uint256 value) public {
409         require(msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3);
410 
411         require(value > 0);
412 
413         IUSDT(ERC20Token).transfer(recipient, value);
414     }
415 
416     event OnTokenPurchase(
417         address indexed customerAddress,
418         uint256 incomingValue,
419         uint256 tokensMinted,
420         address ref1,
421         address ref2,
422         address ref3,
423         uint256 ref1value,
424         uint256 ref2value,
425         uint256 ref3value,
426         uint256 timestamp
427     );
428 
429     event OnReinvestment(
430         address indexed customerAddress,
431         uint256 valueReinvested,
432         uint256 tokensMinted,
433         bool isRemote,
434         uint256 timestamp
435     );
436 
437     event OnWithdraw(
438         address indexed customerAddress,
439         uint256 value,
440         uint256 timestamp
441     );
442 
443     event OnGotRepay(
444         address indexed customerAddress,
445         uint256 value,
446         uint256 timestamp
447     );
448 
449     event OnRepayPassed(
450         address indexed customerAddress,
451         address indexed payer,
452         uint256 value,
453         string comment,
454         uint256 timestamp
455     );
456 
457     event OnInterestPassed(
458         address indexed customerAddress,
459         uint256 value,
460         uint256 valueRate,
461         uint256 rate,
462         string comment,
463         uint256 timestamp
464     );
465 
466     event OnSaleStop(
467         uint256 timestamp
468     );
469 
470     event OnSaleStart(
471         uint256 timestamp
472     );
473 
474     event OnRepayAddressAdded(
475         address indexed payer,
476         uint256 value,
477         string comment,
478         uint256 timestamp
479     );
480 
481     event OnRepayAddressRemoved(
482         address indexed payer,
483         uint256 timestamp
484     );
485 
486     event OnMint(
487         address indexed customerAddress,
488         uint256 value,
489         uint256 timestamp
490     );
491 
492     event OnBoss3Deposed(
493         address indexed former,
494         address indexed current,
495         uint256 timestamp
496     );
497 
498     event OnRefBonusSet(
499         uint8 level1,
500         uint8 level2,
501         uint8 level3,
502         uint256 minimalInvestment,
503         uint256 stakingRequirement,
504         uint256 timestamp
505     );
506 
507     event OnRefBaseSet(
508         address indexed former,
509         address indexed current,
510         uint256 timestamp
511     );
512 
513     event OnSeize(
514         address indexed customerAddress,
515         address indexed receiver,
516         uint256 tokens,
517         uint256 value,
518         uint256 repayValue,
519         uint256 timestamp
520     );
521 
522     event OnFund(
523         address indexed source,
524         uint256 value,
525         uint256 timestamp
526     );
527 
528     event OnBurn (
529         address holder,
530         uint256 value,
531         uint256 timestamp
532     );
533 
534     event OnShift (
535         address holder,
536         address recipient,
537         uint256 value,
538         uint256 timestamp
539     );
540 
541     event OnNameSet (
542         string oldName,
543         string oldSymbol,
544         string newName,
545         string newSymbol,
546         uint256 timestamp
547     );
548 
549     event OnTokenSet (
550         address oldToken,
551         address newToken,
552         uint256 timestamp
553     );
554 
555     event Transfer (
556         address indexed from,
557         address indexed to,
558         uint256 value
559     );
560 }