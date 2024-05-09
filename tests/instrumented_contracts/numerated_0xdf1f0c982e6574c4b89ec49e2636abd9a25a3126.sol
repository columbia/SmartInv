1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract ERC20 {
30     function totalSupply() public constant returns (uint256 supply);
31     function balanceOf(address who) public constant returns (uint256 value);
32     function allowance(address owner, address spender) public constant returns (uint256 permitted);
33 
34     function transfer(address to, uint256 value) public returns (bool ok);
35     function transferFrom(address from, address to, uint256 value) public returns (bool ok);
36     function approve(address spender, uint256 value) public returns (bool ok);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 contract HyipProfit is ERC20 {
43     using SafeMath for uint256;
44     string public constant name = "HYIP Profit";
45     string public constant symbol = "HYIP";
46     uint8 public constant decimals = 8;
47 
48     uint256 initialSupply = 450000000000000;
49 
50     uint256 constant preSaleSoftCap = 31250000000000;
51 
52     uint256 public preSaleFund = 0;
53     uint256 public spentFunds = 0;
54     uint256 public IcoFund = 0;
55 
56     uint256 public soldTokens = 0; //reduces when somebody returns money
57 
58     mapping (address => uint256) tokenBalances; //amount of tokens each address holds
59     mapping (address => uint256) preSaleWeiBalances; //amount of Wei, paid for tokens on preSale. Used only before project completed.
60     mapping (address => uint256) weiBalances; //amount of Wei, paid for tokens that smb holds. Used only before project completed.
61 
62     uint256 public currentStage = 0;
63     tokenAddressGetter tg;
64 
65     bool public isICOfinalized = false;
66 
67     address public HyipProfitTokenTeamAddress;
68     address public utilityTokenAddress = 0x0;
69 
70     modifier onlyTeam {
71         if (msg.sender == HyipProfitTokenTeamAddress) {
72             _;
73         }
74     }
75 
76     mapping (address => mapping (address => uint256)) allowed;
77     mapping (uint256 => address) teamAddresses;
78 
79     uint256 currentDividendsRound;
80     mapping (uint256 => uint256) dividendsPerTokenPerRound;
81     mapping (uint256 => mapping (address => uint256)) poolBalances;
82     mapping (address => uint256) lastWithdrawal;
83 
84     event dividendsReceived (uint256 round, uint256 totalValue, uint256 dividendsPerToken);
85     event dividendsWithdraw (address tokenHolder, uint256 valueInWei);
86     event tokensReceived (address from, uint256 tokensAmount);
87     event tokensWithdrawal (address to, uint256 tokensAmount);
88 
89     event StageSubmittedAndEtherPassedToTheTeam(uint256 stage, uint256 when, uint256 weiAmount);
90     event etherWithdrawFromTheContract(address tokenHolder, uint256 numberOfTokensSoldBack, uint256 weiValue);
91     event Burned(address indexed from, uint256 amount);
92 
93     // ERC20 interface implementation
94 
95     function totalSupply() public constant returns (uint256) {
96         return initialSupply;
97     }
98 
99     function balanceOf(address tokenHolder) public view returns (uint256 balance) {
100         return tokenBalances[tokenHolder];
101     }
102 
103     function allowance(address owner, address spender) public constant returns (uint256) {
104         return allowed[owner][spender];
105     }
106 
107     function transfer(address to, uint256 value) public returns (bool success) {
108         if (tokenBalances[msg.sender] >= value && value > 0) {
109             if (to == address(this)) {
110                 if (!isICOfinalized) {
111                     returnAllAvailableFunds();
112                     return true;
113                 }
114                 else {
115                     passTokensToTheDividendsPool(value);
116                     return true;
117                 }
118             }
119             else {
120                 return transferTokensAndEtherValue(msg.sender, to, value, getHoldersAverageTokenPrice(msg.sender).mul(value) , getUsersPreSalePercentage(msg.sender));
121             }
122         } else return false;
123     }
124 
125     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
126         if (tokenBalances[from]>=value && allowed[from][to] >= value && value > 0) {
127             if (transferTokensAndEtherValue(from, to, value, getHoldersAverageTokenPrice(from).mul(value), getUsersPreSalePercentage(from))){
128                 allowed[from][to] = allowed[from][to].sub(value);
129                 if (from == address(this) && poolBalanceOf(to) >= value) {
130                     if (withdrawDividends(to)) {
131                         poolBalances[currentDividendsRound][to] = poolBalances[currentDividendsRound][to].sub(value);
132                     }
133                 }
134                 return true;
135             }
136             return false;
137         }
138         return false;
139     }
140 
141     function approve(address spender, uint256 value) public returns (bool success) {
142         if ((value != 0) && (tokenBalances[msg.sender] >= value)){
143             allowed[msg.sender][spender] = value;
144             emit Approval (msg.sender, spender, value);
145             return true;
146         } else{
147             return false;
148         }
149     }
150 
151     // Constructor, fallback, return funds
152 
153     constructor () public {
154         HyipProfitTokenTeamAddress = msg.sender;
155         currentDividendsRound = 0;
156         tokenBalances[address(this)] = initialSupply;
157         teamAddresses[0] = HyipProfitTokenTeamAddress;
158         teamAddresses[1] = 0xcC6bCF304d0Ada4Bc7B00Aa1c2c463FBEc263B7e;
159         teamAddresses[2] = 0x1F16BE21574FA46846fCfeae5ef587c29200f93e;
160         teamAddresses[3] = 0x93A10f35Bc5439E419fdDcE04Ea44779B0E1017C;
161         teamAddresses[4] = 0x71bAfdD5bd44D3e1038fE4c0Bc486fb4BB67b806;
162     }
163 
164     function () public payable {
165         if (!isICOfinalized) {
166             uint256 currentPrice = getCurrentSellPrice();
167             uint256 valueInWei = 0;
168             uint256 tokensToPass = 0;
169             uint256 preSalePercent = 0;
170 
171             require (msg.value >= currentPrice);
172 
173             tokensToPass = msg.value.div(currentPrice);
174 
175             require (tokenBalances[address(this)]>= tokensToPass);
176 
177             valueInWei = tokensToPass.mul(currentPrice);
178             soldTokens = soldTokens.add(tokensToPass);
179 
180             if (currentStage == 0) {
181                 preSaleWeiBalances [address(this)] = preSaleWeiBalances [address(this)].add(valueInWei);
182                 preSalePercent = 100;
183                 preSaleFund = preSaleFund.add(msg.value);
184             }
185             else {
186                 weiBalances[address(this)] = weiBalances[address(this)].add(valueInWei);
187                 preSalePercent = 0;
188                 IcoFund = IcoFund.add(msg.value);
189             }
190 
191             transferTokensAndEtherValue(address(this), msg.sender, tokensToPass, valueInWei, preSalePercent);
192         }
193         else {
194             require (msg.value >= 10**18);
195             topUpDividends();
196         }
197     }
198 
199     function returnAllAvailableFunds() public {
200         require (tokenBalances[msg.sender]>0); //you need to be a tokenHolder
201         require (!isICOfinalized); //you can not return tokens after project is completed
202 
203         uint256 preSaleWei = getPreSaleWeiToReturn(msg.sender);
204         uint256 IcoWei = getIcoWeiToReturn(msg.sender);
205         uint256 weiToReturn = preSaleWei.add(IcoWei);
206 
207         uint256 amountOfTokensToReturn = tokenBalances[msg.sender];
208 
209         require (amountOfTokensToReturn>0);
210 
211         uint256 preSalePercentage = getUsersPreSalePercentage(msg.sender);
212 
213         transferTokensAndEtherValue(msg.sender, address(this), amountOfTokensToReturn, weiToReturn, preSalePercentage);
214         emit etherWithdrawFromTheContract(msg.sender, amountOfTokensToReturn, IcoWei.add(preSaleWei));
215         preSaleWeiBalances[address(this)] = preSaleWeiBalances[address(this)].sub(preSaleWei);
216         weiBalances[address(this)] = weiBalances[address(this)].sub(IcoWei);
217         soldTokens = soldTokens.sub(amountOfTokensToReturn);
218         msg.sender.transfer(weiToReturn);
219 
220         preSaleFund = preSaleFund.sub(preSaleWei);
221         IcoFund = IcoFund.sub(IcoWei);
222     }
223 
224     function passTokensToTheDividendsPool(uint256 amount) internal {
225         if (tokenBalances[msg.sender] >= amount) {
226             tokenBalances[address(this)] = tokenBalances[address(this)].add(amount);
227             tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(amount);
228             emit Transfer(msg.sender, address(this), amount);
229 
230             allowed[address(this)][msg.sender] = allowed[address(this)][msg.sender].add(amount);
231             emit Approval (address(this), msg.sender, amount);
232 
233             if (poolBalanceOf(msg.sender) == 0) lastWithdrawal[msg.sender] = currentDividendsRound;
234             poolBalances[currentDividendsRound][msg.sender] = poolBalances[currentDividendsRound][msg.sender].add(amount);
235             emit tokensReceived(msg.sender, amount);
236         }
237     }
238 
239     function topUpDividends() public payable {
240         require (msg.value >= 10**18);
241         uint256 dividends = msg.value;
242         uint256 tokensInPool = balanceOf(address(this));
243         dividendsPerTokenPerRound[currentDividendsRound] = dividends.div(tokensInPool);
244         emit dividendsReceived (currentDividendsRound, dividends, dividendsPerTokenPerRound[currentDividendsRound]);
245         currentDividendsRound = currentDividendsRound.add(1);
246     }
247 
248     function withdrawDividends(address holder) public returns (bool success) {
249         require (poolBalanceOf(holder) > 0);
250         uint256 totalDividendsForHolder = dividendsOf(holder);
251         if (totalDividendsForHolder == 0) return true;
252         uint256 holdersTotalTokensInPool = 0;
253 
254         for (uint256 i = lastWithdrawal[holder]; i < currentDividendsRound; i = i.add(1)) {
255             holdersTotalTokensInPool = holdersTotalTokensInPool.add(poolBalances[i][holder]);
256             poolBalances[i][holder] = 0;
257         }
258 
259         holder.transfer(totalDividendsForHolder);
260         emit dividendsWithdraw (holder, totalDividendsForHolder);
261         poolBalances[currentDividendsRound][holder] = holdersTotalTokensInPool;
262         lastWithdrawal[holder] = currentDividendsRound;
263         return true;
264     } //AnyBody can call
265 
266     // View functions
267 
268     function dividendsOf(address holder) public view returns (uint256 dividendsAmount) {
269         uint256 dividends = 0;
270         for (uint256 i = lastWithdrawal[holder]; i < currentDividendsRound; i = i.add(1)) {
271             for(uint256 j = lastWithdrawal[holder]; j <= i; j = j.add(1)) {
272                 if (poolBalances[j][holder]>0 && dividendsPerTokenPerRound[i] > 0)
273                 dividends = dividends.add(poolBalances[j][holder].mul(dividendsPerTokenPerRound[i]));
274             }
275         }
276         return dividends;
277     }
278 
279     function icoFinalized() public view returns (bool) {
280         return isICOfinalized;
281     }
282 
283     function poolBalanceOf(address holder) public view returns (uint256 balance){
284         uint256 holdersTotalTokensInThePool = 0;
285         for (uint256 i = lastWithdrawal[msg.sender]; i <= currentDividendsRound; i = i.add(1)) {
286             holdersTotalTokensInThePool = holdersTotalTokensInThePool.add(poolBalances[i][holder]);
287         }
288         return holdersTotalTokensInThePool;
289     }
290 
291     function getWeiBalance(address a) public view returns (uint256 weiBalance) {
292         return weiBalances[a];
293     }
294 
295     function getUsersPreSalePercentage(address a) public view returns (uint256 preSaleTokensPercent) {
296         if (!isICOfinalized && (preSaleWeiBalances[a].add(weiBalances[a]) > 0)) {
297             uint256 result = (preSaleWeiBalances[a].mul(100)).div((preSaleWeiBalances[a].add(weiBalances[a])));
298             require (result<=100);
299             return result;
300         }
301         return 0;
302     }
303 
304     function getTotalWeiAvailableToReturn(address a) public view returns (uint256 amount) {
305         return getPreSaleWeiToReturn(a).add(getIcoWeiToReturn(a));
306     }
307 
308     function getPreSaleWeiToReturn (address holder) public view returns (uint256 amount) {
309         if (currentStage == 0) return preSaleWeiBalances[holder];
310         if (currentStage == 1) return preSaleWeiBalances[holder].mul(7).div(10);
311         if (currentStage == 2) return preSaleWeiBalances[holder].mul(4).div(10);
312         return 0;
313     }
314 
315     function getIcoWeiToReturn (address holder) public view returns (uint256 amount) {
316         if (currentStage <= 3) return weiBalances[holder];
317         if (currentStage == 4) return weiBalances[holder].mul(7).div(10);
318         if (currentStage == 5) return weiBalances[holder].mul(4).div(10);
319         return 0;
320     }
321 
322     function getHoldersAverageTokenPrice(address holder) public view returns (uint256 avPriceInWei) {
323         if (!isICOfinalized)
324             return (weiBalances[holder].add(preSaleWeiBalances[holder])).div(tokenBalances[holder]);
325         return 0;
326     }
327 
328     function getCurrentSellPrice() public view returns (uint256 priceInWei) {
329         if (isICOfinalized) return 0;
330         if (currentStage == 0) return 10**6 * 8 ; //this is equal to 0.0008 ETH for 1 token
331         if (currentStage == 1) return 10**6 * 16;
332         if (currentStage == 2) return 10**6 * 24;
333         if (currentStage == 3) return 10**6 * 32;
334         return 0;
335     }
336 
337     function getAvailableFundsForTheTeam() public view returns (uint256 amount) {
338         if (currentStage == 1) return preSaleFund.mul(3).div(10);
339         if (currentStage == 2) return (preSaleFund.sub(spentFunds)).div(2);
340         if (currentStage == 3) return preSaleFund.sub(spentFunds);
341 
342         if (currentStage == 4) return IcoFund.mul(3).div(10);
343         if (currentStage == 5) return (IcoFund.sub(spentFunds)).div(2);
344         if (currentStage == 6) return address(this).balance;
345     }
346 
347     function checkIfMissionCompleted() public view returns (bool success) {
348         if (currentStage == 0 && soldTokens >= preSaleSoftCap) return true;
349 
350         if (currentStage == 1 && preSaleFund.mul(3).div(5) <= IcoFund) return true;
351         if (currentStage == 2 && preSaleFund.mul(6).div(5) <= IcoFund) return true;
352 
353         if (currentStage>=3 &&
354         (utilityTokenAddress == 0x0 || tg.getBeneficiaryAddress() != address(this))) return false;
355 
356         if (currentStage == 3 && preSaleFund.mul(2) <= IcoFund) return true;
357 
358         if (currentStage == 4 && utilityTokenAddress.balance >= IcoFund.mul(3).div(5)) return true;
359         if (currentStage == 5 && utilityTokenAddress.balance >= IcoFund.mul(6).div(5)) return true;
360         if (currentStage == 6 && utilityTokenAddress.balance >= IcoFund.mul(2)) return true;
361 
362         return false;
363     }
364 
365     // Team functions
366 
367     function setUtilityTokenAddressOnce(address a) public onlyTeam {
368         if (utilityTokenAddress == 0x0) {
369             utilityTokenAddress = a;
370             tg = tokenAddressGetter(a);
371         }
372     }
373 
374     function finalizeICO() internal onlyTeam {
375         require(!isICOfinalized); // this function can be called only once
376         passTokensToTheTeam();
377         burnUndistributedTokens(); // undistributed tokens are destroyed
378         isICOfinalized = true;
379     }
380 
381     function passTokensToTheTeam() internal returns (uint256 tokenAmount) { //This function passes tokens to the team without weiValue, so the team can not withdraw ether by returning tokens to the contract
382         uint256 tokensForEachMember = soldTokens.div(20); // 4% for each team member
383         uint256 tokensToPass = tokensForEachMember.mul(5);
384 
385         for (uint256 i = 0; i< 5; i = i.add(1)) {
386             address teamMember = teamAddresses[i];
387             tokenBalances[teamMember] = tokenBalances[teamMember].add(tokensForEachMember);
388             emit Transfer(address(this), teamMember, tokensForEachMember);
389         }
390 
391         soldTokens = soldTokens.add(tokensToPass);
392         return tokensToPass;
393     }
394 
395     function submitNextStage() public onlyTeam returns (bool success) {
396         if (!checkIfMissionCompleted()) return false;
397         if (currentStage==3) spentFunds = 0;
398         if (currentStage == 6) finalizeICO();
399 
400         currentStage = currentStage.add(1);
401         passEtherToTheTeam();
402 
403         return true;
404     }
405 
406     function passEtherToTheTeam() internal returns (bool success) {
407         uint256 weiAmount = getAvailableFundsForTheTeam();
408         HyipProfitTokenTeamAddress.transfer(weiAmount);
409         spentFunds = spentFunds.add(weiAmount);
410         emit StageSubmittedAndEtherPassedToTheTeam(currentStage, now, weiAmount);
411         return true;
412     }
413 
414     function transferTokensAndEtherValue(address from, address to, uint256 value, uint256 weiValue, uint256 preSalePercent) internal returns (bool success){
415         if (tokenBalances[from] >= value) {
416             tokenBalances[to] = tokenBalances[to].add(value);
417             tokenBalances[from] = tokenBalances[from].sub(value);
418 
419             if (!isICOfinalized) {
420                 preSaleWeiBalances[from] = preSaleWeiBalances[from].sub(weiValue.mul(preSalePercent).div(100));
421                 preSaleWeiBalances[to] = preSaleWeiBalances[to].add(weiValue.mul(preSalePercent).div(100));
422 
423                 require (preSalePercent<=100);
424 
425                 weiBalances[from] = weiBalances[from].sub(weiValue.mul(100 - preSalePercent).div(100));
426                 weiBalances[to] = weiBalances[to].add(weiValue.mul(100 - preSalePercent).div(100));
427             }
428             emit Transfer(from, to, value);
429             return true;
430         }
431         return false;
432     }
433 
434     function burnUndistributedTokens() internal {
435         uint256 toBurn = initialSupply.sub(soldTokens);
436         initialSupply = initialSupply.sub(toBurn);
437         tokenBalances[address(this)] = 0;
438         emit Burned(address(this), toBurn);
439     }
440 }
441 
442 contract tokenAddressGetter {
443     function getBeneficiaryAddress() public view returns (address);
444 }