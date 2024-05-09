1 pragma solidity ^0.4.21;
2 
3 /// @title Ownable contract
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function div(uint256 a, uint256 b) internal constant returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28 }
29 
30 /// @title Ownable contract
31 contract Ownable {
32     
33     address public owner;
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     function Ownable() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     /// @dev Change ownership
46     /// @param newOwner Address of the new owner
47     function transferOwnership(address newOwner) onlyOwner public {
48         require(newOwner != address(0));
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51     }
52 
53 }
54 
55 /// @title RateSetter contract
56 contract RateSetter {
57   
58     address public rateSetter;
59     event RateSetterChanged(address indexed previousRateSetter, address indexed newRateSetter);
60 
61     function RateSetter() public {
62         rateSetter = msg.sender;
63     }
64 
65     modifier onlyRateSetter() {
66         require(msg.sender == rateSetter);
67         _;
68     }
69 
70     function changeRateSetter(address newRateSetter) onlyRateSetter public {
71         require(newRateSetter != address(0));
72         emit RateSetterChanged(rateSetter, newRateSetter);
73         rateSetter = newRateSetter;
74     }
75 
76 }
77 
78 /// @title ERC20 contract
79 /// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
80 contract ERC20 {
81     uint public totalSupply;
82     function balanceOf(address who) public constant returns (uint);
83     function transfer(address to, uint value) public returns (bool);
84     event Transfer(address indexed from, address indexed to, uint value);
85     
86     function allowance(address owner, address spender) public constant returns (uint);
87     function transferFrom(address from, address to, uint value) public returns (bool);
88     function approve(address spender, uint value) public returns (bool);
89     event Approval(address indexed owner, address indexed spender, uint value);
90 }
91 
92 /// @title CCWhitelist contract
93 contract CCWhitelist {
94     function isWhitelisted(address addr) public constant returns (bool);
95 }
96 
97 /// @title Crowdsale contract
98 contract Crowdsale is Ownable, RateSetter {
99     using SafeMath for uint256;
100 
101     /// Token reference
102     ERC20 public token;
103     /// Whitelist reference
104     CCWhitelist public whitelist;
105     /// Presale start time (inclusive)
106     uint256 public startTimeIco;
107     /// ICO end time (inclusive)
108     uint256 public endTimeIco;
109     /// Address where the funds will be collected
110     address public wallet;
111     /// EUR per 1 ETH rate
112     uint32 public ethEurRate;
113     /// ETH per 1 BTC rate (multiplied by 100)
114     uint32 public btcEthRate;
115     /// Amount of tokens sold in presale
116     uint256 public tokensSoldPre;
117     /// Amount of tokens sold in ICO
118     uint256 public tokensSoldIco;
119     /// Amount of raised ethers expressed in weis
120     uint256 public weiRaised;
121     /// Amount of raised EUR
122     uint256 public eurRaised;
123     /// Number of contributions
124     uint256 public contributions;
125 
126     /// ICO time phases
127     uint256 public icoPhase1Start;
128     uint256 public icoPhase1End;
129     uint256 public icoPhase2Start;
130     uint256 public icoPhase2End;
131     uint256 public icoPhase3Start;
132     uint256 public icoPhase3End;
133     uint256 public icoPhase4Start;
134     uint256 public icoPhase4End;
135   
136 
137     /// Discount percentages in each phase
138     uint8 public icoPhaseDiscountPercentage1;
139     uint8 public icoPhaseDiscountPercentage2;
140     uint8 public icoPhaseDiscountPercentage3;
141     uint8 public icoPhaseDiscountPercentage4;
142 
143     /// Hard cap in EUR
144     uint32 public HARD_CAP_EUR = 19170000; // 19 170 000 EUR
145     /// Soft cap in EUR
146     uint32 public SOFT_CAP_EUR = 2000000; // 2 000 000 EUR
147     /// Hard cap in tokens
148     uint256 public HARD_CAP_IN_TOKENS = 810 * 10**24; //810m CC tokens
149 
150     /// Mapping for contributors - to limit max contribution and possibly to extract info for refund if soft cap is not reached
151     mapping (address => uint) public contributors;
152 
153     function Crowdsale(uint256 _startTimeIco, uint256 _endTimeIco, uint32 _ethEurRate, uint32 _btcEthRate, address _wallet, address _tokenAddress, address _whitelistAddress, uint256 _tokensSoldPre, uint256 _contributions, uint256 _weiRaised, uint256 _eurRaised, uint256 _tokensSoldIco) public {
154         require(_endTimeIco >= _startTimeIco);
155         require(_ethEurRate > 0 && _btcEthRate > 0);
156         require(_wallet != address(0));
157         require(_tokenAddress != address(0));
158         require(_whitelistAddress != address(0));
159         require(_tokensSoldPre > 0);
160 
161         startTimeIco = _startTimeIco;
162         endTimeIco = _endTimeIco;
163         ethEurRate = _ethEurRate;
164         btcEthRate = _btcEthRate;
165         wallet = _wallet;
166         token = ERC20(_tokenAddress);
167         whitelist = CCWhitelist(_whitelistAddress);
168         tokensSoldPre = _tokensSoldPre;
169         contributions = _contributions;
170         weiRaised = _weiRaised;
171         eurRaised = _eurRaised;
172         tokensSoldIco = _tokensSoldIco;
173         // set time phases
174         icoPhase1Start = 1520208000;
175         icoPhase1End = 1520812799;
176         icoPhase2Start = 1520812800;
177         icoPhase2End = 1526255999;
178         icoPhase3Start = 1526256000;
179         icoPhase3End = 1527465599;
180         icoPhase4Start = 1527465600;
181         icoPhase4End = 1528113600;
182         icoPhaseDiscountPercentage1 = 40; // 40% discount
183         icoPhaseDiscountPercentage2 = 30; // 30% discount
184         icoPhaseDiscountPercentage3 = 20; // 20% discount
185         icoPhaseDiscountPercentage4 = 0;  // 0% discount
186     }
187 
188 
189     /// @dev Sets the rates in crowdsale
190     /// @param _ethEurRate ETH to EUR rate
191     /// @param _btcEthRate BTC to ETH rate 
192     function setRates(uint32 _ethEurRate, uint32 _btcEthRate) public onlyRateSetter {
193         require(_ethEurRate > 0 && _btcEthRate > 0);
194         ethEurRate = _ethEurRate;
195         btcEthRate = _btcEthRate;
196         emit RatesChanged(rateSetter, ethEurRate, btcEthRate);
197     }
198 
199 
200     /// @dev Sets the ICO start and end time
201     /// @param _start Start time
202     /// @param _end End time 
203     function setICOtime(uint256 _start, uint256 _end) external onlyOwner {
204         require(_start < _end);
205         startTimeIco = _start;
206         endTimeIco = _end;
207         emit ChangeIcoPhase(0, _start, _end);
208     }
209 
210 
211     /// @dev Sets the ICO phase 1 duration
212     /// @param _start Start time
213     /// @param _end End time 
214     function setIcoPhase1(uint256 _start, uint256 _end) external onlyOwner {
215         require(_start < _end);
216         icoPhase1Start = _start;
217         icoPhase1End = _end;
218         emit ChangeIcoPhase(1, _start, _end);
219     }
220 
221     /// @dev Sets the ICO phase 2 duration
222     /// @param _start Start time
223     /// @param _end End time 
224     function setIcoPhase2(uint256 _start, uint256 _end) external onlyOwner {
225         require(_start < _end);
226         icoPhase2Start = _start;
227         icoPhase2End = _end;
228         emit ChangeIcoPhase(2, _start, _end);
229     }
230 
231       /// @dev Sets the ICO phase 3 duration
232       /// @param _start Start time
233       /// @param _end End time  
234     function setIcoPhase3(uint256 _start, uint256 _end) external onlyOwner {
235         require(_start < _end);
236         icoPhase3Start = _start;
237         icoPhase3End = _end;
238         emit ChangeIcoPhase(3, _start, _end);
239     }
240 
241     /// @dev Sets the ICO phase 4 duration
242     /// @param _start Start time
243     /// @param _end End time 
244     function setIcoPhase4(uint256 _start, uint256 _end) external onlyOwner {
245         require(_start < _end);
246         icoPhase4Start = _start;
247         icoPhase4End = _end;
248         emit ChangeIcoPhase(4, _start, _end);
249     }
250 
251     function setIcoDiscountPercentages(uint8 _icoPhaseDiscountPercentage1, uint8 _icoPhaseDiscountPercentage2, uint8 _icoPhaseDiscountPercentage3, uint8 _icoPhaseDiscountPercentage4) external onlyOwner {
252         icoPhaseDiscountPercentage1 = _icoPhaseDiscountPercentage1;
253         icoPhaseDiscountPercentage2 = _icoPhaseDiscountPercentage2;
254         icoPhaseDiscountPercentage3 = _icoPhaseDiscountPercentage3;
255         icoPhaseDiscountPercentage4 = _icoPhaseDiscountPercentage4;
256         emit DiscountPercentagesChanged(_icoPhaseDiscountPercentage1, _icoPhaseDiscountPercentage2, _icoPhaseDiscountPercentage3, _icoPhaseDiscountPercentage4);
257 
258     }
259 
260     /// @dev Fallback function for crowdsale contribution
261     function () public payable {
262         buyTokens(msg.sender);
263     }
264 
265     /// @dev Buy tokens function
266     /// @param beneficiary Address which will receive the tokens
267     function buyTokens(address beneficiary) public payable {
268         require(beneficiary != address(0));
269         require(whitelist.isWhitelisted(beneficiary));
270         uint256 weiAmount = msg.value;
271         require(weiAmount > 0);
272         require(contributors[beneficiary].add(weiAmount) <= 200 ether);
273         uint256 tokenAmount = 0;
274         if (isIco()) {
275             uint8 discountPercentage = getIcoDiscountPercentage();
276             tokenAmount = getTokenAmount(weiAmount, discountPercentage);
277             /// Minimum contribution 1 token during ICO
278             require(tokenAmount >= 10**18); 
279             uint256 newTokensSoldIco = tokensSoldIco.add(tokenAmount); 
280             require(newTokensSoldIco <= HARD_CAP_IN_TOKENS);
281             tokensSoldIco = newTokensSoldIco;
282         } else {
283             /// Stop execution and return remaining gas
284             require(false);
285         }
286         executeTransaction(beneficiary, weiAmount, tokenAmount);
287     }
288 
289     /// @dev Internal function used for calculating ICO discount percentage depending on phases
290     function getIcoDiscountPercentage() internal constant returns (uint8) {
291         if (icoPhase1Start >= now && now < icoPhase1End) {
292             return icoPhaseDiscountPercentage1;
293         }
294         else if (icoPhase2Start >= now && now < icoPhase2End) {
295             return icoPhaseDiscountPercentage2;
296         } else if (icoPhase3Start >= now && now < icoPhase3End) {
297             return icoPhaseDiscountPercentage3;
298         } else {
299             return icoPhaseDiscountPercentage4;
300         }
301     }
302 
303     /// @dev Internal function used to calculate amount of tokens based on discount percentage
304     function getTokenAmount(uint256 weiAmount, uint8 discountPercentage) internal constant returns (uint256) {
305         /// Less than 100 to avoid division with zero
306         require(discountPercentage >= 0 && discountPercentage < 100); 
307         uint256 baseTokenAmount = weiAmount.mul(ethEurRate);
308         uint256 denominator = 3 * (100 - discountPercentage);
309         uint256 tokenAmount = baseTokenAmount.mul(10000).div(denominator);
310         return tokenAmount;
311     }
312 
313    
314     /// point out that it works for the last block
315     /// @dev This method is used to get the current amount user can receive for 1ETH -- Used by frontend for easier calculation
316     /// @return Amount of CC tokens
317     function getCurrentTokenAmountForOneEth() public constant returns (uint256) {
318         if (isIco()) {
319             uint8 discountPercentage = getIcoDiscountPercentage();
320             return getTokenAmount(1 ether, discountPercentage);
321         } 
322         return 0;
323     }
324   
325     /// @dev This method is used to get the current amount user can receive for 1BTC -- Used by frontend for easier calculation
326     /// @return Amount of CC tokens
327     function getCurrentTokenAmountForOneBtc() public constant returns (uint256) {
328         uint256 amountForOneEth = getCurrentTokenAmountForOneEth();
329         return amountForOneEth.mul(btcEthRate).div(100);
330     }
331 
332     /// @dev Internal function for execution of crowdsale transaction and proper logging used by payable functions
333     function executeTransaction(address beneficiary, uint256 weiAmount, uint256 tokenAmount) internal {
334         weiRaised = weiRaised.add(weiAmount);
335         uint256 eurAmount = weiAmount.mul(ethEurRate).div(10**18);
336         eurRaised = eurRaised.add(eurAmount);
337         token.transfer(beneficiary, tokenAmount);
338         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
339         contributions = contributions.add(1);
340         contributors[beneficiary] = contributors[beneficiary].add(weiAmount);
341         wallet.transfer(weiAmount);
342     }
343 
344     /// @dev Check if ICO is active
345     function isIco() public constant returns (bool) {
346         return now >= startTimeIco && now <= endTimeIco;
347     }
348 
349     /// @dev Check if ICO has ended
350     function hasIcoEnded() public constant returns (bool) {
351         return now > endTimeIco;
352     }
353 
354     /// @dev Amount of tokens that have been sold during both presale and ICO phase
355     function cummulativeTokensSold() public constant returns (uint256) {
356         return tokensSoldPre + tokensSoldIco;
357     }
358 
359     /// @dev Function to extract mistakenly sent ERC20 tokens sent to Crowdsale contract and to extract unsold CC tokens
360     /// @param _token Address of token we want to extract
361     function claimTokens(address _token) public onlyOwner {
362         if (_token == address(0)) { 
363             owner.transfer(this.balance);
364             return;
365         }
366 
367         ERC20 erc20Token = ERC20(_token);
368         uint balance = erc20Token.balanceOf(this);
369         erc20Token.transfer(owner, balance);
370         emit ClaimedTokens(_token, owner, balance);
371     }
372 
373     /// Events
374     event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount);
375     event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
376     event IcoPhaseAmountsChanged(uint256 _icoPhaseAmount1, uint256 _icoPhaseAmount2, uint256 _icoPhaseAmount3, uint256 _icoPhaseAmount4);
377     event RatesChanged(address indexed _rateSetter, uint32 _ethEurRate, uint32 _btcEthRate);
378     event DiscountPercentagesChanged(uint8 _icoPhaseDiscountPercentage1, uint8 _icoPhaseDiscountPercentage2, uint8 _icoPhaseDiscountPercentage3, uint8 _icoPhaseDiscountPercentage4);
379     /// 0 is for changing start and end time of ICO
380     event ChangeIcoPhase(uint8 _phase, uint256 _start, uint256 _end);
381 
382 }
383 
384 /// @title CulturalCoinCrowdsale contract
385 contract CulturalCoinCrowdsale is Crowdsale {
386 
387     function CulturalCoinCrowdsale(uint256 _startTimeIco, uint256 _endTimeIco, uint32 _ethEurRate, uint32 _btcEthRate, address _wallet, address _tokenAddress, address _whitelistAddress, uint256 _tokensSoldPre, uint256 _contributions, uint256 _weiRaised, uint256 _eurRaised, uint256 _tokensSoldIco) 
388     Crowdsale(_startTimeIco, _endTimeIco, _ethEurRate, _btcEthRate, _wallet, _tokenAddress, _whitelistAddress, _tokensSoldPre, _contributions, _weiRaised, _eurRaised, _tokensSoldIco) public {
389 
390     }
391 
392 }