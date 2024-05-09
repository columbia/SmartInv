1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 }
49 
50 contract ERC20Interface {
51   function totalSupply() public constant returns (uint);
52   function balanceOf(address tokenOwner) public constant returns (uint balance);
53   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
54   function transfer(address to, uint tokens) public returns (bool success);
55   function approve(address spender, uint tokens) public returns (bool success);
56   function transferFrom(address from, address to, uint tokens) public returns (bool success);
57   event Transfer(address indexed from, address indexed to, uint tokens);
58   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 
62 contract ERC827 {
63 
64   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
65   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
66   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
67 
68 }
69 
70 
71 contract TEFoodsToken is Ownable, ERC20Interface {
72 
73   using SafeMath for uint;
74 
75   string public constant name = "TEFOOD FARM TO FORK FOOD TRACEABILITY SYSTEM LICENSE TOKEN";
76   string public constant symbol = "TFOOD";
77   uint8 public constant decimals = 18;
78   uint constant _totalSupply = 1000000000 * 1 ether;
79   uint public transferrableTime = 1521712800;
80   uint _vestedSupply;
81   uint _circulatingSupply;
82   mapping (address => uint) balances;
83   mapping (address => mapping(address => uint)) allowed;
84 
85   struct vestedBalance {
86     address addr;
87     uint balance;
88   }
89   mapping (uint => vestedBalance[]) vestingMap;
90 
91 
92 
93   function TEFoodsToken () public {
94     owner = msg.sender;
95     balances[0x00] = _totalSupply;
96   }
97 
98   event VestedTokensReleased(address to, uint amount);
99 
100   function allocateTokens (address addr, uint amount) public onlyOwner returns (bool) {
101     require (addr != 0x00);
102     require (amount > 0);
103     balances[0x00] = balances[0x00].sub(amount);
104     balances[addr] = balances[addr].add(amount);
105     _circulatingSupply = _circulatingSupply.add(amount);
106     assert (_vestedSupply.add(_circulatingSupply).add(balances[0x00]) == _totalSupply);
107     return true;
108   }
109 
110   function allocateVestedTokens (address addr, uint amount, uint vestingPeriod) public onlyOwner returns (bool) {
111     require (addr != 0x00);
112     require (amount > 0);
113     require (vestingPeriod > 0);
114     balances[0x00] = balances[0x00].sub(amount);
115     vestingMap[vestingPeriod].push( vestedBalance (addr,amount) );
116     _vestedSupply = _vestedSupply.add(amount);
117     assert (_vestedSupply.add(_circulatingSupply).add(balances[0x00]) == _totalSupply);
118     return true;
119   }
120 
121   function releaseVestedTokens (uint vestingPeriod) public {
122     require (now >= transferrableTime.add(vestingPeriod));
123     require (vestingMap[vestingPeriod].length > 0);
124     require (vestingMap[vestingPeriod][0].balance > 0);
125     var v = vestingMap[vestingPeriod];
126     for (uint8 i = 0; i < v.length; i++) {
127       balances[v[i].addr] = balances[v[i].addr].add(v[i].balance);
128       _circulatingSupply = _circulatingSupply.add(v[i].balance);
129       _vestedSupply = _vestedSupply.sub(v[i].balance);
130       v[i].balance = 0;
131       VestedTokensReleased(v[i].addr, v[i].balance);
132     }
133   }
134 
135   function enableTransfers () public onlyOwner returns (bool) {
136     if (now.add(86400) < transferrableTime) {
137       transferrableTime = now.add(86400);
138     }
139     owner = 0x00;
140     return true;
141   }
142 
143   function () public payable {
144     revert();
145   }
146 
147   function totalSupply() public constant returns (uint) {
148     return _circulatingSupply;
149   }
150 
151   function balanceOf(address tokenOwner) public constant returns (uint balance) {
152     return balances[tokenOwner];
153   }
154 
155   function vestedBalanceOf(address tokenOwner, uint vestingPeriod) public constant returns (uint balance) {
156     var v = vestingMap[vestingPeriod];
157     for (uint8 i = 0; i < v.length; i++) {
158       if (v[i].addr == tokenOwner) return v[i].balance;
159     }
160     return 0;
161   }
162 
163   function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
164     return allowed[tokenOwner][spender];
165   }
166 
167   function transfer(address to, uint tokens) public returns (bool success) {
168     require (now >= transferrableTime);
169     require (to != address(this));
170     require (balances[msg.sender] >= tokens);
171     balances[msg.sender] = balances[msg.sender].sub(tokens);
172     balances[to] = balances[to].add(tokens);
173     Transfer(msg.sender, to, tokens);
174     return true;
175   }
176 
177   function approve(address spender, uint tokens) public returns (bool success) {
178     require (spender != address(this));
179     allowed[msg.sender][spender] = tokens;
180     Approval(msg.sender, spender, tokens);
181     return true;
182   }
183 
184   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
185     require (now >= transferrableTime);
186     require (to != address(this));
187     require (allowed[from][msg.sender] >= tokens);
188     balances[from] = balances[from].sub(tokens);
189     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
190     balances[to] = balances[to].add(tokens);
191     Transfer(from, to, tokens);
192     return true;
193   }
194 
195 }
196 
197 contract TEFoods827Token is TEFoodsToken, ERC827 {
198 
199   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
200     super.approve(_spender, _value);
201     require(_spender.call(_data));
202     return true;
203   }
204 
205   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
206     super.transfer(_to, _value);
207     require(_to.call(_data));
208     return true;
209   }
210 
211   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
212     super.transferFrom(_from, _to, _value);
213     require(_to.call(_data));
214     return true;
215   }
216 
217 }
218 
219 
220 contract TEFoodsCrowdsale is Ownable {
221 
222   using SafeMath for uint;
223 
224   TEFoods827Token public tokenContract;
225 
226   uint public constant crowdsaleStartTime = 1519293600;
227   uint public constant crowdsaleUncappedTime = 1519336800;
228   uint public constant crowdsaleClosedTime = 1521712800;
229   uint public maxGasPriceInWei = 50000000000;
230   uint public constant contributionCapInWei = 1000000000000000000;
231   address public constant teFoodsAddress = 0x27Ca683EdeAB8D03c6B5d7818f78Ba27a2025159;
232 
233   uint public constant tokenRateInUsdCents = 5;
234   uint public constant ethRateInUsdCents = 92500;
235   uint public constant amountToRaiseInUsdCents = 1910000000;
236   uint public constant minContributionInUsdCents = 10000;
237 
238   uint[4] public tokenBonusTimes = [1519898400,1520503200,1521108000,1521712800];
239   uint[4] public tokenBonusPct = [15,12,10,5];
240 
241   uint public whitelistedAddressCount;
242   uint public contributorCount;
243   bool public crowdsaleFinished;
244   uint public amountRaisedInUsdCents;
245 
246   uint public constant totalTokenSupply = 1000000000 * 1 ether;
247   uint public tokensAllocated;
248 
249   uint public constant marketingTokenAllocation = 60000000 * 1 ether;
250   uint public marketingTokensDistributed;
251 
252   mapping (address => bool) presaleAllocated;
253   mapping (address => bool) marketingAllocated;
254 
255   struct Contributor {
256     bool authorised;
257     bool contributed;
258   }
259   mapping (address => Contributor) whitelist;
260 
261 
262   event PresaleAllocation(address to, uint usdAmount, uint tokenAmount);
263   event MarketingAllocation(address to, uint tokenAmount);
264   event CrowdsaleClosed(uint usdRaisedInCents);
265   event TokensTransferrable();
266 
267   function TEFoodsCrowdsale () public {
268     require (teFoodsAddress != 0x00);
269     tokenContract = new TEFoods827Token();
270   }
271 
272   function allocatePresaleTokens (address recipient, uint amountInUsdCents, uint bonusPct, uint vestingPeriodInSeconds) public onlyOwner  {
273     require (now < crowdsaleStartTime);
274     require (!presaleAllocated[recipient]);
275     uint tokenAmount = amountInUsdCents.mul(1 ether).div(tokenRateInUsdCents);
276     uint bonusAmount = tokenAmount.mul(bonusPct).div(100);
277 
278     if (vestingPeriodInSeconds > 0) {
279       require (tokenContract.allocateTokens(recipient, tokenAmount));
280       require (tokenContract.allocateVestedTokens(recipient, bonusAmount, vestingPeriodInSeconds));
281     } else {
282       require (tokenContract.allocateTokens(recipient, tokenAmount.add(bonusAmount)));
283     }
284     amountRaisedInUsdCents = amountRaisedInUsdCents.add(amountInUsdCents);
285     tokensAllocated = tokensAllocated.add(tokenAmount).add(bonusAmount);
286     presaleAllocated[recipient] = true;
287     PresaleAllocation(recipient, amountInUsdCents, tokenAmount.add(bonusAmount));
288   }
289 
290   function allocateMarketingTokens (address recipient, uint tokenAmount) public onlyOwner {
291     require (!marketingAllocated[recipient]);
292     require (marketingTokensDistributed.add(tokenAmount) <= marketingTokenAllocation);
293     marketingTokensDistributed = marketingTokensDistributed.add(tokenAmount);
294     tokensAllocated = tokensAllocated.add(tokenAmount);
295     require (tokenContract.allocateTokens(recipient, tokenAmount));
296     marketingAllocated[recipient] = true;
297     MarketingAllocation(recipient, tokenAmount);
298   }
299 
300   function whitelistUsers (address[] addressList) public onlyOwner {
301     require (now < crowdsaleStartTime);
302     for (uint8 i = 0; i < addressList.length; i++) {
303       require (!whitelist[i].authorised);
304       whitelist[addressList[i]].authorised = true;
305     }
306     whitelistedAddressCount = whitelistedAddressCount.add(addressList.length);
307   }
308 
309   function revokeUsers (address[] addressList) public onlyOwner {
310     require (now < crowdsaleStartTime);
311     for (uint8 i = 0; i < addressList.length; i++) {
312       require (whitelist[i].authorised);
313       whitelist[addressList[i]].authorised = false;
314     }
315     whitelistedAddressCount = whitelistedAddressCount.sub(addressList.length);
316   }
317 
318   function setMaxGasPrice (uint newMaxInWei) public onlyOwner {
319     require(newMaxInWei >= 1000000000);
320     maxGasPriceInWei = newMaxInWei;
321   }
322 
323   function checkWhitelisted (address addr) public view returns (bool) {
324     return whitelist[addr].authorised;
325   }
326 
327   function isOpen () public view returns (bool) {
328     return (now >= crowdsaleStartTime && !crowdsaleFinished && now < crowdsaleClosedTime);
329   }
330 
331 
332   function getRemainingEthAvailable () public view returns (uint) {
333     if (crowdsaleFinished || now > crowdsaleClosedTime) return 0;
334     return amountToRaiseInUsdCents.sub(amountRaisedInUsdCents).mul(1 ether).div(ethRateInUsdCents);
335   }
336 
337   function _applyBonus (uint amount) internal view returns (uint) {
338     for (uint8 i = 0; i < 3; i++) {
339       if (tokenBonusTimes[i] > now) {
340         return amount.add(amount.mul(tokenBonusPct[i]).div(100));
341       }
342     }
343     return amount.add(amount.mul(tokenBonusPct[3]).div(100));
344   }
345 
346   function _allocateTokens(address addr, uint amount) internal {
347     require (tokensAllocated.add(amount) <= totalTokenSupply);
348     tokensAllocated = tokensAllocated.add(amount);
349     teFoodsAddress.transfer(this.balance);
350     if (!whitelist[addr].contributed) {
351       whitelist[addr].contributed = true;
352       contributorCount = contributorCount.add(1);
353     }
354     require(tokenContract.allocateTokens(addr, amount));
355   }
356 
357   function () public payable {
358     require (tx.gasprice <= maxGasPriceInWei);
359     require (msg.value > 0);
360     require (now >= crowdsaleStartTime && now <= crowdsaleClosedTime);
361     require (whitelist[msg.sender].authorised);
362     require (!crowdsaleFinished);
363     if (now < crowdsaleUncappedTime) {
364       require (!whitelist[msg.sender].contributed);
365       require (msg.value <= contributionCapInWei);
366     }
367     uint usdAmount = msg.value.mul(ethRateInUsdCents).div(1 ether);
368     require (usdAmount >= minContributionInUsdCents);
369     uint tokenAmount = _applyBonus(msg.value.mul(ethRateInUsdCents).div(tokenRateInUsdCents));
370     amountRaisedInUsdCents = amountRaisedInUsdCents.add(usdAmount);
371     if (amountRaisedInUsdCents >= amountToRaiseInUsdCents) {
372       closeCrowdsale();
373     } else {
374       _allocateTokens(msg.sender, tokenAmount);
375     }
376   }
377 
378   function closeCrowdsale () public {
379     require (!crowdsaleFinished);
380     require (now >= crowdsaleStartTime);
381     require (msg.sender == owner || amountRaisedInUsdCents >= amountToRaiseInUsdCents);
382     crowdsaleFinished = true;
383 
384     if (msg.value > 0 && amountRaisedInUsdCents >= amountToRaiseInUsdCents) {
385 
386       uint excessEth = amountRaisedInUsdCents.sub(amountToRaiseInUsdCents).mul(1 ether).div(ethRateInUsdCents);
387       uint tokenAmount = _applyBonus(msg.value.sub(excessEth).mul(ethRateInUsdCents).div(tokenRateInUsdCents));
388       amountRaisedInUsdCents = amountToRaiseInUsdCents;
389       msg.sender.transfer(excessEth);
390       _allocateTokens(msg.sender, tokenAmount);
391     } else if ( amountRaisedInUsdCents < amountToRaiseInUsdCents) {
392       tokenAmount = amountToRaiseInUsdCents.sub(amountRaisedInUsdCents).mul(1 ether).div(tokenRateInUsdCents);
393       tokensAllocated = tokensAllocated.add(tokenAmount); // burn
394     }
395     CrowdsaleClosed(amountRaisedInUsdCents);
396   }
397 
398   function enableTokenTransfers () public onlyOwner {
399     require (crowdsaleFinished);
400     require (marketingTokensDistributed == marketingTokenAllocation);
401     uint remainingTokens = totalTokenSupply.sub(tokensAllocated);
402     uint oneYear = remainingTokens.mul(25).div(100);
403     uint twoYears = remainingTokens.sub(oneYear);
404     tokensAllocated = tokensAllocated.add(remainingTokens);
405     require (tokenContract.allocateVestedTokens(teFoodsAddress, oneYear, 31536000));
406     require (tokenContract.allocateVestedTokens(teFoodsAddress, twoYears, 63072000));
407     require (tokenContract.enableTransfers());
408     TokensTransferrable();
409   }
410 
411 }