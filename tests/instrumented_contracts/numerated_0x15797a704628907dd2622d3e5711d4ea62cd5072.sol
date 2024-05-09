1 pragma solidity ^0.4.19;
2 
3 library itMaps {
4     /* itMapAddressUint
5          address =>  Uint
6     */
7     struct entryAddressUint {
8     // Equal to the index of the key of this item in keys, plus 1.
9     uint keyIndex;
10     uint value;
11     }
12 
13     struct itMapAddressUint {
14     mapping(address => entryAddressUint) data;
15     address[] keys;
16     }
17 
18     function insert(itMapAddressUint storage self, address key, uint value) internal returns (bool replaced) {
19         entryAddressUint storage e = self.data[key];
20         e.value = value;
21         if (e.keyIndex > 0) {
22             return true;
23         } else {
24             e.keyIndex = ++self.keys.length;
25             self.keys[e.keyIndex - 1] = key;
26             return false;
27         }
28     }
29 
30     function remove(itMapAddressUint storage self, address key) internal returns (bool success) {
31         entryAddressUint storage e = self.data[key];
32         if (e.keyIndex == 0)
33         return false;
34 
35         if (e.keyIndex <= self.keys.length) {
36             // Move an existing element into the vacated key slot.
37             self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;
38             self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];
39             self.keys.length -= 1;
40             delete self.data[key];
41             return true;
42         }
43     }
44 
45     function destroy(itMapAddressUint storage self) internal  {
46         for (uint i; i<self.keys.length; i++) {
47             delete self.data[ self.keys[i]];
48         }
49         delete self.keys;
50         return ;
51     }
52 
53     function contains(itMapAddressUint storage self, address key) internal constant returns (bool exists) {
54         return self.data[key].keyIndex > 0;
55     }
56 
57     function size(itMapAddressUint storage self) internal constant returns (uint) {
58         return self.keys.length;
59     }
60 
61     function get(itMapAddressUint storage self, address key) internal constant returns (uint) {
62         return self.data[key].value;
63     }
64 
65     function getKeyByIndex(itMapAddressUint storage self, uint idx) internal constant returns (address) {
66         return self.keys[idx];
67     }
68 
69     function getValueByIndex(itMapAddressUint storage self, uint idx) internal constant returns (uint) {
70         return self.data[self.keys[idx]].value;
71     }
72 }
73 
74 contract ERC20 {
75     function totalSupply() public constant returns (uint256 supply);
76     function balanceOf(address who) public constant returns (uint value);
77     function allowance(address owner, address spender) public constant returns (uint _allowance);
78 
79     function transfer(address to, uint value) public returns (bool ok);
80     function transferFrom(address from, address to, uint value) public returns (bool ok);
81     function approve(address spender, uint value) public returns (bool ok);
82 
83     event Transfer(address indexed from, address indexed to, uint value);
84     event Approval(address indexed owner, address indexed spender, uint value);
85 }
86 
87 contract TakeMyEther is ERC20{
88     using itMaps for itMaps.itMapAddressUint;
89 
90     uint private initialSupply = 2800000;
91     uint public soldTokens = 0; //reduces when somebody returns money
92     string public constant name = "TakeMyEther";
93     string public constant symbol = "TMEther";
94     address public TakeMyEtherTeamAddress;
95 
96     itMaps.itMapAddressUint tokenBalances; //amount of tokens each address holds
97     mapping (address => uint256) weiBalances; //amount of Wei, paid for tokens that smb holds. Used only before project completed.
98     mapping (address => uint256) weiBalancesReturned;
99 
100     uint public percentsOfProjectComplete = 0;
101     uint public lastStageSubmitted;
102     uint public lastTimeWithdrawal;
103 
104     uint public constant softCapTokensAmount = 500000;
105     uint public constant hardCapTokensAmount = 2250000;
106 
107     uint public constant lockDownPeriod = 1 weeks;
108     uint public constant minimumStageDuration = 2 weeks;
109 
110     bool public isICOfinalized = false;
111     bool public projectCompleted = false;
112 
113     modifier onlyTeam {
114         if (msg.sender == TakeMyEtherTeamAddress) {
115             _;
116         }
117     }
118 
119     mapping (address => mapping (address => uint256)) allowed;
120 
121     event StageSubmitted(uint last);
122     event etherPassedToTheTeam(uint weiAmount, uint when);
123     event etherWithdrawFromTheContract(address tokenHolder, uint numberOfTokensSoldBack, uint weiValue);
124     event Burned(address indexed from, uint amount);
125     event DividendsTransfered(address to, uint tokensAmount, uint weiAmount);
126 
127     // ERC20 interface implementation
128 
129     function totalSupply() public constant returns (uint256) {
130         return initialSupply;
131     }
132 
133     function balanceOf(address tokenHolder) public view returns (uint256 balance) {
134         return tokenBalances.get(tokenHolder);
135     }
136 
137     function allowance(address owner, address spender) public constant returns (uint256) {
138         return allowed[owner][spender];
139     }
140 
141     function transfer(address to, uint value) public returns (bool success) {
142         if (tokenBalances.get(msg.sender) >= value && value > 0) {
143             if (to == address(this)) { // if you send even 1 token back to the contract, it will return all available funds to you
144                 returnAllAvailableFunds();
145                 return true;
146             }
147             else {
148                 return transferTokensAndEtherValue(msg.sender, to, value, getAverageTokenPrice(msg.sender) * value);
149             }
150         } else return false;
151     }
152 
153     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
154         if (tokenBalances.get(from)>=value && allowed[from][to] >= value && value > 0) {
155             if (transferTokensAndEtherValue(from, to, value, getAverageTokenPrice(from) * value)) {
156                 allowed[from][to] -= value;
157                 return true;
158             }
159             return false;
160         }
161         return false;
162     }
163 
164     function approve(address spender, uint value) public returns (bool success) {
165         if ((value != 0) && (tokenBalances.get(msg.sender) >= value)){
166             allowed[msg.sender][spender] = value;
167             emit Approval(msg.sender, spender, value);
168             return true;
169         } else{
170             return false;
171         }
172     }
173 
174     // Constructor, fallback, return funds
175 
176     function TakeMyEther() public {
177         TakeMyEtherTeamAddress = msg.sender;
178         tokenBalances.insert(address(this), initialSupply);
179         lastStageSubmitted = now;
180     } //tested
181 
182     function () public payable {
183         require (!projectCompleted);
184         uint weiToSpend = msg.value; //recieved value
185         uint currentPrice = getCurrentSellPrice(); //0.5 ETH or 1 ETH for 1000 tokens
186         uint valueInWei = 0;
187         uint valueToPass = 0;
188 
189         if (weiToSpend < currentPrice) {// return ETH back if nothing to buy
190             return;
191         }
192 
193         if (!tokenBalances.contains(msg.sender))
194         tokenBalances.insert(msg.sender, 0);
195 
196         if (soldTokens < softCapTokensAmount) {
197             uint valueLeftForSoftCap = softCapTokensAmount - soldTokens;
198             valueToPass = weiToSpend / currentPrice;
199 
200             if (valueToPass > valueLeftForSoftCap)
201             valueToPass = valueLeftForSoftCap;
202 
203             valueInWei = valueToPass * currentPrice;
204             weiToSpend -= valueInWei;
205             soldTokens += valueToPass;
206             weiBalances[address(this)] += valueInWei;
207             transferTokensAndEtherValue(address(this), msg.sender, valueToPass, valueInWei);
208         }
209 
210         currentPrice = getCurrentSellPrice(); //renew current price
211 
212         if (weiToSpend < currentPrice) {
213             return;
214         }
215 
216         if (soldTokens < hardCapTokensAmount && soldTokens >= softCapTokensAmount) {
217             uint valueLeftForHardCap = hardCapTokensAmount - soldTokens;
218             valueToPass = weiToSpend / currentPrice;
219 
220             if (valueToPass > valueLeftForHardCap)
221             valueToPass = valueLeftForHardCap;
222 
223             valueInWei = valueToPass * currentPrice;
224             weiToSpend -= valueInWei;
225             soldTokens += valueToPass;
226             weiBalances[address(this)] += valueInWei;
227             transferTokensAndEtherValue(address(this), msg.sender, valueToPass, valueInWei);
228         }
229 
230         if (weiToSpend / 10**17 > 1) { //return unspent funds if they are greater than 0.1 ETH
231             msg.sender.transfer(weiToSpend);
232         }
233     }
234 
235     function returnAllAvailableFunds() public {
236         require (tokenBalances.contains(msg.sender)); //you need to be a tokenHolder
237         require (!projectCompleted); //you can not return tokens after project is completed
238 
239         uint avPrice = getAverageTokenPrice(msg.sender);
240         weiBalances[msg.sender] = getWeiAvailableToReturn(msg.sender); //depends on project completeness level
241 
242         uint amountOfTokensToReturn = weiBalances[msg.sender] / avPrice;
243 
244         require (amountOfTokensToReturn>0);
245 
246         uint valueInWei = weiBalances[msg.sender];
247 
248         transferTokensAndEtherValue(msg.sender, address(this), amountOfTokensToReturn, valueInWei);
249         emit etherWithdrawFromTheContract(msg.sender, amountOfTokensToReturn, valueInWei);
250         weiBalances[address(this)] -= valueInWei;
251         soldTokens -= amountOfTokensToReturn;
252         msg.sender.transfer(valueInWei);
253     }
254 
255     // View functions
256 
257     function getWeiBalance(address a) public view returns (uint) {
258         return weiBalances[a];
259     }
260 
261     function getWeiAvailableToReturn(address holder) public view returns (uint amount) {
262         if (!isICOfinalized) return weiBalances[holder];
263         uint percentsBlocked = 0;
264         if (percentsOfProjectComplete > 10 && lastStageSubmitted + lockDownPeriod > now)
265         percentsBlocked = percentsOfProjectComplete - 10;
266         else
267         percentsBlocked = percentsOfProjectComplete;
268         return ((weiBalances[holder]  / 100) * (100 - percentsOfProjectComplete));
269     }
270 
271     function getAverageTokenPrice(address holder) public view returns (uint avPriceInWei) {
272         return weiBalances[holder] / tokenBalances.get(holder);
273     }
274 
275     function getNumberOfTokensForTheTeam() public view returns (uint amount) {
276         if (soldTokens == softCapTokensAmount) return soldTokens * 4; // 80%
277         if (soldTokens == hardCapTokensAmount) return soldTokens/4; // 20%
278         uint teamPercents = (80 - ((soldTokens - softCapTokensAmount) / ((hardCapTokensAmount - softCapTokensAmount)/60)));
279         return ((soldTokens / (100 - teamPercents)) * teamPercents); // tokens for the team
280     }
281 
282     function getCurrentSellPrice() public view returns (uint priceInWei) {
283         if (!isICOfinalized) {
284             if (soldTokens < softCapTokensAmount) return 10**14 * 5 ; //this is equal to 0.0005 ETH
285             else return 10**15; //this is equal to 0.001 ETH
286         }
287         else { //if someone returns tokens after ICO finished, he can buy them until project is finished. But the price will depend on the project completeness level.
288             if (!projectCompleted) //if project is finished, no one can buy tokens
289             return (1 * 10**15 + 5 * (percentsOfProjectComplete * 10**13)) ; //each percent of completeness adds 5% to the tokenPrice.
290             else return 0; // there is no problem, because project is completed and fallback function won't work;
291         }
292     }
293 
294     function getAvailableFundsForTheTeam() public view returns (uint amount) {
295         if (percentsOfProjectComplete == 100) return address(this).balance; // take all the rest
296         return (address(this).balance /(100 - (percentsOfProjectComplete - 10))) * 10; // take next 10% of funds, left on the contract.
297         /*So if, for example, percentsOfProjectComplete is 30 (increased by 10 from previous stage)
298         there are 80% of funds, left on the contract. So we devide balance by 80 to get 1%, and then multiply by 10*/
299     }
300 
301     // Team functions
302 
303     function finalizeICO() public onlyTeam {
304         require(!isICOfinalized); // this function can be called only once
305         if (soldTokens < hardCapTokensAmount)
306         require (lastStageSubmitted + minimumStageDuration < now); // ICO duration is at least 2 weeks
307         require(soldTokens >= softCapTokensAmount); //means, that the softCap Reached
308         uint tokensToPass = passTokensToTheTeam(); //but without weiValue, so the team can not withdraw ether by returning tokens to the contract
309         burnUndistributedTokens(tokensToPass);//tokensToPass); // undistributed tokens are destroyed
310         lastStageSubmitted = now;
311         emit StageSubmitted(lastStageSubmitted);
312         increaseProjectCompleteLevel(); // Now, team can withdraw 10% of funds raised to begin the project
313         passFundsToTheTeam();
314         isICOfinalized = true;
315     }
316 
317     function submitNextStage() public onlyTeam returns (bool success) {
318         if (lastStageSubmitted + minimumStageDuration > now) return false; //Team submitted the completeness of previous stage more then 2 weeks before.
319         lastStageSubmitted = now;
320         emit StageSubmitted(lastStageSubmitted);
321         increaseProjectCompleteLevel();
322         return true;
323     }
324 
325     function unlockFundsAndPassEther() public onlyTeam returns (bool success) {
326         require (lastTimeWithdrawal<=lastStageSubmitted);
327         if (lastStageSubmitted + lockDownPeriod > now) return false; //funds can not be passed until lockDownPeriod ends
328         if (percentsOfProjectComplete == 100 && !projectCompleted) {
329             projectCompleted = true;
330             if (tokenBalances.get(address(this))>0) {
331                 uint toTransferAmount = tokenBalances.get(address(this));
332                 tokenBalances.insert(TakeMyEtherTeamAddress, tokenBalances.get(address(this)) + tokenBalances.get(TakeMyEtherTeamAddress));
333                 tokenBalances.insert(address(this), 0);
334                 emit Transfer(address(this), TakeMyEtherTeamAddress, toTransferAmount);
335             }
336         }
337         passFundsToTheTeam();
338         return true;
339     }
340 
341     // Receive dividends
342 
343     function topUpWithEtherAndTokensForHolders(address tokensContractAddress, uint tokensAmount) public payable {
344         uint weiPerToken = msg.value / initialSupply;
345         uint tokensPerToken = 100 * tokensAmount / initialSupply; //Multiplication for more precise amount
346         uint weiAmountForHolder = 0;
347         uint tokensForHolder = 0;
348 
349         for (uint i = 0; i< tokenBalances.size(); i += 1) {
350             address tokenHolder = tokenBalances.getKeyByIndex(i);
351             if (tokenBalances.get(tokenHolder)>0) {
352                 weiAmountForHolder = tokenBalances.get(tokenHolder)*weiPerToken;
353                 tokensForHolder = tokenBalances.get(tokenHolder) * tokensPerToken / 100; // Dividing because of the previous multiplication
354                 tokenHolder.transfer(weiAmountForHolder); //This will pass a certain amount of ether to TakeMyEther platform tokenHolders
355                 if (tokensContractAddress.call(bytes4(keccak256("authorizedTransfer(address,address,uint256)")), msg.sender, tokenHolder, tokensForHolder)) //This will pass a certain amount of tokens to TakeMyEther platform tokenHolders
356                 emit DividendsTransfered(tokenHolder, tokensForHolder, weiAmountForHolder);
357             }
358         }
359     }
360 
361     function passUndistributedEther() public {
362         require (projectCompleted);
363         uint weiPerToken = (address(this).balance * 100) / initialSupply;
364 
365         for (uint i = 0; i< tokenBalances.size(); i += 1) {
366             address tokenHolder = tokenBalances.getKeyByIndex(i);
367             if (tokenBalances.get(tokenHolder)>0) {
368                 uint weiAmountForHolder = (tokenBalances.get(tokenHolder)*weiPerToken)/100;
369                 tokenHolder.transfer(weiAmountForHolder); //This will pass a certain amount of ether to TakeMyEther platform tokenHolders
370                 emit DividendsTransfered(tokenHolder, 0, weiAmountForHolder);
371             }
372         }
373     } // When project is finished and Dividends are passed to the tokenHolders, there is some wei, left on the contract. Gradually, there can be a large amount of wei left, so it should be also distributed among tokenHolders.
374 
375     // Internal functions
376 
377     function transferTokensAndEtherValue(address from, address to, uint value, uint weiValue) internal returns (bool success){
378         if (tokenBalances.contains(from) && tokenBalances.get(from) >= value) {
379             tokenBalances.insert(to, tokenBalances.get(to) + value);
380             tokenBalances.insert(from, tokenBalances.get(from) - value);
381 
382             weiBalances[from] -= weiValue;
383             weiBalances[to] += weiValue;
384 
385             emit Transfer(from, to, value);
386             return true;
387         }
388         return false;
389     }
390 
391     function passFundsToTheTeam() internal {
392         uint weiAmount = getAvailableFundsForTheTeam();
393         TakeMyEtherTeamAddress.transfer(weiAmount);
394         emit etherPassedToTheTeam(weiAmount, now);
395         lastTimeWithdrawal = now;
396     }
397 
398     function passTokensToTheTeam() internal returns (uint tokenAmount) { //This function passes tokens to the team without weiValue, so the team can not withdraw ether by returning tokens to the contract
399         uint tokensToPass = getNumberOfTokensForTheTeam();
400         tokenBalances.insert(TakeMyEtherTeamAddress, tokensToPass);
401         weiBalances[TakeMyEtherTeamAddress] = 0; // those tokens don't cost any ether
402         emit Transfer(address(this), TakeMyEtherTeamAddress, tokensToPass);
403         return tokensToPass;
404     }
405 
406     function increaseProjectCompleteLevel() internal {
407         if (percentsOfProjectComplete<60)
408         percentsOfProjectComplete += 10;
409         else
410         percentsOfProjectComplete = 100;
411     }
412 
413     function burnUndistributedTokens(uint tokensToPassToTheTeam) internal {
414         uint toBurn = initialSupply - (tokensToPassToTheTeam + soldTokens);
415         initialSupply -=  toBurn;
416         tokenBalances.insert(address(this), 0);
417         emit Burned(address(this), toBurn);
418     }
419 }