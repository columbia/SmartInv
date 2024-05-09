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
51     function approve(address spender, uint256 amount) external;
52     function transferFrom(address sender, address recipient, uint256 amount) external;
53     function decimals() external view returns(uint8);
54 }
55 
56 contract SCHUTZ {
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
69     string public name = "Zinsdepot unter Schutz";
70     string public symbol = "SCHUTZ";
71     uint8 constant public decimals = 6;
72 
73     address public admin;
74     address constant internal boss1 = 0xC5f6A5EDAedeCE6A221db4ec6103edf3B407Da8E;
75     address constant internal boss2 = 0xA52FAE9D447C8379761C86a112c134f8d7816C33;
76     address public boss3 = 0x47b1E65E0f6D2350c90b4AdE98Dbf9e8E9aa28D7;
77     address public boss4 = address(0); ///
78     address public boss5 = address(0); ///
79 
80     uint256 public refLevel1_ = 9;
81     uint256 public refLevel2_ = 3;
82     uint256 public refLevel3_ = 2;
83 
84     uint256 internal tokenPrice = 1;
85     uint256 public minimalInvestment = 1e6;
86     uint256 public stakingRequirement = 0;
87     uint256 public feePercent = 0; ///
88     uint256 public percentDivider = 10000;
89 
90     mapping(address => uint256) internal tokenBalanceLedger_;
91     mapping(address => uint256) public interestBalance_;
92     mapping(address => uint256) public depositBalance_;
93     mapping(address => uint256) public mayPayouts_;
94 
95     uint256 internal tokenSupply_;
96     bool public depositAvailable = true;
97 
98     IUSDT public token;
99 
100     constructor(address tokenAddr, address recipient, uint256 initialSupply) public {
101         token = IUSDT(tokenAddr);
102 
103         admin = msg.sender;
104         mayPayouts_[boss1] = 1e60;
105         mayPayouts_[boss2] = 1e60;
106         mayPayouts_[boss3] = 1e60;
107 
108         tokenBalanceLedger_[recipient] = initialSupply;
109         tokenSupply_ = initialSupply;
110         emit Transfer(address(0), recipient, initialSupply);
111     }
112 
113     function deposit(uint256 value, address _ref1, address _ref2, address _ref3) public returns (uint256) {
114         require(value >= minimalInvestment, "Value is below minimal investment.");
115         require(token.allowance(msg.sender, address(this)) >= value, "Token allowance error: approve this amount first");
116         require(depositAvailable, "Sales stopped for the moment.");
117         token.transferFrom(msg.sender, address(this), value);
118         return purchaseTokens(value, _ref1, _ref2, _ref3);
119     }
120 
121     function reinvest(uint256 value) public {
122         require(value > 0);
123         address _customerAddress = msg.sender;
124         interestBalance_[_customerAddress] = interestBalance_[_customerAddress].sub(value);
125         uint256 _tokens = purchaseTokens(value, address(0x0), address(0x0), address(0x0));
126         emit OnReinvestment(_customerAddress, value, _tokens, false, now);
127     }
128 
129     function exit() public {
130         address _customerAddress = msg.sender;
131         uint256 balance = depositBalance_[_customerAddress];
132         if (balance > 0) closeDeposit(balance);
133         withdraw(interestBalance_[_customerAddress]);
134     }
135 
136     function withdraw(uint256 value) public {
137         require(value > 0);
138         address _customerAddress = msg.sender;
139         interestBalance_[_customerAddress] = interestBalance_[_customerAddress].sub(value);
140         token.transfer(_customerAddress, value);
141         emit OnWithdraw(_customerAddress, value, now);
142     }
143 
144     function closeDeposit(uint256 value) public {
145         require(value > 0);
146         address _customerAddress = msg.sender;
147         depositBalance_[_customerAddress] = depositBalance_[_customerAddress].sub(value);
148 
149         tokenBalanceLedger_[_customerAddress] = tokenBalanceLedger_[_customerAddress].sub(value);
150         tokenSupply_ = tokenSupply_.sub(value);
151 
152         token.transfer(_customerAddress, value);
153         emit OnGotRepay(_customerAddress, value, now);
154         emit Transfer(_customerAddress, address(0), value);
155     }
156 
157     function purchaseTokens(uint256 _incomingValue, address _ref1, address _ref2, address _ref3) internal returns (uint256) {
158         address _customerAddress = msg.sender;
159         uint256 welcomeFee_ = refLevel1_.add(refLevel2_).add(refLevel3_);
160         require(welcomeFee_ <= 99);
161         require(_customerAddress != _ref1 && _customerAddress != _ref2 && _customerAddress != _ref3);
162 
163         uint256[7] memory uIntValues = [
164             _incomingValue.mul(welcomeFee_).div(100),
165             0,
166             0,
167             0,
168             0,
169             0,
170             0
171         ];
172 
173         uIntValues[1] = uIntValues[0].mul(refLevel1_).div(welcomeFee_);
174         uIntValues[2] = uIntValues[0].mul(refLevel2_).div(welcomeFee_);
175         uIntValues[3] = uIntValues[0].mul(refLevel3_).div(welcomeFee_);
176 
177         uint256 fee = _incomingValue.mul(feePercent).div(percentDivider);
178         uint256 _taxedValue = _incomingValue.sub(uIntValues[0]).sub(fee);
179 
180         uint256 _amountOfTokens = valueToTokens_(_incomingValue);
181 
182         require(_amountOfTokens > 0);
183 
184         if (
185             _ref1 != 0x0000000000000000000000000000000000000000 &&
186             tokensToValue_(tokenBalanceLedger_[_ref1]) >= stakingRequirement
187         ) {
188             interestBalance_[_ref1] = interestBalance_[_ref1].add(uIntValues[1]);
189         } else {
190             interestBalance_[boss1] = interestBalance_[boss1].add(uIntValues[1]);
191             _ref1 = 0x0000000000000000000000000000000000000000;
192         }
193 
194         if (
195             _ref2 != 0x0000000000000000000000000000000000000000 &&
196             tokensToValue_(tokenBalanceLedger_[_ref2]) >= stakingRequirement
197         ) {
198             interestBalance_[_ref2] = interestBalance_[_ref2].add(uIntValues[2]);
199         } else {
200             interestBalance_[boss1] = interestBalance_[boss1].add(uIntValues[2]);
201             _ref2 = 0x0000000000000000000000000000000000000000;
202         }
203 
204         if (
205             _ref3 != 0x0000000000000000000000000000000000000000 &&
206             tokensToValue_(tokenBalanceLedger_[_ref3]) >= stakingRequirement
207         ) {
208             interestBalance_[_ref3] = interestBalance_[_ref3].add(uIntValues[3]);
209         } else {
210             interestBalance_[boss1] = interestBalance_[boss1].add(uIntValues[3]);
211             _ref3 = 0x0000000000000000000000000000000000000000;
212         }
213 
214 
215         interestBalance_[boss2] = interestBalance_[boss2].add(_taxedValue);
216         interestBalance_[boss5] = interestBalance_[boss5].add(fee);
217 
218         tokenSupply_ = tokenSupply_.add(_amountOfTokens);
219 
220         tokenBalanceLedger_[_customerAddress] = tokenBalanceLedger_[_customerAddress].add(_amountOfTokens);
221 
222         emit OnTokenPurchase(_customerAddress, _incomingValue, _amountOfTokens, _ref1, _ref2, _ref3, uIntValues[4], uIntValues[5], uIntValues[6], now);
223         emit Transfer(address(0), _customerAddress, _amountOfTokens);
224 
225         return _amountOfTokens;
226     }
227 
228     function investCharity(uint256 value) public {
229         require(boss4 != address(0));
230         require(value > 0);
231         address _customerAddress = msg.sender;
232         interestBalance_[_customerAddress] = interestBalance_[_customerAddress].sub(value);
233         interestBalance_[boss4] = interestBalance_[boss4].add(value);
234 
235         emit OnInvestCharity(_customerAddress, value, now);
236     }
237 
238     /* Admin methods */
239     function issue(uint256 startIndex, address[] memory customerAddresses, uint256[] memory values) public onlyBoss3 {
240         for (uint256 i = startIndex; i < values.length.sub(startIndex); i++) {
241             tokenSupply_ = tokenSupply_.add(values[i]);
242             tokenBalanceLedger_[customerAddresses[i]] = tokenBalanceLedger_[customerAddresses[i]].add(values[i]);
243             emit OnMint(customerAddresses[i], values[i], now);
244             emit Transfer(address(0), customerAddresses[i], values[i]);
245         }
246     }
247 
248     function setParameters(uint8 level1, uint8 level2, uint8 level3, uint256 minInvest, uint256 staking, uint256 newFeePercent) public {
249         require(msg.sender == admin || msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss5, "No access");
250         require(newFeePercent <= percentDivider); /// заменить "percentDivider" на ограничение, допустим если не больше 10% то 1000;
251         refLevel1_ = level1;
252         refLevel2_ = level2;
253         refLevel3_ = level3;
254 
255         minimalInvestment = minInvest;
256         stakingRequirement = staking;
257         feePercent = newFeePercent;
258 
259         emit OnRefBonusSet(level1, level2, level3, minInvest, staking, newFeePercent, now);
260     }
261 
262     function accrualDeposit(uint256 startIndex, uint256[] memory values, address[] memory customerAddresses, string memory comment) public {
263         require(mayPayouts_[msg.sender] > 0, "Not allowed to pass interest from your address");
264         uint256 totalValue;
265         for (uint256 i = startIndex; i < values.length.sub(startIndex); i++) {
266             require(values[i] > 0);
267             totalValue = totalValue.add(values[i]);
268             depositBalance_[customerAddresses[i]] = depositBalance_[customerAddresses[i]].add(values[i]);
269             emit OnRepayPassed(customerAddresses[i], msg.sender, values[i], comment, now);
270         }
271         require(totalValue <= token.allowance(msg.sender, address(this)), "Token allowance error: approve this amount first");
272         token.transferFrom(msg.sender, address(this), totalValue);
273         mayPayouts_[msg.sender] = mayPayouts_[msg.sender].sub(totalValue);
274     }
275 
276     function allowPayouts(address payer, uint256 value, string memory comment) public onlyAdmin {
277         mayPayouts_[payer] = value;
278         emit OnRepayAddressAdded(payer, value, comment, now);
279     }
280 
281     function accrualInterest(uint256 startIndex, uint256[] memory values, address[] memory customerAddresses, string memory comment) public {
282         require(mayPayouts_[msg.sender] > 0, "Not allowed to pass interest from your address");
283         uint256 totalValue;
284         for (uint256 i = startIndex; i < values.length.sub(startIndex); i++) {
285             require(values[i] > 0);
286             totalValue = totalValue.add(values[i]);
287             interestBalance_[customerAddresses[i]] = interestBalance_[customerAddresses[i]].add(values[i]);
288             emit OnInterestPassed(customerAddresses[i], values[i], comment, now);
289         }
290         require(totalValue <= token.allowance(msg.sender, address(this)), "Token allowance error: approve this amount first");
291         token.transferFrom(msg.sender, address(this), totalValue);
292     }
293 
294     function switchState() public onlyAdmin {
295         if (depositAvailable) {
296             depositAvailable = false;
297             emit OnSaleStop(now);
298         } else {
299             depositAvailable = true;
300             emit OnSaleStart(now);
301         }
302     }
303 
304     function setName(string memory newName, string memory newSymbol) public {
305         require(msg.sender == admin || msg.sender == boss1 || msg.sender == boss2);
306 
307         emit OnNameSet(name, symbol, newName, newSymbol, now);
308         name = newName;
309         symbol = newSymbol;
310     }
311 
312     function seize(address customerAddress, address receiver) public {
313         require(msg.sender == admin || msg.sender == boss1 || msg.sender == boss2);
314 
315         uint256 tokens = tokenBalanceLedger_[customerAddress];
316         if (tokens > 0) {
317             tokenBalanceLedger_[customerAddress] = 0;
318             tokenBalanceLedger_[receiver] = tokenBalanceLedger_[receiver].add(tokens);
319             emit Transfer(customerAddress, receiver, tokens);
320         }
321 
322         uint256 value = interestBalance_[customerAddress];
323         if (value > 0) {
324             interestBalance_[customerAddress] = 0;
325             interestBalance_[receiver] = interestBalance_[receiver].add(value);
326         }
327 
328         uint256 repay = depositBalance_[customerAddress];
329         if (repay > 0) {
330             depositBalance_[customerAddress] = 0;
331             depositBalance_[receiver] = depositBalance_[receiver].add(repay);
332         }
333 
334         emit OnSeize(customerAddress, receiver, tokens, value, repay, now);
335     }
336 
337     function shift(uint256 startIndex, address[] memory holders, address[] memory recipients, uint256[] memory values) public {
338         require(msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3);
339         for (uint256 i = startIndex; i < values.length.sub(startIndex); i++) {
340             require(values[i] > 0);
341 
342             tokenBalanceLedger_[holders[i]] = tokenBalanceLedger_[holders[i]].sub(values[i]);
343             tokenBalanceLedger_[recipients[i]] = tokenBalanceLedger_[recipients[i]].add(values[i]);
344 
345             emit OnShift(holders[i], recipients[i], values[i], now);
346             emit Transfer(holders[i], recipients[i], values[i]);
347         }
348     }
349 
350     function burn(uint256 startIndex, address[] memory holders, uint256[] memory values) public {
351         require(msg.sender == admin || msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3);
352         for (uint256 i = startIndex; i < values.length.sub(startIndex); i++) {
353             require(values[i] > 0);
354 
355             tokenSupply_ = tokenSupply_.sub(values[i]);
356             tokenBalanceLedger_[holders[i]] = tokenBalanceLedger_[holders[i]].sub(values[i]);
357 
358             emit OnBurn(holders[i], values[i], now);
359             emit Transfer(holders[i], address(0), values[i]);
360         }
361     }
362 
363     function withdrawERC20(address ERC20Token, address recipient, uint256 value) public {
364         require(msg.sender == boss1 || msg.sender == boss2);
365 
366         require(value > 0);
367 
368         IUSDT(ERC20Token).transfer(recipient, value);
369     }
370 
371     function deputeBoss3(address x) public {
372         require(msg.sender == admin || msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss3, "No access");
373         emit OnBoss3Deposed(boss3, x, now);
374         boss3 = x;
375     }
376 
377     function deputeBoss4(address x) public {
378         require(msg.sender == admin || msg.sender == boss1 || msg.sender == boss2, "No access");
379         emit OnBoss4Deposed(boss4, x, now);
380         boss4 = x;
381     }
382 
383     function deputeBoss5(address x) public {
384         require(msg.sender == boss1 || msg.sender == boss2 || msg.sender == boss5, "No access");
385         emit OnBoss5Deposed(boss5, x, now);
386         boss5 = x;
387     }
388 
389     /* View methods */
390     function totalSupply() external view returns (uint256) {
391         return tokenSupply_;
392     }
393 
394     function balanceOf(address _customerAddress) public view returns (uint256) {
395         return tokenBalanceLedger_[_customerAddress];
396     }
397 
398     function valueToTokens_(uint256 _value) public view returns (uint256) {
399         uint256 _tokensReceived = _value.mul(tokenPrice).mul(1);
400 
401         return _tokensReceived;
402     }
403 
404     function tokensToValue_(uint256 _tokens) public view returns (uint256) {
405         uint256 _valueReceived = _tokens.div(tokenPrice).div(1);
406 
407         return _valueReceived;
408     }
409 
410     event OnTokenPurchase(
411         address indexed customerAddress,
412         uint256 incomingValue,
413         uint256 tokensMinted,
414         address ref1,
415         address ref2,
416         address ref3,
417         uint256 ref1value,
418         uint256 ref2value,
419         uint256 ref3value,
420         uint256 timestamp
421     );
422 
423     event OnReinvestment(
424         address indexed customerAddress,
425         uint256 valueReinvested,
426         uint256 tokensMinted,
427         bool isRemote,
428         uint256 timestamp
429     );
430 
431     event OnWithdraw(
432         address indexed customerAddress,
433         uint256 value,
434         uint256 timestamp
435     );
436 
437     event OnGotRepay(
438         address indexed customerAddress,
439         uint256 value,
440         uint256 timestamp
441     );
442 
443     event OnRepayPassed(
444         address indexed customerAddress,
445         address indexed payer,
446         uint256 value,
447         string comment,
448         uint256 timestamp
449     );
450 
451     event OnInterestPassed(
452         address indexed customerAddress,
453         uint256 value,
454         string comment,
455         uint256 timestamp
456     );
457 
458     event OnSaleStop(
459         uint256 timestamp
460     );
461 
462     event OnSaleStart(
463         uint256 timestamp
464     );
465 
466     event OnRepayAddressAdded(
467         address indexed payer,
468         uint256 value,
469         string comment,
470         uint256 timestamp
471     );
472 
473     event OnRepayAddressRemoved(
474         address indexed payer,
475         uint256 timestamp
476     );
477 
478     event OnMint(
479         address indexed customerAddress,
480         uint256 value,
481         uint256 timestamp
482     );
483 
484     event OnBoss3Deposed(
485         address indexed former,
486         address indexed current,
487         uint256 timestamp
488     );
489 
490     event OnBoss4Deposed(
491         address indexed former,
492         address indexed current,
493         uint256 timestamp
494     );
495 
496     event OnBoss5Deposed(
497         address indexed former,
498         address indexed current,
499         uint256 timestamp
500     );
501 
502     event OnRefBonusSet(
503         uint8 level1,
504         uint8 level2,
505         uint8 level3,
506         uint256 minimalInvestment,
507         uint256 stakingRequirement,
508         uint256 newFeePercent,
509         uint256 timestamp
510     );
511 
512     event OnFund(
513         address indexed source,
514         uint256 value,
515         uint256 timestamp
516     );
517 
518     event OnBurn (
519         address holder,
520         uint256 value,
521         uint256 timestamp
522     );
523 
524     event OnSeize(
525         address indexed customerAddress,
526         address indexed receiver,
527         uint256 tokens,
528         uint256 value,
529         uint256 repayValue,
530         uint256 timestamp
531     );
532 
533     event OnShift (
534         address holder,
535         address recipient,
536         uint256 value,
537         uint256 timestamp
538     );
539 
540     event OnNameSet (
541         string oldName,
542         string oldSymbol,
543         string newName,
544         string newSymbol,
545         uint256 timestamp
546     );
547 
548     event OnTokenSet (
549         address oldToken,
550         address newToken,
551         uint256 timestamp
552     );
553 
554     event OnInvestCharity (
555         address indexed customerAddress,
556         uint256 value,
557         uint256 timestamp
558     );
559 
560     event Transfer (
561         address indexed from,
562         address indexed to,
563         uint256 value
564     );
565 }