1 pragma solidity ^0.4.18;
2 
3 /// @title Ownable contract
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28 }
29 
30 /// @title Ownable contract
31 contract Ownable {
32   
33   address public owner;
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   /// @dev Change ownership
46   /// @param newOwner Address of the new owner
47   function transferOwnership(address newOwner) onlyOwner public {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 /// @title RateSetter contract
56 contract RateSetter {
57   
58   address public rateSetter;
59   event RateSetterChanged(address indexed previousRateSetter, address indexed newRateSetter);
60 
61   function RateSetter() public {
62     rateSetter = msg.sender;
63   }
64 
65   modifier onlyRateSetter() {
66     require(msg.sender == rateSetter);
67     _;
68   }
69 
70   function changeRateSetter(address newRateSetter) onlyRateSetter public {
71     require(newRateSetter != address(0));
72     RateSetterChanged(rateSetter, newRateSetter);
73     rateSetter = newRateSetter;
74   }
75 
76 }
77 
78 /// @title ERC20 contract
79 /// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
80 contract ERC20 {
81   uint public totalSupply;
82   function balanceOf(address who) public constant returns (uint);
83   function transfer(address to, uint value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint value);
85   
86   function allowance(address owner, address spender) public constant returns (uint);
87   function transferFrom(address from, address to, uint value) public returns (bool);
88   function approve(address spender, uint value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint value);
90 }
91 
92 /// @title CCWhitelist contract
93 contract CCWhitelist {
94   function isWhitelisted(address addr) public constant returns (bool);
95 }
96 
97 /// @title Crowdsale contract
98 contract Crowdsale is Ownable, RateSetter {
99   using SafeMath for uint256;
100 
101   /// Token reference
102   ERC20 public token;
103   /// Whitelist reference
104   CCWhitelist public whitelist;
105   /// Presale start time (inclusive)
106   uint256 public startTimePre;
107   /// Presale end time (inclusive)
108   uint256 public endTimePre;
109   /// ICO start time (inclusive)
110   uint256 public startTimeIco;
111   /// ICO end time (inclusive)
112   uint256 public endTimeIco;
113   /// Address where the funds will be collected
114   address public wallet;
115   /// EUR per 1 ETH rate
116   uint32 public ethEurRate;
117   /// ETH per 1 BTC rate (multiplied by 100)
118   uint32 public btcEthRate;
119   /// Amount of tokens sold in presale
120   uint256 public tokensSoldPre;
121   /// Amount of tokens sold in ICO
122   uint256 public tokensSoldIco;
123   /// Amount of raised ethers expressed in weis
124   uint256 public weiRaised;
125   /// Amount of raised EUR
126   uint256 public eurRaised;
127   /// Number of contributions
128   uint256 public contributions;
129   /// Presale cap
130   uint256 public preCap;
131   /// Presale discount percentage
132   uint8 public preDiscountPercentage;
133 
134   /// Amount of tokens in each phase
135   uint256 public icoPhaseAmount1;
136   uint256 public icoPhaseAmount2;
137   uint256 public icoPhaseAmount3;
138   uint256 public icoPhaseAmount4;
139 
140   /// Discount percentages in each phase
141   uint8 public icoPhaseDiscountPercentage1;
142   uint8 public icoPhaseDiscountPercentage2;
143   uint8 public icoPhaseDiscountPercentage3;
144   uint8 public icoPhaseDiscountPercentage4;
145 
146   /// Hard cap in EUR
147   uint32 public HARD_CAP_EUR = 19170000; // 19 170 000 EUR
148   /// Soft cap in EUR
149   uint32 public SOFT_CAP_EUR = 2000000; // 2 000 000 EUR
150   /// Hard cap in tokens
151   uint256 public HARD_CAP_IN_TOKENS = 810 * 10**24; //810m CC tokens
152 
153   /// Mapping for contributors - to limit max contribution and possibly to extract info for refund if soft cap is not reached
154   mapping (address => uint) public contributors;
155 
156   function Crowdsale(uint256 _startTimePre, uint256 _endTimePre, uint256 _startTimeIco, uint256 _endTimeIco, uint32 _ethEurRate, uint32 _btcEthRate, address _wallet, address _tokenAddress, address _whitelistAddress) {
157     require(_startTimePre >= now);
158     require(_endTimePre >= _startTimePre);
159     require(_startTimeIco >= _endTimePre);
160     require(_endTimeIco >= _startTimeIco);
161     require(_ethEurRate > 0 && _btcEthRate > 0);
162     require(_wallet != address(0));
163     require(_tokenAddress != address(0));
164     require(_whitelistAddress != address(0));
165 
166     startTimePre = _startTimePre;
167     endTimePre = _endTimePre;
168     startTimeIco = _startTimeIco;
169     endTimeIco = _endTimeIco;
170     ethEurRate = _ethEurRate;
171     btcEthRate = _btcEthRate;
172     wallet = _wallet;
173     token = ERC20(_tokenAddress);
174     whitelist = CCWhitelist(_whitelistAddress);
175     preCap = 90 * 10**24;             // 90m tokens
176     preDiscountPercentage = 50;       // 50% discount
177     icoPhaseAmount1 = 135 * 10**24;   // 135m tokens 
178     icoPhaseAmount2 = 450 * 10**24;   // 450m tokens
179     icoPhaseAmount3 = 135 * 10**24;   // 135m tokens
180     icoPhaseAmount4 = 90 * 10**24;    // 90m tokens
181     icoPhaseDiscountPercentage1 = 40; // 40% discount
182     icoPhaseDiscountPercentage2 = 30; // 30% discount
183     icoPhaseDiscountPercentage3 = 20; // 20% discount
184     icoPhaseDiscountPercentage4 = 0;  // 0% discount
185   }
186 
187 
188   function setRates(uint32 _ethEurRate, uint32 _btcEthRate) public onlyRateSetter {
189     require(_ethEurRate > 0 && _btcEthRate > 0);
190     ethEurRate = _ethEurRate;
191     btcEthRate = _btcEthRate;
192     RatesChanged(rateSetter, ethEurRate, btcEthRate);
193   }
194 
195   /// @dev Fallback function for crowdsale contribution
196   function () payable {
197     buyTokens(msg.sender);
198   }
199 
200   /// @dev Buy tokens function
201   /// @param beneficiary Address which will receive the tokens
202   function buyTokens(address beneficiary) public payable {
203     require(beneficiary != address(0));
204     require(whitelist.isWhitelisted(beneficiary));
205     uint256 weiAmount = msg.value;
206     require(weiAmount > 0);
207     require(contributors[beneficiary].add(weiAmount) <= 200 ether);
208     uint256 tokenAmount = 0;
209     if (isPresale()) {
210       /// Minimum contribution of 1 ether during presale
211       require(weiAmount >= 1 ether); 
212       tokenAmount = getTokenAmount(weiAmount, preDiscountPercentage);
213       uint256 newTokensSoldPre = tokensSoldPre.add(tokenAmount);
214       require(newTokensSoldPre <= preCap);
215       tokensSoldPre = newTokensSoldPre;
216     } else if (isIco()) {
217       uint8 discountPercentage = getIcoDiscountPercentage();
218       tokenAmount = getTokenAmount(weiAmount, discountPercentage);
219       /// Minimum contribution 1 token during ICO
220       require(tokenAmount >= 10**18); 
221       uint256 newTokensSoldIco = tokensSoldIco.add(tokenAmount); 
222       require(newTokensSoldIco <= HARD_CAP_IN_TOKENS);
223       tokensSoldIco = newTokensSoldIco;
224     } else {
225       /// Stop execution and return remaining gas
226       require(false);
227     }
228     executeTransaction(beneficiary, weiAmount, tokenAmount);
229   }
230 
231   /// @dev Internal function used for calculating ICO discount percentage depending on levels
232   function getIcoDiscountPercentage() internal constant returns (uint8) {
233     if (tokensSoldIco <= icoPhaseAmount1) {
234       return icoPhaseDiscountPercentage1;
235     } else if (tokensSoldIco <= icoPhaseAmount1.add(icoPhaseAmount2)) {
236       return icoPhaseDiscountPercentage2;
237     } else if (tokensSoldIco <= icoPhaseAmount1.add(icoPhaseAmount2).add(icoPhaseAmount3)) { 
238       return icoPhaseDiscountPercentage3;
239     } else {
240       return icoPhaseDiscountPercentage4;
241     }
242   }
243 
244   /// @dev Internal function used to calculate amount of tokens based on discount percentage
245   function getTokenAmount(uint256 weiAmount, uint8 discountPercentage) internal constant returns (uint256) {
246     /// Less than 100 to avoid division with zero
247     require(discountPercentage >= 0 && discountPercentage < 100); 
248     uint256 baseTokenAmount = weiAmount.mul(ethEurRate);
249     uint256 denominator = 3 * (100 - discountPercentage);
250     uint256 tokenAmount = baseTokenAmount.mul(10000).div(denominator);
251     return tokenAmount;
252   }
253 
254    
255   /// point out that it works for the last block
256   /// @dev This method is used to get the current amount user can receive for 1ETH -- Used by frontend for easier calculation
257   /// @return Amount of CC tokens
258   function getCurrentTokenAmountForOneEth() public constant returns (uint256) {
259     if (isPresale()) {
260       return getTokenAmount(1 ether, preDiscountPercentage);
261     } else if (isIco()) {
262       uint8 discountPercentage = getIcoDiscountPercentage();
263       return getTokenAmount(1 ether, discountPercentage);
264     } 
265     return 0;
266   }
267   
268   /// @dev This method is used to get the current amount user can receive for 1BTC -- Used by frontend for easier calculation
269   /// @return Amount of CC tokens
270   function getCurrentTokenAmountForOneBtc() public constant returns (uint256) {
271     uint256 amountForOneEth = getCurrentTokenAmountForOneEth();
272     return amountForOneEth.mul(btcEthRate).div(100);
273   }
274 
275   /// @dev Internal function for execution of crowdsale transaction and proper logging used by payable functions
276   function executeTransaction(address beneficiary, uint256 weiAmount, uint256 tokenAmount) internal {
277     weiRaised = weiRaised.add(weiAmount);
278     uint256 eurAmount = weiAmount.mul(ethEurRate).div(10**18);
279     eurRaised = eurRaised.add(eurAmount);
280     token.transfer(beneficiary, tokenAmount);
281     TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
282 	  contributions = contributions.add(1);
283     contributors[beneficiary] = contributors[beneficiary].add(weiAmount);
284     wallet.transfer(weiAmount);
285   }
286 
287   function changeIcoPhaseAmounts(uint256[] icoPhaseAmounts) public onlyOwner {
288     require(icoPhaseAmounts.length == 4);
289     uint256 sum = 0;
290     for (uint i = 0; i < icoPhaseAmounts.length; i++) {
291       sum = sum.add(icoPhaseAmounts[i]);
292     }
293     require(sum == HARD_CAP_IN_TOKENS);
294     icoPhaseAmount1 = icoPhaseAmounts[0];
295     icoPhaseAmount2 = icoPhaseAmounts[1];
296     icoPhaseAmount3 = icoPhaseAmounts[2];
297     icoPhaseAmount4 = icoPhaseAmounts[3];
298     IcoPhaseAmountsChanged(icoPhaseAmount1, icoPhaseAmount2, icoPhaseAmount3, icoPhaseAmount4);
299   }
300 
301   /// @dev Check if presale is active
302   function isPresale() public constant returns (bool) {
303     return now >= startTimePre && now <= endTimePre;
304   }
305 
306   /// @dev Check if ICO is active
307   function isIco() public constant returns (bool) {
308     return now >= startTimeIco && now <= endTimeIco;
309   }
310 
311   /// @dev Check if presale has ended
312   function hasPresaleEnded() public constant returns (bool) {
313     return now > endTimePre;
314   }
315 
316   /// @dev Check if ICO has ended
317   function hasIcoEnded() public constant returns (bool) {
318     return now > endTimeIco;
319   }
320 
321   /// @dev Amount of tokens that have been sold during both presale and ICO phase
322   function cummulativeTokensSold() public constant returns (uint256) {
323     return tokensSoldPre + tokensSoldIco;
324   }
325 
326   /// @dev Function to extract mistakenly sent ERC20 tokens sent to Crowdsale contract and to extract unsold CC tokens
327   /// @param _token Address of token we want to extract
328   function claimTokens(address _token) public onlyOwner {
329     if (_token == address(0)) { 
330          owner.transfer(this.balance);
331          return;
332     }
333 
334     ERC20 erc20Token = ERC20(_token);
335     uint balance = erc20Token.balanceOf(this);
336     erc20Token.transfer(owner, balance);
337     ClaimedTokens(_token, owner, balance);
338   }
339 
340   /// Events
341   event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount);
342   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
343   event IcoPhaseAmountsChanged(uint256 _icoPhaseAmount1, uint256 _icoPhaseAmount2, uint256 _icoPhaseAmount3, uint256 _icoPhaseAmount4);
344   event RatesChanged(address indexed _rateSetter, uint32 _ethEurRate, uint32 _btcEthRate);
345 
346 }
347 
348 /// @title CulturalCoinCrowdsale contract
349 contract CulturalCoinCrowdsale is Crowdsale {
350 
351   function CulturalCoinCrowdsale(uint256 _startTimePre, uint256 _endTimePre, uint256 _startTimeIco, uint256 _endTimeIco, uint32 _ethEurRate, uint32 _btcEthRate, address _wallet, address _tokenAddress, address _whitelistAddress) 
352   Crowdsale(_startTimePre, _endTimePre, _startTimeIco, _endTimeIco, _ethEurRate, _btcEthRate, _wallet, _tokenAddress, _whitelistAddress) public {
353 
354   }
355 
356 }