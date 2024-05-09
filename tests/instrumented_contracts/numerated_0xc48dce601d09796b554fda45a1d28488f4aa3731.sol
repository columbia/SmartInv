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
55 /// @title ERC20 contract
56 /// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
57 contract ERC20 {
58   uint public totalSupply;
59   function balanceOf(address who) public constant returns (uint);
60   function transfer(address to, uint value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint value);
62   
63   function allowance(address owner, address spender) public constant returns (uint);
64   function transferFrom(address from, address to, uint value) public returns (bool);
65   function approve(address spender, uint value) public returns (bool);
66   event Approval(address indexed owner, address indexed spender, uint value);
67 }
68 
69 /// @title ExtendedERC20 contract
70 contract ExtendedERC20 is ERC20 {
71   function mint(address _to, uint _amount) public returns (bool);
72 }
73 
74 /// @title WizzleInfinityHelper contract
75 contract WizzleInfinityHelper {
76   function isWhitelisted(address addr) public constant returns (bool);
77 }
78 
79 /// @title Crowdsale contract
80 contract Crowdsale is Ownable {
81   using SafeMath for uint256;
82   
83   /// Token reference
84   ExtendedERC20 public token;
85   /// WizzleInfinityHelper reference - helper for whitelisting
86   WizzleInfinityHelper public helper;
87   /// Presale start time (inclusive)
88   uint256 public startTimePre;
89   /// Presale end time (inclusive)
90   uint256 public endTimePre;
91   /// ICO start time (inclusive)
92   uint256 public startTimeIco;
93   /// ICO end time (inclusive)
94   uint256 public endTimeIco;
95   /// Address where the funds will be collected
96   address public wallet;
97   /// EUR per 1 ETH rate
98   uint32 public rate;
99   /// Amount of tokens sold in presale
100   uint256 public tokensSoldPre;
101   /// Amount of tokens sold in ICO
102   uint256 public tokensSoldIco;
103   /// Amount of raised ethers expressed in weis
104   uint256 public weiRaised;
105   /// Number of contributors
106   uint256 public contributors;
107   /// Presale cap
108   uint256 public preCap;
109   /// ICO cap
110   uint256 public icoCap;
111   /// Presale discount percentage
112   uint8 public preDiscountPercentage;
113   /// Amount of tokens in ICO discount level 1 
114   uint256 public icoDiscountLevel1;
115   /// Amount of tokens in ICO discount level 2
116   uint256 public icoDiscountLevel2;
117   /// ICO discount percentage 1
118   uint8 public icoDiscountPercentageLevel1;
119   /// ICO discount percentage 2
120   uint8 public icoDiscountPercentageLevel2;
121   /// ICO discount percentage 3
122   uint8 public icoDiscountPercentageLevel3;
123 
124   function Crowdsale(uint256 _startTimePre, uint256 _endTimePre, uint256 _startTimeIco, uint256 _endTimeIco, uint32 _rate, address _wallet, address _tokenAddress, address _helperAddress) {
125     require(_startTimePre >= now);
126     require(_endTimePre >= _startTimePre);
127     require(_startTimeIco >= _endTimePre);
128     require(_endTimeIco >= _startTimeIco);
129     require(_rate > 0);
130     require(_wallet != address(0));
131     require(_tokenAddress != address(0));
132     require(_helperAddress != address(0));
133     startTimePre = _startTimePre;
134     endTimePre = _endTimePre;
135     startTimeIco = _startTimeIco;
136     endTimeIco = _endTimeIco;
137     rate = _rate;
138     wallet = _wallet;
139     token = ExtendedERC20(_tokenAddress);
140     helper = WizzleInfinityHelper(_helperAddress);
141     preCap = 1500 * 10**24;           // 1500m tokens
142     preDiscountPercentage = 50;       // 50% discount
143     icoCap = 3450 * 10**24;           // 3450m tokens (500m + 500m + 2450m)
144     icoDiscountLevel1 = 500 * 10**24; // 500m tokens 
145     icoDiscountLevel2 = 500 * 10**24; // 500m tokens
146     icoDiscountPercentageLevel1 = 40; // 40% discount
147     icoDiscountPercentageLevel2 = 30; // 30% discount
148     icoDiscountPercentageLevel3 = 25; // 25% discount
149   }
150 
151   /// @dev Set the rate of ETH - EUR
152   /// @param _rate Rate of ETH - EUR
153   function setRate(uint32 _rate) public onlyOwner {
154     require(_rate > 0);
155     rate = _rate;
156   }
157 
158   /// @dev Fallback function for crowdsale contribution
159   function () payable {
160     buyTokens(msg.sender);
161   }
162 
163   /// @dev Buy tokens function
164   /// @param beneficiary Address which will receive the tokens
165   function buyTokens(address beneficiary) public payable {
166     require(beneficiary != address(0));
167     require(helper.isWhitelisted(beneficiary));
168     uint256 weiAmount = msg.value;
169     require(weiAmount > 0);
170     uint256 tokenAmount = 0;
171     if (isPresale()) {
172       /// Minimum contribution of 1 ether during presale
173       require(weiAmount >= 1 ether); 
174       tokenAmount = getTokenAmount(weiAmount, preDiscountPercentage);
175       uint256 newTokensSoldPre = tokensSoldPre.add(tokenAmount);
176       require(newTokensSoldPre <= preCap);
177       tokensSoldPre = newTokensSoldPre;
178     } else if (isIco()) {
179       uint8 discountPercentage = getIcoDiscountPercentage();
180       tokenAmount = getTokenAmount(weiAmount, discountPercentage);
181       /// Minimum contribution 1 token during ICO
182       require(tokenAmount >= 10**18); 
183       uint256 newTokensSoldIco = tokensSoldIco.add(tokenAmount);
184       require(newTokensSoldIco <= icoCap);
185       tokensSoldIco = newTokensSoldIco;
186     } else {
187       /// Stop execution and return remaining gas
188       require(false);
189     }
190     executeTransaction(beneficiary, weiAmount, tokenAmount);
191   }
192 
193   /// @dev Internal function used for calculating ICO discount percentage depending on levels
194   function getIcoDiscountPercentage() internal constant returns (uint8) {
195     if (tokensSoldIco <= icoDiscountLevel1) {
196       return icoDiscountPercentageLevel1;
197     } else if (tokensSoldIco <= icoDiscountLevel1.add(icoDiscountLevel2)) {
198       return icoDiscountPercentageLevel2;
199     } else { 
200       return icoDiscountPercentageLevel3; //for everything else
201     }
202   }
203 
204   /// @dev Internal function used to calculate amount of tokens based on discount percentage
205   function getTokenAmount(uint256 weiAmount, uint8 discountPercentage) internal constant returns (uint256) {
206     /// Less than 100 to avoid division with zero
207     require(discountPercentage >= 0 && discountPercentage < 100); 
208     uint256 baseTokenAmount = weiAmount.mul(rate);
209     uint256 tokenAmount = baseTokenAmount.mul(10000).div(100 - discountPercentage);
210     return tokenAmount;
211   }
212 
213   /// @dev Internal function for execution of crowdsale transaction and proper logging used by payable functions
214   function executeTransaction(address beneficiary, uint256 weiAmount, uint256 tokenAmount) internal {
215     weiRaised = weiRaised.add(weiAmount);
216     token.mint(beneficiary, tokenAmount);
217     TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
218 	  contributors = contributors.add(1);
219     wallet.transfer(weiAmount);
220   }
221 
222   /// @dev Used to change presale cap (maximum tokens sold during presale)
223   /// @param _preCap Presale cap
224   function changePresaleCap(uint256 _preCap) public onlyOwner {
225     require(_preCap > 0);
226     PresaleCapChanged(owner, _preCap);
227     preCap = _preCap;
228   }
229 
230   /// @dev Used to change presale discount percentage
231   /// @param _preDiscountPercentage Presale discount percentage
232   function changePresaleDiscountPercentage(uint8 _preDiscountPercentage) public onlyOwner {
233     require(_preDiscountPercentage >= 0 && _preDiscountPercentage < 100);
234     PresaleDiscountPercentageChanged(owner, _preDiscountPercentage);
235     preDiscountPercentage = _preDiscountPercentage;
236   }
237 
238   /// @dev Used to change presale time
239   /// @param _startTimePre Start time of presale
240   /// @param _endTimePre End time of presale
241   function changePresaleTimeRange(uint256 _startTimePre, uint256 _endTimePre) public onlyOwner {
242     require(_endTimePre >= _startTimePre);
243     PresaleTimeRangeChanged(owner, _startTimePre, _endTimePre);
244     startTimePre = _startTimePre;
245     endTimePre = _endTimePre;
246   }
247 
248   /// @dev Used to change ICO cap in case the hard cap has been reached
249   /// @param _icoCap ICO cap
250   function changeIcoCap(uint256 _icoCap) public onlyOwner {
251     require(_icoCap > 0);
252     IcoCapChanged(owner, _icoCap);
253     icoCap = _icoCap;
254   }
255 
256   /// @dev Used to change time of ICO
257   /// @param _startTimeIco Start time of ICO
258   /// @param _endTimeIco End time of ICO
259   function changeIcoTimeRange(uint256 _startTimeIco, uint256 _endTimeIco) public onlyOwner {
260     require(_endTimeIco >= _startTimeIco);
261     IcoTimeRangeChanged(owner, _startTimeIco, _endTimeIco);
262     startTimeIco = _startTimeIco;
263     endTimeIco = _endTimeIco;
264   }
265 
266   /// @dev Change amount of tokens in discount phases
267   /// @param _icoDiscountLevel1 Amount of tokens in first phase
268   /// @param _icoDiscountLevel2 Amount of tokens in second phase
269   function changeIcoDiscountLevels(uint256 _icoDiscountLevel1, uint256 _icoDiscountLevel2) public onlyOwner {
270     require(_icoDiscountLevel1 > 0 && _icoDiscountLevel2 > 0);
271     IcoDiscountLevelsChanged(owner, _icoDiscountLevel1, _icoDiscountLevel2);
272     icoDiscountLevel1 = _icoDiscountLevel1;
273     icoDiscountLevel2 = _icoDiscountLevel2;
274   }
275 
276   /// @dev Change discount percentages for different phases
277   /// @param _icoDiscountPercentageLevel1 Discount percentage of phase 1
278   /// @param _icoDiscountPercentageLevel2 Discount percentage of phase 2
279   /// @param _icoDiscountPercentageLevel3 Discount percentage of phase 3
280   function changeIcoDiscountPercentages(uint8 _icoDiscountPercentageLevel1, uint8 _icoDiscountPercentageLevel2, uint8 _icoDiscountPercentageLevel3) public onlyOwner {
281     require(_icoDiscountPercentageLevel1 >= 0 && _icoDiscountPercentageLevel1 < 100);
282     require(_icoDiscountPercentageLevel2 >= 0 && _icoDiscountPercentageLevel2 < 100);
283     require(_icoDiscountPercentageLevel3 >= 0 && _icoDiscountPercentageLevel3 < 100);
284     IcoDiscountPercentagesChanged(owner, _icoDiscountPercentageLevel1, _icoDiscountPercentageLevel2, _icoDiscountPercentageLevel3);
285     icoDiscountPercentageLevel1 = _icoDiscountPercentageLevel1;
286     icoDiscountPercentageLevel2 = _icoDiscountPercentageLevel2;
287     icoDiscountPercentageLevel3 = _icoDiscountPercentageLevel3;
288   }
289 
290   /// @dev Check if presale is active
291   function isPresale() public constant returns (bool) {
292     return now >= startTimePre && now <= endTimePre;
293   }
294 
295   /// @dev Check if ICO is active
296   function isIco() public constant returns (bool) {
297     return now >= startTimeIco && now <= endTimeIco;
298   }
299 
300   /// @dev Check if presale has ended
301   function hasPresaleEnded() public constant returns (bool) {
302     return now > endTimePre;
303   }
304 
305   /// @dev Check if ICO has ended
306   function hasIcoEnded() public constant returns (bool) {
307     return now > endTimeIco;
308   }
309 
310   /// @dev Amount of tokens that have been sold during both presale and ICO phase
311   function cummulativeTokensSold() public constant returns (uint256) {
312     return tokensSoldPre + tokensSoldIco;
313   }
314 
315   /// @dev Function to extract mistakenly sent ERC20 tokens sent to Crowdsale contract
316   /// @param _token Address of token we want to extract
317   function claimTokens(address _token) public onlyOwner {
318     if (_token == address(0)) { 
319          owner.transfer(this.balance);
320          return;
321     }
322 
323     ERC20 erc20Token = ERC20(_token);
324     uint balance = erc20Token.balanceOf(this);
325     erc20Token.transfer(owner, balance);
326     ClaimedTokens(_token, owner, balance);
327   }
328 
329   /// Events
330   event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount);
331   event PresaleTimeRangeChanged(address indexed _owner, uint256 _startTimePre, uint256 _endTimePre);
332   event PresaleCapChanged(address indexed _owner, uint256 _preCap);
333   event PresaleDiscountPercentageChanged(address indexed _owner, uint8 _preDiscountPercentage);
334   event IcoCapChanged(address indexed _owner, uint256 _icoCap);
335   event IcoTimeRangeChanged(address indexed _owner, uint256 _startTimeIco, uint256 _endTimeIco);
336   event IcoDiscountLevelsChanged(address indexed _owner, uint256 _icoDiscountLevel1, uint256 _icoDiscountLevel2);
337   event IcoDiscountPercentagesChanged(address indexed _owner, uint8 _icoDiscountPercentageLevel1, uint8 _icoDiscountPercentageLevel2, uint8 _icoDiscountPercentageLevel3);
338   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
339 
340 }
341 
342 /// @title WizzleInfinityTokenCrowdsale contract
343 contract WizzleInfinityTokenCrowdsale is Crowdsale {
344 
345   function WizzleInfinityTokenCrowdsale(uint256 _startTimePre, uint256 _endTimePre, uint256 _startTimeIco, uint256 _endTimeIco, uint32 _rate, address _wallet, address _tokenAddress, address _helperAddress) 
346   Crowdsale(_startTimePre, _endTimePre, _startTimeIco, _endTimeIco, _rate, _wallet, _tokenAddress, _helperAddress) public {
347 
348   }
349 
350 }